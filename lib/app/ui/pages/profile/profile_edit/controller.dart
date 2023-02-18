import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/args.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_edit/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/update_user_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/update_user_avatar_api_request.dart';
import 'package:mobile_sev2/domain/file.dart' as FileDomain;
import 'package:mobile_sev2/domain/user.dart';

class ProfileEditController extends BaseController {
  ProfileEditPresenter _presenter;
  UserData _userData;
  EventBus _eventBus;
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  DateUtilInterface _dateUtil;

  DateTime? _birthDate;

  bool _isUploading = false;
  bool _isValidated = false;
  bool _isGithubValidated = false;
  bool _isStackoverflowValidated = false;
  bool _isHackerrankValidated = false;
  bool _isDuolingoValidated = false;
  bool _isLinkedinValidated = false;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _githubUrlController = TextEditingController();
  final TextEditingController _stackoverflowUrlController =
      TextEditingController();
  final TextEditingController _hackerrankUrlController =
      TextEditingController();
  final TextEditingController _duolingoUrlController = TextEditingController();
  final TextEditingController _linkedinUrlController = TextEditingController();

  ProfileEditController(
    this._presenter,
    this._userData,
    this._eventBus,
    this._filePicker,
    this._encoder,
    this._dateUtil,
  );

  TextEditingController get userNameController => _userNameController;
  TextEditingController get displayNameController => _displayNameController;
  TextEditingController get birthDateController => _birthDateController;
  TextEditingController get birthPlaceController => _birthPlaceController;
  TextEditingController get githubUrlController => _githubUrlController;
  TextEditingController get stackoverflowUrlController =>
      _stackoverflowUrlController;
  TextEditingController get hackerrankController => _hackerrankUrlController;
  TextEditingController get duolingoUrlController => _duolingoUrlController;
  TextEditingController get linkedinUrlController => _linkedinUrlController;

  UserData get userData => _userData;
  bool get isUploading => _isUploading;
  bool get isValidated => _isValidated;
  bool get isGithubValidated => _isGithubValidated;
  bool get isStackoverflowValidated => _isStackoverflowValidated;
  bool get isHackerrankValidated => _isHackerrankValidated;
  bool get isDuolingoValidated => _isDuolingoValidated;
  bool get isLinkedinValidated => _isLinkedinValidated;

  DateUtilInterface get dateUtil => _dateUtil;
  DateTime? get birthDate => _birthDate;

  @override
  void getArgs() {}

  @override
  void load() {
    _userNameController.text = _userData.name;
    _displayNameController.text = _userData.username;
    loading(true);
    _presenter.onGetUsers(GetUsersApiRequest(ids: ["${_userData.id}"]));
    validate();
  }

