import 'package:event_bus/event_bus.dart';
import 'package:mobile_sev2/app/infrastructures/events/reporting.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/infrastructures/misc/constants.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/presenter.dart';
import 'package:mobile_sev2/data/payload/api/flag/create_flag_api_request.dart';

class ReportController extends BaseController {
  EventBus _eventBus;

  ReportController(this._presenter, this._eventBus);
  ReportArgs? _data;
  ReportPresenter _presenter;
  DialogReportMode _dialogReportMode = DialogReportMode.SelectReport;

  List<String> _reportOption = [
    "Nudity",
    "Violence",
    "Harassment/Abusive",
    "Suicide or self-injury",
    "False information",
    "Spam",
    "Hate Speech",
    "Terrorism",
    "Something else",
  ];

  ReportArgs? get data => _data;
  DialogReportMode get dialogReportMode => _dialogReportMode;
  List<String> get reportOption => _reportOption;

  @override
  void disposing() {}

  @override
  void getArgs() {
    if (args != null) _data = args as ReportArgs;
    print(_data?.toPrint());
  }

  @override
  void initListeners() {
    // create flag
    _presenter.createFlagOnNext = (bool result, PersistenceType type) {
      print("Report: success createFlag $type");
    };

    _presenter.createFlagOnComplete = (PersistenceType type) {
      print("Report: completed createFlag $type");
    };

    _presenter.createFlagOnError = (e, PersistenceType type) {
      print("Report: error createFlag $e $type");
    };
  }

  @override
  void load() {}
  void onReportedChat(String reportOption) {
    _presenter.onCreateFlag(
      CreateFlagApiRequest(
        objectPHID: _data?.phId ?? "",
        note:
            "REPORTED ${_data?.reportedType} for reason '${reportOption.toUpperCase()}'",
        color: 0,
      ),
    );
    _dialogReportMode = DialogReportMode.Done;
    refreshUI();
    _eventBus.fire(ReportingSuccess(_data!.phId));
  }

  void changeMode(DialogReportMode mode) {
    _dialogReportMode = mode;
    refreshUI();
  }
}

enum DialogReportMode {
  SelectReport,
  Done,
}
