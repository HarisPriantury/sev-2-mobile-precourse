import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/chat/get_messages_api_request.dart';
import 'package:mobile_sev2/data/payload/api/chat/send_message_api_request.dart';
import 'package:mobile_sev2/data/payload/api/flag/get_flags_api_request.dart';
import 'package:mobile_sev2/data/payload/api/topic/subscribe_topic_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/chat_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/flag_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/topic_request_interface.dart';
import 'package:mobile_sev2/data/payload/contracts/user_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/topic/SubscribeListDBRequest.dart';
import 'package:mobile_sev2/data/payload/db/topic/subscribe_topic_db_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/flag.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/use_cases/chat/get_messages.dart';
import 'package:mobile_sev2/use_cases/chat/send_message.dart';
import 'package:mobile_sev2/use_cases/flag/get_flags.dart';

import 'package:mobile_sev2/use_cases/public_space/get_messages_public_space.dart';
import 'package:mobile_sev2/use_cases/topic/get_subscribe_list.dart';
import 'package:mobile_sev2/use_cases/topic/subscribe_topic.dart';
import 'package:mobile_sev2/use_cases/topic/unsubscribe_topic.dart';
import 'package:mobile_sev2/use_cases/user/get_users.dart';

class PublicSpaceRoomPresenter extends Presenter {
  GetMessagesPublicSpaceUseCase _getMessagesPublicSpaceUseCase;
  GetMessagesUseCase _messageUseCase;
  SendMessageUseCase _sendUseCase;
  GetUsersUseCase _getUsersUseCase;
  GetFlagsUseCase _getFlagsUseCase;

  // topic
  SubscribeTopicUseCase _subscribeUseCase;
  SubscribeTopicUseCase _subscribeDBUseCase;

  UnsubscribeTopicUseCase _unsubscribeUseCase;
  UnsubscribeTopicUseCase _unsubscribeDBUseCase;

  GetSubscribeListUseCase _subscribeListUseCase;

  PublicSpaceRoomPresenter(
    this._getMessagesPublicSpaceUseCase,
    this._messageUseCase,
    this._sendUseCase,
    this._getUsersUseCase,
    this._subscribeUseCase,
    this._subscribeDBUseCase,
    this._unsubscribeUseCase,
    this._unsubscribeDBUseCase,
    this._subscribeListUseCase,
    this._getFlagsUseCase,
  );

  late Function getMessagesPublicSpaceOnNext;
  late Function getMessagesPublicSpaceOnComplete;
  late Function getMessagesPublicSpaceOnError;

  // get messages
  late Function getMessagesOnNext;
  late Function getMessagesOnComplete;
  late Function getMessagesOnError;

  // get users
  late Function getUsersOnNext;
  late Function getUsersOnComplete;
  late Function getUsersOnError;

  // send message
  late Function sendMessageOnNext;
  late Function sendMessageOnComplete;
  late Function sendMessageOnError;

  // subscribe
  late Function subscribeOnNext;
  late Function subscribeOnComplete;
  late Function subscribeOnError;

  // unsubscribe
  late Function unsubscribeOnNext;
  late Function unsubscribeOnComplete;
  late Function unsubscribeOnError;

  // get subscribe list
  late Function getSubscribeListOnNext;
  late Function getSubscribeListOnComplete;
  late Function getSubscribeListOnError;

  // get reported message list
  late Function getFlagsOnNext;
  late Function getFlagsOnComplete;
  late Function getFlagsOnError;

  void onGetMessages(GetMessagesRequestInterface req) {
    if (req is GetMessagesApiRequest) {
      _messageUseCase.execute(
          _GetMessagesObserver(this, PersistenceType.api), req);
    }
    // else {
    //   _messageDbUseCase.execute(_GetMessagesObserver(this, PersistenceType.db), req);
    // }
  }

  void onGetMessagesPublicSpace(GetMessagesPublicSpaceRequestInterface req) {
    _getMessagesPublicSpaceUseCase.execute(
      _GetMessagesPublicSpaceObserver(this),
      req,
    );
  }

  void onSendMessage(SendMessageRequestInterface req) {
    if (req is SendMessageApiRequest) {
      _sendUseCase.execute(
          _SendMessageObserver(this, PersistenceType.api), req);
    }
  }

  void onGetUsers(
    GetUsersRequestInterface req,
    String from, {
    bool isNewMessage = false,
  }) {
    _getUsersUseCase.execute(
        _GetUsersObserver(
          this,
          PersistenceType.api,
          from,
          isNewMessage,
        ),
        req);
  }

  void onSubscribe(SubscribeTopicRequestInterface req) {
    if (req is SubscribeTopicApiRequest) {
      _subscribeUseCase.execute(
          _SubscribeTopicObserver(
            this,
            PersistenceType.api,
            req.topic,
          ),
          req);
    } else {
      _subscribeDBUseCase.execute(
        _SubscribeTopicObserver(
          this,
          PersistenceType.db,
          (req as SubscribeTopicDBRequest).topic,
        ),
        req,
      );
    }
  }

