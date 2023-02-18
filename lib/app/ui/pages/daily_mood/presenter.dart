import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/data/payload/api/mood/get_moods_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/mood_request_interface.dart';
import 'package:mobile_sev2/domain/mood.dart';
import 'package:mobile_sev2/use_cases/mood/get_moods.dart';
import 'package:mobile_sev2/use_cases/mood/send_mood.dart';

class DailyMoodPresenter extends Presenter {
  GetMoodsUseCase _getMoodsUseCase;
  SendMoodUseCase _sendMoodUseCase;

  DailyMoodPresenter(
    this._getMoodsUseCase,
    this._sendMoodUseCase,
  );

  //get moods
  late Function getMoodsOnNext;
  late Function getMoodsOnComplete;
  late Function getMoodsOnError;

  //send Mood
  late Function sendMoodOnNext;
  late Function sendMoodOnComplete;
  late Function sendMoodOnError;

  void onGetMoods(GetMoodsRequestInterface req) {
    if (req is GetMoodsApiRequest) {
      _getMoodsUseCase.execute(_GetMoodsObserver(this, PersistenceType.api), req);
    }
  }

  void onSendMood(SendMoodRequestInterface req) {
    _sendMoodUseCase.execute(_SendMoodObserver(this, PersistenceType.api), req);
  }

  @override
  void dispose() {
    _getMoodsUseCase.dispose();
  }
}

class _GetMoodsObserver implements Observer<List<Mood>> {
  DailyMoodPresenter _presenter;
  PersistenceType _type;

  _GetMoodsObserver(this._presenter, this._type);

  @override
  void onNext(List<Mood>? mood) {
    _presenter.getMoodsOnNext(mood, _type);
  }

  @override
  void onComplete() {
    _presenter.getMoodsOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.getMoodsOnError(e, _type);
  }
}

class _SendMoodObserver implements Observer<bool> {
  DailyMoodPresenter _presenter;
  PersistenceType _type;

  _SendMoodObserver(this._presenter, this._type);

  @override
  void onNext(bool? response) {
    _presenter.sendMoodOnNext(response, _type);
  }

  @override
  void onComplete() {
    _presenter.sendMoodOnComplete(_type);
  }

  @override
  void onError(e) {
    _presenter.sendMoodOnError(_type, e);
  }
}
