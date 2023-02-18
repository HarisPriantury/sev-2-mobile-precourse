import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/args.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/presenter.dart';
import 'package:mobile_sev2/domain/shop/payment_method.dart';
import 'package:mobile_sev2/domain/shop/product.dart';

class ShopController extends BaseController {
  ShopPresenter _presenter;

  ShopController(
    this._presenter,
  );

  ShopArgs _data = ShopArgs("");
  ShopArgs get data => _data;

  String _selectedPayment = "";

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _shippingContactController = TextEditingController();
  TextEditingController _destinationShippingContactController =
      TextEditingController();
  TextEditingController _cityShippingDestinationController =
      TextEditingController();
  TextEditingController _postalCodeShippingDestinationController =
      TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get phoneNumberController => _phoneNumberController;
  TextEditingController get fullNameController => _fullNameController;
  TextEditingController get shippingContactController =>
      _shippingContactController;
  TextEditingController get destinationShippingContactController =>
      _destinationShippingContactController;
  TextEditingController get cityShippingDestinationController =>
      _cityShippingDestinationController;
  TextEditingController get postalCodeShippingDestinationController =>
      _postalCodeShippingDestinationController;

  String get selectedPayment => _selectedPayment;

  List<PaymentMethod> vaPaymentMethod = [
    PaymentMethod(
      "1",
      paymentMethodImage: ImageItem.IC_PAY_BCA,
      paymentMethodName: "BCA Virtual Account",
    ),
    PaymentMethod(
      "2",
      paymentMethodImage: ImageItem.IC_PAY_MANDIRI,
      paymentMethodName: "Mandiri Virtual Account",
    ),
    PaymentMethod(
      "3",
      paymentMethodImage: ImageItem.IC_PAY_BNI,
      paymentMethodName: "BNI Virtual Account",
    ),
    PaymentMethod(
      "4",
      paymentMethodImage: ImageItem.IC_PAY_BRI,
      paymentMethodName: "BRI Virtual Account",
    ),
  ];

  List<PaymentMethod> tfPaymentMethod = [
    PaymentMethod(
      "1",
      paymentMethodImage: ImageItem.IC_PAY_BCA,
      paymentMethodName: "BCA Bank Transfer",
    ),
    PaymentMethod(
      "2",
      paymentMethodImage: ImageItem.IC_PAY_MANDIRI,
      paymentMethodName: "Mandiri Bank Transfer",
    ),
  ];

  List<Product> productItems = [
    Product(
      "1",
      productImage: ImageItem.IC_SAMBAL,
      productTitle:
          "Sambal Bawang Original Sambel Bu Rudy Khas Surabaya 150 Gram",
      productPrice: 117000,
      quantity: 3,
    ),
  ];

  @override
  void getArgs() {
    if (args != null) {
      _data = args as ShopArgs;
    }
  }

  @override
  void load() {}

  @override
  void initListeners() {
    loading(false);
  }

  @override
  void disposing() {
    _presenter.dispose();
  }

  void setSelectedPayment(String value) {
    if (_selectedPayment != value) {
      _selectedPayment = value;
      refreshUI();
    }
  }
}
