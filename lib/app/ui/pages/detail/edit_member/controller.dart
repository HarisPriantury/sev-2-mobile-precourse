import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class EditMemberController extends BaseController {
  late EditMemberArgs? _data;
  EditMemberArgs? get data => _data;
  List<PhObject> _memberList = List.empty(growable: true);
  List<PhObject> get memberList => _memberList;
  EditMemberPresenter _presenter;
  bool isRemoveMember = false;
  bool isAddMember = false;
  CreateEventApiRequest _createEventRequest = CreateEventApiRequest();
  EditMemberController(
    this._presenter,
  );
  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as EditMemberArgs;
      if (_data!.selectedBefore != null)
        _memberList.addAll(_data!.selectedBefore!);
    }
  }

  @override
  void initListeners() {
    _presenter.createEventOnNext = (bool result) {
      print("edit member: success createEvent");
    };

    _presenter.createEventOnComplete = () {
      print("edit member: completed createEvent");
      _closeAndRefresh();
    };

    _presenter.createEventOnError = (e) {
      print("edit member: error createEvent: $e");
    };
  }

  @override
  void load() {}
  Future<void> onSearchEventMember() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).create_form_participants_label,
        placeholderText: S.of(context).create_form_participants_select,
        type: SearchSelectionType.multiple,
        selectedBefore: _memberList,
      ),
    );
    if (result != null) {
      var res = result as List<PhObject>;
      if (_memberList.length != res.length) {
        isAddMember = true;
        _memberList.clear();
        _memberList = res;
        showOnLoading(context, "Loading...");
        onEditMember();
        showNotif(context, "Peserta berhasil ditambahkan");
        refreshUI();
      }
    }
  }

  void removeMember(List<PhObject> member) {
    isRemoveMember = true;
    Navigator.pop(context);
    showOnLoading(context, "Loading...");
    var participantToRemove = [];
    _memberList.forEach((element) {
      for (var i = 0; i < member.length; i++) {
        if (member[i].id == element.id) {
          participantToRemove.add(element.id);
        }
      }
    });
    _memberList.removeWhere((e) => participantToRemove.contains(e.id));
    refreshUI();
    onEditMember();
  }

  void onEditMember() {
    _createEventRequest.invitees = _memberList.map((e) => e.id).toList();
    _createEventRequest.objectIdentifier = _data?.phid;
    _presenter.onCreateEvent(_createEventRequest);
  }

  void _closeAndRefresh() {
    if (isRemoveMember) {
      isRemoveMember = false;
      Navigator.pop(context);
      Navigator.pop(context, _memberList);
    } else if (isAddMember) {
      isAddMember = false;
      Navigator.pop(context);
    } else {
      Navigator.pop(context, _memberList);
    }
  }

  Future<void> goToSearchMember() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.searchMember,
      arguments: SearchMemberArgs(
        "${_data?.phid}",
        selectedBefore: _memberList,
      ),
    );
    if (result != null) {
      var res = result as List<PhObject>;
      if (_memberList.length != res.length) {
        _memberList.clear();
        _memberList = res;
        refreshUI();
      }
    }
  }
}
