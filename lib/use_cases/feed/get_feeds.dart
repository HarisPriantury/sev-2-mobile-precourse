import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/contracts/feed_request_interface.dart';
import 'package:mobile_sev2/data/persistences/repositories/contracts/feed_repository_interface.dart';
import 'package:mobile_sev2/domain/feed.dart';

class GetFeedsUseCase extends UseCase<List<Feed>, GetFeedsRequestInterface> {
  FeedRepository _repository;

  GetFeedsUseCase(this._repository);

  @override
  Future<Stream<List<Feed>?>> buildUseCaseStream(
      GetFeedsRequestInterface? params) async {
    final StreamController<List<Feed>> _controller = StreamController();
    try {
      List<Feed> feeds = await _repository.findAll(params!);
      _controller.add(feeds);
      _controller.close();
    } catch (e) {
      _controller.addError(e);
    }
    return _controller.stream;
  }
}
