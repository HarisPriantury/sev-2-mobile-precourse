import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mime/mime.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/user.dart';

class RoomDetailController extends BaseController {
  RoomDetailArgs? _data;

  // properties
  RoomDetailPresenter _presenter;
  UserData _userData;
  DateUtilInterface _dateUtil;
  DownloaderInterface _downloader;
  late Room _room;
  List<User> _participants = [];
  List<File> _medias = [];
  List<File> _docs = [];
  List<File> _links = [];

  // getter
  List<User> get participants => _participants;

  UserData get userData => _userData;

  DateUtil get dateUtil => _dateUtil as DateUtil;

  DownloaderInterface get downloader => _downloader;

  List<File> get medias => _medias;

  List<File> get docs => _docs;

  List<File> get links => _links;

  RoomDetailController(
      this._presenter, this._userData, this._dateUtil, this._downloader);

  @override
  void load() {
    // extract route arguments and divide in to media (image and vide), docs (pdf, xls, doc, etc), or links
    _room = _data!.room;
    _medias = _data!.files
        .where(
            (f) => f.fileType == FileType.image || f.fileType == FileType.video)
        .toList();

    _docs = _data!.files.where((f) => f.fileType == FileType.document).toList();
    _links = _data!.files.where((f) => f.fileType == FileType.link).toList();
  }

  @override
  void getArgs() {
    if (args != null) _data = args as RoomDetailArgs;
    print(_data?.toPrint());
  }

  // format date for media
  String formatMediaDate(DateTime dt) {
    return _dateUtil.format("dd MMM", dt);
  }

  IconData getAssetFromMime(String mimeType) {
    switch (extensionFromMime(mimeType)) {
      case "doc":
      case "docx":
        return FontAwesomeIcons.fileWord;
      case "odt":
      case "conf":
      case "text/rtf":
      case "rtf":
        return FontAwesomeIcons.fileLines;
      case "pdf":
        return FontAwesomeIcons.filePdf;
      case "pptx":
      case "pot":
      case "odp":
        return FontAwesomeIcons.filePowerpoint;
      case "xla":
      case "xlsx":
      case "ods":
        return FontAwesomeIcons.fileExcel;
      case "csv":
        return FontAwesomeIcons.fileCsv;
      case "application/x-rar":
      case "rar":
      case "zip":
        return FontAwesomeIcons.fileZipper;
      default:
        return FontAwesomeIcons.file;
    }
  }

  void goToMediaDetail(MediaType type, String url, String title) {
    Navigator.pushNamed(context, Pages.mediaDetail,
        arguments: MediaArgs(
          type: type,
          url: url,
          title: title,
        ));
  }

  User getOtherMember() {
    return _room.participants!
        .firstWhere((element) => element.id != _userData.id);
  }

  @override
  void initListeners() {
    // get participants
    _presenter.getParticipantsOnNext = (List<User> participants) {
      print("room detail: success getParticipants");
      _participants.addAll(participants);
    };

    _presenter.getParticipantsOnComplete = () {
      print("room detail: completed getParticipants");
    };

    _presenter.getParticipantsOnError = (e) {
      print("room detail: error getParticipants $e");
    };

    // add participants
    _presenter.addParticipantsOnNext = (bool result) {
      print("room detail: success addParticipants");
      //
    };

    _presenter.addParticipantsOnComplete = () {
      print("room detail: completed addParticipants");
    };

    _presenter.addParticipantsOnError = (e) {
      print("room detail: error addParticipants $e");
    };

    // remove participant
    _presenter.removeParticipantsOnNext = (bool result) {
      print("room detail: success removeParticipants");
      //
    };

    _presenter.removeParticipantsOnComplete = () {
      print("room detail: completed removeParticipants");
    };

    _presenter.removeParticipantsOnError = (e) {
      print("room detail: error removeParticipants $e");
    };

    // get files
    _presenter.getFilesOnNext = (List<File> files) {
      print("room detail: success getFiles");
      //
    };

    _presenter.getFilesOnComplete = () {
      print("room detail: completed getFiles");
    };

    _presenter.getFilesOnError = (e) {
      print("room detail: error getFiles $e");
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    _participants.clear();
    _medias.clear();
    _docs.clear();
    _links.clear();
    load();
    refreshUI();
  }

  void downloadFile(String url) {
    showNotif(context, S.of(context).chat_on_download_label);
    _downloader.startDownloadOrOpen(url, context);
  }
}
