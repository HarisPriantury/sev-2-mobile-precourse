import 'package:mobile_sev2/data/payload/contracts/public_space_request_interface.dart';
import 'package:mobile_sev2/domain/chat.dart';
import 'package:mobile_sev2/domain/room.dart';

abstract class PublicSpaceRepository {
  Future<Room> getPublicSpace(GetPublicSpaceRequestInterface request);
  Future<List<Chat>> findAll(GetMessagesPublicSpaceRequestInterface params);
}
