import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/presenter.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/create_column_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/edit_column_api_request.dart';

class FormColumnController extends BaseController {
  FormColumnArgs? _data;
  FormColumnPresenter _presenter;

  TextEditingController _textEditingController = TextEditingController();

  String? _projectId;
  String? _columnId;
  String? _columnName;

  FormColumnController(this._presenter);

  String get columnName => _columnName ?? "Masukan nama kolom";

  TextEditingController get textEditingController => _textEditingController;

  String getFormTitle(BuildContext ctx) {
    if (_data?.formType == FormType.create) {
      return "${S.of(ctx).label_add} ${S.of(ctx).label_column}";
    }
    return S.of(ctx).label_rename;
  }

  bool isValidated() {
    if (_textEditingController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  void _editColumnName(String columnName) {
    _presenter.onEditColumn(EditColumnApiRequest(
      _columnId!,
      columnName,
    ));
  }

  void _createColumn(String columnName) {
    _presenter.onCreateColumn(CreateColumnApiRequest(
      _projectId!,
      columnName,
    ));
  }

  void onSubmit(String columnName) {
    showOnLoading(context, "Loading...");
    if (_data?.formType == FormType.create) {
      _createColumn(columnName);
    } else {
      _editColumnName(columnName);
    }
  }

  @override
  void load() {}

  @override
  void initListeners() {
    _presenter.editColumnOnNext = (BaseApiResponse response) {
      print("formColumn: success editColumn");
      Navigator.pop(context);
      Navigator.pop(context, _projectId);
    };

    _presenter.editColumnOnComplete = () {
      print("formColumn: complete editColumn");
    };

    _presenter.editColumnOnError = (e) {
      print("formColumn: error editColumn $e");
      Navigator.pop(context);
      showNotif(context, S.of(context).error_disconnected);
    };

    _presenter.createColumnOnNext = (BaseApiResponse response) {
      print("formColumn: success createColumn");
      Navigator.pop(context);
      Navigator.pop(context, _projectId);
    };

    _presenter.createColumnOnComplete = () {
      print("formColumn: complete createColumn");
    };

    _presenter.createColumnOnError = (e) {
      print("formColumn: error createColumn $e");
      Navigator.pop(context);
      showNotif(context, S.of(context).error_disconnected);
    };
  }

  @override
  void getArgs() {
    if (args != null) _data = args as FormColumnArgs;
    _projectId = _data?.projectId;
    _columnId = _data?.columnId;
    _columnName = _data?.columnName;
  }

  @override
  void disposing() {
    _presenter.dispose();
  }
}
