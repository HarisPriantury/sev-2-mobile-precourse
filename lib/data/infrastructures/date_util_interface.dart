abstract class DateUtilInterface {
  DateTime fromPattern(String pattern, String date);
  DateTime fromSeconds(int seconds);
  DateTime fromMilliseconds(int ms);
  String format(String pattern, DateTime dt);
  String basicDateFormat(DateTime dt);
  String basicTimeFormat(DateTime dt);
  String displayDateFormat(DateTime dt);
  String displayDateTimeFormat(DateTime dt);
  int currentMillisecond();
  DateTime now();
  DateTime removeTime(DateTime dt);
  DateTime firstDate(DateTime? dt);
  DateTime lastDate(DateTime? dt);
  DateTime from(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]);
}
