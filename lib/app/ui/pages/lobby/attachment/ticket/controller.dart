import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/args.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/presenter.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/payload/api/lobby/get_lobby_room_tasks_api_request.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class RoomTicketController extends BaseController {
  RoomTicketPresenter _presenter;
  late Room _room;
  List<Ticket> _unbreak = [];
  List<Ticket> _triage = [];
  List<Ticket> _high = [];
  List<Ticket> _normal = [];
  List<Ticket> _low = [];
  List<Ticket> _wishlist = [];

  RoomTicketController(this._presenter);

  Room get room => _room;

  List<Ticket> get unbreakTickets => _unbreak;

  List<Ticket> get triageTickets => _triage;

  List<Ticket> get highTickets => _high;

  List<Ticket> get normalTickets => _normal;

  List<Ticket> get lowTickets => _low;

  List<Ticket> get wishlistTickets => _wishlist;

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      var _data = args as RoomTicketArgs;
      _room = _data.room;
      print(_data.toPrint());
    }
  }

  @override
  void initListeners() {
    _presenter.getLobbyRoomTicketsOnNext = (List<Ticket> tickets) {
      print("RoomTicket: success getLobbyRoomTickets");

      _unbreak.clear();
      _triage.clear();
      _high.clear();
      _normal.clear();
      _low.clear();
      _wishlist.clear();

      tickets.forEach((t) {
        switch (t.priority) {
          case Ticket.STATUS_UNBREAK:
            _unbreak.add(t);
            break;
          case Ticket.STATUS_TRIAGE:
            _triage.add(t);
            break;
          case Ticket.STATUS_HIGH:
            _high.add(t);
            break;
          case Ticket.STATUS_NORMAL:
            _normal.add(t);
            break;
          case Ticket.STATUS_LOW:
            _low.add(t);
            break;
          case Ticket.STATUS_WISHLIST:
            _wishlist.add(t);
            break;
          default:
        }
      });
    };

    _presenter.getLobbyRoomTicketsOnComplete = () {
      print("RoomTicket: completed getLobbyRoomTickets");
      loading(false);
      reloading(false);
    };

    _presenter.getLobbyRoomTicketsOnError = (e) {
      print("RoomTicket: error getLobbyRoomTickets $e");
    };
  }

  @override
  void load() {
    loading(true);
    _presenter.onGetLobbyRoomTickets(GetLobbyRoomTasksApiRequest(_room.id));
  }

  @override
  Future<void> reload({String? type}) async {
    super.reload();
    _presenter.onGetLobbyRoomTickets(GetLobbyRoomTasksApiRequest(_room.id));
    reloading(true);
    await Future.delayed(Duration(seconds: 1));
  }

  void onAddTicket() {
    Navigator.pushNamed(context, Pages.create,
            arguments: CreateArgs(type: Ticket, room: _room))
        .then((value) => load());
  }

  void onItemClicked(Ticket ticket) {
    Navigator.pushNamed(
      context,
      Pages.ticketDetail,
      arguments: DetailTicketArgs(phid: ticket.id, id: ticket.intId),
    ).then((value) => load());
  }
}
