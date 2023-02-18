import 'package:intl/intl.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/timezone.dart';

const DEFAULT_TIMEZONE = "Asia/Jakarta";
const DEFAULT_TIMEFORMAT = "hh:mm a";
const DEFAULT_DATEFORMAT = "yyyy-MM-d";
const DEFAULT_STARTOFWEEK = "7";
const DEFAULT_DISPLAYDATEFORMAT = "EEEE, MMM d";

class MockDateUtilInterface extends Mock implements DateUtilInterface {

  @override
  DateTime fromPattern(String pattern, String date) {
    var inputFormat = DateFormat(pattern);
    var dt = inputFormat.parse(date);

    var loc;
    if (loc.isEmpty) loc = DEFAULT_TIMEZONE;
    return TZDateTime.from(dt, getLocation(loc));
  }

  @override
  DateTime fromSeconds(int seconds) {
    return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  }

  @override
  String format(String pattern, DateTime dt) {
    var loc;
    if (loc.isEmpty) loc = DEFAULT_TIMEZONE;
    var tzDate = TZDateTime.from(dt, getLocation(loc));
    return DateFormat(pattern).format(tzDate);
  }

  @override
  int currentMillisecond() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  @override
  DateTime now() {
    return DateTime.now();
  }

  @override
  DateTime from(int year,
      [int month = 1,
        int day = 1,
        int hour = 0,
        int minute = 0,
        int second = 0,
        int millisecond = 0,
        int microsecond = 0]) {
    return DateTime(year, month, day, hour, minute, second, millisecond, microsecond);
  }

  @override
  DateTime fromMilliseconds(int ms) {
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  @override
  String basicDateFormat(DateTime dt) {
    var df;
    if (df.isEmpty) {
      df = DEFAULT_DATEFORMAT;
    }
    return DateFormat(df).format(dt);
  }

  @override
  String basicTimeFormat(DateTime dt) {
    var tf = DEFAULT_TIMEFORMAT;
    if (tf.isEmpty) {
      tf = DEFAULT_TIMEFORMAT;
    }
    return DateFormat(tf).format(dt);
  }

  @override
  String displayDateTimeFormat(DateTime dt) {
    var tf = DEFAULT_TIMEFORMAT;
    if (tf.isEmpty) {
      tf = DEFAULT_TIMEFORMAT;
    }
    return DateFormat("$DEFAULT_DISPLAYDATEFORMAT, $tf").format(dt);
  }

  @override
  String displayDateFormat(DateTime dt) {
    return DateFormat(DEFAULT_DISPLAYDATEFORMAT).format(dt);
  }

  @override
  DateTime removeTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day);
  }

  @override
  DateTime firstDate(DateTime? dt) {
    if (dt != null) {
      return this.from(dt.year, dt.month, 1);
    }
    return this.from(
      this.now().year,
      this.now().month,
      1,
    );
  }

  @override
  DateTime lastDate(DateTime? dt) {
    if (dt != null) {
      return this
          .from(
        dt.year,
        dt.month + 1,
        1,
      )
          .subtract(Duration(days: 1));
    }
    return this
        .from(
      this.now().year,
      this.now().month + 1,
      1,
    )
        .subtract(Duration(days: 1));
  }
}