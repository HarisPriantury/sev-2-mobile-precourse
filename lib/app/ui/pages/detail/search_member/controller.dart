import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/presenter.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:stream_transform/src/rate_limit.dart';

class SearchMemberController extends BaseController {
  SearchMemberController(this._presenter);

  CreateEventApiRequest _createEventRequest = CreateEventApiRequest();
  late SearchMemberArgs? _data;
  final FocusNode _focusNodeSearch = FocusNode();
  bool _isSearch = false;
  List<PhObject> _memberList = List.empty(growable: true);
  SearchMemberPresenter _presenter;
  final TextEditingController _searchController = TextEditingController();
  List<PhObject> _searchedMember = [];
  final StreamController<String> _streamController = StreamController();

  @override
  void disposing() {
    _streamController.close();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as SearchMemberArgs;
      if (_data!.selectedBefore != null)
        _memberList.addAll(_data!.selectedBefore!);
    }
  }

  @override
  void initListeners() {
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _searchedMember = _memberList
          .where((u) => u.name!.toLowerCase().contains(s.toLowerCase()))
          .toList();
      refreshUI();
    });
    _presenter.createEventOnNext = (bool result) {
      print("SearchMember: success createEvent");
      showNotif(context, "Peserta berhasil dihapus");
    };

    _presenter.createEventOnComplete = () {
      print("SearchMember: completed createEvent");
      _closeAndRefresh();
    };

    _presenter.createEventOnError = (e) {
      print("SearchMember: error createEvent: $e");
      Navigator.pop(context);
    };
  }

  @override
  void load() {
    // TODO: implement load
  }

  List<PhObject> get searchedMember => _searchedMember;

  List<PhObject> get memberList => _memberList;

  bool get isSearch => _isSearch;

  TextEditingController get searchController => _searchController;

  FocusNode get focusNodeSearch => _focusNodeSearch;

  StreamController<String> get streamController => _streamController;

  void onSearch(bool value) {
    _isSearch = value;

    if (_isSearch) {
      _focusNodeSearch.requestFocus();
    } else {
      _focusNodeSearch.unfocus();
      _searchController.clear();
      _searchedMember.clear();
    }
    refreshUI();
  }

  void clearSearch() {
    _searchController.text = "";
    refreshUI();
  }

  void removeMember(List<PhObject> member) {
    Navigator.pop(context);
    showOnLoading(context, "Loading...");
    var memberToRemove = [];
    _memberList.forEach((element) {
      for (var i = 0; i < member.length; i++) {
        if (member[i].id == element.id) {
          memberToRemove.add(element.id);
        }
      }
    });
    _memberList.removeWhere((e) => memberToRemove.contains(e.id));
    refreshUI();
    onEditMember();
  }

  void onEditMember() {
    _createEventRequest.invitees = _memberList.map((e) => e.id).toList();
    _createEventRequest.objectIdentifier = _data?.phid;
    _presenter.onCreateEvent(_createEventRequest);
  }

  void _closeAndRefresh() {
    Navigator.pop(context, _memberList);
  }
}
