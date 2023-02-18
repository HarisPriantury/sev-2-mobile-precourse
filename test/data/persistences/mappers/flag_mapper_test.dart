import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/flag_mapper.dart';
import 'package:mobile_sev2/domain/flag.dart';

import '../../../response/response.dart';

void main() {
  group("FlagMapper test", () {
    late FlagMapper flagMapper;

    setUp(() {
      flagMapper = FlagMapper();
    });

    test("convertGetFlagsApiRequest test", () {
      List<Flag> flags =
          flagMapper.convertGetFlagsApiRequest(jsonDecode(getFlagsResponse));
      expect(flags, TypeMatcher<List<Flag>>());
      expect(flags.length == 2, true);
      expect(flags.first.id, "23");
    });
  });
}
