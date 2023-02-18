import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/events/refresh.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/infrastructures/misc/sheet_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/author_reaction_sheet.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/add_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/main/args.dart';
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
import 'package:mobile_sev2/data/payload/api/lobby/create_lobby_room_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/get_object_reactions_api_request.dart';
import 'package:mobile_sev2/data/payload/api/reaction/give_reaction_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_ticket_info_api_request.dart';
import 'package:mobile_sev2/data/payload/api/ticket/get_tickets_api_request.dart';
import 'package:mobile_sev2/data/payload/api/user/get_users_api_request.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:rich_text_view/rich_text_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_sev2/domain/file.dart' as FileDomain;
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

import 'presenter.dart';

class DetailTicketController extends SheetController {
  bool _isExpandDescription = false;
  bool get isExpandDescription => _isExpandDescription;

  bool _isSendingMessage = false;
  bool get isSendingMessage => _isSendingMessage;

  final TextEditingController _textEditingController = TextEditingController();
  TextEditingController get textEditingController => _textEditingController;

  final FocusNode _focusNodeMsg = FocusNode();
  FocusNode get focusNodeMsg => _focusNodeMsg;

  List<Suggestion> userSuggestion = [];

  void onExpandDescription() {
    _isExpandDescription = !_isExpandDescription;
    refreshUI();
  }

  List<Suggestion> filterUserSuggestion(String query) {
    return userSuggestion
        .where((user) => user.subtitle.toLowerCase().contains(query))
        .toList();
  }

  void sendMessage() {
    if (_textEditingController.text.trim().isEmpty) return;

    _presenter.onTaskTransaction(
      CreateLobbyRoomTicketApiRequest(
        objectIdentifier: _ticketObj?.id,
        comment: _textEditingController.text,
      ),
    );
    _isSendingMessage = true;
    _textEditingController.clear();
    _uploadedFiles.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    refreshUI();
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
  }

  DetailTicketPresenter _presenter;
  DetailTicketArgs? _data;
  DateUtilInterface _dateUtil;
  UserData _userData;
  List<User> _userList;
  EventBus _eventBus;

  // create transaction request
  CreateLobbyRoomTicketApiRequest _createTaskRequest =
      CreateLobbyRoomTicketApiRequest();

  //this is [Set] because every action can only called once
  Ticket? _ticketObj;
  List<PhTransaction> _transactions = [];

  List<Ticket> _subtask = [];
  List<Ticket> get subtask => _subtask;
  List<Ticket> _parentTask = [];
  List<Ticket> get parenTask => _parentTask;
  List<PhObject> _formerSubscribers = [];
  List<PhObject> get formerSubscribers => _formerSubscribers;

  List<ObjectReactions> _objectReactions = [];

  // hold ticket priority and status
  String? _ticketPriority;
  String? _ticketStatus;

  // project status
  bool _isForRsp = false;
  bool _isForDev = false;
  bool _isArchived = false;
  bool isChanged = true;
  String? _projectStatus;

  // files
  FilesPickerInterface _filePicker;
  EncoderInterface _encoder;
  DownloaderInterface _downloader;
  bool _isUploading = false;
  List<FileDomain.File> _uploadedFiles = [];
  List<FileDomain.File> _files = [];
  List<PhTransaction> _transactionsTmp = [];
  List<PhTransaction> _fTransactions = [];

  // mention
  Map<String, PreviewData> mapData = Map();

  // first project column id
  String _firstProjectColumnId = "";

  bool _isReloadReaction = false;

  int _parentTaskLength = 0;

  int _subTaskLength = 0;

  bool _isHasParentTask = false;

  bool _isHasSubtasks = false;

  DetailTicketController(
    this._presenter,
    this._userData,
    this._dateUtil,
    this._userList,
    this._eventBus,
    this._filePicker,
    this._encoder,
    this._downloader,
  );

  Ticket? get ticketObj => _ticketObj;

  List<PhTransaction>? get transactions => _transactions;

  int get parentTaskLength => _parentTaskLength;

  int get subTaskLength => _subTaskLength;

  bool get isHasParentTask => _isHasParentTask;

  bool get isHasSubtasks => _isHasSubtasks;

  bool get isUploading => _isUploading;

  List<FileDomain.File> get uploadedFiles => _uploadedFiles;

