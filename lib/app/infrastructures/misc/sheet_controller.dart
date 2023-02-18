import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';

class SheetController extends BaseController {
  Map<String, StateSetter> _stateSetters = {};

  @override
  void disposing() {
    _stateSetters.clear();
  }

  @override
  void getArgs() {}

  @override
  void initListeners() {}

  @override
  void load() {}

  void addStateSetter(String key, StateSetter st) {
    _stateSetters[key] = st;
  }

  void removeStateSetter(String key) {
    _stateSetters.remove(key);
  }

  void refresh() {
    if (_stateSetters.isNotEmpty) {
      _stateSetters.forEach((String key, StateSetter setter) {
        setter(() {
          refreshUI();
        });
      });
    } else {
      refreshUI();
    }
  }
}
