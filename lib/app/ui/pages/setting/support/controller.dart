import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/on_loading.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';

class SupportController extends BaseController {
  final TextEditingController _textFormController = TextEditingController();
  String _dropDownValue = "";
  bool _isValidate = false;
  List<String> _listValue = [];

  TextEditingController get textFormController => _textFormController;

  String get dropDownValue => _dropDownValue;

  bool get isValidate => _isValidate;

  List<String> getListValue(BuildContext context) {
    _listValue = [
      S.of(context).label_ticket_project,
      S.of(context).label_chat_message,
      S.of(context).label_user,
      S.of(context).label_document,
      S.of(context).profile_status_other_label,
    ];

    return _listValue;
  }

  void selectValue(String newValue) {
    _dropDownValue = newValue;
    validateForm();
    refreshUI();
  }

  Future validateForm() async {
    refreshUI();
    return _isValidate = _dropDownValue.isNotEmpty && _textFormController.text.isNotEmpty;
  }

  void goToChatSupport() {
    showOnLoading(context, "Menghubungkan dengan tim SEV-2 ...");
    Timer(Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(context, Pages.chatSupport, ModalRoute.withName(Pages.setting));
    });
  }

  @override
  void load() {}

  @override
  void initListeners() {}

  @override
  void disposing() {}

  @override
  void getArgs() {}
}
