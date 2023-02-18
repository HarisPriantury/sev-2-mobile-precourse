import 'package:flutter/cupertino.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/search/advanced_search/presenter.dart';
import 'package:mobile_sev2/data/payload/db/search/add_query_db_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/query.dart';

class AdvancedSearchController extends BaseController {
  UserData _userData;
  AdvancedSearchPresenter _presenter;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _queryController = TextEditingController();
  final FocusNode _focusNodeSearch = FocusNode();
  List<String> _documentTypeList = [
    "Room",
    "Tugas",
    "Event",
    "User",
    "Project"
  ];
  List<String> _documentStatusList = ['Open', 'Closed'];
  String? _documentStatus;
  List<PhObject> _authoredBy = [];
  List<PhObject> _subscribedBy = [];
  String? _documentType;
  Query? _query;

  AdvancedSearchController(this._presenter, this._userData);

  FocusNode get focusNodeSearch => _focusNodeSearch;

  TextEditingController get searchController => _searchController;

  TextEditingController get queryController => _queryController;

  List<String> get documentTypeList => _documentTypeList;

  List<String> get documentStatusList => _documentStatusList;

  String? get documentStatus => _documentStatus;

  List<PhObject> get authoredBy => _authoredBy;

  List<PhObject> get subscribedBy => _subscribedBy;

  String? get documentType => _documentType;

  @override
  void getArgs() {
    //
  }

  @override
  void initListeners() {
    _focusNodeSearch.addListener(onFocusChange);
  }

  void onFocusChange() {
    if (_focusNodeSearch.hasFocus) {
      // Hide sticker when keyboard appear
    }

    _presenter.addQueryOnNext = (bool? state) {
      print("advancedSearch: success addQuery $state");
    };

    _presenter.addQueryOnComplete = () {
      print("advancedSearch: completed addQuery");
      refreshUI();
    };

    _presenter.addQueryOnError = (e) {
      print("advancedSearch: error addQuery $e");
      refreshUI();
    };
  }

  void goToQueries() async {
    var result = await Navigator.pushNamed(context, Pages.queries);

    if (result != null) {
      // Navigator.of(context).pop(result as Query);
      _generateQueryFromDB(result as Query);
      Navigator.of(context).pop(_query);
    }
  }

  void _generateQueryFromDB(Query query) {
    _query = query;
  }

  Future<void> onSearchSubscribers() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).label_subscriber,
        placeholderText: S.of(context).create_form_search_user_select,
        selectedBefore: _subscribedBy,
      ),
    );

    if (result != null) {
      _subscribedBy = result as List<PhObject>;
      refreshUI();
    }
  }

  Future<void> onSearchAuthors() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).room_detail_authored_by_label,
        placeholderText: S.of(context).create_form_search_user_select,
        selectedBefore: _authoredBy,
      ),
    );

    if (result != null) {
      _authoredBy = result as List<PhObject>;
      refreshUI();
    }
  }

  void setDocumentStatus(String? values) {
    _documentStatus = values;
    refreshUI();
  }

  void setDocumentType(String? value) {
    _documentType = value;
    refreshUI();
  }

  void _generateQuery() {
    _query = new Query(
      _queryController.text,
      _searchController.text,
      _authoredBy,
      _subscribedBy,
      _documentType ?? "",
      _documentStatus ?? "",
      _userData.workspace,
    );
  }

  void onSearch() {
    _generateQuery();
    Navigator.of(context).pop(_query);
  }

  void onSaveQuery() {
    _generateQuery();
    _presenter.onAddQuery(AddQueryDBRequest(_query!));
  }

  void refresh() {
    refreshUI();
  }

  @override
  void load() {}

  @override
  void disposing() {
    //
  }
}
