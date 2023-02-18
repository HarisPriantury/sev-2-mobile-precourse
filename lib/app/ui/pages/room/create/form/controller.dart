import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/create/search/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/room/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/room/create_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_participants_api_request.dart';
import 'package:mobile_sev2/data/payload/api/room/get_rooms_api_request.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class CreateRoomController extends BaseController {
  CreateRoomArgs? _data;
  late FormType _type;

  final TextEditingController _titleGroupController = TextEditingController();
  final TextEditingController _topicGroupController = TextEditingController();

  // properties
  CreateRoomPresenter _presenter;
  UserData _userData;

  List<PhObject> _members = [];

  CreateRoomController(
    this._presenter,
    this._userData,
  );

  // getter
  List<PhObject> get members => _members;

  FormType get type => _type;

  TextEditingController get titleGroupController => _titleGroupController;

  TextEditingController get topicGroupController => _topicGroupController;

  @override
  void load() {
    if (_data != null) {
      if (_type == FormType.create) {
        loading(false);
      } else {
        if (_data?.room != null) {
          _presenter.onGetParticipants(
            GetParticipantsApiRequest(_data!.room!.id),
          );
        }
      }
    } else {
      loading(false);
    }
  }

  // check if form is ready to be submitted.
  // all field must not be emptied and members is not empty
  bool isFormReady() {
    return !_titleGroupController.text.isNullOrBlank() &&
        !_topicGroupController.text.isNullOrBlank() &&
        _members.length > 2;
  }

  void onCreateRoom() {
    showOnLoading(context, S.of(context).label_connect_room_chat);

    _presenter.onCreateRoom(
      CreateRoomApiRequest(
        _titleGroupController.text,
        _topicGroupController.text,
        _members.map((e) => e.id).toList(),
        objectIdentifier: _data?.room?.id,
      ),
    );
  }

  Future<void> onSearchUsers() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.objectSearch,
      arguments: ObjectSearchArgs(
        'user',
        title: S.of(context).label_subscriber,
        placeholderText: S.of(context).create_form_search_user_label,
        selectedBefore: _members,
      ),
    );

    if (result != null) {
      _members.clear();
      _members.addAll(result as List<PhObject>);
      num idx = _members.indexWhere((element) => element.id == _userData.id);
      if (idx < 0) {
        _members.add(_userData.toUser());
      }
      refreshUI();
    }
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as CreateRoomArgs;
      _type = _data!.type;
      _titleGroupController.text = _data?.room?.name ?? "";
      _topicGroupController.text = _data?.room?.description ?? "";
    } else {
      _type = FormType.create;
    }
  }

  @override
  void initListeners() {
    _presenter.createRoomOnNext = (BaseApiResponse resp, PersistenceType type) {
      print("create room: success createRoom $type");
      // get room details
      _presenter.onGetRooms(GetRoomsApiRequest(ids: [resp.result], limit: 1));
    };

    _presenter.createRoomOnComplete = (PersistenceType type) {
      print("create room: completed createRoom $type");
    };

    _presenter.createRoomOnError = (e, PersistenceType type) {
      print("create room: error createRoom $e $type");
    };

    _presenter.getRoomsOnNext = (List<Room> rooms, PersistenceType type) {
      print("create room: success getRooms $type");

      // navigate user to newly created room
      Navigator.pop(context);
      Navigator.pushReplacementNamed(
        context,
        Pages.lobbyRoom,
        arguments: LobbyRoomArgs(
          rooms.first,
          type: RoomType.voice,
        ),
      );
    };

    _presenter.getRoomsOnComplete = (PersistenceType type) {
      print("create room: completed getRooms $type");
    };

    _presenter.getRoomsOnError = (e, PersistenceType type) {
      print("create room: error getRooms $e $type");
    };

    _presenter.getParticipantsOnNext =
        (List<User>? users, PersistenceType type) {
      print("create room: success getParticipants $type");
      if (users != null) {
        _members.clear();
        _members.addAll(users);
      }
      loading(false);
    };

    _presenter.getParticipantsOnComplete = (PersistenceType type) {
      print("create room: completed getParticipants $type");
    };

    _presenter.getParticipantsOnError = (e, PersistenceType type) {
      print("create room: error getParticipants $e $type");
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
