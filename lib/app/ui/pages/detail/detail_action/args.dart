import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';
import 'package:mobile_sev2/domain/ticket.dart';

enum DetailActionType {
  assign,
  changeStatus,
  changePriority,
  updateStoryPoint,
  changeProjectLabel,
  changeSubscriber,
}

class DetailActionArgs extends BaseArgs {
  final DetailActionType type;
  final Ticket ticket;

  DetailActionArgs({
    required this.type,
    required this.ticket,
  });

  @override
  String toPrint() {
    return "DetailActionArgs data: $type $ticket";
  }
}
