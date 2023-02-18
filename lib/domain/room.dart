import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'room.g.dart';

@HiveType(typeId: 17)
class Room extends PhObject {
  @HiveField(7)
  String description;

  @HiveField(9)
  bool isPinned = false;

  @HiveField(10)
  bool isGroup = false;

  @HiveField(11)
  int unreadChats;

  @HiveField(12)
  String url;

  @HiveField(13)
  User? lastMessageSender;

  @HiveField(14)
  String? lastMessage;

  @HiveField(15)
  FileType? lastMessageType;

  @HiveField(16)
  DateTime? lastMessageCreatedAt;

  @HiveField(17)
  List<User>? participants = [];

  @HiveField(18)
  List<Chat>? chats = [];

  @HiveField(19)
  List<File>? attachments = [];

  @HiveField(20)
  String? memberCount;

  @HiveField(21)
  bool? isOwner;

  @HiveField(22)
  bool? isFavorite;

  @HiveField(23)
  bool? isDeleted;

  @HiveField(24)
  String? workspaceId;

  int? participantCount;

  bool? isJoinable;

  Room(
    id, {
    this.participants,
    this.description = "",
    this.chats,
    this.unreadChats = 0,
    this.url = "",
    this.attachments,
    this.isPinned = false,
    this.isGroup = false,
    this.lastMessageSender,
    this.lastMessage = "",
    this.lastMessageCreatedAt,
    this.memberCount,
    this.isOwner,
    this.isFavorite,
    this.isDeleted,
    this.workspaceId,
    this.participantCount,
    this.isJoinable,
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

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'avatar': avatar,
        'is_pinned': isPinned,
        'is_group': isGroup,
        'unread_chats': unreadChats,
        'url': url,
        'last_message_sender': jsonEncode(lastMessageSender),
        'last_message': lastMessage,
        'last_message_created_at': lastMessageCreatedAt == null ? 0 : lastMessageCreatedAt?.millisecondsSinceEpoch,
        'participants': jsonEncode(participants),
        'chats': jsonEncode(chats),
        'attachments': jsonEncode(attachments),
        'member_count': memberCount,
        'participant_count': participantCount,
        'is_joinable': isJoinable,
        'is_owner': isOwner,
        'is_favorite': isFavorite,
        'is_deleted': isDeleted,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      json['id'],
      description: json['description'],
      avatar: json['avatar'],
      isPinned: json['is_pinned'],
      isGroup: json['is_group'],
      unreadChats: json['unread_chats'],
      url: json['url'],
      lastMessageSender: jsonDecode(json['last_message_sender']),
      lastMessage: json['last_message_created_at'],
      lastMessageCreatedAt: json['last_message'] == 0
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(json['last_message_created_at']),
      participants: (jsonDecode(json['participants']) as List).map((e) => User.fromJson(e)).toList(),
      chats: (jsonDecode(json['chats']) as List).map((e) => Chat.fromJson(e)).toList(),
      attachments: (jsonDecode(json['attachments']) as List).map((e) => File.fromJson(e)).toList(),
      memberCount: json['member_count'],
      participantCount: json['participant_count'],
      isJoinable: json['is_joinable'],
      isOwner: json['is_owner'],
      isFavorite: json['is_favorite'],
      isDeleted: json['is_deleted'],
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
      workspaceId: "",
    );
  }

  static String getName() {
    return 'room';
  }

  @override
  Room clone() {
    return Room(
      this.id,
      avatar: this.avatar,
      participants: this.participants,
      description: this.description,
      chats: this.chats,
      unreadChats: this.unreadChats,
      url: this.url,
      attachments: this.attachments,
      isPinned: this.isPinned,
      isGroup: this.isGroup,
      lastMessageSender: this.lastMessageSender,
      lastMessage: this.lastMessage,
      lastMessageCreatedAt: this.lastMessageCreatedAt,
      memberCount: this.memberCount,
      participantCount: this.participantCount,
      isJoinable: this.isJoinable,
      isOwner: this.isOwner,
      isFavorite: this.isFavorite,
      isDeleted: this.isDeleted,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
      workspaceId: this.workspaceId,
      fullName: this.fullName,
    );
  }
}
