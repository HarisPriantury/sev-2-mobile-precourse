import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/calendar_data_source.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/profile/profile_calendar/controller.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ProfileCalendarPage extends View {
  final Object? arguments;

  ProfileCalendarPage({this.arguments});

  @override
  _ProfileCalendarState createState() => _ProfileCalendarState(
      AppComponent.getInjector().get<ProfileCalendarController>(), arguments);
}

class _ProfileCalendarState
    extends ViewState<ProfileCalendarPage, ProfileCalendarController> {
  ProfileCalendarController _controller;

  _ProfileCalendarState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ProfileCalendarController>(
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
                  S.of(context).label_calendar,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    _controller.goToCreatePage();
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text(
                      S.of(context).label_add,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.orangeFB9600),
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            body: _controller.isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: Dimens.SPACE_20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_10),
                          height: MediaQuery.of(context).size.height * 0.78,
                          child: SfCalendar(
                            todayHighlightColor: ColorsItem.blue38A1D3,
                            todayTextStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold),
                            showNavigationArrow: false,
                            initialSelectedDate: _controller.dateUtil.now(),
                            minDate: _controller.dateUtil
                                .now()
                                .subtract(Duration(days: 30)),
                            maxDate: _controller.dateUtil
                                .now()
                                .add(Duration(days: 30)),
                            dataSource: EventDataSource(_controller.calendars),
                            selectionDecoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                  color: ColorsItem.orangeFB9600, width: 2),
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(Dimens.SPACE_8)),
                              shape: BoxShape.rectangle,
                            ),
                            onTap: (detail) {
                              if (detail.targetElement ==
                                  CalendarElement.appointment) {
                                Calendar calendar =
                                    detail.appointments!.first as Calendar;
                                _controller.goToDetailEvent(calendar);
                              }
                            },
                            view: CalendarView.week,
                            headerStyle: CalendarHeaderStyle(
                                textStyle: GoogleFonts.montserrat(
                                    color: ColorsItem.blue38A1D3,
                                    fontSize: Dimens.SPACE_18,
                                    fontWeight: FontWeight.bold)),
                            viewHeaderStyle: ViewHeaderStyle(
                                dayTextStyle: GoogleFonts.montserrat(
                                    color: ColorsItem.grey8D9299,
                                    fontSize: Dimens.SPACE_16),
                                dateTextStyle: GoogleFonts.montserrat(
                                    color: ColorsItem.white9E9E9E,
                                    fontSize: Dimens.SPACE_12)),
                            headerHeight: Dimens.SPACE_60,
                            cellBorderColor: Colors.grey,
                            timeSlotViewSettings: TimeSlotViewSettings(
                                timeTextStyle: GoogleFonts.montserrat(
                                    color: ColorsItem.grey8D9299,
                                    fontSize: Dimens.SPACE_12)),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }),
      );
}
