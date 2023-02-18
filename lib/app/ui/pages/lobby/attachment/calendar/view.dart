import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/calendar_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/calendar/controller.dart';

class RoomCalendarPage extends View {
  final Object? arguments;

  RoomCalendarPage({this.arguments});

  @override
  _RoomCalendarState createState() => _RoomCalendarState(
      AppComponent.getInjector().get<RoomCalendarController>(), arguments);
}

class _RoomCalendarState
    extends ViewState<RoomCalendarPage, RoomCalendarController> {
  RoomCalendarController _controller;

  _RoomCalendarState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomCalendarController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).room_calendar_label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimens.SPACE_20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: Dimens.SPACE_4,
                    ),
                    Text(
                      _controller.room.name!,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                      ),
                    ),
                  ],
                ),
                suffix: Padding(
                  padding: EdgeInsets.only(right: Dimens.SPACE_16),
                  child: GestureDetector(
                    onTap: () => _controller.onAddCalendar(),
                    child: Text(
                      S.of(context).label_add,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.orangeFB9600),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.isLoading
                    ? Expanded(
                        child: Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: DefaultRefreshIndicator(
                          onRefresh: () => _controller.reload(),
                          child: _controller.calendars.isEmpty
                              ? EmptyList(
                                  title:
                                      S.of(context).room_empty_calendar_title,
                                  descripton: S
                                      .of(context)
                                      .room_empty_calendar_description)
                              : ListView.builder(
                                  itemCount: _controller.calendars.length,
                                  itemBuilder: (context, index) {
                                    return CalendarItem(
                                      calendar: _controller.calendars[index],
                                      onTap: () {
                                        _controller.onItemClicked(
                                            _controller.calendars[index]);
                                      },
                                    );
                                  }),
                        ),
                      )
              ],
            ),
          );
        }),
      );
}
