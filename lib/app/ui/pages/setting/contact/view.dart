import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/pages/setting/contact/controller.dart';

class ContactPage extends View {
  final Object? arguments;

  ContactPage({this.arguments});

  @override
  _ContactState createState() => _ContactState(
      AppComponent.getInjector().get<ContactController>(), arguments);
}

class _ContactState extends ViewState<ContactPage, ContactController> {
  ContactController _controller;

  _ContactState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ContactController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "Bantuan",
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pilih Jenis Pertanyaan",
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            hintText: "Pilih Salah Satu",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.type == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.type,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onTypeChanged(newValue);
                              _controller.validate();
                            },
                            items: _controller.typeList.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                  Text("Pesan",
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  TextField(
                    style: GoogleFonts.montserrat(),
                    decoration: InputDecoration(
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide()),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide()),
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      hintText: S.of(context).room_detail_comment_hint,
                      hintStyle: GoogleFonts.montserrat(),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    onChanged: (val) {
                      _controller.validate();
                    },
                    controller: _controller.contentController,
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(Dimens.SPACE_20),
              child: ButtonDefault(
                buttonText: "Kirim Pesan".toUpperCase(),
                buttonLineColor: Colors.transparent,
                buttonColor: ColorsItem.orangeFB9600,
                disabledButtonColor: ColorsItem.grey606060,
                isDisabled: !_controller.isValidated,
                radius: Dimens.SPACE_8,
                letterSpacing: 1.5,
                onTap: () {},
              ),
            ),
          );
        }),
      );
}
