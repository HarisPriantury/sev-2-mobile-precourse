import 'package:mobile_sev2/domain/phobject.dart';

class PaymentMethod extends PhObject {
  String paymentMethodImage, paymentMethodName;

  PaymentMethod(
    super.id, {
    required this.paymentMethodImage,
    required this.paymentMethodName,
  });
}
