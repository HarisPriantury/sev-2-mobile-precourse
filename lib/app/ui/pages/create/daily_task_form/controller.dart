import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/create/daily_task_form/args.dart';

class DailyTaskFormController extends BaseController {
  DailyTaskFormArgs? _data;

  // for ip Daily task form
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _startPageController = new TextEditingController();
  TextEditingController _endPageController = new TextEditingController();
  TextEditingController _summaryBookController = new TextEditingController();
  TextEditingController _feedbackForPairingController =
      new TextEditingController();
  TextEditingController _sharingFromPairingController =
      new TextEditingController();

  bool _isValidated = false;
  bool _isSummaryBookFilled = false;
  bool _isFeedbackForPairingFilled = false;
  bool _isSharingFromPairingFilled = false;

  bool _isInputTitleEmpty = false;
  bool _isInputStartPageEmpty = false;
  bool _isInputEndPageEmpty = false;
  bool _isInputSummaryBookValidated = false;
  bool _isInputFeedbackEmpty = false;
  bool _isInputSharingEmpty = false;

  TextEditingController get titleController => _titleController;
  TextEditingController get startPageController => _startPageController;
  TextEditingController get endPageController => _endPageController;
  TextEditingController get summaryBookController => _summaryBookController;
  TextEditingController get feedbackForPairingController =>
      _feedbackForPairingController;
  TextEditingController get sharingFromPairingController =>
      _sharingFromPairingController;

  DailyTaskFormArgs? get data => _data;
  bool get isValidated => _isValidated;
  bool get validateSummaryBook => _isSummaryBookFilled;
  bool get validateFeedbackForPairing => _isFeedbackForPairingFilled;
  bool get validateSharingFromPairing => _isSharingFromPairingFilled;

  bool get isInputTitleEmpty => _isInputTitleEmpty;
  bool get isInputStartPageEmpty => _isInputStartPageEmpty;
  bool get isInputEndPageEmpty => _isInputEndPageEmpty;
  bool get isInputSummaryBookValidated => _isInputSummaryBookValidated;
  bool get isInputFeedbackEmpty => _isInputFeedbackEmpty;
  bool get isInputSharingEmpty => _isInputSharingEmpty;

  void validate() {
    if (_data?.dailyTaskType == DailyTaskType.book) {
      _isValidated = _titleController.text.isNotEmpty &&
          _startPageController.text.isNotEmpty &&
          _endPageController.text.isNotEmpty &&
          _summaryBookController.text.isNotEmpty;
      _isSummaryBookFilled = _isValidated;
    } else if (_data?.dailyTaskType == DailyTaskType.feedback) {
      _isValidated = _feedbackForPairingController.text.isNotEmpty;
      _isFeedbackForPairingFilled = _isValidated;
    } else if (_data?.dailyTaskType == DailyTaskType.sharing) {
      _isValidated = _sharingFromPairingController.text.isNotEmpty;
      _isSharingFromPairingFilled = _isValidated;
    } else {
      _isValidated = false;
    }
    refreshUI();
  }

  void onSubmitDailyTask() {
    Navigator.pop(context, [
      _isSummaryBookFilled,
      _isFeedbackForPairingFilled,
      _isSharingFromPairingFilled,
    ]);
  }

  void validateOnTap() {
    if (data?.dailyTaskType == DailyTaskType.book) {
      if (_titleController.text.isEmpty) {
        _isInputTitleEmpty = true;
      }
      if (_startPageController.text.isEmpty) {
        _isInputStartPageEmpty = true;
      }
      if (_endPageController.text.isEmpty) {
        _isInputEndPageEmpty = true;
      }
      if (_summaryBookController.text.isEmpty) {
        _isInputSummaryBookValidated = true;
      }
    } else if (data?.dailyTaskType == DailyTaskType.feedback) {
      if (_feedbackForPairingController.text.isEmpty) {
        _isInputFeedbackEmpty = true;
      }
    } else if (data?.dailyTaskType == DailyTaskType.sharing) {
      if (_sharingFromPairingController.text.isEmpty) {
        _isInputSharingEmpty = true;
      }
    }
    refreshUI();
  }

  @override
  void disposing() {
    // TODO: implement disposing
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as DailyTaskFormArgs;
      _isSummaryBookFilled = _data!.isBookChecked;
      _isFeedbackForPairingFilled = data!.isFeedbackChecked;
      _isSharingFromPairingFilled = data!.isSharingChecked;
    }
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

  @override
  void load() {
    // TODO: implement load
  }
}
