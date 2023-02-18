import 'package:hive/hive.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/feed.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/job.dart';
import 'package:mobile_sev2/domain/meta/lobby_room_info.dart';
import 'package:mobile_sev2/domain/meta/lobby_status.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/meta/room_participants.dart';
import 'package:mobile_sev2/domain/meta/search_history.dart';
import 'package:mobile_sev2/domain/meta/status_history.dart';
import 'package:mobile_sev2/domain/meta/topic.dart';
import 'package:mobile_sev2/domain/meta/unread_chat.dart';
import 'package:mobile_sev2/domain/notification.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/query.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/setting.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/domain/workspace.dart';

class DataUtil {
  FileType getFileType(String mimeType) {
    var videoMimeTypes = {
      "video/x-flv": true,
      "video/mp4": true,
      "application/x-mpegURL": true,
      "video/MP2T": true,
      "video/3gpp": true,
      "video/quicktime": true,
      "video/x-msvideo": true,
      "video/x-ms-wmv": true
    };

    var imageMimeTypes = {"image/png": true, "image/jpeg": true};

    if (imageMimeTypes[mimeType] != null) {
      return FileType.image;
    } else if (videoMimeTypes[mimeType] != null) {
      return FileType.video;
    } else {
      return FileType.document;
    }
  }

  static bool isHTML(String contents) {
    final RegExp isHTML = RegExp(
      r"(?:</[^<]+>)|(?:<[^<]+/>)",
      caseSensitive: false,
    );

    return isHTML.hasMatch(contents);
  }

  static bool containsFile(String contents) {
    final RegExp isFile = RegExp(
      r"(?:{F[0-9]+})",
      caseSensitive: false,
      multiLine: true,
    );
    return isFile.hasMatch(contents);
  }

  static List<String?> getFiles(String contents) {
    final RegExp isFile = RegExp(
      r"(?:{F[0-9]+})",
      caseSensitive: false,
      multiLine: true,
    );
    var matches = isFile.allMatches(contents).map((e) => e.group(0));
    return matches.toList();
  }

  static bool isFile(String contents) {
    final RegExp isFile = RegExp(
      r"(^{+F[0-9]+})",
      caseSensitive: false,
      multiLine: true,
    );
    return isFile.hasMatch(contents);
  }

  static List<String?> getLinks(String contents) {
    final RegExp isLink = RegExp(
      r"(?:\[\[.*?\]\])",
      caseSensitive: false,
      multiLine: true,
    );
    var matches = isLink
        .allMatches(contents)
        .map((e) => e.group(0))
        .map((e) => e!.replaceAll(RegExp(r"\[|\]|}"), "").trim());
    return matches.toList();
  }

  static List<String?> getRawLinks(String contents) {
    final RegExp isLink = RegExp(
      r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+',
      caseSensitive: false,
      multiLine: true,
    );
    var matches = isLink
        .allMatches(contents)
        .map((e) => e.group(0))
        .map((e) => e!.trim());
    return matches.toList();
  }

  static String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true,
    );

    return htmlText.replaceAll(exp, '');
  }

  static String deleteFileIdFromTransactionContent(
      List<File> attachments, String transactionContent) {
    attachments.forEach((element) {
      transactionContent =
          transactionContent.replaceFirst('{F${element.idInt}}', '');
    });
    return transactionContent.trim();
  }

  static Future<void> clearDb() async {
    // await AppComponent.getInjector().get<Box<Workspace>>().clear();
    await AppComponent.getInjector().get<Box<Calendar>>().clear();
    await AppComponent.getInjector().get<Box<PhObject>>().clear();
    await AppComponent.getInjector().get<Box<PhTransaction>>().clear();
    await AppComponent.getInjector().get<Box<Stickit>>().clear();
    await AppComponent.getInjector().get<Box<LobbyRoomInfo>>().clear();
    await AppComponent.getInjector().get<Box<LobbyStatus>>().clear();
    await AppComponent.getInjector().get<Box<ObjectReactions>>().clear();
    await AppComponent.getInjector().get<Box<UnreadChat>>().clear();
    await AppComponent.getInjector().get<Box<User>>().clear();
    await AppComponent.getInjector().get<Box<WorkInfo>>().clear();
    await AppComponent.getInjector().get<Box<HiringInfo>>().clear();
    await AppComponent.getInjector().get<Box<StoryPointInfo>>().clear();
    await AppComponent.getInjector().get<Box<SubscriptionInfo>>().clear();
    await AppComponent.getInjector().get<Box<ProjectsInfo>>().clear();
    await AppComponent.getInjector().get<Box<TicketSubscriberInfo>>().clear();
    await AppComponent.getInjector().get<Box<Ticket>>().clear();
    await AppComponent.getInjector().get<Box<Room>>().clear();
    await AppComponent.getInjector().get<Box<Project>>().clear();
    await AppComponent.getInjector().get<Box<Notification>>().clear();
    await AppComponent.getInjector().get<Box<JobApplication>>().clear();
    await AppComponent.getInjector().get<Box<Job>>().clear();
    await AppComponent.getInjector().get<Box<File>>().clear();
    await AppComponent.getInjector().get<Box<Feed>>().clear();
    await AppComponent.getInjector().get<Box<QuotedChat>>().clear();
    await AppComponent.getInjector().get<Box<Reaction>>().clear();
    await AppComponent.getInjector().get<Box<Chat>>().clear();
    await AppComponent.getInjector().get<Box<RoomParticipants>>().clear();
    await AppComponent.getInjector().get<Box<StatusHistory>>().clear();
    await AppComponent.getInjector().get<Box<Phone>>().clear();
    await AppComponent.getInjector().get<Box<Email>>().clear();
    await AppComponent.getInjector().get<Box<NotifStream>>().clear();
    await AppComponent.getInjector().get<Box<SearchHistory>>().clear();
    await AppComponent.getInjector().get<Box<Query>>().clear();
    await AppComponent.getInjector().get<Box<Topic>>().clear();
  }
}
