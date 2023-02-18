import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/adaptive_listview.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/transaction_item.dart';
import 'package:mobile_sev2/app/ui/pages/notification/list/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/mention.dart';
import 'package:shimmer/shimmer.dart';

class NotificationsPage extends View {
  final Object? arguments;

  NotificationsPage({this.arguments});

  @override
  _NotificationsState createState() => _NotificationsState(
      AppComponent.getInjector().get<NotificationsController>(), arguments);
}

class _NotificationsState
    extends ViewState<NotificationsPage, NotificationsController> {
  NotificationsController _controller;
  DateTime currentBackPressTime = DateTime.now();
  _NotificationsState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<NotificationsController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  title: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: FaIcon(
                          FontAwesomeIcons.angleLeft,
                        ),
                      ),
                      SizedBox(
                        width: Dimens.SPACE_19,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).notification_title,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_18,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: Dimens.SPACE_4),
                          Text(
                            S.of(context).notification_subtitle,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  prefix: SizedBox(),
                  titleMargin: 0,
                ),
              ),
              body: _controller.isLoading
                  ? _shimmer()
                  : DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          TabBar(
                              indicatorColor: ColorsItem.orangeFB9600,
                              unselectedLabelColor: ColorsItem.grey666B73,
                              labelColor: ColorsItem.orangeFB9600,
                              tabs: [
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.solidBell,
                                          size: Dimens.SPACE_12),
                                      SizedBox(width: Dimens.SPACE_4),
                                      Flexible(
                                        child: Text(
                                            S.of(context).notification_title,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_12),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade),
                                      )
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.barsStaggered,
                                          size: Dimens.SPACE_12),
                                      SizedBox(width: Dimens.SPACE_4),
                                      Flexible(
                                        child: Text(
                                            S
                                                .of(context)
                                                .notification_stream_label,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_12),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade),
                                      )
                                    ],
                                  ),
                                ),
                                Tab(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.at,
                                        size: Dimens.SPACE_12,
                                      ),
                                      SizedBox(width: Dimens.SPACE_4),
                                      Flexible(
                                        child: Text(
                                          S
                                              .of(context)
                                              .notification_mention_label,
                                          style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          Expanded(
                              child: TabBarView(
                            children: [
                              _tabNotification(),
                              _tabStream(),
                              _tabMentions(),
                            ],
                          ))
                        ],
                      )),
            ),
          );
        }),
      );

  Widget _tabNotification() {
    return _controller.notifications.isEmpty
        ? Container(
            padding: EdgeInsets.only(top: Dimens.SPACE_30),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        ImageItem.IC_NO_NOTIF,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    Center(
                      child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 2.65,
                              left: Dimens.SPACE_40,
                              right: Dimens.SPACE_40),
                          child: Text(S.of(context).notification_title,
                              style: GoogleFonts.raleway(
                                  color: ColorsItem.grey8D9299,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimens.SPACE_25),
                              textAlign: TextAlign.center)),
                    )
                  ],
                ),
                Center(
                    child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4,
                  ),
                  child: Text(S.of(context).notification_empty_label,
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.grey666B73,
                          fontSize: Dimens.SPACE_14),
                      textAlign: TextAlign.center),
                ))
              ],
            ),
          )
        : AdaptiveListview(
            onRefresh: () => _controller.reload(),
            item: (context, index) {
              if (index == _controller.notifications.length) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_6),
                    child: CircularProgressIndicator(
                      color: ColorsItem.whiteFEFEFE,
                    ),
                  ),
                );
              } else {
                var item = _controller.notifications[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_20,
                              vertical: Dimens.SPACE_14,
                            ),
                            child: Text(
                                S.of(context).label_recent.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.grey858A93,
                                    fontSize: Dimens.SPACE_12,
                                    fontWeight: FontWeight.w700)),
                          )
                        : SizedBox(),
                    TransactionItem(
                      avatar: item.icon,
                      backgroundColor: item.isRead
                          ? null
                          : ColorsItem.black32373D.withOpacity(0.48),
                      transactionAuthor: item.title,
                      dateTime:
                          _controller.formatNotificationTime(item.createdAt!),
                      transactionContent: '',
                    ),
                  ],
                );
              }
            },
            itemCount: _controller.notifications.length +
                (_controller.isNotificationPaginating ? 1 : 0),
            scrollController: _controller.listScrollController,
          );
  }

  Widget _tabStream() {
    return _controller.streams.isEmpty
        ? Container(
            padding: EdgeInsets.only(top: Dimens.SPACE_30),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        ImageItem.IC_NO_NOTIF,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    Center(
                      child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 2.65,
                              left: Dimens.SPACE_40,
                              right: Dimens.SPACE_40),
                          child: Text(S.of(context).notification_stream_label,
                              style: GoogleFonts.raleway(
                                  color: ColorsItem.grey8D9299,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimens.SPACE_25),
                              textAlign: TextAlign.center)),
                    )
                  ],
                ),
                Center(
                    child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 4,
                  ),
                  child: Text(S.of(context).stream_empty_label,
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.grey666B73,
                          fontSize: Dimens.SPACE_14),
                      textAlign: TextAlign.center),
                ))
              ],
            ),
          )
        : AdaptiveListview(
            onRefresh: () => _controller.reload(),
            item: (context, index) {
              if (index == _controller.streams.length) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_6),
                    child: CircularProgressIndicator(
                      color: ColorsItem.whiteFEFEFE,
                    ),
                  ),
                );
              } else {
                var item = _controller.streams[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    index == 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_20,
                              vertical: Dimens.SPACE_14,
                            ),
                            child: Text(
                              S.of(context).label_recent.toUpperCase(),
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.grey858A93,
                                fontSize: Dimens.SPACE_12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : SizedBox(),
                    InkWell(
                      onTap: () {
                        _controller.onTapStream(item);
                      },
                      child: TransactionItem(
                        avatar: item.user.avatar!,
                        transactionAuthor: item.content,
                        dateTime:
                            _controller.formatNotificationTime(item.createdAt),
                        transactionContent: '',
                      ),
                    ),
                  ],
                );
              }
            },
            itemCount: _controller.streams.length +
                (_controller.isStreamPaginating ? 1 : 0),
            scrollController: _controller.secondListScrollController,
          );
    // ListView.builder(
    //         controller: _controller.secondListScrollController,
    //         itemCount: _controller.streams.length,
    //         itemBuilder: (context, index) {
    //           var item = _controller.streams[index];
    //           return Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               index == 0
    //                   ? Padding(
    //                       padding: const EdgeInsets.all(Dimens.SPACE_20),
    //                       child: Text(S.of(context).label_recent.toUpperCase(),
    //                           style: GoogleFonts.montserrat(
    //                               color: ColorsItem.grey858A93,
    //                               fontSize: Dimens.SPACE_12,
    //                               fontWeight: FontWeight.w700)),
    //                     )
    //                   : SizedBox(),
    //               TransactionItem(
    //                 avatar: item.icon,
    //                 isActionable: true,
    //                 backgroundColor: item.isRead ? null : ColorsItem.black32373D.withOpacity(0.48),
    //                 transactionAuthor: item.title,
    //                 dateTime: _controller.formatNotificationTime(item.createdAt!),
    //                 transactionContent: '',
    //               ),
    //             ],
    //           );
    //         });
  }

  Widget _tabMentions() {
    return _controller.mentions.isEmpty
        ? Container(
            padding: EdgeInsets.only(top: Dimens.SPACE_30),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        ImageItem.IC_NO_NOTIF,
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.65,
                          left: Dimens.SPACE_40,
                          right: Dimens.SPACE_40,
                        ),
                        child: Text(
                          S.of(context).notification_mention_label,
                          style: GoogleFonts.raleway(
                              color: ColorsItem.grey8D9299,
                              fontWeight: FontWeight.bold,
                              fontSize: Dimens.SPACE_25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 4,
                    ),
                    child: Text(
                      S.of(context).embrace_empty_label,
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.grey666B73,
                          fontSize: Dimens.SPACE_14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        : AdaptiveListview(
            onRefresh: () => _controller.reload(),
            item: (context, index) {
              if (index == _controller.mentions.length) {
                return Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_6),
                    child: CircularProgressIndicator(
                      color: ColorsItem.whiteFEFEFE,
                    ),
                  ),
                );
              } else {
                var item = _controller.mentions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dateSeparator(
                      mentionA:
                          index == 0 ? null : _controller.mentions[index - 1],
                      mentionB: item,
                    ),
                    InkWell(
                      onTap: () {
                        _controller.onTapMention(item);
                      },
                      child: TransactionItem(
                        hasHeader: true,
                        headerText:
                            "${item.author.name} ${S.of(context).mentioned_you_in_label} ${item.object?.name}",
                        avatar: item.author.avatar!,
                        transactionAuthor: item.content,
                        dateTime:
                            _controller.formatNotificationTime(item.createdAt),
                        transactionContent: '',
                        maxLines: 2,
                      ),
                    ),
                  ],
                );
              }
            },
            itemCount: _controller.mentions.length +
                (_controller.isEmbracePaginating ? 1 : 0),
            scrollController: _controller.thirdListScrollController,
          );
  }

  Widget _dateSeparator({Mention? mentionA, required Mention mentionB}) {
    if (mentionA != null) {
      if (mentionA.createdAt.isSameDate(mentionB.createdAt)) {
        return SizedBox();
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.SPACE_20,
            vertical: Dimens.SPACE_14,
          ),
          child: Text(
            _getDisplayDate(mentionB.createdAt),
            style: GoogleFonts.montserrat(
              color: ColorsItem.grey858A93,
              fontSize: Dimens.SPACE_12,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.SPACE_20,
          vertical: Dimens.SPACE_14,
        ),
        child: Text(
          _getDisplayDate(mentionB.createdAt),
          style: GoogleFonts.montserrat(
            color: ColorsItem.grey858A93,
            fontSize: Dimens.SPACE_12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  String _getDisplayDate(DateTime dateTime) {
    if (_controller.dateUtil.now().isSameDate(dateTime)) {
      return S.of(context).label_recent.toUpperCase();
    } else if (_controller.dateUtil
        .now()
        .subtract(Duration(days: 1))
        .isSameDate(dateTime)) {
      return S.of(context).label_yesterday.toUpperCase();
    } else {
      return _controller.dateUtil.format("dd MMMM", dateTime).toUpperCase();
    }
  }

  Future<bool> showConfirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Tap Again To Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _shimmer() {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Shimmer.fromColors(
                  period: Duration(seconds: 1),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    decoration: BoxDecoration(
                      color: ColorsItem.black32373D,
                      borderRadius: new BorderRadius.all(
                          const Radius.circular(Dimens.SPACE_12)),
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    height: Dimens.SPACE_16,
                  ),
                  baseColor: ColorsItem.grey979797,
                  highlightColor: ColorsItem.grey606060,
                ),
                Shimmer.fromColors(
                  period: Duration(seconds: 1),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    decoration: BoxDecoration(
                      color: ColorsItem.black32373D,
                      borderRadius: new BorderRadius.all(
                          const Radius.circular(Dimens.SPACE_12)),
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    height: Dimens.SPACE_16,
                  ),
                  baseColor: ColorsItem.grey979797,
                  highlightColor: ColorsItem.grey606060,
                ),
                Shimmer.fromColors(
                  period: Duration(seconds: 1),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    decoration: BoxDecoration(
                      color: ColorsItem.black32373D,
                      borderRadius: new BorderRadius.all(
                          const Radius.circular(Dimens.SPACE_12)),
                    ),
                    width: MediaQuery.of(context).size.width / 5,
                    height: Dimens.SPACE_16,
                  ),
                  baseColor: ColorsItem.grey979797,
                  highlightColor: ColorsItem.grey606060,
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.SPACE_15),
          Shimmer.fromColors(
            period: Duration(seconds: 1),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
              decoration: BoxDecoration(
                color: ColorsItem.black32373D,
                borderRadius: new BorderRadius.all(
                    const Radius.circular(Dimens.SPACE_12)),
              ),
              width: Dimens.SPACE_50,
              height: Dimens.SPACE_16,
            ),
            baseColor: ColorsItem.grey979797,
            highlightColor: ColorsItem.grey606060,
          ),
          SizedBox(
            height: Dimens.SPACE_15,
          ),
          Shimmer.fromColors(
            period: Duration(seconds: 1),
            baseColor: ColorsItem.grey979797,
            highlightColor: ColorsItem.grey606060,
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 10,
                itemBuilder: (_, __) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ColorsItem.black32373D,
                              shape: BoxShape.circle),
                          width: Dimens.SPACE_40,
                          height: Dimens.SPACE_40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                width: 200,
                                height: Dimens.SPACE_16,
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            ),
                            SizedBox(height: Dimens.SPACE_6),
                            Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                width: Dimens.SPACE_100,
                                height: Dimens.SPACE_12,
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
