import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mockito/mockito.dart';

class MockTicketRepository extends Mock implements TicketRepository {
  @override
  Future<List<Ticket>> findAll(GetTicketsRequestInterface params) async {
    return Future.value([Ticket('hahaha')]);
  }

  @override
  Future<bool> create(CreateTicketRequestInterface request) {
    throw UnimplementedError();
  }

  @override
  Future<TicketSubscriberInfo> findInfo(GetTicketInfoRequestInterface params) async {
    return Future.value(TicketSubscriberInfo(['abcde'], 0, 0));
  }
}