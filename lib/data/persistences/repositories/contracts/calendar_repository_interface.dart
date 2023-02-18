import 'package:mobile_sev2/data/payload/contracts/calendar_request_interface.dart';
import 'package:mobile_sev2/domain/calendar.dart';

abstract class CalendarRepository {
  Future<List<Calendar>> findAll(GetEventsRequestInterface params);
  Future<bool> create(CreateEventRequestInterface request);
  Future<bool> join(JoinEventRequestInterface request);
}
