import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/author_reaction_sheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/expandable_text.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_event/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/args.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';
import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/data/payload/api/calendar/create_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/get_events_api_request.dart';
import 'package:mobile_sev2/data/payload/api/calendar/join_event_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/prepare_create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/db/chat/send_message_db_request.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_sev2/domain/file.dart' as FileDomain;
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class DetailEventController extends BaseController {
  DetailEventController(
    this._presenter,
    this._dateUtil,
    this._userData,
    this._userList,
    this._filePicker,
    this._encoder,
    this._downloader,
  );

  List<Suggestion> userSuggestion = [];
  //TODO: CHANGED
  DetailEventArgs _args = DetailEventArgs(phid: "", id: 0);
  DateUtilInterface _dateUtil;
  Calendar? _event;
  ExpandableText _expandableText = ExpandableText("", charLimit: 100);
  final FocusNode _focusNodeMsg = FocusNode();
  bool _isSendingMessage = false;
  List<ObjectReactions> _objectReactions = [];
  DetailEventPresenter _presenter;
  String _statusInvitation = "invited";
  final TextEditingController _textEditingController = TextEditingController();
  List<PhTransaction> _transactions = [];
  UserData _userData;
  List<User> _userList;
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  DownloaderInterface _downloader;

  bool _isUploading = false;
  List<FileDomain.File> _uploadedFiles = [];
  List<FileDomain.File> _files = [];
  List<PhTransaction> _transactionsTmp = [];
  List<PhTransaction> _fTransactions = [];
  Map<String, PreviewData> mapData = Map();

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _args = args as DetailEventArgs;
      print(_args.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getEventOnNext = (List<Calendar> events, PersistenceType type) {
      if (events.isNotEmpty) {
        print("getEventOnNext : ${events.first.toJson()}");
        _event = events.first;
        print("detail event: getEventOnNext $type");
        _expandableText = ExpandableText(
          _event?.description ?? "",
          charLimit: 100,
        );
      }
      refreshUI();
    };
    _presenter.getEventOnComplete = (PersistenceType type) {
      event!.invitees!.removeWhere((element) => element.status == "uninvited");
      print("detail event: completed calendar $type");
      loading(false);
    };
    _presenter.getEventOnError = (e, PersistenceType type) {
      print("detail event: error calendar $e $type");
      loading(false);
    };

    _presenter.getTransactionsOnNext =
        (List<PhTransaction> transactions, PersistenceType type) {
      print("detail: success getTransactions $type");
      _transactions.clear();
      _transactions.addAll(transactions);
      _transactionsTmp.clear();
      _transactionsTmp.addAll(transactions);

      List<String> phids = [];
      List<int> fileIds = [];
      _transactions.forEach((t) {
        phids.add(t.actor.id);
        phids.add(t.target.id);

        if (t.oldRelation != null) {
          phids.add(t.oldRelation!.id);
        }

        if (t.newRelation != null) {
          phids.add(t.newRelation!.id);
        }

        if (t.attachments!.isNotEmpty) {
          fileIds.addAll(t.attachments!.map((e) => e.idInt));
        }
      });

      if (phids.isNotEmpty) {
        _presenter.onGetObjects(GetObjectsApiRequest(phids));
      }

      if (fileIds.isNotEmpty) {
        _presenter.onGetFiles(GetFilesApiRequest(ids: fileIds), 'parsing');
      } else {
        loading(false);
      }
    };

    _presenter.getTransactionsOnComplete = (PersistenceType type) {
      print("detail: completed getTransactions $type");
      _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
          objectIds: _transactions.map((e) => e.id).toList()));
    };

    _presenter.getTransactionsOnError = (e, PersistenceType type) {
      print("detail: error getTransactions: $e $type");
      loading(false);
    };

    _presenter.calendarTransactionOnNext = (bool result, PersistenceType type) {
      print("detail: success calendarTransaction $type");
    };

    _presenter.calendarTransactionOnComplete = (PersistenceType type) {
      print("detail: completed calendarTransaction $type");
      _getTransaction();
      _isSendingMessage = false;
      refreshUI();
    };

    _presenter.calendarTransactionOnError = (e, PersistenceType type) {
      print("detail: error calendarTransaction: $e $type");
      _isSendingMessage = false;
      loading(false);
    };
    _presenter.joinEventOnNext = (bool result, PersistenceType type) {
      print("detail: success joinEvent $type");
    };

    _presenter.joinEventOnComplete = (PersistenceType type) {
      print("detail: completed joinEvent $type");
      var idx =
          _event!.invitees!.indexWhere((element) => element.id == _userData.id);
      if (idx > -1) {
        _event!.invitees![idx].status = _statusInvitation; //"attending";
      } else {
        User me = _userData.toUser();
        me.status = "attending";
        _event!.invitees!.add(me);
      }
      loading(false);
    };

    _presenter.joinEventOnError = (e, PersistenceType type) {
      print("detail: error joinEvent: $e $type");
      loading(false);
    };
    _presenter.getObjectsOnNext =
        (List<PhObject> objects, PersistenceType type) {
      print("detail: success getObjects $type");

      objects.forEach((obj) {
        var ts = _transactions.where((t) => t.target.id == obj.id);
        ts.forEach((tsi) {
          var idx = _transactions.indexWhere((t) => t.id == tsi.id);
          if (idx >= 0) {
            _transactions[idx].target = obj;
          }
        });

        var tsOr = _transactions.where((t) => t.oldRelation?.id == obj.id);
        tsOr.forEach((tsi) {
          var idx = _transactions.indexWhere((t) => t.id == tsi.id);
          if (idx >= 0) {
            _transactions[idx].action = _transactions[idx]
                .action
                .replaceAll(tsi.oldRelation!.id, obj.name!);
          }
        });

        var tsNr = _transactions.where((t) => t.newRelation?.id == obj.id);
        tsNr.forEach((tsi) {
          var idx = _transactions.indexWhere((t) => t.id == tsi.id);
          if (idx >= 0) {
            _transactions[idx].action = _transactions[idx]
                .action
                .replaceAll(tsi.newRelation!.id, obj.name!);
          }
        });
      });
    };

    _presenter.getObjectsOnComplete = (PersistenceType type) {
      print("detail: completed getObjects $type");
      // loading(false);
    };

    _presenter.getObjectsOnError = (e, PersistenceType type) {
      print("detail: error getObjects: $e $type");
      loading(false);
    };

    _presenter.getObjectReactionOnNext = (List<ObjectReactions> result) {
      print("detail: success getObjectReactions ${result.length}");
      _transactions.forEach((element) {
        element.reactions?.clear();
      });
      _objectReactions.clear();
      _objectReactions.addAll(result);
      result.forEach((reaction) {
        int idx =
            _transactions.indexWhere((chat) => chat.id == reaction.objectId);
        if (idx > -1) {
          if (_transactions[idx].reactions != null)
            _transactions[idx].reactions?.add(reaction.reaction);
          else
            _transactions[idx].reactions = [reaction.reaction];
        }
      });
      refreshUI();
    };

    _presenter.getObjectReactionOnComplete = () {
      print("voice: completed getObjectReactions");
    };

    _presenter.getObjectReactionOnError = (e) {
      print("voice: error getObjectReactions $e");
      loading(false);
    };
    _presenter.sendReactionOnNext = (bool result, PersistenceType type) {
      print("detail: success sendReaction");
      //
    };

    _presenter.sendReactionOnComplete = (PersistenceType type) {
      print("detail: completed sendReaction");
      _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
          objectIds: _transactions.map((e) => e.id).toList()));
    };

    _presenter.sendReactionOnError = (e, PersistenceType type) {
      print("detail: error sendReaction $e");
      loading(false);
    };

    // upload file
    _presenter.uploadFileOnNext =
        (BaseApiResponse result, PersistenceType type) {
      print("voice: success uploadFile");
      _presenter.onGetFiles(
          GetFilesApiRequest(phids: [result.result]), "upload");
    };

    _presenter.uploadFileOnComplete = (PersistenceType type) {
      print("voice: complete uploadFile");
    };

    _presenter.uploadFileOnError = (e, PersistenceType type) {
      print("voice: error uploadFile");
      loading(false);
    };

    // prepare upload file
    _presenter.prepareFileUploadOnNext = (bool result, PersistenceType type) {
      print("voice: success prepareFileUpload");
      //
    };

    _presenter.prepareFileUploadOnComplete = (PersistenceType type) {
      print("voice: completed prepareFileUpload");
      _isUploading = false;
    };

    _presenter.prepareFileUploadOnError = (e, PersistenceType type) {
      print("voice: error prepareFileUpload $e");
      loading(false);
    };

    // get files
    _presenter.getFilesOnNext =
        (List<FileDomain.File> files, PersistenceType ptype, String type) {
      print("transactions: success getFiles");

      if (type == "upload") {
        files.forEach((f) {
          print('_textEditingController.text' + _textEditingController.text);
          print('f.idInt' + f.idInt.toString());
          _textEditingController.text =
              "${_textEditingController.text} {F${f.idInt}}";
        });

        _uploadedFiles.addAll(files);
      }

      if (type == "parsing") {
        _files.clear();
        _files.addAll(files);
        files.forEach((f) {
          List ids = [];
          for (var i = 0; i < _transactionsTmp.length; i++) {
            var tTmp = _transactionsTmp[i];
            if (tTmp.attachments!.length != 0) {
              for (var j = 0; j < tTmp.attachments!.length; j++) {
                if (tTmp.attachments![j].idInt == f.idInt) {
                  ids.add([i, j]);
                }
              }
            }
            ids.forEach((idx) {
              _transactionsTmp[idx[0]].attachments![idx[1]] = f;
            });
          }
        });

        _fTransactions.clear();
        _fTransactions.addAll(_transactionsTmp);
        _transactions = _fTransactions;
        loading(false);
      }
    };

    _presenter.getFilesOnComplete = (PersistenceType type) {
      print("chat: completed getFiles");
      refreshUI();
    };

    _presenter.getFilesOnError = (e, PersistenceType type) {
      print("chat: error getFiles $e");
      loading(false);
    };
  }

  @override
  void load() {
    _mapUserListToSuggestion();
    _getEvent();
    _getTransaction();
  }

  @override
  Future<void> reload({String? type}) {
    load();
    return super.reload();
  }

  bool get isSendingMessage => _isSendingMessage;

  Calendar? get event => _event;

  ExpandableText get expandableText => _expandableText;

  TextEditingController get textEditingController => _textEditingController;

  FocusNode get focusNodeMsg => _focusNodeMsg;

  List<PhTransaction>? get transactions => _transactions;

  bool get isUploading => _isUploading;

  List<FileDomain.File> get uploadedFiles => _uploadedFiles;

  List<FileDomain.File> get files => _files;

  DownloaderInterface get downloader => _downloader;

  String parseTime(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  String getCalendarStatus() {
    if (event?.isCancelled ?? false) {
      return "Cancelled";
    } else {
      return "Active";
    }
  }

  String getCalendarPolicy() {
    return "All User";
  }

  bool isJoinedOrDeclined(bool isJoined) {
    var invs = _event!.invitees!.where((inv) => inv.id == _userData.id);
    var status = "declined";
    if (isJoined) {
      status = "attending";
    }
    return invs.isNotEmpty && invs.first.status == status;
  }

  void onCalendarAct(bool willJoin) {
    _statusInvitation = willJoin ? 'attending' : 'declined';
    _presenter.onJoinEvent(JoinEventApiRequest(_event!.id, willJoin));
    loading(true);
  }

  bool isInvited() {
    return _event!.invitees!.where((inv) => inv.id == _userData.id).isNotEmpty;
  }

  void collapseContent() {
    _expandableText.collapse();
    refreshUI();
  }

  void expandContent() {
    _expandableText.expand();
    refreshUI();
  }

  Future<void> onOpen(String link) async {
    Uri uri = Uri.parse(link);
    if (link[0] == '@') {
      var username = link.split('@').last;
      int index = _userList.indexWhere((element) => element.name == username);
      if (index > 0) goToProfile(_userList[index]);
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $link';
    }
  }

  void onGetPreviewData(String id, PreviewData data) {
    mapData[id] = data;
    refreshUI();
  }

  void goToProfile(User user) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: ProfileArgs(user: user));
  }

  void sendMessage() {
    if (_textEditingController.text.trim().isEmpty) return;

    _presenter.onCalendarTransaction(
      CreateEventApiRequest(
        objectIdentifier: _event?.id,
        comment: _textEditingController.text,
      ),
    );
    _isSendingMessage = true;
    _textEditingController.clear();
    _uploadedFiles.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    refreshUI();
  }

  List<Suggestion> filterUserSuggestion(String query) {
    return userSuggestion
        .where((user) => user.subtitle.toLowerCase().contains(query))
        .toList();
  }

  void sendReaction(reactionId, objectId) {
    _presenter.onSendReaction(GiveReactionApiRequest(reactionId, objectId));
  }

  void showAuthorsReaction(String transactionId,
      Map<String, List<Reaction>> reactionMapList, String reactionId) {
    List<ObjectReactions> listAllReactions = [];

    listAllReactions.addAll(
        _objectReactions.where((object) => object.objectId == transactionId));

    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return AuthorReactionSheet(
            reactionMapList: reactionMapList,
            listAllReactions: listAllReactions,
            reactionId: reactionId,
            userList: _userList,
          );
        });
  }

  void goToEditPage() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.create,
      arguments: CreateArgs(type: Calendar, object: _event),
    );

    if (result != null) {
      reload();
    }
  }

  void _mapUserListToSuggestion() {
    userSuggestion.clear();
    if (_userList.isNotEmpty) {
      _userList.forEach((user) {
        userSuggestion.add(
          Suggestion(
            imageURL: user.avatar ?? "",
            subtitle: user.name ?? "",
            title: user.fullName ?? "",
          ),
        );
      });
    }
  }

  void _getEvent() {
    var now = _dateUtil.now();
    _presenter.onGetEvent(
      GetEventsApiRequest(
        phids: [_args.phid ?? ""],
        startDate: now.subtract(Duration(days: 90)),
        endDate: now.add(Duration(days: 90)),
      ),
    );
    loading(true);
  }

  void _getTransaction() {
    _presenter.onGetTransactions(
      GetObjectTransactionsApiRequest(
        identifier: _args.phid,
      ),
    );
  }

  void goToEditParticipantPage() async {
    var result = await Navigator.pushNamed(
      context,
      Pages.editMember,
      arguments: EditMemberArgs(
        "${_args.phid}",
        selectedBefore: event!.invitees!,
      ),
    );

    if (result != null) {
      event!.invitees!.removeWhere((element) => element.status == "uninvited");
      _getEvent();
    }
  }

  Future<void> upload(FileDomain.FileType type) async {
    FilePickerResult? result = await _filePicker.pick(type);

    if (result != null) {
      _isUploading = true;
      refreshUI();
      result.files.forEach((el) {
        // prepare file allocate
        _presenter.onPrepareUploadFile(PrepareCreateFileApiRequest(
            el.name, _encoder.encodeBytes(el.bytes!).length));

        // upload
        _presenter.onUploadFile(
            CreateFileApiRequest(el.name, _encoder.encodeBytes(el.bytes!)));
      });
    } else {
      // canceled
    }
  }

  void cancelUpload(FileDomain.File file) {
    var txt = _textEditingController.text;
    txt = txt.replaceAll("{F${file.idInt}}", "").trim();
    _uploadedFiles.remove(file);
    _textEditingController.text = txt;
    refreshUI();
  }

  void downloadOrOpenFile(String url) {
    showNotif(context, S.of(context).chat_on_download_label);
    _downloader.startDownloadOrOpen(url, context);
  }

  void goToMediaDetail(MediaType type, String url, String title) {
    Navigator.pushNamed(context, Pages.mediaDetail,
        arguments: MediaArgs(
          type: type,
          url: url,
          title: title,
        ));
  }

  void reportEvent() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments:
                ReportArgs(phId: _event?.id ?? "", reportedType: "EVENT"),
          );
        });
  }
}
