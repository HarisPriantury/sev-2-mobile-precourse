import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/downloader.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/presenter.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';
import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/file/create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/prepare_create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_files_api_request.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:stream_transform/stream_transform.dart';

class RoomFileController extends BaseController {
  RoomFilePresenter _presenter;
  DownloaderInterface _downloader;
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  DateUtilInterface _dateUtil;
  late Room? _room;
  List<File> _files = [];
  RoomFileArgs? _data;
  UserData _userData;
  RoomFileArgs? get data => _data;
  var _fileAfter = "";
  final TextEditingController _searchFileController = TextEditingController();
  TextEditingController get searchFileController => _searchFileController;
  final FocusNode _focusNodeSearchFile = FocusNode();
  FocusNode get focusNodeSearchFile => _focusNodeSearchFile;
  bool _isSearchFile = false;
  final StreamController<String> _streamController = StreamController();
  var _keywordFile = "";

  RoomFileController(
    this._presenter,
    this._downloader,
    this._filePicker,
    this._encoder,
    this._dateUtil,
    this._userData,
  );

  DateUtil get dateUtil => _dateUtil as DateUtil;

  Downloader get downloader => _downloader as Downloader;

  Room? get room => _room;

  List<File> get files => _files;

  StreamController<String> get streamController => _streamController;

  @override
  void disposing() {
    _presenter.dispose();
    _streamController.close();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as RoomFileArgs;
      if (_data?.room != null) _room = _data?.room!;
      print(_data?.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getLobbyRoomFilesOnNext =
        (List<File> files, PersistenceType type) {
      printd("roomFile: success getLobbyRoomFiles $type");
      _files.clear();
      _files.addAll(files);
    };

    _presenter.getLobbyRoomFilesOnComplete = (PersistenceType type) {
      print("roomFile: completed getLobbyRoomFiles $type");
      loading(false);
    };

    _presenter.getLobbyRoomFilesOnError = (e, PersistenceType type) {
      print("roomFile: error getLobbyRoomFiles $e $type");
    };

    _presenter.getFilesOnNext = (List<File> files, PersistenceType type) {
      printd("roomFile: success getFiles $type");
      _files.addAll(files);
      if (files.isNotEmpty) {
        _fileAfter = files.last.idInt.toString();
      }
    };

    _presenter.getFilesOnComplete = (PersistenceType type) {
      printd("roomFile: success getFiles $type");
      loading(false);
    };

    _presenter.getFilesOnError = (e, PersistenceType type) {
      print("roomFile: error getFiles $e $type");
    };

    _presenter.prepareFileUploadOnNext =
        (bool state, PlatformFile file, PersistenceType type) {
      printd("roomFile: success prepareFileUpload $type");
      // upload
      _presenter.onUploadFile(CreateFileApiRequest(
          file.name, _encoder.encodeBytes(file.bytes!),
          roomId: _room!.id));
    };

    _presenter.prepareFileUploadOnComplete = (PersistenceType type) {
      print("roomFile: completed prepareFileUpload $type");
    };

    _presenter.prepareFileUploadOnError = (e, PersistenceType type) {
      print("roomFile: error prepareFileUpload $e $type");
    };

    // upload file
    _presenter.uploadFileOnNext =
        (BaseApiResponse result, PersistenceType type) {
      printd("roomFile: success uploadFile");
    };

    _presenter.uploadFileOnComplete = (PersistenceType type) {
      print("roomFile: complete uploadFile");
      load();
    };

    _presenter.uploadFileOnError = (e, PersistenceType type) {
      print("roomFile: error uploadFile");
    };
  }

  @override
  void load() {
    _initStream();
    loading(true);
    if (_data?.isRoom ?? false) {
      _presenter.onGetLobbyRoomFiles(GetLobbyRoomFilesApiRequest(_room!.id));
    } else {
      _getUserFiles(_keywordFile);
    }
  }

  void _initStream() {
    _focusNodeSearchFile.addListener(onFocusSearchFile);
    listScrollController.addListener(scrollFilesListener);
    // File
    _streamController.stream
        .transform(StreamTransformer.fromBind(
            (s) => s.debounce(const Duration(milliseconds: 750))))
        .listen((s) {
      _keywordFile = s.toLowerCase();
      loading(true);
      _files.clear();
      _getUserFiles(_keywordFile, reset: true);
      refreshUI();
    });
  }

  void onFocusSearchFile() {
    if (_focusNodeSearchFile.hasFocus) {
      onSearchFile(true);
    } else if (_searchFileController.text.isEmpty) {
      onSearchFile(false);
    }
  }

  void onSearchFile(bool isSearchingFile) {
    _isSearchFile = isSearchingFile;
    if (_isSearchFile) {
      _focusNodeSearchFile.requestFocus();
    } else {
      _focusNodeSearchFile.unfocus();
      _searchFileController.clear();
    }
    refreshUI();
  }

  void _getUserFiles(String keyword, {bool reset = false}) {
    _presenter.onGetFiles(
      GetFilesApiRequest(
        authorIds: ["${_userData.id}"],
        limit: 10,
        after: reset ? "" : _fileAfter,
        nameLike: keyword,
      ),
    );
  }

  void scrollFilesListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      _getUserFiles(_keywordFile);
    }
  }

  Future<void> uploadRoomFile() async {
    FilePickerResult? result = await _filePicker.pickAllTypes();

    if (result != null) {
      loading(true);
      result.files.forEach((el) {
        // prepare file allocate
        _presenter.onPrepareUploadFile(
            PrepareCreateFileApiRequest(
                el.name, _encoder.encodeBytes(el.bytes!).length),
            el);
      });
    } else {
      refreshUI();
    }
  }

  void downloadFile(String url) {
    showNotif(context, S.of(context).chat_on_download_label);
    _downloader.startDownloadOrOpen(url, context);
  }

  void openFile(String url) {
    _downloader.openFile(url);
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    if (_data?.isRoom ?? false) {
      _presenter.onGetLobbyRoomFiles(GetLobbyRoomFilesApiRequest(_room!.id));
      reloading(true);
      await Future.delayed(Duration(seconds: 1));
    } else {
      _files.clear();
      _fileAfter = "";
      _keywordFile = "";
      _getUserFiles(_keywordFile);
    }
  }

  void clearSearch() {
    _keywordFile = "";
    _searchFileController.text = "";
    onSearchFile(false);
    _files.clear();
    loading(true);
    _getUserFiles(_keywordFile);
  }
}
