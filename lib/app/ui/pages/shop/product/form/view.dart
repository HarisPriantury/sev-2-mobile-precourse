import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_form_field.dart';
import 'package:mobile_sev2/app/ui/pages/shop/product/form/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class FormAddProduct extends View {
  FormAddProduct({this.arguments});

  final Object? arguments;

  @override
  _CreateState createState() => _CreateState(
      AppComponent.getInjector().get<FormAddProductController>(), arguments);
}

class _CreateState extends ViewState<FormAddProduct, FormAddProductController> {
  _CreateState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  FormAddProductController _controller;

  @override
  Widget get view => ControlledWidgetBuilder<FormAddProductController>(
        builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            backgroundColor: ColorsItem.black1F2329,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft,
                      color: ColorsItem.whiteE0E0E0),
                  onPressed: () => Navigator.pop(context),
                ),
                color: ColorsItem.black191C21,
                title: Text(
                  S.of(context).label_add_product,
                  style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteEDEDED,
                    fontSize: Dimens.SPACE_18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.SPACE_20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultFormField(
                      label: "Nama Produk",
                      textEditingController: controller.productName,
                      onChanged: (val) => {},
                      hintText: "Nama Produk",
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    //Kategori Produk
                    DefaultFormFieldWithAction(
                      children: _buildSearchItems(List.empty()),
                      label: "Kategori Produk",
                      onTap: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: ColorsItem.whiteFEFEFE,
                        size: Dimens.SPACE_16,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    DefaultFormFieldWithAction(
                      children: _buildSearchItems(List.empty()),
                      label: "Nama Provider",
                      onTap: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: ColorsItem.whiteFEFEFE,
                        size: Dimens.SPACE_16,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    DefaultFormFieldWithAction(
                      children: _buildSearchItems(List.empty()),
                      label: "Tag Produk",
                      onTap: () {},
                      icon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: ColorsItem.whiteFEFEFE,
                        size: Dimens.SPACE_16,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    DefaultFormFieldWithLongText(
                      enabledBorderColor: ColorsItem.grey666B73,
                      focusedBorderColor: ColorsItem.grey666B73,
                      hintText: "Deskripsi Produk",
                      label: "Deskripsi Produk",
                      maxLines: 5,
                      onChanged: (val) {},
                      textEditingController: controller.productDescription,
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    Text(
                      "Harga & Stok",
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteEDEDED,
                        fontSize: Dimens.SPACE_12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_8),
                    Theme(
                      data: ThemeData(
                        primaryColor: ColorsItem.grey666B73,
                        primaryColorDark: ColorsItem.grey666B73,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: DefaultFormField(
                              textEditingController: controller.productPrice,
                              onChanged: (val) => {},
                              hintText: "Harga",
                              keyboardType: TextInputType.number,
                              prefixIcon: Text(
                                " Rp ",
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteE0E0E0,
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                  minWidth: 0, minHeight: Dimens.SPACE_20),
                            ),
                          ),
                          SizedBox(
                            width: Dimens.SPACE_12,
                          ),
                          Expanded(
                            child: DefaultFormField(
                              textEditingController: controller.productStock,
                              onChanged: (val) => {},
                              hintText: "Stok",
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    Text(
                      "Nilai Komisi Barang",
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteEDEDED,
                        fontSize: Dimens.SPACE_12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_8),
                    Theme(
                      data: ThemeData(
                        primaryColor: ColorsItem.grey666B73,
                        primaryColorDark: ColorsItem.grey666B73,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: DefaultFormField(
                              textEditingController:
                                  controller.productComissionType,
                              onChanged: (val) => {},
                              hintText: "Tipe Komisi",
                            ),
                          ),
                          SizedBox(
                            width: Dimens.SPACE_12,
                          ),
                          Expanded(
                            child: DefaultFormField(
                              textEditingController:
                                  controller.productComissionValue,
                              onChanged: (val) => {},
                              hintText: "Nilai",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    Text(
                      "Dimensi",
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteEDEDED,
                        fontSize: Dimens.SPACE_12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_8),
                    Theme(
                      data: ThemeData(
                        primaryColor: ColorsItem.grey666B73,
                        primaryColorDark: ColorsItem.grey666B73,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: DefaultFormField(
                              textEditingController:
                                  controller.productDimentionHeight,
                              onChanged: (val) => {},
                              hintText: "",
                              keyboardType: TextInputType.number,
                              suffixIcon: Text(
                                " Cm ",
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteE0E0E0,
                                ),
                              ),
                              suffixIconConstraints: BoxConstraints(
                                  minWidth: 0, minHeight: Dimens.SPACE_20),
                            ),
                          ),
                          SizedBox(
                            width: Dimens.SPACE_12,
                          ),
                          Expanded(
                            child: DefaultFormField(
                              textEditingController:
                                  controller.productDimentionWidth,
                              onChanged: (val) => {},
                              hintText: "",
                              keyboardType: TextInputType.number,
                              suffixIcon: Text(
                                " Cm ",
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteE0E0E0,
                                ),
                              ),
                              suffixIconConstraints: BoxConstraints(
                                  minWidth: 0, minHeight: Dimens.SPACE_20),
                            ),
                          ),
                          SizedBox(
                            width: Dimens.SPACE_12,
                          ),
                          Expanded(
                            child: DefaultFormField(
                              textEditingController:
                                  controller.productDimentionLong,
                              onChanged: (val) => {},
                              hintText: "",
                              keyboardType: TextInputType.number,
                              suffixIcon: Text(
                                " Cm ",
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteE0E0E0,
                                ),
                              ),
                              suffixIconConstraints: BoxConstraints(
                                  minWidth: 0, minHeight: Dimens.SPACE_20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_12),
                    Text(
                      "Berat",
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteEDEDED,
                        fontSize: Dimens.SPACE_12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_8),
                    Theme(
                      data: ThemeData(
                        primaryColor: ColorsItem.grey666B73,
                        primaryColorDark: ColorsItem.grey666B73,
                      ),
                      child: DefaultFormField(
                        keyboardType: TextInputType.number,
                        textEditingController: controller.productWeight,
                        onChanged: (val) => {},
                        hintText: "",
                        suffixIcon: Text(
                          " Kg ",
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteE0E0E0,
                          ),
                        ),
                        suffixIconConstraints: BoxConstraints(
                            minWidth: 0, minHeight: Dimens.SPACE_20),
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_14),
                    Container(
                      width: 200,
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: ColorsItem.orangeCC6000,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print("Simpan dan Post");
                        },
                        child: Text(
                          "Simpan dan Post",
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );

  List<Widget> _buildSearchItems(List<PhObject> list) {
    List<Widget> chips = new List.empty(growable: true);
    chips.add(SizedBox(width: Dimens.SPACE_4));
    for (PhObject obj in list) {
      chips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_4),
        child: Container(
          decoration: BoxDecoration(
              color: ColorsItem.grey666B73,
              borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8, vertical: Dimens.SPACE_2),
          child: Text(obj.name!,
              style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE)),
        ),
      ));
    }
    chips.add(SizedBox(width: Dimens.SPACE_4));
    return chips;
  }
}
