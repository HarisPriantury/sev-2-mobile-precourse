import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/mention_mapper.dart';
import 'package:mobile_sev2/domain/mention.dart';

import '../../../mock/data/mock_date_util.dart';
import '../../../response/response.dart';

void main() {
  group("MentionMapper test", () {
    late MockDateUtilInterface dateUtilInterface;
    late MentionMapper mentionMapper;

    setUp(() {
      dateUtilInterface = MockDateUtilInterface();
      mentionMapper = MentionMapper(dateUtilInterface);
    });

    test("convertGetMentionsApiResponse test", () {
      List<Mention> mentions = mentionMapper
          .convertGetMentionsApiResponse(jsonDecode(getMentionsResponse));
      expect(mentions, TypeMatcher<List<Mention>>());
      expect(mentions.length == 1, true);
      expect(mentions.first.id, "PHID-MNTN-7mcbgk2sb2amksizzy5d");
      expect(mentions.first.author.name, "andhikasatria");
      expect(mentions.first.mentionedUsers.first.id, "PHID-USER-p3nh6gkhqfdbdef5zr5z");
    });
  });
}
