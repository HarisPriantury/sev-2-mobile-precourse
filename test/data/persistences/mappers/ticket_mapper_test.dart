import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/persistences/mappers/ticket_mapper.dart';
import 'package:mobile_sev2/domain/ticket.dart';

import '../../../mock/data/mock_date_util.dart';
import '../../../response/response.dart';

void main() {
  group("TicketMapper test", () {
    late MockDateUtilInterface dateUtilInterface;
    late TicketMapper ticketMapper;

    setUp(() {
      dateUtilInterface = MockDateUtilInterface();
      ticketMapper = TicketMapper(dateUtilInterface);
    });

    test("convertGetTicketsApiResponse test", () {
      List<Ticket> tickets = ticketMapper.convertGetTicketsApiResponse(jsonDecode(ticketResponse));
      expect(tickets, TypeMatcher<List<Ticket>?>());
      expect(tickets.length, 1);
      expect(tickets.first.id, "PHID-TASK-ykvov6tkex6uy7h6wick");
    });
  });
}
