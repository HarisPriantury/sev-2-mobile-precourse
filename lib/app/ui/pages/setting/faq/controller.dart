import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/args.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/faq/get_faqs_api_request.dart';
import 'package:mobile_sev2/domain/faq.dart';
import 'package:stream_transform/stream_transform.dart';

class FaqController extends BaseController {
  FaqPresenter _presenter;
  DateUtilInterface _dateUtil;
  FaqArgs? _data;
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _streamController = StreamController();
  final FocusNode _focusNodeSearch = FocusNode();

  FaqController(this._presenter, this._dateUtil);

  bool _isSearch = false;
  List<Faq> _rfaqList = [];
  List<Faq> _faqList = [];

  bool get isSearch => _isSearch;
  FocusNode get focusNodeSearch => _focusNodeSearch;
  TextEditingController get searchController => _searchController;
  StreamController<String> get streamController => _streamController;
  List<Faq> get rfaqList => _rfaqList;
  List<Faq> get faqList => _faqList;
  Faq? get faqData => _data?.faq;

  void goToFaqDetail(Faq faq) {
    Navigator.pushNamed(context, Pages.faqDetail, arguments: FaqArgs(faq));
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as FaqArgs;
      print(_data?.toPrint());
    }
  }

  @override
  void load() {
    _getPlaceholderFAQ();
    _presenter.onGetFaqs(GetFaqsApiRequest());
  }

  @override
  void initListeners() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _faqList = _rfaqList
          .where((f) =>
              f.questionTitle.toLowerCase().contains(s) ||
              f.questionDescription.toLowerCase().contains(s) ||
              f.answers.toLowerCase().contains(s))
          .toList();
      refreshUI();
    });

    _presenter.getFaqsOnNext = (List<Faq> faqs, PersistenceType type) {
      print("faqs: success getFaqs $type");
      _rfaqList.clear();
      _faqList.clear();
      _rfaqList.addAll(faqs);
      _faqList.addAll(faqs);
    };

    _presenter.getFaqsOnComplete = (PersistenceType type) {
      print("faqs: completed getFaqs $type");
      loading(false);
    };

    _presenter.getFaqsOnError = (e, PersistenceType type) {
      print("faqs: error getFaqs $e $type");
    };
  }

  void clearSearch() {
    _searchController.text = "";
    refreshUI();
  }

  void onSearch(bool isSearching) {
    _isSearch = isSearching;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _focusNodeSearch.unfocus();
      _searchController.clear();
    }
    refreshUI();
  }

  Future<void> _getPlaceholderFAQ() async {
    var faqs = List<Faq>.empty(growable: true);
    final String _result = await rootBundle
        .loadString('lib/app/ui/assets/resources/static/faq_data.json');
    final response = await json.decode(_result);

    var data = response['result']['data'];
    for (var f in data) {
      faqs.add(
        Faq(
          f['phid'],
          f['fields']['title'],
          f['fields']['content'],
          f['fields']['answerSummary'],
          f['fields']['status'],
          _dateUtil.fromMilliseconds(f['fields']['dateModified']),
        ),
      );
    }

    _rfaqList.clear();
    _faqList.clear();
    _rfaqList.addAll(faqs);
    _faqList.addAll(faqs);
    refreshUI();
  }

  @override
  void disposing() {
    _streamController.close();
  }
}
