import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/base.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'chat.g.dart';

// Represent a single message in a chat room
@HiveType(typeId: 2)
class Chat extends PhObject {
  static const SEND_MESSAGE_ID = "send_message_id";
  @HiveField(7)
  User? sender;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  String message;

  String? htmlMessage;

  // system can also send message, for example when new participant arrived or removed
  // we need to differentiate it with message from user
  @HiveField(10)
  bool isFromSystem;

  @HiveField(11)
  String roomId;

  @HiveField(12)
  List<File>? attachments;

  // token/reaction/emoji given in a chat
  @HiveField(13)
  List<Reaction>? reactions;

  // used when we reply a chat intentionally
  @HiveField(14)
  QuotedChat? quotedChat;

  Chat(
    id,
    this.createdAt,
    this.message,
    this.isFromSystem,
    this.roomId, {
    this.htmlMessage,
    this.sender,
    this.attachments,
    this.reactions,
    this.quotedChat,
    uri,
    typeName,
    type,
    name,
    fullName,
    status,
    avatar,
  }) : super(
          id,
          uri: uri,
          typeName: typeName,
          type: type,
          name: name,
          fullName: fullName,
          status: status,
          avatar: avatar,
        );

  // check if a chat has image inside its attachments
  bool hasImage() {
    return this.attachments != null &&
        this
            .attachments!
            .where((at) => at.fileType == FileType.image)
            .toList()
            .isNotEmpty;
  }

  // check if a chat has video inside its video
  bool hasVideo() {
    return this.attachments != null &&
        this
            .attachments!
            .where((at) => at.fileType == FileType.video)
            .toList()
            .isNotEmpty;
  }

  // check if a chat has doc inside its attachments
  bool hasDocument() {
    return this.attachments != null &&
        this
            .attachments!
            .where((at) => at.fileType == FileType.document)
            .toList()
            .isNotEmpty;
  }

  @override
  Map<String, dynamic> toJson() => {
        'sender': jsonEncode(sender),
        'created_at': createdAt.millisecondsSinceEpoch,
        'message': message,
        'is_from_system': isFromSystem,
        'room_id': roomId,
        'attachments': jsonEncode(attachments),
        'reactions': jsonEncode(reactions),
        'quoted_chat': jsonEncode(quotedChat),
        'id': id,
        'full_name': fullName,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      json['id'],
      DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      json['message'],
      json['is_from_system'],
      json['room_id'],
      sender: jsonDecode(json['sender']),
      attachments: (jsonDecode(json['attachments']) as List)
          .map((e) => File.fromJson(e))
          .toList(),
      reactions: (jsonDecode(json['reactions']) as List)
          .map((e) => Reaction.fromJson(e))
          .toList(),
      quotedChat: jsonDecode(json['quoted_chat']),
      fullName: json['full_name'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  static String getName() {
    return 'chat';
  }

  @override
  Chat clone() {
    return Chat(
      this.id,
      this.createdAt,
      this.message,
      this.isFromSystem,
      this.roomId,
      sender: this.sender,
      attachments: this.attachments,
      reactions: this.reactions,
      quotedChat: this.quotedChat,
      fullName: this.fullName,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}

@HiveType(typeId: 3)
class QuotedChat extends BaseDomain {
  @HiveField(0)
  String id;

  @HiveField(1)
  String message;

  QuotedChat(
    this.id,
    this.message,
  );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
      };

  factory QuotedChat.fromJson(Map<String, dynamic> json) {
    return QuotedChat(
        json['id'],
        jsonDecode(
          json['message'],
        ));
  }

  static String getName() {
    return 'quoted_chat';
  }

  @override
  clone() {
    return QuotedChat(
      this.id,
      this.message,
    );
  }
}
