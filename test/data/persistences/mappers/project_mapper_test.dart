import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/project_mapper.dart';
import 'package:mobile_sev2/domain/project.dart';

import '../../../mock/data/mock_date_util.dart';
import '../../../response/response.dart';

void main() {
  group("ProjectMapper test", () {
    late MockDateUtilInterface dateUtilInterface;
    late ProjectMapper mentionMapper;

    setUp(() {
      dateUtilInterface = MockDateUtilInterface();
      mentionMapper = ProjectMapper(dateUtilInterface);
    });

    test("convertGetProjectColumnTicketApiResponse test", () {
      List<ProjectColumn> columns = mentionMapper
          .convertGetProjectColumnTicketApiResponse(jsonDecode(getProjectManiphestResponse));
      expect(columns, TypeMatcher<List<ProjectColumn>>());
      expect(columns.length == 22, true);
    });
  });
}