  @override
  void initListeners() {
    _presenter.getUsersOnNext = (List<User> users, PersistenceType type) {
      if (users.first.birthDate != null)
        _birthDateController.text =
            _dateUtil.basicDateFormat(users.first.birthDate!);
      _birthPlaceController.text = users.first.birthPlace ?? "";
      _githubUrlController.text = users.first.githubUrl ?? "";
      _stackoverflowUrlController.text = users.first.stackoverflowUrl ?? "";
      _hackerrankUrlController.text = users.first.hackerrankUrl ?? "";
      _duolingoUrlController.text = users.first.duolingoUrl ?? "";
      _linkedinUrlController.text = users.first.linkedinUrl ?? "";
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      printd("profileEdit: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      printd("profileEdit: error getUsers $e $type");
    };

    _presenter.updateProfileOnNext = (bool result, PersistenceType type) {
      print("profileEdit: success updateProfile $type");
    };

    _presenter.updateProfileOnComplete = (PersistenceType type) {
      print("profileEdit: completed updateProfile $type");

      // save to user data for latest data updated
      _userData.name = _userNameController.text;
      _userData.save();

      _eventBus.fire(Refresh());
      Navigator.pop(context);
      loading(false);
    };

    _presenter.updateProfileOnError = (e, PersistenceType type) {
      loading(false);
      print("profileEdit: error updateProfile $e $type");
    };
    _presenter.updateAvatarProfileOnNext = (bool result, PersistenceType type) {
      print("avatarProfileEdit: success avatarUpdateProfile $type");
      _isUploading = false;
    };

    _presenter.updateAvatarProfileOnComplete = (PersistenceType type) {
      print("avatarProfileEdit: completed avatarUpdateProfile $type");

      _userData.name = _userNameController.text;
      _userData.save();

      _eventBus.fire(Refresh());
      Navigator.pop(context);
    };

    _presenter.updateAvatarProfileOnError = (e, PersistenceType type) {
      loading(false);
      print("avatarProfileEdit: error avatarUpdateProfile $e $type");
    };
  }

  void save() {
    loading(true);
    _presenter.onUpdateProfile(UpdateUserApiRequest(
      _userData.id,
      name: _userNameController.text,
      birthDate: _birthDateController.text.isNotEmpty
          ? (DateTime(_birthDate!.year, _birthDate!.month, _birthDate!.day, 0,
                          0, 0)
                      .millisecondsSinceEpoch /
                  1000)
              .ceil()
          : null,
      birthPlace: _birthPlaceController.text.isNotEmpty
          ? _birthPlaceController.text
          : null,
      githubUrl: _githubUrlController.text.isNotEmpty
          ? _githubUrlController.text
          : null,
      stackoverflowUrl: _stackoverflowUrlController.text.isNotEmpty
          ? _stackoverflowUrlController.text
          : null,
      hackerrankUrl: _hackerrankUrlController.text.isNotEmpty
          ? _hackerrankUrlController.text
          : null,
      duolingoUrl: _duolingoUrlController.text.isNotEmpty
          ? _duolingoUrlController.text
          : null,
      linkedinUrl: _linkedinUrlController.text.isNotEmpty
          ? _linkedinUrlController.text
          : null,
    ));
    refreshUI();
  }

  Future<void> upload(FileDomain.FileType type) async {
    FilePickerResult? result = await _filePicker.pick(type);
    if (result != null) {
      _isUploading = true;
      refreshUI();
      delay(() => _presenter.onUpdateAvatar(UpdateAvatarUserApiRequest(
          _encoder.encodeBytes(result.files.first.bytes!))));
    } else {
      // canceled
    }
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  void setCalendarBirthDate(DateTime date) {
    _birthDateController.text = _dateUtil.basicDateFormat(date);
    _birthDate = date;
    refreshUI();
  }

  void validate() {
    _isGithubValidated = _githubUrlController.text.isEmpty ||
        RegExp(r'github\.com\/([A-z0-9_-]+)\/?')
            .hasMatch(_githubUrlController.text);
    _isStackoverflowValidated = _stackoverflowUrlController.text.isEmpty ||
        RegExp(r'stackoverflow\.com\/users\/[0-9]+\/([A-z0-9-_.]+)\/?')
            .hasMatch(_stackoverflowUrlController.text);
    _isHackerrankValidated = _hackerrankUrlController.text.isEmpty ||
        RegExp(r'hackerrank\.com\/([A-z0-9_-]+)\/?')
            .hasMatch(_hackerrankUrlController.text);
    _isDuolingoValidated = _duolingoUrlController.text.isEmpty ||
        RegExp(r'duolingo\.com\/profile\/([A-z0-9_-]+)\/?')
            .hasMatch(_duolingoUrlController.text);
    _isLinkedinValidated = _linkedinUrlController.text.isEmpty ||
        RegExp(r'inkedin\.com\/in\/([\w\-\_À-ÿ%]+)\/?')
            .hasMatch(_linkedinUrlController.text);
    _isValidated = _displayNameController.text.isNotEmpty &&
        _userNameController.text.isNotEmpty &&
        _isGithubValidated &&
        _isStackoverflowValidated &&
        _isHackerrankValidated &&
        _isDuolingoValidated &&
        _isLinkedinValidated;
    refreshUI();
  }
}
