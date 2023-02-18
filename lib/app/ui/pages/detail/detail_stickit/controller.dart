import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/author_reaction_sheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/expandable_text.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_stickit/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_info/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/view.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';
import 'package:mobile_sev2/data/infrastructures/encoder_interface.dart';
import 'package:mobile_sev2/data/infrastructures/files_picker_interface.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/common/get_object_transactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/common/get_objects_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/get_files_api_request.dart';
import 'package:mobile_sev2/data/payload/api/file/prepare_create_file_api_request.dart';
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_stickit_room_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/stickit/get_stickit_api_request.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:mobile_sev2/domain/file.dart' as FileDomain;

class DetailStickitController extends BaseController {
  DetailStickitPresenter _presenter;
  DateUtilInterface _dateUtil;
  List<User> _userList;
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  DownloaderInterface _downloader;

  bool _isUploading = false;
  List<FileDomain.File> _uploadedFiles = [];
  List<FileDomain.File> _files = [];
  List<PhTransaction> _transactionsTmp = [];
  List<PhTransaction> _fTransactions = [];

  late DetailStickitArgs _args;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNodeMsg = FocusNode();

  Stickit? _stickit;

  List<PhTransaction> _transactions = [];

  List<ObjectReactions> _objectReactions = [];

  ExpandableText _expandableText = ExpandableText("", charLimit: 100);

  List<Suggestion> userSuggestion = [];

  bool _isSendingMessage = false;

  ExpandableText get expandableText => _expandableText;

  Stickit? get stickit => _stickit;

  List<PhTransaction>? get transactions => _transactions;

  TextEditingController get textEditingController => _textEditingController;

  FocusNode get focusNodeMsg => _focusNodeMsg;

  bool get isSendingMessage => _isSendingMessage;

  bool get isUploading => _isUploading;

  List<FileDomain.File> get uploadedFiles => _uploadedFiles;

  List<FileDomain.File> get files => _files;

  DownloaderInterface get downloader => _downloader;

  DetailStickitController(
    this._presenter,
    this._dateUtil,
    this._userList,
    this._filePicker,
    this._encoder,
    this._downloader,
  );

  Map<String, PreviewData> mapData = Map();

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _args = args as DetailStickitArgs;
      print(_args.toPrint());
    }
  }

  @override
  void load() {
    _mapUserListToSuggestion();
    _getStickit();
    _getTransaction();
  }

  void _mapUserListToSuggestion() {
    userSuggestion.clear();
    if (_userList.isNotEmpty) {
      _userList.forEach((user) {
        userSuggestion.add(
          Suggestion(
            imageURL: user.avatar!,
            subtitle: user.name!,
            title: user.fullName!,
          ),
        );
      });
    }
    // else {
    //   _presenter.onGetListUserFromDb(GetListUserDBRequest());
    // }
  }

  List<Suggestion> filterUserSuggestion(String query) {
    return userSuggestion
        .where((user) => user.subtitle.toLowerCase().contains(query))
        .toList();
  }

  void sendMessage() {
    // if txt is empty, then ignore it
    if (_textEditingController.text.trim().isEmpty) return;

    _presenter.onStickitTransaction(
      CreateLobbyRoomStickitApiRequest(
        objectIdentifier: _stickit?.id,
        comment: _textEditingController.text,
      ),
    );
    _isSendingMessage = true;
    _textEditingController.clear();
    _uploadedFiles.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    refreshUI();
    // _chats.insert(
    //   0,
    //   Chat(
    //     Chat.SEND_MESSAGE_ID,
    //     _dateUtil.now(),
    //     _textEditingController.text,
    //     false,
    //     room!.id,
    //     sender: _userData.toUser(),
    //     quotedChat: QuotedChat("", _repliedMessage),
    //   ),
    // );
    // _presenter.onSendMessage(
    //   SendMessageApiRequest(
    //     room!.id,
    //     _repliedMessage != ""
    //         ? ">$_repliedMessage\n${_textEditingController.text}"
    //         : "${_textEditingController.text}",
    //   ),
    // );
    // refreshUI();
    // _textEditingController.clear();
    // _uploadedFiles.clear();
    // _isSendingMessage = false;
    // _repliedMessage = "";
    // _isActiveReply = false;
  }

  @override
  void initListeners() {
    _presenter.getStickitsOnNext =
        (List<Stickit> stickits, PersistenceType type) {
      print("detail stickit: success getStickits ${stickits.length} $type");
      if (stickits.isNotEmpty) {
        _stickit = stickits.first.clone();
        print("stickit: ${_stickit?.stickitType}");
        _expandableText = ExpandableText(
          _stickit?.htmlContent ?? "",
          charLimit: 100,
        );
      }
      refreshUI();
    };
    _presenter.getStickitsOnComplete = (PersistenceType type) {
      print("detail stickit: completed getStickits $type");
      loading(false);
    };
    _presenter.getStickitsOnError = (e, PersistenceType type) {
      print("detail stickit: error getStickits $e $type");
      loading(false);
    };

    _presenter.getTransactionsOnNext =
        (List<PhTransaction> transactions, PersistenceType type) {
      print("detail: success getTransactions $type ${transactions.length}");
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
    };

    _presenter.stickitTransactionOnNext = (bool result, PersistenceType type) {
      print("detail: success stickitTransaction $type");
    };

    _presenter.stickitTransactionOnComplete = (PersistenceType type) {
      print("detail: completed stickitTransaction $type");
      // _forceRefresh();
      _getTransaction();
      _isSendingMessage = false;
      refreshUI();
    };

    _presenter.stickitTransactionOnError = (e, PersistenceType type) {
      print("detail: error.stickitTransaction: $e $type");
      _isSendingMessage = false;
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
    };

    // send reaction
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
    };
  }

  @override
  Future<void> reload({String? type}) {
    load();
    return super.reload();
  }

  void collapseContent() {
    _expandableText.collapse();
    refreshUI();
  }

  void expandContent() {
    _expandableText.expand();
    refreshUI();
  }

  void _getStickit() {
    _presenter.onGetStickit(
      GetStickitsApiRequest(
        phids: [_args.phid ?? ""],
        limit: 1,
      ),
    );
  }

  void _getTransaction() {
    _presenter.onGetTransactions(
      GetObjectTransactionsApiRequest(
        identifier: _args.phid,
      ),
    );
  }

  String parseTime(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
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
      arguments: CreateArgs(type: Stickit, object: _stickit),
    );

    if (result != null) {
      reload();
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

  FutureOr<bool> onOpen(String link) async {
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
    return true;
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

  void reportStickit() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments:
                ReportArgs(phId: _stickit?.id ?? "", reportedType: "STICKIT"),
          );
        });
  }
}
