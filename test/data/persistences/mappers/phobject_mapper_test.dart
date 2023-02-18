import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/phobject_mapper.dart';
import 'package:mobile_sev2/data/persistences/mappers/stickit_mapper.dart';
import 'package:mobile_sev2/domain/phobject.dart';
import 'package:mobile_sev2/domain/phtransaction.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:uuid/uuid.dart';

import '../../../mock/data/mock_date_util.dart';
import '../../../response/response.dart';

void main() {
  group("PhObjectMapper test", () {
    late MockDateUtilInterface dateUtilInterface;
    late PhobjectMapper phObjectMapper;

    setUp(() {
      dateUtilInterface = MockDateUtilInterface();
      phObjectMapper = PhobjectMapper(dateUtilInterface, Uuid());
    });

    test("convertGetPhObjectsApiRequest test", () {
      List<PhTransaction> _transactions =
          phObjectMapper.convertGetPhTransactionsApiResponse(
              jsonDecode(stickitTransactionResponse));
      expect(_transactions, TypeMatcher<List<PhTransaction>>());
      expect(_transactions.first.id, "PHID-XACT-LBYT-pqsaov5ovxnpdzl");
    });
  });
}
