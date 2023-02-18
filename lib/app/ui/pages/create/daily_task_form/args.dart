import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class DailyTaskFormArgs implements BaseArgs {
  DailyTaskType? dailyTaskType;
  bool isBookChecked = false;
  bool isFeedbackChecked = false;
  bool isSharingChecked = false;

  DailyTaskFormArgs(
      {this.dailyTaskType,
      required this.isBookChecked,
      required this.isFeedbackChecked,
      required this.isSharingChecked});
  @override
  String toPrint() {
    return "LobbyArgs";
  }
}

enum DailyTaskType { book, feedback, sharing }
