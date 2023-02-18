import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class CreateTicketDBRequest implements CreateTicketRequestInterface {
  Ticket ticket;

  CreateTicketDBRequest(this.ticket);
}
