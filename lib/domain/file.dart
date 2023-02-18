import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/user.dart';

part 'file.g.dart';

@HiveType(typeId: 5)
class File extends PhObject {
  @HiveField(7)
  int idInt;

  @HiveField(8)
  FileType fileType;

  @HiveField(9)
  String mimeType;

  @HiveField(10)
  String title;

  @HiveField(11)
  String url;

  @HiveField(12)
  int size;

  @HiveField(13)
  DateTime? createdAt;

  @HiveField(14)
  User? author;

  File(
    id, {
    this.idInt = 0,
    this.fileType = FileType.image,
    this.url = "",
    this.title = "",
    this.size = 0,
    this.mimeType = "",
    this.createdAt,
    this.author,
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
        ) {
    this.createdAt = createdAt ?? DateTime.now();
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'idInt': idInt,
        'file_type': fileType == FileType.image
            ? 'image'
            : fileType == FileType.video
                ? 'video'
                : fileType == FileType.document
                    ? 'document'
                    : 'link',
        'url': url,
        'mime_type': mimeType,
        'title': title,
        'size': size,
        'created_at': createdAt?.millisecondsSinceEpoch,
        'author': author,
        'name': name,
        'status': status,
        'type': type,
        'type_name': typeName,
        'uri': uri,
      };

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      json['id'],
      idInt: json['idInt'],
      fileType: json['type'] == 'image'
          ? FileType.image
          : json['type'] == 'video'
              ? FileType.video
              : json['type'] == 'document'
                  ? FileType.document
                  : FileType.link,
      mimeType: json['mime_type'],
      url: json['url'],
      title: json['title'],
      size: json['size'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      author: jsonDecode(json['size']),
      name: json['name'],
      status: json['status'],
      type: json['type'],
      typeName: json['type_name'],
      uri: json['uri'],
    );
  }

  // get size in humanize words
  // return such as: 1 MB, 2 KB, or 30 B
  String getFileSizeWording() {
    var notion = "B";
    int iSize = this.size;

    if (iSize >= 1000) {
      iSize = (iSize / 1000).ceil();
      notion = "KB";
    }

    if (iSize >= 1000) {
      iSize = (iSize / 1000).ceil();
      notion = "MB";
    }

    return "$iSize $notion";
  }

  static String getName() {
    return 'file';
  }

  @override
  File clone() {
    return File(
      this.id,
      idInt: this.idInt,
      fileType: this.fileType,
      mimeType: this.mimeType,
      url: this.url,
      title: this.title,
      size: this.size,
      createdAt: this.createdAt,
      author: this.author,
      name: this.name,
      status: this.status,
      type: this.type,
      typeName: this.typeName,
      uri: this.uri,
    );
  }
}

@HiveType(typeId: 6)
enum FileType {
  @HiveField(0)
  image,
  @HiveField(1)
  video,
  @HiveField(2)
  document,
  @HiveField(4)
  link
}
