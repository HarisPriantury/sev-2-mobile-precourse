import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/utils.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_form_field.dart';
import 'package:mobile_sev2/app/ui/assets/widget/no_connection.dart';
import 'package:mobile_sev2/app/ui/pages/shop/checkout/controller.dart';

class ShopPage extends View {
  final Object? arguments;

  ShopPage({this.arguments});

  @override
  _ShopState createState() =>
      _ShopState(AppComponent.getInjector().get<ShopController>(), arguments);
}

class _ShopState extends ViewState<ShopPage, ShopController> {
  ShopController _controller;
  DateTime currentBackPressTime = DateTime.now();
  _ShopState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<ShopController>(
        builder: (context, controller) {
          return !_controller.isConnected
              ? NoConnection(globalKey)
              : WillPopScope(
                  onWillPop: () async {
                    return true;
                  },
                  child: Scaffold(
                    key: globalKey,
                    backgroundColor: ColorsItem.black1F2329,
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      toolbarHeight: MediaQuery.of(context).size.height / 10,
                      flexibleSpace: SimpleAppBar(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.SPACE_20,
                            vertical: Dimens.SPACE_10),
                        color: ColorsItem.black191C21,
                        toolbarHeight: MediaQuery.of(context).size.height / 10,
                        title: Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(context).pop(),
                              child: FaIcon(
                                FontAwesomeIcons.angleLeft,
                                color: ColorsItem.whiteFEFEFE,
                              ),
                            ),
                            SizedBox(
                              width: Dimens.SPACE_19,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.data.shopName,
                                  style: GoogleFonts.montserrat(
                                      color: ColorsItem.whiteEDEDED,
                                      fontSize: Dimens.SPACE_18,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: Dimens.SPACE_4),
                                Text(
                                  "Bayar",
                                  style: GoogleFonts.montserrat(
                                      color: ColorsItem.greyB8BBBF,
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        prefix: SizedBox(),
                        titleMargin: 0,
                      ),
                    ),
                    body: _controller.isLoading
                        ? Container(
                            color: ColorsItem.black191C21,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(Dimens.SPACE_20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _paymentAlert(),
                                  _personalData(controller),
                                  _delivery(controller),
                                  _payment(controller),
                                  _shoppingSummary(controller),
                                  _payNow(controller),
                                ],
                              ),
                            ),
                          ),
                  ),
                );
        },
      );

  _paymentAlert() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: S.of(context).label_pay_as,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12, color: ColorsItem.whiteColor)),
              TextSpan(
                text: " ${S.of(context).label_guest}",
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12, color: ColorsItem.orangeFB9600),
              ),
              TextSpan(
                text:
                    " ${S.of(context).label_or} ${S.of(context).label_login} ",
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12, color: ColorsItem.whiteColor),
              ),
              TextSpan(
                text: S.of(context).label_here,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12,
                    color: ColorsItem.whiteColor,
                    decoration: TextDecoration.underline),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimens.SPACE_25),
      ],
    );
  }

  _personalData(ShopController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "1. " + S.of(context).label_personal_data.toUpperCase(),
          style: GoogleFonts.montserrat(
            color: ColorsItem.grey666B73,
            fontSize: Dimens.SPACE_14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: Dimens.SPACE_15),
        DefaultFormField(
          label: S.of(context).profile_profile_email_label,
          textEditingController: controller.emailController,
          onChanged: (val) => {},
          hintText: S.of(context).profile_profile_email_label,
        ),
        SizedBox(height: Dimens.SPACE_20),
        DefaultFormField(
          label: S.of(context).label_no_handphone,
          textEditingController: controller.phoneNumberController,
          onChanged: (val) => {},
          hintText: S.of(context).label_no_handphone,
        ),
      ],
    );
  }

  _delivery(ShopController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: Dimens.SPACE_30),
      Text(
        "2. " + S.of(context).label_delivery.toUpperCase(),
        style: GoogleFonts.montserrat(
          color: ColorsItem.grey666B73,
          fontSize: Dimens.SPACE_14,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
      SizedBox(height: Dimens.SPACE_25),
      DefaultFormField(
        label: S.of(context).register_full_name_label,
        textEditingController: controller.fullNameController,
        onChanged: (val) => {},
        hintText: S.of(context).register_full_name_label,
      ),
      SizedBox(height: Dimens.SPACE_20),
      DefaultFormField(
        label: S.of(context).label_delivery_contact,
        textEditingController: controller.shippingContactController,
        onChanged: (val) => {},
        hintText: S.of(context).label_delivery_contact,
      ),
      SizedBox(height: Dimens.SPACE_20),
      DefaultFormField(
        label: S.of(context).label_delivery_address,
        textEditingController: controller.destinationShippingContactController,
        onChanged: (val) => {},
        hintText: S.of(context).label_delivery_address,
      ),
      SizedBox(height: Dimens.SPACE_20),
      DefaultFormField(
        label: S.of(context).label_city,
        textEditingController: controller.cityShippingDestinationController,
        onChanged: (val) => {},
        hintText: S.of(context).label_city,
      ),
      SizedBox(height: Dimens.SPACE_20),
      DefaultFormField(
        label: S.of(context).label_postal_code,
        textEditingController:
            controller.postalCodeShippingDestinationController,
        onChanged: (val) => {},
        hintText: S.of(context).label_postal_code,
        keyboardType: TextInputType.number,
      ),
    ]);
  }

  _payment(ShopController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.SPACE_30),
        Text(
          "3. " + S.of(context).label_payment.toUpperCase(),
          style: GoogleFonts.montserrat(
            color: ColorsItem.grey666B73,
            fontSize: Dimens.SPACE_14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        _virtualAccount(controller),
        SizedBox(height: Dimens.SPACE_10),
        _transferBank(controller),
      ],
    );
  }

  _virtualAccount(ShopController controller) {
    return Container(
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          iconColor: Colors.white,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
        ),
        header: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Text(
              S.of(context).label_virtual_account,
              style:
                  GoogleFonts.montserrat(fontSize: 16.0, color: Colors.white),
            )),
        collapsed: SizedBox(),
        expanded: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: controller.vaPaymentMethod.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: ColorsItem.greyd8d8d8),
                    child: RadioListTile<String>(
                      value:
                          controller.vaPaymentMethod[index].paymentMethodName,
                      controlAffinity: ListTileControlAffinity.trailing,
                      groupValue: controller.selectedPayment,
                      title: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              color: ColorsItem.whiteColor,
                              width: Dimens.SPACE_40,
                              height: Dimens.SPACE_40,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.asset(
                                  controller.vaPaymentMethod[index]
                                      .paymentMethodImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Dimens.SPACE_10),
                          Text(
                              controller
                                  .vaPaymentMethod[index].paymentMethodName,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.whiteFEFEFE)),
                        ],
                      ),
                      activeColor: ColorsItem.orangeFB9600,
                      onChanged: (val) {
                        controller.setSelectedPayment(val!);
                      },
                      selected: controller.selectedPayment ==
                          _controller.vaPaymentMethod[index].paymentMethodName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimens.SPACE_16),
                    child: Divider(
                        color: ColorsItem.grey858A93, height: Dimens.SPACE_2),
                  )
                ],
              );
            }),
      ),
    );
  }

  _transferBank(ShopController controller) {
    return Container(
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          iconColor: Colors.white,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
        ),
        header: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Text(
              S.of(context).label_transfer_bank,
              style:
                  GoogleFonts.montserrat(fontSize: 16.0, color: Colors.white),
            )),
        collapsed: SizedBox(),
        expanded: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: controller.tfPaymentMethod.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Theme(
                    data: Theme.of(context)
                        .copyWith(unselectedWidgetColor: ColorsItem.greyd8d8d8),
                    child: RadioListTile<String>(
                      value:
                          controller.tfPaymentMethod[index].paymentMethodName,
                      controlAffinity: ListTileControlAffinity.trailing,
                      groupValue: controller.selectedPayment,
                      title: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              color: ColorsItem.whiteColor,
                              width: Dimens.SPACE_40,
                              height: Dimens.SPACE_40,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Image.asset(
                                  controller.tfPaymentMethod[index]
                                      .paymentMethodImage,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: Dimens.SPACE_10),
                          Text(
                              controller
                                  .tfPaymentMethod[index].paymentMethodName,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.whiteFEFEFE)),
                        ],
                      ),
                      activeColor: ColorsItem.orangeFB9600,
                      onChanged: (val) {
                        controller.setSelectedPayment(val!);
                      },
                      selected: controller.selectedPayment ==
                          _controller.tfPaymentMethod[index].paymentMethodName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimens.SPACE_16),
                    child: Divider(
                        color: ColorsItem.grey858A93, height: Dimens.SPACE_2),
                  )
                ],
              );
            }),
      ),
    );
  }

  _shoppingSummary(ShopController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: Dimens.SPACE_30),
        Text(
          "4. " + S.of(context).label_shopping_summary.toUpperCase(),
          style: GoogleFonts.montserrat(
            color: ColorsItem.grey666B73,
            fontSize: Dimens.SPACE_14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: Dimens.SPACE_25),
        _detailSummary(controller),
      ],
    );
  }

  _detailSummary(ShopController controller) {
    return Container(
      child: Column(
        children: [
          ListView.builder(
            itemCount: controller.productItems.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              var product = controller.productItems[index];
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Dimens.SPACE_16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  color: ColorsItem.whiteColor,
                                  width: Dimens.SPACE_40,
                                  height: Dimens.SPACE_40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Image.asset(
                                      product.productImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimens.SPACE_10),
                              Expanded(
                                child: Text(
                                  product.productTitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                      color: ColorsItem.whiteFEFEFE),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimens.SPACE_10),
                        Column(
                          children: [
                            Text(
                              "${product.quantity} X",
                              style: TextStyle(
                                color: ColorsItem.whiteColor,
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_8),
                            Text(
                              "${Utils.idrFormat(product.productPrice)}",
                              style: TextStyle(
                                color: ColorsItem.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                      color: ColorsItem.grey666B73,
                      indent: Dimens.SPACE_50,
                      endIndent: Dimens.SPACE_20,
                      height: Dimens.SPACE_1)
                ],
              );
            },
          ),
          Divider(color: ColorsItem.grey666B73),
          SizedBox(height: Dimens.SPACE_10),
          _price(controller),
          Divider(color: ColorsItem.grey666B73),
          SizedBox(height: Dimens.SPACE_10),
          _totalPrice(controller),
        ],
      ),
    );
  }

  _price(ShopController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).label_price,
              style: TextStyle(
                color: ColorsItem.whiteColor,
              ),
            ),
            Text(
              S.of(context).label_delivery,
              style: TextStyle(
                color: ColorsItem.whiteColor,
              ),
            ),
          ],
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(
            "Rp.117.000",
            style: TextStyle(
              color: ColorsItem.whiteColor,
            ),
          ),
          Text(
            "Rp.0",
            style: TextStyle(
              color: ColorsItem.whiteColor,
            ),
          ),
        ]),
      ],
    );
  }

  _totalPrice(ShopController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).label_total,
          style: TextStyle(
            color: ColorsItem.whiteColor,
          ),
        ),
        Text(
          "Rp. 117.000",
          style: TextStyle(
            color: ColorsItem.whiteColor,
          ),
        ),
      ],
    );
  }

  _payNow(ShopController controller) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35.0),
        child: ClipRRect(
          borderRadius:
              new BorderRadius.all(const Radius.circular(Dimens.SPACE_10)),
          child: Container(
            height: Dimens.SPACE_40,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  S.of(context).label_pay_now.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(width: Dimens.SPACE_12),
                FaIcon(
                  FontAwesomeIcons.arrowRight,
                  size: Dimens.SPACE_12,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