  void sendReaction(reactionId, objectId) {
    _presenter.onSendReaction(GiveReactionApiRequest(reactionId, objectId));
  }

  void _refreshDetailTickets() {
    loading(true);
    _presenter.onGetTickets(
      GetTicketsApiRequest(
        queryKey: GetTicketsApiRequest.QUERY_ALL,
        phids: [_data!.phid!],
      ),
    );
  }

  String getTicketPolicy() {
    String policy = 'All User';
    if (ticketObj?.project != null) {
      if (ticketObj?.project?.viewPolicy != null &&
          ticketObj!.project!.viewPolicy.isNotEmpty) {
        policy = ticketObj!.project!.viewPolicy;
      }
    }
    return policy;
  }

  void goToDepedencyTicket(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id, id: ticket.intId),
    );

    reload();
  }

  Future<void> goToEditPage({bool isSubTask = false}) async {
    if (isSubTask) {
      Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(
            type: Ticket,
            object: _ticketObj,
            isSubTask: isSubTask,
            columnId: _firstProjectColumnId),
      );
      refreshUI();
    } else {
      var result = await Navigator.pushNamed(
        context,
        Pages.create,
        arguments: CreateArgs(type: Ticket, object: _ticketObj),
      );

      if (result != null) {
        _refreshDetailTickets();
      }
    }
  }

  Future<void> goToTaskActionPage(TaskActionType type) async {
    if (_ticketObj != null) {
      var result = await Navigator.pushNamed(
        context,
        Pages.taskAction,
        arguments: TaskActionArgs(
          type: type,
          task: _ticketObj!,
          subTask: _subtask.isNotEmpty ? _subtask : _parentTask,
        ),
      );
      if (result != null) {
        reload();
      }
    }
  }

  void goToAddActionPage() {
    if (_ticketObj != null) {
      Navigator.of(context).pushNamed(
        Pages.addAction,
        arguments: AddActionArgs(id: _ticketObj!.id),
      );
    }
  }

  @override
  void load() {
    _mapUserListToSuggestion();

    _refreshDetailTickets();
  }

  void getTransaction() {
    _presenter.onGetTransactions(
      GetObjectTransactionsApiRequest(
        identifier: _ticketObj?.id,
      ),
    );
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DetailTicketArgs;
      print(_data?.toPrint());
    }
  }

  @override
  void initListeners() {
    _eventBus.on<Refresh>().listen((event) {
      reload();
    });
    _presenter.getUsersOnNext =
        (List<User> users, PersistenceType type, String role) {
      print("detail ticket: success getUsers $type $role, ${users.length}");
      if (role == "owner") {
        if (users.length == 1) {
          if (_ticketObj != null) {
            if (users.first.id == _ticketObj!.author!.id) {
              _ticketObj?.author = users.first;
            }
          }
        }
        users.forEach((u) {
          if (_ticketObj != null) {
            if (u.id == _ticketObj!.assignee!.id) {
              _ticketObj?.assignee = u;
            }

            if (u.id == _ticketObj!.author!.id) {
              _ticketObj?.author = u;
            }
          }
        });
      } else if (role == "subscribers") {
        _formerSubscribers.clear();
        _formerSubscribers.addAll(users);
        refreshUI();
      }
    };

    _presenter.getUsersOnComplete = (PersistenceType type) {
      print("detail ticket: completed getUsers $type");
      loading(false);
    };

    _presenter.getUsersOnError = (e, PersistenceType type) {
      print("detail ticket: error getUsers: $e $type");
    };

    _presenter.getTransactionsOnNext =
        (List<PhTransaction> transactions, PersistenceType type) {
      print("detail ticket: success getTransactions $type");

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
      print("detail ticket: completed getTransactions $type");
      _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
          objectIds: _transactions.map((e) => e.id).toList()));
    };

    _presenter.getTransactionsOnError = (e, PersistenceType type) {
      print("detail ticket: error getTransactions: $e $type");
    };

    _presenter.getObjectsOnNext =
        (List<PhObject> objects, PersistenceType type) {
      print("detail ticket: success getObjects $type");

      objects.forEach((obj) {
        // var ts = _transactions.where((t) => t.actor.id == obj.id);
        // ts.forEach((tsi) {
        //   var idx = _transactions.indexWhere((t) => t.id == tsi.id);
        //   if (idx >= 0) {
        //     _transactions[idx].actor = obj;
        //   }
        // });

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
      print("detail ticket: completed getObjects $type");
      // loading(false);
    };

    _presenter.getObjectsOnError = (e, PersistenceType type) {
      print("detail ticket: error getObjects: $e $type");
    };

    _presenter.getTicketSubscribersOnNext =
        (TicketSubscriberInfo subscribersInfo, PersistenceType type) {
      print("detail ticket: success getTicketSubscribers $type");
      if (_ticketObj != null) {
        _ticketObj!.subscriberInfo = subscribersInfo;
        if (subscribersInfo.totalSubscriber > 0)
          _presenter.onGetUsers(
              GetUsersApiRequest(ids: ticketObj!.subscriberInfo!.subscriberIds),
              "subscribers");
      }
    };

    _presenter.getTicketSubscribersOnComplete = (PersistenceType type) {
      print("detail ticket: completed getTicketSubscribers $type");
      refreshUI();
    };

    _presenter.getTicketSubscribersOnError = (e, PersistenceType type) {
      print("detail ticket: error getTicketSubscribers: $e $type");
    };

    _presenter.taskTransactionOnNext = (bool result, PersistenceType type) {
      print("detail ticket: success taskTransaction $type");
    };

    _presenter.taskTransactionOnComplete = (PersistenceType type) {
      print("detail ticket: completed taskTransaction $type");
      // _forceRefresh();
      _isSendingMessage = false;
      getTransaction();
      refreshUI();
    };

    _presenter.taskTransactionOnError = (e, PersistenceType type) {
      print("detail ticket: error taskTransaction: $e $type");
      _isSendingMessage = false;
    };

    // send reaction
    _presenter.sendReactionOnNext = (bool result, PersistenceType type) {
      print("detail ticket: success sendReaction");
      //
    };

    _presenter.sendReactionOnComplete = (PersistenceType type) {
      print("detail ticket: completed sendReaction");
      _isReloadReaction = true;
      _presenter.onGetObjectReactions(GetObjectReactionsApiRequest(
          objectIds: _transactions.map((e) => e.id).toList()));
    };

    _presenter.sendReactionOnError = (e, PersistenceType type) {
      print("detail ticket: error sendReaction $e");
    };

    // get object reactions
    _presenter.getObjectReactionOnNext = (List<ObjectReactions> result) {
      print("detail ticket: success getObjectReactions ${result.length}");
      if (_isReloadReaction) {
        _transactions.forEach((element) {
          element.reactions?.clear();
        });
        _objectReactions.clear();
      }
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
      print("detail ticket: completed getObjectReactions");
    };

    _presenter.getObjectReactionOnError = (e) {
      print("detail ticket: error getObjectReactions $e");
    };

    _presenter.getTicketsOnNext = (List<Ticket> tickets, PersistenceType type) {
      if (tickets.isNotEmpty) {
        _ticketObj = tickets.first;
        _presenter.onGetColumnTicket(
            GetProjectColumnTicketApiRequest(_ticketObj!.project!.id));
      }
      getRelatedTask(tickets.length > 0 ? tickets.first : null);
      if (tickets.first.assignee != null) {
        _presenter.onGetUsers(
          GetUsersApiRequest(
            ids: [ticketObj!.author!.id, ticketObj!.assignee!.id],
          ),
          "owner",
        );
      } else {
        _presenter.onGetUsers(
          GetUsersApiRequest(ids: [ticketObj!.author!.id]),
          "owner",
        );
      }

      _presenter.onGetTicketSubscribers(
        GetTicketInfoApiRequest(
          tickets.first.intId.toString(),
        ),
      );

      getTransaction();
      refreshUI();
    };
    _presenter.getTicketsOnComplete = (PersistenceType type) {
      print("detail ticket: completed getTickets $type");
      loading(false);
    };
    _presenter.getTicketsOnError = (e, PersistenceType type) {
      print("detail ticket: error getTickets $e $type");
      loading(false);
    };

    // upload file
    _presenter.uploadFileOnNext =
        (BaseApiResponse result, PersistenceType type) {
      print("detail ticket: success uploadFile");
      _presenter.onGetFiles(
          GetFilesApiRequest(phids: [result.result]), "upload");
    };

    _presenter.uploadFileOnComplete = (PersistenceType type) {
      print("detail ticket: complete uploadFile");
    };

    _presenter.uploadFileOnError = (e, PersistenceType type) {
      print("detail ticket: error uploadFile");
    };

    // prepare upload file
    _presenter.prepareFileUploadOnNext = (bool result, PersistenceType type) {
      print("detail ticket: success prepareFileUpload");
      //
    };

    _presenter.prepareFileUploadOnComplete = (PersistenceType type) {
      print("detail ticket: completed prepareFileUpload");
      _isUploading = false;
    };

    _presenter.prepareFileUploadOnError = (e, PersistenceType type) {
      print("detail ticket: error prepareFileUpload $e");
    };

    // get files
    _presenter.getFilesOnNext =
        (List<FileDomain.File> files, PersistenceType ptype, String type) {
      print("detail ticket: success getFiles");

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
      print("detail ticket: completed getFiles");
      refreshUI();
    };

    _presenter.getFilesOnError = (e, PersistenceType type) {
      print("detail ticket: error getFiles $e");
    };

    _presenter.getColumnsTicketOnNext = (List<ProjectColumn> columns) {
      print("detail ticket: success getColumnTicket ${columns.length}");
      List<ProjectColumn> _tempColumns = [];
      _tempColumns.addAll(columns);
      _tempColumns.sort((a, b) {
        if (a.sequence == null) {
          return 1;
        } else if (b.sequence == null) {
          return -1;
        }
        return a.sequence!.compareTo(b.sequence!);
      });
      _firstProjectColumnId = _tempColumns.first.id;
    };

    _presenter.getColumnsTicketOnComplete = () {
      print("detail ticket: completed getColumnTicket");
      loading(false);
      refreshUI();
    };

    _presenter.getColumnsTicketOnError = (e) {
      print("detail ticket: error getColumnTicket: $e");
      loading(false);
    };
  }

  bool isAuthor() {
    return _ticketObj!.author?.id == _userData.id ||
        _ticketObj!.assignee?.id == _userData.id;
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
    if (link.contains("/T")) {
      link = "https://refactory.sev-2.com/$link";
      uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $link';
      }
    } else {
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
    return true;
  }

  bool hasDependencies() {
    return _isHasParentTask || _isHasSubtasks;
  }

  void getRelatedTask(Ticket? ticket) {
    if (ticket!.parentTask != null || ticket.subTasks != null) {
      if (ticket.parentTask!.isNotEmpty && ticket.subTasks!.isNotEmpty) {
        _parentTaskLength = ticket.parentTask!.length;
        _parentTask = ticket.parentTask!;
        _isHasParentTask = true;

        _subTaskLength = ticket.subTasks!.length;
        _subtask = ticket.subTasks!;
        _isHasSubtasks = true;
      } else if (ticket.parentTask!.isNotEmpty) {
        _parentTaskLength = ticket.parentTask!.length;
        _parentTask = ticket.parentTask!;
        _isHasParentTask = true;
      } else if (ticket.subTasks!.isNotEmpty) {
        _subTaskLength = ticket.subTasks!.length;
        _subtask = ticket.subTasks!;
        _isHasSubtasks = true;
      } else {
        _parentTaskLength = 0;
        _isHasParentTask = false;
        _subTaskLength = 0;
        _subtask.clear();
        _isHasSubtasks = false;
      }
    }
    refreshUI();
  }

  //TODO: check if ticket has mocks
  bool hasMocks() {
    return false;
  }

  //TODO: check if ticket has duplicates
  bool hasDuplicates() {
    return false;
  }

  String parseTime(DateTime dt) {
    return _dateUtil.displayDateTimeFormat(dt);
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    reloading(true);
    _refreshDetailTickets();
    _createTaskRequest = CreateLobbyRoomTicketApiRequest();
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
      },
    );
  }

  void backPage() {
    if (_data!.from == Pages.splash) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        Pages.main,
        (Route<dynamic> route) => false,
        arguments: MainArgs(Pages.splash),
      );
    } else {
      _eventBus.fire(Refresh());
      Navigator.pop(context, true);
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

  void reportRoom() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return PopupReport(
            arguments:
                ReportArgs(phId: _ticketObj?.id ?? "", reportedType: "TICKET"),
          );
        });
  }
}
