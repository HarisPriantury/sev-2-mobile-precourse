import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/calendar_data_source.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/calendar_event_item.dart';
import 'package:mobile_sev2/app/ui/pages/calendar/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MainCalendarPage extends View {
  final Object? arguments;

  MainCalendarPage({this.arguments});

  @override
  _MainCalendarState createState() => _MainCalendarState(
      AppComponent.getInjector().get<MainCalendarController>(), arguments);
}

class _MainCalendarState
    extends ViewState<MainCalendarPage, MainCalendarController> {
  MainCalendarController _controller;
  DateTime currentBackPressTime = DateTime.now();
  _MainCalendarState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<MainCalendarController>(
          builder: (context, controller) {
            return WillPopScope(
              onWillPop: () async {
                return showConfirmExit();
              },
              child: Scaffold(
                key: globalKey,
                appBar: AppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  flexibleSpace: SimpleAppBar(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                    toolbarHeight: MediaQuery.of(context).size.height / 10,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).label_calendar,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_18,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Dimens.SPACE_4),
                        Text(
                          S.of(context).label_calendar_subtitle,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    prefix: SizedBox(),
                    titleMargin: 0,
                  ),
                ),
                body: controller.isLoading
                    ? Column(
                        children: [
                          SizedBox(height: Dimens.SPACE_22),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                width: MediaQuery.of(context).size.width / 5,
                                height: Dimens.SPACE_18,
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            ),
                          ),
                          SizedBox(height: Dimens.SPACE_15),
                          Container(
                            child: Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: Dimens.SPACE_130,
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            ),
                          )
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.all(Dimens.SPACE_12),
                                child: SfCalendar(
                                  showNavigationArrow: true,
                                  dataSource:
                                      EventDataSource(controller.calendars),
                                  initialSelectedDate:
                                      controller.dateUtil.now(),
                                  minDate: controller.dateUtil
                                      .now()
                                      .subtract(Duration(days: 30)),
                                  maxDate: controller.dateUtil
                                      .now()
                                      .add(Duration(days: 30)),
                                  todayTextStyle: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.bold),
                                  selectionDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorsItem.orangeFB9600,
                                        width: 2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    shape: BoxShape.rectangle,
                                  ),
                                  firstDayOfWeek: int.parse(
                                              controller.userData.startWeek) ==
                                          0
                                      ? 7
                                      : int.parse(
                                          controller.userData.startWeek),
                                  onTap: (detail) {
                                    if (detail.targetElement ==
                                        CalendarElement.header) {
                                      controller.goToDetailCalendar();
                                    } else if (detail.targetElement ==
                                        CalendarElement.calendarCell) {
                                      controller
                                          .onTapEvent(detail.appointments);
                                    }
                                  },
                                  view: CalendarView.month,
                                  monthViewSettings: MonthViewSettings(
                                      showTrailingAndLeadingDates: false,
                                      monthCellStyle: MonthCellStyle(
                                        textStyle: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_16),
                                      )),
                                  monthCellBuilder: (BuildContext buildContext,
                                      MonthCellDetails details) {
                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.SPACE_8),
                                        border: controller.isToday(details.date)
                                            ? Border.all(width: 1)
                                            : null,
                                        color: details.appointments.isNotEmpty
                                            ? ColorsItem.blue38A1D3
                                            : null,
                                      ),
                                      child: Text(
                                        details.date.day.toString(),
                                        style: GoogleFonts.montserrat(
                                            color:
                                                details.appointments.isNotEmpty
                                                    ? ColorsItem.whiteFEFEFE
                                                    : null,
                                            fontSize: Dimens.SPACE_16,
                                            fontWeight:
                                                details.appointments.isNotEmpty
                                                    ? FontWeight.w700
                                                    : FontWeight.w400),
                                      ),
                                    );
                                  },
                                  appointmentTextStyle: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_10),
                                  headerStyle: CalendarHeaderStyle(
                                      textStyle: GoogleFonts.montserrat(
                                          color: ColorsItem.blue38A1D3,
                                          fontSize: Dimens.SPACE_18,
                                          fontWeight: FontWeight.bold)),
                                  viewHeaderStyle: ViewHeaderStyle(
                                    dayTextStyle: GoogleFonts.montserrat(
                                        color: ColorsItem.grey8D9299,
                                        fontSize: Dimens.SPACE_12),
                                  ),
                                  todayHighlightColor: ColorsItem.blue38A1D3,
                                  timeSlotViewSettings: TimeSlotViewSettings(
                                      timeTextStyle: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_12)),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: controller.appointment.length,
                              itemBuilder: (context, index) {
                                Calendar calendar =
                                    controller.appointment[index];
                                return CalendarEventItem(
                                  day: calendar.startTime
                                          .isSameDate(calendar.endTime)
                                      ? controller.dateUtil
                                          .format('EEE', calendar.startTime)
                                      : "${controller.dateUtil.format('EEE', calendar.startTime)} - ${controller.dateUtil.format('EEE', calendar.endTime)}",
                                  date: calendar.startTime
                                          .isSameDate(calendar.endTime)
                                      ? calendar.startTime.day.toString()
                                      : "${calendar.startTime.day.toString()} - ${calendar.endTime.day.toString()}",
                                  dateTime: calendar.startTime
                                          .isSameDate(calendar.endTime)
                                      ? "${controller.dateUtil.displayDateFormat(calendar.startTime)}, ${controller.dateUtil.basicTimeFormat(calendar.startTime)} - ${controller.dateUtil.basicTimeFormat(calendar.endTime)}"
                                      : "${controller.dateUtil.displayDateTimeFormat(calendar.startTime)} -\n${controller.dateUtil.displayDateTimeFormat(calendar.endTime)}",
                                  title: calendar.name!,
                                  onTap: () {
                                    controller.goToDetail(
                                        controller.appointment[index]);
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
              ),
            );
          },
        ),
      );

  Future<bool> showConfirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap Again To Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
