import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/create_column_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/edit_column_api_request.dart';
import 'package:mobile_sev2/data/payload/contracts/project_request_interface.dart';
import 'package:mobile_sev2/use_cases/project/create_column.dart';
import 'package:mobile_sev2/use_cases/project/edit_column.dart';

class FormColumnPresenter extends Presenter {
  EditColumnUseCase _editColumnUseCase;
  CreateColumnUseCase _createColumnUseCase;

  FormColumnPresenter(
    this._editColumnUseCase,
    this._createColumnUseCase,
  );

  late Function editColumnOnNext;
  late Function editColumnOnComplete;
  late Function editColumnOnError;

  late Function createColumnOnNext;
  late Function createColumnOnComplete;
  late Function createColumnOnError;

  void onEditColumn(EditColumnRequestInterface req) {
    if (req is EditColumnApiRequest) {
      _editColumnUseCase.execute(_EditColumnObserver(this), req);
    }
  }

  void onCreateColumn(CreateColumnRequestInterface req) {
    if (req is CreateColumnApiRequest) {
      _createColumnUseCase.execute(_CreateColumnObserver(this), req);
    }
  }

  @override
  void dispose() {
    _editColumnUseCase.dispose();
    _createColumnUseCase.dispose();
  }
}

class _EditColumnObserver implements Observer<BaseApiResponse> {
  FormColumnPresenter _presenter;

  _EditColumnObserver(this._presenter);

  void onNext(BaseApiResponse? response) {
    _presenter.editColumnOnNext(response);
  }

  void onComplete() {
    _presenter.editColumnOnComplete();
  }

  void onError(e) {
    _presenter.editColumnOnError(e);
  }
}

class _CreateColumnObserver implements Observer<BaseApiResponse> {
  FormColumnPresenter _presenter;

  _CreateColumnObserver(this._presenter);

  void onNext(BaseApiResponse? response) {
    _presenter.createColumnOnNext(response);
  }

  void onComplete() {
    _presenter.createColumnOnComplete();
  }

  void onError(e) {
    _presenter.createColumnOnError(e);
  }
}
