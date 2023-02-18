import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/setting/support/controller.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';

class SupportPage extends View {
  final Object? arguments;

  SupportPage({this.arguments});

  @override
  _SupportState createState() => _SupportState(
      AppComponent.getInjector().get<SupportController>(), arguments);
}

class _SupportState extends ViewState<SupportPage, SupportController> {
  SupportController _controller;

  _SupportState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<SupportController>(
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
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color: ColorsItem.whiteE0E0E0,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                S.of(context).label_sev2_support,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  color: ColorsItem.whiteEDEDED,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: ColorsItem.black191C21,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${S.of(context).label_hello}, Fariz",
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteEDEDED,
                        fontSize: Dimens.SPACE_16,
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: Dimens.SPACE_8),
                  Text(
                    S.of(context).label_welcome_sev2_support,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.grey666B73,
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: Dimens.SPACE_22,
                  ),
                  Text(
                    S.of(context).label_what_can_help,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.whiteFEFEFE,
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_8),
                  Container(
                      height: 48,
                      padding: EdgeInsets.all(Dimens.SPACE_12),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorsItem.grey666B73),
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(10.0))),
                      child: DropdownButton(
                        isExpanded: true,
                        value: _controller.dropDownValue != ""
                            ? _controller.dropDownValue
                            : null,
                        hint: Text(
                          S.of(context).label_select_one,
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.grey666B73,
                            fontSize: Dimens.SPACE_14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        icon: FaIcon(
                          FontAwesomeIcons.chevronDown,
                          color: ColorsItem.whiteE0E0E0,
                        ),
                        iconSize: 16,
                        elevation: 16,
                        underline:
                            DropdownButtonHideUnderline(child: Container()),
                        style: GoogleFonts.montserrat(
                          color: ColorsItem.whiteE0E0E0,
                          fontSize: Dimens.SPACE_14,
                          fontWeight: FontWeight.w500,
                        ),
                        dropdownColor: ColorsItem.black1F2329,
                        onChanged: (String? newValue) {
                          _controller.selectValue(newValue!);
                        },
                        items: _controller
                            .getListValue(context)
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                  SizedBox(
                    height: Dimens.SPACE_22,
                  ),
                  Container(
                    height: 150,
                    padding: EdgeInsets.all(Dimens.SPACE_12),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorsItem.grey666B73),
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(10.0))),
                    child: TextFormField(
                      onChanged: (String newValue) {
                        _controller.validateForm();
                      },
                      controller: _controller.textFormController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                      decoration: InputDecoration.collapsed(
                        border: InputBorder.none,
                        hintText: S.of(context).label_write_you_want_ask,
                        fillColor: Colors.transparent,
                        hintStyle: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.grey858A93,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.SPACE_22,
                  ),
                  Text(
                    S.of(context).label_attachment,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.whiteFEFEFE,
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_8),
                  Container(
                      width: double.infinity,
                      height: Dimens.SPACE_48,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ColorsItem.black1F2329),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: ColorsItem.grey666B73))),
                        ),
                        onPressed: () {},
                        child: Text(
                          S.of(context).label_upload_attachment.toUpperCase(),
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                  SizedBox(height: Dimens.SPACE_30),
                  Container(
                      width: double.infinity,
                      height: Dimens.SPACE_48,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: !_controller.isValidate
                              ? MaterialStateProperty.all(ColorsItem.grey8C8C8C)
                              : MaterialStateProperty.all(
                                  ColorsItem.orangeCC6000),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimens.SPACE_24),
                              side: BorderSide(
                                color: !_controller.isValidate
                                    ? ColorsItem.grey666B73
                                    : ColorsItem.orangeCC6000,
                              ),
                            ),
                          ),
                        ),
                        onPressed: _controller.isValidate
                            ? () {
                                _controller.goToChatSupport();
                              }
                            : () {},
                        child: Text(
                          S.of(context).login_contact_us_label.toUpperCase(),
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.black020202,
                            fontSize: Dimens.SPACE_14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      });
}
