import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/form_column/controller.dart';

class FormColumnPage extends View {
  final Object? arguments;

  FormColumnPage({this.arguments});

  @override
  _FormColumnState createState() => _FormColumnState(
        AppComponent.getInjector().get<FormColumnController>(),
        arguments,
      );
}

class _FormColumnState extends ViewState<FormColumnPage, FormColumnController> {
  FormColumnController _controller;

  _FormColumnState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<FormColumnController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  _controller.getFormTitle(context),
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                suffix: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                  child: InkWell(
                    onTap: _controller.isValidated()
                        ? () {
                            _controller.onSubmit(
                              _controller.textEditingController.text,
                            );
                          }
                        : () {},
                    child: Text(
                      S.of(context).label_submit,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        fontWeight: FontWeight.w700,
                        color: ColorsItem.orangeFB9600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.SPACE_20,
                vertical: Dimens.SPACE_16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${S.of(context).profile_profile_name_label} ${S.of(context).label_column}",
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w700,
                      color: ColorsItem.greyB8BBBF,
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorsItem.grey666B73),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8)),
                    ),
                    child: TextField(
                      controller: _controller.textEditingController,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                        hintStyle: GoogleFonts.montserrat(
                            color: ColorsItem.grey666B73),
                        hintText: _controller.columnName,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
}
