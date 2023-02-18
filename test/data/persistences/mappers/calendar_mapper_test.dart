import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/calendar_mapper.dart';
import 'package:mobile_sev2/domain/calendar.dart';

import '../../../mock/data/mock_date_util.dart';
import '../../../response/response.dart';

void main() {
  group("CalendarMapper test", () {
    late MockDateUtilInterface dateUtilInterface;
    late CalendarMapper mentionMapper;

    setUp(() {
      dateUtilInterface = MockDateUtilInterface();
      mentionMapper = CalendarMapper(dateUtilInterface);
    });

    test("convertGetCalendarApiResponse test", () {
      List<Calendar> mentions = mentionMapper
          .convertGetCalendarApiResponse(jsonDecode(getLobbyCalendarResponse));
      expect(mentions, TypeMatcher<List<Calendar>>());
    });
  });
}
