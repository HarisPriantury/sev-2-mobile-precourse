import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/list/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/payload/api/wiki/get_wikis_api_request.dart';
import 'package:mobile_sev2/domain/wiki.dart';

class WikiListController extends BaseController {
  WikiListController(
    this._presenter,
    this._dateUtil,
  );

  DateUtilInterface _dateUtil;
  WikiListPresenter _presenter;
  final StreamController<String> _streamController = StreamController();
  var _wikiAfter = "";
  List<Wiki> _wikis = [];

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }

  @override
  void getArgs() {}

  @override
  void initListeners() {
    _presenter.getWikiOnNext = (List<Wiki> wikis, PersistenceType type) {
      printd("wikiList: success getWiki $type");
      _wikis.addAll(wikis);
      if (wikis.isNotEmpty) {
        _wikiAfter = wikis.last.idInt.toString();
      }
    };

    _presenter.getWikiOnComplete = (PersistenceType type) {
      printd("wikiList: success getWiki $type");
      loading(false);
    };

    _presenter.getWikiOnError = (e, PersistenceType type) {
      print("wikiList: error getWiki $e $type");
      loading(false);
    };
  }

  @override
  void load() {
    _initStream();
    loading(true);
    _getWikis();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    loading(true);
    _wikis.clear();
    _wikiAfter = "";
    _getWikis();
  }

  DateUtil get dateUtil => _dateUtil as DateUtil;

  List<Wiki> get wikis => _wikis;

  StreamController<String> get streamController => _streamController;

  void scrollWikisListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      _getWikis();
    }
  }

  void gotoDetailWiki(Wiki wiki) {
    printd(wiki.toJson());
    Navigator.pushNamed(
      context,
      Pages.detailWiki,
      arguments: WikiDetailArgs(wiki),
    );
  }

  void _initStream() {
    listScrollController.addListener(scrollWikisListener);
  }

  void _getWikis() {
    _presenter.onGetWiki(
      GetWikisApiRequest(
        after: _wikiAfter,
        limit: 10,
      ),
    );
  }
}
