import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/assets/widget/ticket_item.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/ticket/controller.dart';

class RoomTicketPage extends View {
  final Object? arguments;

  RoomTicketPage({this.arguments});

  @override
  _RoomTicketState createState() => _RoomTicketState(
      AppComponent.getInjector().get<RoomTicketController>(), arguments);
}

class _RoomTicketState extends ViewState<RoomTicketPage, RoomTicketController> {
  RoomTicketController _controller;

  _RoomTicketState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomTicketController>(
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
                      S.of(context).main_task_tab_title,
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
                    onTap: () => _controller.onAddTicket(),
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
                        child: (_controller.unbreakTickets.isEmpty &&
                                _controller.triageTickets.isEmpty &&
                                _controller.wishlistTickets.isEmpty &&
                                _controller.wishlistTickets.isEmpty &&
                                _controller.wishlistTickets.isEmpty &&
                                _controller.wishlistTickets.isEmpty)
                            ? DefaultRefreshIndicator(
                                onRefresh: () => _controller.reload(),
                                child: EmptyList(
                                    title: S.of(context).room_empty_task_title,
                                    descripton: S
                                        .of(context)
                                        .room_empty_task_description),
                              )
                            : DefaultRefreshIndicator(
                                onRefresh: () => _controller.reload(),
                                child: SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    children: [
                                      controller.unbreakTickets.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: Dimens.SPACE_10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.SPACE_10),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .grey979797
                                                          .withOpacity(0.5))),
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  iconColor:
                                                      ColorsItem.grey606060,
                                                  iconSize: Dimens.SPACE_35,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    child: Text(
                                                      "Unbreak Now! (${controller.unbreakTickets.length} ${S.of(context).label_ticket})",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: Dimens
                                                                  .SPACE_16),
                                                    )),
                                                collapsed: SizedBox(),
                                                expanded: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: controller
                                                        .unbreakTickets.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TicketItem(
                                                          onTap: () {
                                                            controller
                                                                .onItemClicked(
                                                              controller
                                                                      .unbreakTickets[
                                                                  index],
                                                            );
                                                          },
                                                          ticket: controller
                                                                  .unbreakTickets[
                                                              index],
                                                          iconColor:
                                                              Colors.pink);
                                                    }),
                                              ),
                                            ),
                                      controller.triageTickets.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.SPACE_10),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .grey979797
                                                          .withOpacity(0.5))),
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  iconColor:
                                                      ColorsItem.grey606060,
                                                  iconSize: Dimens.SPACE_35,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    child: Text(
                                                      "Needs Triage (${controller.triageTickets.length} ${S.of(context).label_ticket})",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_16,
                                                      ),
                                                    )),
                                                collapsed: SizedBox(),
                                                expanded: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: controller
                                                        .triageTickets.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TicketItem(
                                                          onTap: () {
                                                            controller
                                                                .onItemClicked(
                                                              controller
                                                                      .triageTickets[
                                                                  index],
                                                            );
                                                          },
                                                          ticket: controller
                                                                  .triageTickets[
                                                              index],
                                                          iconColor:
                                                              Colors.purple);
                                                    }),
                                              ),
                                            ),
                                      controller.highTickets.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.SPACE_10),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .grey979797
                                                          .withOpacity(0.5))),
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  iconColor:
                                                      ColorsItem.grey606060,
                                                  iconSize: Dimens.SPACE_35,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    child: Text(
                                                      "High (${controller.highTickets.length} ${S.of(context).label_ticket})",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_16,
                                                      ),
                                                    )),
                                                collapsed: SizedBox(),
                                                expanded: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: controller
                                                        .highTickets.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TicketItem(
                                                          onTap: () {
                                                            controller
                                                                .onItemClicked(
                                                              controller
                                                                      .highTickets[
                                                                  index],
                                                            );
                                                          },
                                                          ticket: controller
                                                                  .highTickets[
                                                              index],
                                                          iconColor:
                                                              Colors.red);
                                                    }),
                                              ),
                                            ),
                                      controller.normalTickets.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.SPACE_10),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .grey979797
                                                          .withOpacity(0.5))),
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  iconColor:
                                                      ColorsItem.grey606060,
                                                  iconSize: Dimens.SPACE_35,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    child: Text(
                                                      "Normal (${controller.normalTickets.length} ${S.of(context).label_ticket})",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_16,
                                                      ),
                                                    )),
                                                collapsed: SizedBox(),
                                                expanded: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: controller
                                                        .normalTickets.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TicketItem(
                                                          onTap: () {
                                                            controller
                                                                .onItemClicked(
                                                              controller
                                                                      .normalTickets[
                                                                  index],
                                                            );
                                                          },
                                                          ticket: controller
                                                                  .normalTickets[
                                                              index],
                                                          iconColor:
                                                              Colors.orange);
                                                    }),
                                              ),
                                            ),
                                      controller.lowTickets.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  Dimens.SPACE_10,
                                                  0),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.SPACE_10),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .grey979797
                                                          .withOpacity(0.5))),
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  iconColor:
                                                      ColorsItem.grey606060,
                                                  iconSize: Dimens.SPACE_35,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    child: Text(
                                                      "Low (${controller.lowTickets.length} ${S.of(context).label_ticket})",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_16,
                                                      ),
                                                    )),
                                                collapsed: SizedBox(),
                                                expanded: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: controller
                                                        .lowTickets.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TicketItem(
                                                          onTap: () {
                                                            controller
                                                                .onItemClicked(
                                                              controller
                                                                      .lowTickets[
                                                                  index],
                                                            );
                                                          },
                                                          ticket: controller
                                                                  .lowTickets[
                                                              index],
                                                          iconColor:
                                                              Colors.yellow);
                                                    }),
                                              ),
                                            ),
                                      controller.wishlistTickets.isEmpty
                                          ? SizedBox()
                                          : Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.SPACE_10),
                                                  border: Border.all(
                                                      color: ColorsItem
                                                          .grey979797
                                                          .withOpacity(0.5))),
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  iconColor:
                                                      ColorsItem.grey606060,
                                                  iconSize: Dimens.SPACE_35,
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    child: Text(
                                                      "Wishlist (${controller.wishlistTickets.length} ${S.of(context).label_ticket})",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize:
                                                            Dimens.SPACE_16,
                                                      ),
                                                    )),
                                                collapsed: SizedBox(),
                                                expanded: ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: controller
                                                        .wishlistTickets.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return TicketItem(
                                                          onTap: () {
                                                            controller
                                                                .onItemClicked(
                                                              controller
                                                                      .wishlistTickets[
                                                                  index],
                                                            );
                                                          },
                                                          ticket: controller
                                                                  .wishlistTickets[
                                                              index],
                                                          iconColor: Colors
                                                              .lightBlueAccent);
                                                    }),
                                              ),
                                            ),
                                      SizedBox(height: Dimens.SPACE_12),
                                    ],
                                  ),
                                ),
                              ),
                      ),
              ],
            ),
          );
        }),
      );
}
