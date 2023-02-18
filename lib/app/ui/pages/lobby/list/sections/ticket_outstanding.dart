import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/controller.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class TicketOutstanding extends StatelessWidget {
  final void Function(Ticket) onTap;
  final void Function() onMoveToProject;
  final List<Ticket> outstandingTicket;
  final void Function() onSelectAllTicket;
  final void Function() onSelectUnbreakTicket;
  final void Function() onSelectHighTicket;
  final void Function() onSelectNormalTicket;
  final LobbyController lobbyController;

  const TicketOutstanding({
    required this.onTap,
    required this.outstandingTicket,
    required this.onMoveToProject,
    required this.onSelectUnbreakTicket,
    required this.onSelectAllTicket,
    required this.onSelectHighTicket,
    required this.onSelectNormalTicket,
    required this.lobbyController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: Theme.of(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Dimens.SPACE_15.h),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.SPACE_10.h),
                border:
                    Border.all(color: ColorsItem.grey979797.withOpacity(0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).label_outstanding_tasks,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: Dimens.SPACE_10.h),
                              Container(
                                padding: EdgeInsets.all(Dimens.SPACE_5.h),
                                decoration: BoxDecoration(
                                    color:
                                        ColorsItem.green219653.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(
                                        Dimens.SPACE_4.h)),
                                child: Text(
                                  S.of(context).status_task_open,
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _popMenu(),
                    ],
                  ),
                ),
                SizedBox(height: Dimens.SPACE_10.h),
                outstandingTicket.isEmpty
                    ? Center(
                        child: Text(
                          S.of(context).label_search_empty,
                          style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: outstandingTicket.length,
                          itemBuilder: (context, index) {
                            var item = outstandingTicket;
                            return InkWell(
                              onTap: () {
                                onTap(item[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: Dimens.SPACE_1.h,
                                      color: ColorsItem.grey666B73,
                                    ),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: Dimens.SPACE_10.h,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(Dimens.SPACE_10.h),
                                      padding: EdgeInsets.all(Dimens.SPACE_5.h),
                                      child: FaIcon(
                                        FontAwesomeIcons.ticket,
                                        color: ColorsItem.orangeCC6000,
                                        size: Dimens.SPACE_15.h,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimens.SPACE_5.h),
                                        color: ColorsItem.yellowF2C94C,
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          item[index].name ?? "",
                                          style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14.sp,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                Divider(
                  color: ColorsItem.grey666B73,
                  height: Dimens.SPACE_2,
                ),
                SizedBox(
                  height: Dimens.SPACE_15.h,
                ),
                Container(
                  padding: EdgeInsets.only(
                      right: Dimens.SPACE_20.h, bottom: Dimens.SPACE_5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          onMoveToProject();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              S.of(context).appbar_see_all_label,
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: Dimens.SPACE_20.h),
        ],
      ),
    );
  }

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          onSelectAllTicket();
        } else if (value == 1) {
          onSelectUnbreakTicket();
        } else if (value == 2) {
          onSelectHighTicket();
        } else {
          onSelectNormalTicket();
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: Dimens.SPACE_20.h),
        child: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          size: Dimens.SPACE_18.h,
        ),
      ),
      itemBuilder: (context) => _generatePopUp(context),
    );
  }

  List<PopupMenuEntry<int>> _generatePopUp(BuildContext context) {
    List<PopupMenuEntry<int>> popup = [];
    popup.add(
      PopupMenuItem(
        value: 0,
        child: Text(
          S.of(context).status_task_all,
          style: GoogleFonts.montserrat(
            fontSize: Dimens.SPACE_14.sp,
          ),
        ),
      ),
    );
    popup.add(
      PopupMenuItem(
        value: 1,
        child: Text(
          Ticket.STATUS_UNBREAK,
          style: GoogleFonts.montserrat(
            fontSize: Dimens.SPACE_14.sp,
          ),
        ),
      ),
    );
    popup.add(
      PopupMenuItem(
        value: 2,
        child: Text(
          Ticket.STATUS_HIGH,
          style: GoogleFonts.montserrat(
            fontSize: Dimens.SPACE_14.sp,
          ),
        ),
      ),
    );
    popup.add(
      PopupMenuItem(
        value: 3,
        child: Text(
          Ticket.STATUS_NORMAL,
          style: GoogleFonts.montserrat(
            fontSize: Dimens.SPACE_14.sp,
          ),
        ),
      ),
    );
    return popup;
  }
}
