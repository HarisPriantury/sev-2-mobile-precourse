import 'package:flutter/cupertino.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class ContactController extends BaseController {
  String? _type;
  bool _isValidated = false;
  TextEditingController _contentController = TextEditingController();

  final List<String> typeList = ["Bantuan", "Saran", "Aduan"];

  String? get type => _type;

  bool get isValidated => _isValidated;

  TextEditingController get contentController => _contentController;

  void onTypeChanged(String? newValue) {
    _type = newValue;
    refreshUI();
  }

  void validate() {
    if (_type != null && !_contentController.text.isNullOrBlank()) {
      _isValidated = true;
    } else
      _isValidated = false;
  }

  @override
  void disposing() {
    // TODO: implement disposing
  }

  @override
  void getArgs() {
    // TODO: implement getArgs
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
