import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

abstract class TicketRepository {
  Future<List<Ticket>> findAll(GetTicketsRequestInterface params);
  Future<TicketSubscriberInfo> findInfo(GetTicketInfoRequestInterface params);
  Future<bool> create(CreateTicketRequestInterface request);
  Future<bool> taskTransaction(TaskTransactionRequestInterface request);
  Future<TicketProjectInfo> findProjectInfo(GetTicketInfoRequestInterface params);
}
