import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/column_list/presenter.dart';
import 'package:mobile_sev2/data/payload/api/common/base_api_response.dart';
import 'package:mobile_sev2/data/payload/api/project/get_project_column_ticket_api_request.dart';
import 'package:mobile_sev2/data/payload/api/project/reorder_column_api_request.dart';
import 'package:mobile_sev2/domain/project.dart';

class ColumnListController extends BaseController {
  ColumnListArgs? _data;
  ColumnListPresenter _presenter;

  int _firstSequence = 0;
  int _highestSequence = 0;
  int _lastIdxMove = 0;
  bool _isColumnMoved = false;
  bool _errorHasShow = false;
  String? _projectId;
  List<ProjectColumn> _projectColumn = [];

  ColumnListController(this._presenter);

  bool get isColumnMoved => _isColumnMoved;

  List<ProjectColumn> get projectColumn => _projectColumn;

  void moveColumn(int oldIdx, int newIdx) {
    _isColumnMoved = true;
    if (oldIdx < newIdx) {
      newIdx -= 1;
    }
    final ProjectColumn column = _projectColumn.removeAt(oldIdx);
    _projectColumn.insert(newIdx, column);
    refreshUI();
  }

  void reorderColumn() {
    _isColumnMoved = false;
    _errorHasShow = false;
    String columnId = "";
    int newSequence = 0;
    showOnLoading(context, "Loading...");

    for (int idx = 0; idx < _projectColumn.length; idx++) {
      print("lastSeq: $_highestSequence");
      print("sequence awal : ${_projectColumn[idx].sequence}");
      columnId = _projectColumn[idx].id;
      newSequence = idx;
      _lastIdxMove = idx;
      if ((_highestSequence < _projectColumn.length) ||
          (_firstSequence >= _projectColumn.length)) {
        newSequence = idx + 1 + _highestSequence;
      }
      print("new sequence : $newSequence");
      _presenter.onReorderColumn(
        ReorderColumnApiRequest(
          _projectId!,
          columnId,
          newSequence.toString(),
        ),
        idx,
      );
    }
    refreshUI();
  }

  @override
  void load() {
    _presenter.onGetColumnTicket(GetProjectColumnTicketApiRequest(_projectId!));
  }

  @override
  void initListeners() {
    _presenter.getColumnsTicketOnNext = (List<ProjectColumn> columns) {
      print("workboard: success getColumnTicket ${columns.length}");
      columns.sort((a, b) {
        if (a.sequence == null) {
          return 1;
        } else if (b.sequence == null) {
          return -1;
        }
        return a.sequence!.compareTo(b.sequence!);
      });
      _firstSequence = columns.first.sequence!;
      _highestSequence = columns.last.sequence!;
      _projectColumn.clear();
      _projectColumn.addAll(columns);
    };

    _presenter.getColumnsTicketOnComplete = () {
      print("workboard: completed getColumnTicket");
      loading(false);
      refreshUI();
    };

    _presenter.getColumnsTicketOnError = (e) {
      print("workboard: error getColumnTicket: $e");
      loading(false);
    };

    _presenter.reorderColumnOnNext = (BaseApiResponse response, int index) {
      print("workboard: success reorderColumn");
      if ((_lastIdxMove == index) && !_errorHasShow) {
        Navigator.pop(context);
        Navigator.pop(context, _projectId);
      }
    };

    _presenter.reorderColumnOnComplete = () {
      print("workboard: complete reorderColumn");
    };

    _presenter.reorderColumnOnError = (e) {
      print("workboard: error reorderColumn $e");
      if (!_errorHasShow) {
        Navigator.pop(context);
        showNotif(context, S.of(context).error_disconnected);
        _errorHasShow = true;
      }
    };
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  @override
  void getArgs() {
    if (args != null) _data = args as ColumnListArgs;
    _projectId = _data?.projectId;
  }
}
