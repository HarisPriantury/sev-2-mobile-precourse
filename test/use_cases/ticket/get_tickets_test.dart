import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/use_cases/ticket/get_tickets.dart';
import 'package:mockito/mockito.dart';

import '../../mock/repository/mock_ticket_repository.dart';

class MockGetTicketsRequestInterface extends Mock
    implements GetTicketsRequestInterface {}

void main() {
  group("TicketUseCase", () {
    late MockTicketRepository repository;
    late GetTicketsUseCase useCase;
    late _Observer _observer;

    setUp(() {
      repository = MockTicketRepository();
      useCase = GetTicketsUseCase(repository);
      _observer = _Observer();
    });

    test('getTicketsUseCase test', () async {
      useCase.execute(_observer, MockGetTicketsRequestInterface());
    });
  });
}

class _Observer implements Observer<List<Ticket>> {
  void onNext(List<Ticket>? tickets) {
    expect(tickets, TypeMatcher<List<Ticket>?>());
    expect(tickets?.length, 1);
    expect(tickets?.first.id, 'hahaha');
  }

  void onComplete() {}

  void onError(e) {
    throw e;
  }
}
