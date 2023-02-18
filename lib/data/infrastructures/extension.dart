import 'package:mobile_sev2/data/payload/api/job/get_jobs_api_request.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

extension StringListUtil on List<String>? {
  bool isNullOrEmpty() {
    if (this == null) return true;
    if (this!.isEmpty) return true;
    return false;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String ucwords() {
    return this
        .toLowerCase()
        .split(" ")
        .map((e) => "${e[0].toUpperCase()}${e.substring(1)}")
        .join(" ");
  }

  String firstWord(String separator) {
    return this.split(separator).first;
  }

  String removeLast({int char = 1}) {
    return this.substring(0, this.length - char);
  }
}

extension StrExtension on String? {
  bool isNullOrEmpty() {
    if (this == null) return true;
    if (this!.isEmpty) return true;
    return false;
  }

  bool isNullOrBlank() {
    if (this == null)
      return true;
    else
      return this!.trim().isEmpty;
  }
}

extension DateTimeExtension on DateTime {
  int toEpoch() {
    return (this.millisecondsSinceEpoch / 1000).round();
  }
}

extension TicketStatusParseToString on TicketStatus {
  String parseToString() {
    return this.toString().split('.').last;
  }
}

extension FileTypeParseString on FileType {
  String parseToString() {
    return this.toString().split('.').last;
  }
}

extension GetJobsQueryParseToString on GetJobsQuery {
  String parseToString() {
    return this.toString().split('.').last;
  }
}

extension UserTypeParseToString on UserType {
  String parseToString() {
    return this.toString().split('.').last;
  }
}

extension SubscriptionStatusParseToString on SubscriptionStatus {
  String parseToString() {
    return this.toString().split('.').last;
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}

extension ChatUtils on Chat {
  bool isIdValid() {
    return !(id == Chat.SEND_MESSAGE_ID);
  }
}
