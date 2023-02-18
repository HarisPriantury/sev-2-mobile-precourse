import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';

class FormAddProductController extends BaseController {
  TextEditingController _productName = TextEditingController();
  TextEditingController _productDescription = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  TextEditingController _productStock = TextEditingController();
  TextEditingController _productComissionType = TextEditingController();
  TextEditingController _productComissionValue = TextEditingController();
  TextEditingController _productDimentionHeight = TextEditingController();
  TextEditingController _productDimentionWidth = TextEditingController();
  TextEditingController _productDimentionLong = TextEditingController();
  TextEditingController _productWeight = TextEditingController();

  TextEditingController get productName => _productName;
  TextEditingController get productDescription => _productDescription;
  TextEditingController get productPrice => _productPrice;
  TextEditingController get productStock => _productStock;
  TextEditingController get productComissionType => _productComissionType;
  TextEditingController get productComissionValue => _productComissionValue;
  TextEditingController get productDimentionHeight => _productDimentionHeight;
  TextEditingController get productDimentionWidth => _productDimentionWidth;
  TextEditingController get productDimentionLong => _productDimentionLong;
  TextEditingController get productWeight => _productWeight;

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
