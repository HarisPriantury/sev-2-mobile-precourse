import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/notification_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/notification_repository_interface.dart';
import 'package:mobile_sev2/domain/meta/notif_stream.dart';

class GetNotifStreamsUseCase extends UseCase<List<NotifStream>, GetNotifStreamsRequestInterface> {
  NotificationRepository _repository;

  GetNotifStreamsUseCase(this._repository);

  @override
  Future<Stream<List<NotifStream>?>> buildUseCaseStream(GetNotifStreamsRequestInterface? params) async {
    final StreamController<List<NotifStream>> _controller = StreamController();
    try {
      List<NotifStream> notifications = await _repository.getNotifStreams(params!);
      _controller.add(notifications);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
