import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/controller.dart';

class DateTimePage extends View {
  final Object? arguments;

  DateTimePage({this.arguments});

  @override
  _DateTimeState createState() => _DateTimeState(
      AppComponent.getInjector().get<SettingController>(), arguments);
}

class _DateTimeState extends ViewState<DateTimePage, SettingController> {
  SettingController _controller;

  _DateTimeState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<SettingController>(
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
                  S.of(context).setting_account_datetime,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                suffix: GestureDetector(
                  onTap: () {
                    _controller.saveDateTime();
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text(S.of(context).label_submit,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.orangeFB9600,
                        )),
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).setting_datetime_choose_timezone,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.timezone == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.userData.timezone,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onTimeZoneChanged(newValue);
                            },
                            items: _controller.timezoneList
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14),
                                        ),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                  Text(S.of(context).setting_datetime_timeformat,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.timeFormat == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.userData.timeFormat,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onTimeFormatChanged(newValue);
                            },
                            items: _controller.timeFormatList
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(value,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14)),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                  Text(S.of(context).setting_datetime_dateformat,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.dateFormat == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.userData.dateFormat,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onDateFormatChanged(newValue);
                            },
                            items: _controller.dateFormatList
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(value,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14)),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                  Text(S.of(context).setting_datetime_startweek,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
                  SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.firstDayOfWeek == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.userData.startWeek,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onFirstDayOfWeekChanged(newValue);
                            },
                            items: _controller.dayList
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(value,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14)),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                ],
              ),
            ),
          );
        }),
      );
}