  void onUnsubscribe(SubscribeTopicRequestInterface req) {
    if (req is SubscribeTopicApiRequest) {
      _unsubscribeUseCase.execute(
          _UnsubscribeTopicObserver(
            this,
            PersistenceType.api,
          ),
          req);
    } else {
      _unsubscribeDBUseCase.execute(
          _UnsubscribeTopicObserver(
            this,
            PersistenceType.db,
          ),
          req);
    }
  }

  void onGetSubscribeList(SubscribeListRequestInterface req) {
    if (req is SubscribeListDBRequest) {
      _subscribeListUseCase.execute(
          _SubscribeListObserver(
            this,
            PersistenceType.db,
          ),
          req);
    }
  }

  void onGetFlags(GetFlagsRequestInterface req) {
    if (req is GetFlagsApiRequest) {
      _getFlagsUseCase.execute(
        _GetFlagsObserver(
          this,
          PersistenceType.api,
        ),
        req,
      );
    }
  }

  @override
  void dispose() {
    _getMessagesPublicSpaceUseCase.dispose();
    _messageUseCase.dispose();
    _sendUseCase.dispose();
    _getUsersUseCase.dispose();
    _subscribeListUseCase.dispose();
    _subscribeUseCase.dispose();
    _subscribeDBUseCase.dispose();
    _unsubscribeUseCase.dispose();
    _unsubscribeDBUseCase.dispose();
    _getFlagsUseCase.dispose();
  }
}

class _GetMessagesPublicSpaceObserver implements Observer<List<Chat>> {
  PublicSpaceRoomPresenter _presenter;

  _GetMessagesPublicSpaceObserver(this._presenter);

  @override
  void onComplete() {
    _presenter.getMessagesPublicSpaceOnComplete();
  }

  @override
  void onError(e) {
    _presenter.getMessagesPublicSpaceOnError(e);
  }

  @override
  void onNext(List<Chat>? response) {
    _presenter.getMessagesPublicSpaceOnNext(response);
  }
}

class _GetMessagesObserver implements Observer<List<Chat>> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;

  _GetMessagesObserver(this._presenter, this._type);

  void onNext(List<Chat>? chats) {
    _presenter.getMessagesOnNext(chats, _type);
  }

  void onComplete() {
    _presenter.getMessagesOnComplete(_type);
  }

  void onError(e) {
    _presenter.getMessagesOnError(e, _type);
  }
}

class _SendMessageObserver implements Observer<bool> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;

  _SendMessageObserver(this._presenter, this._type);

  void onNext(bool? result) {
    _presenter.sendMessageOnNext(result, _type);
  }

  void onComplete() {
    _presenter.sendMessageOnComplete(_type);
  }

  void onError(e) {
    _presenter.sendMessageOnError(e, _type);
  }
}

class _GetUsersObserver implements Observer<List<User>> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;
  String from;
  bool isNewMessage;

  _GetUsersObserver(
    this._presenter,
    this._type,
    this.from,
    this.isNewMessage,
  );

  void onNext(List<User>? users) {
    _presenter.getUsersOnNext(users, _type, from, isNewMessage);
  }

  void onComplete() {
    _presenter.getUsersOnComplete(_type);
  }

  void onError(e) {
    _presenter.getUsersOnError(e, _type);
  }
}

class _SubscribeTopicObserver implements Observer<Topic> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;
  Topic _topic;

  _SubscribeTopicObserver(this._presenter, this._type, this._topic);

  void onNext(Topic? result) {
    _presenter.subscribeOnNext(_topic, _type);
  }

  void onComplete() {
    _presenter.subscribeOnComplete(_type);
  }

  void onError(e) {
    _presenter.subscribeOnError(e, _type);
  }
}

class _UnsubscribeTopicObserver implements Observer<void> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;

  _UnsubscribeTopicObserver(this._presenter, this._type);

  void onNext(void result) {
    _presenter.unsubscribeOnNext(result, _type);
  }

  void onComplete() {
    _presenter.unsubscribeOnComplete(_type);
  }

  void onError(e) {
    _presenter.unsubscribeOnError(e, _type);
  }
}

class _SubscribeListObserver implements Observer<List<Topic>> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;

  _SubscribeListObserver(this._presenter, this._type);

  void onNext(List<Topic>? result) {
    _presenter.getSubscribeListOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getSubscribeListOnComplete(_type);
  }

  void onError(e) {
    _presenter.getSubscribeListOnError(e, _type);
  }
}

class _GetFlagsObserver implements Observer<List<Flag>> {
  PublicSpaceRoomPresenter _presenter;
  PersistenceType _type;

  _GetFlagsObserver(this._presenter, this._type);

  void onNext(List<Flag>? result) {
    _presenter.getFlagsOnNext(result, _type);
  }

  void onComplete() {
    _presenter.getFlagsOnComplete(_type);
  }

  void onError(e) {
    _presenter.getFlagsOnError(e, _type);
  }
}
