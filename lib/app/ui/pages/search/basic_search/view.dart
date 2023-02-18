import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/history_search.dart';
import 'package:mobile_sev2/app/ui/assets/widget/search_item.dart';
import 'package:mobile_sev2/app/ui/pages/search/basic_search/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/room.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:mobile_sev2/domain/user.dart';

class BasicSearchPage extends View {
  final Object? arguments;

  BasicSearchPage({this.arguments});

  @override
  _BasicSearchState createState() => _BasicSearchState(
      AppComponent.getInjector().get<BasicSearchController>(), arguments);
}

class _BasicSearchState
    extends ViewState<BasicSearchPage, BasicSearchController> {
  BasicSearchController _controller;

  _BasicSearchState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<BasicSearchController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              elevation: 0,
              automaticallyImplyLeading: false,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                padding: EdgeInsets.symmetric(
                  vertical: Dimens.SPACE_10,
                ),
                titleMargin: 0,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        S.of(context).main_search_tab_title,
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _controller.goToAdvanced(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: Dimens.SPACE_20),
                        child: Text(
                          S.of(context).search_advance_label,
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimens.SPACE_14,
                            color: ColorsItem.orangeFB9600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimens.SPACE_20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: SearchBar(
                      hintText: S.of(context).label_search,
                      border: Border.all(
                          color: ColorsItem.grey979797.withOpacity(0.5)),
                      borderRadius: new BorderRadius.all(
                          const Radius.circular(Dimens.SPACE_40)),
                      innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                      outerPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
                      controller: _controller.searchController,
                      focusNode: _controller.focusNodeSearch,
                      onChanged: (txt) {
                        controller.streamController.add(txt);
                      },
                      filterValue: _controller.filterValue,
                      clear: true,
                      clearTap: () => _controller.clearSearch(),
                      onTap: () {
                        if (_controller.isQuerySearch)
                          _controller.clearSearch();
                        _controller.delayMillis(() {
                          _controller.onSearch(true);
                        }, milliseconds: 500);
                      },
                      endIcon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: ColorsItem.greyB8BBBF,
                        size: Dimens.SPACE_18,
                      ),
                      textStyle: TextStyle(fontSize: Dimens.SPACE_15),
                      hintStyle: TextStyle(color: ColorsItem.grey8D9299),
                      buttonText: 'Clear',
                    ),
                  ),
                  _controller.isSearch &&
                          (_controller.searchController.text.isNotEmpty ||
                              _controller.filterValue.isNotEmpty) &&
                          (_controller.searchController.text != " " &&
                              _controller.searchController.text != "")
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: Dimens.SPACE_5,
                                bottom: Dimens.SPACE_20,
                                left: Dimens.SPACE_20,
                                right: Dimens.SPACE_20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _controller.searchController.text.isNotEmpty
                                    ? RichText(
                                        text: new TextSpan(
                                          text: S
                                              .of(context)
                                              .search_found_placeholder,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              color: ColorsItem.grey8D9299),
                                          children: <TextSpan>[
                                            new TextSpan(
                                                text:
                                                    '"${_controller.searchController.text}"',
                                                style: new TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: Dimens.SPACE_15,
                                ),
                                !_controller.isFinishedLoading()
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: Dimens.SPACE_50),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ))
                                    : _controller.searchResults.isNotEmpty ||
                                            _controller
                                                .searchController.text.isEmpty
                                        ? Expanded(
                                            child: ListView.builder(
                                                controller: _controller
                                                    .listScrollController,
                                                itemCount: _controller
                                                        .searchResults.length +
                                                    (_controller.isPaginating
                                                        ? 1
                                                        : 0),
                                                itemBuilder: (context, index) {
                                                  if (index ==
                                                      _controller.searchResults
                                                          .length) {
                                                    return Center(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: Dimens
                                                                    .SPACE_12),
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    );
                                                  }
                                                  var object = _controller
                                                      .searchResults[index];
                                                  if (object is Room) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _controller
                                                            .joinRoom(object);
                                                      },
                                                      child: SearchItem(
                                                        title: object
                                                            .getFullName()!,
                                                        desc:
                                                            "${S.of(context).label_room}",
                                                        verticalPadding:
                                                            Dimens.SPACE_16,
                                                        thisIcon: FaIcon(
                                                          FontAwesomeIcons
                                                              .solidComments,
                                                          size: Dimens.SPACE_12,
                                                        ),
                                                      ),
                                                    );
                                                  } else if (object is User) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _controller.goToProfile(
                                                            object);
                                                      },
                                                      child: SearchItem(
                                                        title:
                                                            "${object.getFullName()!}",
                                                        desc:
                                                            "${S.of(context).label_user}",
                                                        verticalPadding:
                                                            Dimens.SPACE_16,
                                                        thisIcon: FaIcon(
                                                          FontAwesomeIcons
                                                              .solidUser,
                                                          size: Dimens.SPACE_12,
                                                        ),
                                                      ),
                                                    );
                                                  } else if (object
                                                      is Calendar) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _controller
                                                            .goToDetailEvent(
                                                                object);
                                                      },
                                                      child: SearchItem(
                                                        title:
                                                            "E${object.intId} : ${object.getFullName()!}",
                                                        desc:
                                                            "${S.of(context).label_event} · ${_controller.dateUtil.format('d MMMM yyyy', object.startTime)}",
                                                        verticalPadding:
                                                            Dimens.SPACE_16,
                                                        thisIcon: FaIcon(
                                                          FontAwesomeIcons
                                                              .calendarDay,
                                                          size: Dimens.SPACE_12,
                                                        ),
                                                      ),
                                                    );
                                                  } else if (object is Ticket) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _controller
                                                            .goToTicketDetail(
                                                                object);
                                                      },
                                                      child: SearchItem(
                                                        title:
                                                            "T${object.intId} : ${object.getFullName()!}",
                                                        desc:
                                                            "${S.of(context).label_ticket}· ${object.ticketStatus.parseToString().ucwords()}",
                                                        verticalPadding:
                                                            Dimens.SPACE_16,
                                                        thisIcon: FaIcon(
                                                          FontAwesomeIcons
                                                              .listCheck,
                                                          size: Dimens.SPACE_12,
                                                        ),
                                                      ),
                                                    );
                                                  } else if (object
                                                      is Project) {
                                                    return InkWell(
                                                      onTap: () {
                                                        _controller
                                                            .goToDetailProject(
                                                                object);
                                                      },
                                                      child: SearchItem(
                                                        title:
                                                            "#${object.intId} : ${object.getFullName()!}",
                                                        desc:
                                                            "${S.of(context).label_project}",
                                                        verticalPadding:
                                                            Dimens.SPACE_16,
                                                        thisIcon: FaIcon(
                                                          FontAwesomeIcons
                                                              .tableColumns,
                                                          size: Dimens.SPACE_12,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                }),
                                          )
                                        : Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .search_data_not_found_title,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                    Text(
                                                      S
                                                          .of(context)
                                                          .search_data_not_found_description,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14.0,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: List.generate(
                                        _controller.filterList.length,
                                        (index) => InkWell(
                                          highlightColor: Colors.transparent,
                                          onTap: () => _controller
                                              .setFilterValue(_controller
                                                  .filterList[index]),
                                          child: Container(
                                            padding:
                                                EdgeInsets.all(Dimens.SPACE_5),
                                            margin: EdgeInsets.only(
                                                right: Dimens.SPACE_7,
                                                top: Dimens.SPACE_6),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6.0))),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 0.5,
                                                  color: ColorsItem.white9E9E9E,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                    6.0,
                                                  ),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    Dimens.SPACE_5),
                                                child: Text(
                                                  _controller.filterList[index],
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: Dimens.SPACE_14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      spacing: Dimens.SPACE_4,
                                      runSpacing: Dimens.SPACE_4,
                                    ),
                                    SizedBox(
                                      height: Dimens.SPACE_20,
                                    ),
                                  ],
                                ),
                              ),
                              controller.searchHistory.isNotEmpty
                                  ? Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.SPACE_20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${S.of(context).label_history} ${S.of(context).main_search_tab_title}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimens.SPACE_12,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _controller
                                                          .onDeleteAllHistory();
                                                    },
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .label_delete_all,
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            Dimens.SPACE_12,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: Dimens.SPACE_6,
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  itemCount: _controller
                                                      .searchHistory.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return HistorySearch(
                                                      onTap: () {
                                                        _controller
                                                            .searchFromHistory(
                                                                _controller
                                                                        .searchHistory[
                                                                    index]);
                                                      },
                                                      delete: () {
                                                        _controller.onDeleteHistory(
                                                            _controller
                                                                    .searchHistory[
                                                                index]);
                                                      },
                                                      textHistory: _controller
                                                          .searchHistory[index]
                                                          .keyword,
                                                    );
                                                  }),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        }),
      );
}
