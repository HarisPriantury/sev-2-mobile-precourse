import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/calendar.dart';

class MainCalendarArgs implements BaseArgs {
  List<Calendar> calendars;

  MainCalendarArgs(this.calendars);
  @override
  String toPrint() {
    return "MainCalendarArgs data: ${calendars.length}";
  }
}
