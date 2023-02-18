import 'package:mobile_sev2/domain/phobject.dart';

class Product extends PhObject {
  String productImage, productTitle;
  double productPrice;
  int quantity;

  Product(
    super.id, {
    required this.productImage,
    required this.productTitle,
    required this.productPrice,
    required this.quantity,
  });
}
