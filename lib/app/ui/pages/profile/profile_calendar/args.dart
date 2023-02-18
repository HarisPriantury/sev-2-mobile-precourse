import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/calendar.dart';

class ProfileCalendarArgs implements BaseArgs {
  List<Calendar> calendars;

  ProfileCalendarArgs(this.calendars);
  @override
  String toPrint() {
    return "MediaArgs data: ${calendars.length}";
  }

}