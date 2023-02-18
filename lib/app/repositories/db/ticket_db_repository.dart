import 'package:hive/hive.dart';
import 'package:mobile_sev2/data/payload/contracts/ticket_request_interface.dart';
import 'package:mobile_sev2/data/payload/db/ticket/create_ticket_db_request.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/ticket_repository_interface.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class TicketDBRepository implements TicketRepository {
  Box<Ticket> _box;

  TicketDBRepository(this._box);

  @override
  Future<List<Ticket>> findAll(GetTicketsRequestInterface params) {
    var tickets = _box.values.toList();
    return Future.value(tickets);
  }

  @override
  Future<bool> create(CreateTicketRequestInterface request) {
    var params = request as CreateTicketDBRequest;
    _box.put(params.ticket.id, params.ticket);
    return Future.value(true);
  }

  @override
  Future<TicketSubscriberInfo> findInfo(GetTicketInfoRequestInterface params) {
    throw UnimplementedError();
  }

  @override
  Future<bool> taskTransaction(TaskTransactionRequestInterface request) {
    // TODO: implement removeSubtask
    throw UnimplementedError();
  }

  @override
  Future<TicketProjectInfo> findProjectInfo(
    GetTicketInfoRequestInterface params,
  ) {
    // TODO: implement findProjectInfo
    throw UnimplementedError();
  }
}
