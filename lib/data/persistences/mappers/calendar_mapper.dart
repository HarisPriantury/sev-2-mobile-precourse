import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/user.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class CalendarMapper {
  DateUtilInterface _dateUtil;
  CalendarMapper(this._dateUtil);

  List<Calendar> convertGetEventsApiResponse(Map<String, dynamic> response) {
    var calendars = List<Calendar>.empty(growable: true);

    var data = response['result']['data'];
    for (var cal in data) {
      if (cal['phid'] != null) {
        var calData = Calendar(
          cal['phid'],
          cal['fields']['description'],
          User(
            cal['fields']['host']['userPHID'],
            name: cal['fields']['host']['username'],
            fullName: cal['fields']['host']['fullname'],
            avatar: cal['fields']['host']['profile_image_uri'],
          ),
          false,
          false,
          _dateUtil.fromSeconds(cal['fields']['startDateTime']['epoch']),
          _dateUtil.fromSeconds(cal['fields']['endDateTime']['epoch']),
          cal['fields']['isAllDay'],
          "",
          name: cal['fields']['name'],
          code: "E${cal['id']}",
          intId: cal['id'],
        );

        var invitees = List<User>.empty(growable: true);
        cal['fields']['invitees'].forEach((inv) {
          invitees.add(User(
            inv['phid'],
            name: inv['username'],
            fullName: inv['fullname'],
            avatar: inv['profileImageURI'],
            status: inv['status'],
          ));
        });
        calData.invitees = invitees;
        if (cal['attachments'].isNotEmpty) {
          if (cal['attachments']['subscribers']['subscriberPHIDs'] != null) {
            var subcribers = List<String>.empty(growable: true);
            cal['attachments']['subscribers']['subscriberPHIDs'].forEach((sub) {
              subcribers.add(sub);
            });
            calData.subcribersPhid = subcribers;
          }
        }
        calendars.add(calData);
      }
    }

    return calendars;
  }

  List<Calendar> convertGetCalendarApiResponse(Map<String, dynamic> response) {
    var calendars = List<Calendar>.empty(growable: true);

    var data = response['result']['data'];
    for (var cal in data) {
      var cals = Calendar(
        cal['phid'],
        cal['description'],
        User(
          cal['host']['phid'],
          name: cal['host']['username'],
          fullName: cal['host']['fullname'],
          avatar: cal['host']['profileImageURI'],
        ),
        cal['isCancelled'],
        cal['isRecurring'],
        DateTime(
          cal['parameters']['startDateTime']['year'],
          cal['parameters']['startDateTime']['month'],
          cal['parameters']['startDateTime']['day'],
          cal['parameters']['startDateTime']['hour'],
          cal['parameters']['startDateTime']['minute'],
          cal['parameters']['startDateTime']['second'],
        ),
        DateTime(
          cal['parameters']['endDateTime']['year'],
          cal['parameters']['endDateTime']['month'],
          cal['parameters']['endDateTime']['day'],
          cal['parameters']['endDateTime']['hour'],
          cal['parameters']['endDateTime']['minute'],
          cal['parameters']['endDateTime']['second'],
        ),
        cal['parameters']['startDateTime']['isAllDay'],
        "",
        name: cal['name'],
        code: "E${cal['id']}",
        intId: int.parse(cal['id']),
      );

      if (cal['parameters']["recurrenceRule"] != null) {
        cals.frequency = cal['parameters']["recurrenceRule"]['FREQ'];
      }

      if (cal['parameters']["untilDateTime"] != null) {
        cals.untilTime = DateTime(
          cal['parameters']['untilDateTime']['year'],
          cal['parameters']['untilDateTime']['month'],
          cal['parameters']['untilDateTime']['day'],
          cal['parameters']['untilDateTime']['hour'],
          cal['parameters']['untilDateTime']['minute'],
          cal['parameters']['untilDateTime']['second'],
        );
      }

      var invitees = List<User>.empty(growable: true);
      cal['invitees'].forEach((inv) {
        invitees.add(User(
          inv['phid'],
          name: inv['username'],
          fullName: inv['fullname'],
          avatar: inv['profileImageURI'],
          status: inv['status'],
        ));
      });
      cals.invitees = invitees;

      var label = _dateUtil.displayDateTimeFormat(cals.startTime);
      // check it's same day
      if (cals.startTime.isSameDate(cals.endTime)) {
        if (cals.isAllDay) {
          label = "${_dateUtil.displayDateFormat(cals.startTime)}. \nSepanjang Hari.";
        } else {
          label = "$label - ${_dateUtil.basicTimeFormat(cals.endTime)}.";
        }
      } else {
        if (cals.isAllDay) {
          label =
              "${_dateUtil.displayDateFormat(cals.startTime)} - ${_dateUtil.displayDateFormat(cals.endTime)}, Sepanjang Hari.";
        } else {
          label = "$label - ${_dateUtil.displayDateTimeFormat(cals.endTime)}.";
        }
      }

      // check if it's recurring
      if (cals.isRecurring && cals.untilTime != null) {
        var repeater = 'hari';
        var until = _dateUtil.displayDateFormat(cals.untilTime!);
        switch (cals.frequency?.toLowerCase()) {
          case 'daily':
            repeater = 'hari';
            break;
          case 'weekly':
            repeater = 'minggu';
            break;
          case 'monthly':
            repeater = 'bulan';
            break;
          case 'yearly':
            repeater = 'tahun';
            break;
          default:
            break;
        }

        label = "$label \nAcara ini berulang tiap $repeater sampai $until";
      }

      cals.label = label;
      calendars.add(cals);
    }
    // todo: adjust timezone
    return calendars;
  }
}
