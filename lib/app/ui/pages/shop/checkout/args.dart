import 'package:mobile_sev2/app/infrastructures/misc/base_args.dart';

class ShopArgs implements BaseArgs {
  final String shopName;

  ShopArgs(this.shopName);
  @override
  String toPrint() {
    return "ShopArgs data: $shopName";
  }
}
