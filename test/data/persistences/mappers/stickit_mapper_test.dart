import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/stickit_mapper.dart';
import 'package:mobile_sev2/domain/stickit.dart';

import '../../../mock/data/mock_date_util.dart';
import '../../../response/response.dart';

void main() {
  group("StickitMapper test", () {
    late MockDateUtilInterface dateUtilInterface;
    late StickitMapper stickitMapper;

    setUp(() {
      dateUtilInterface = MockDateUtilInterface();
      stickitMapper = StickitMapper(dateUtilInterface);
    });

    test("convertGetStickitsApiRequest test", () {
      List<Stickit> stickits =
      stickitMapper.convertGetStickitsApiResponse(jsonDecode(stickitsSearchResponse));
      expect(stickits, TypeMatcher<List<Stickit>>());
      expect(stickits.length == 3, true);
      expect(stickits.first.id, "PHID-LBYT-3i3biazcd74tvxn3uxzs");
    });
  });
}
