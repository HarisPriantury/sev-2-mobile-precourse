import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/contracts/room_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/room_repository_interface.dart';

class CreateRoomUseCase
    extends UseCase<BaseApiResponse, CreateRoomRequestInterface> {
  RoomRepository _repository;

  CreateRoomUseCase(this._repository);

  @override
  Future<Stream<BaseApiResponse>> buildUseCaseStream(
      CreateRoomRequestInterface? params) async {
    final StreamController<BaseApiResponse> _controller = StreamController();
    try {
      BaseApiResponse result = await _repository.create(params!);
      _controller.add(result);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
