import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';

class ShowBottomModalTicket extends StatefulWidget {
  final String intId,
      ticketName,
      rawStatus,
      storyPoint,
      assignedName,
      authorName,
      projectName,
      subType;
  final void Function() onGotoDetail;

  const ShowBottomModalTicket({
    required this.intId,
    required this.ticketName,
    required this.rawStatus,
    required this.storyPoint,
    required this.assignedName,
    required this.authorName,
    required this.projectName,
    required this.subType,
    required this.onGotoDetail,
  });

  @override
  State<ShowBottomModalTicket> createState() => _ShowBottomModalTicketState();
}

class _ShowBottomModalTicketState extends State<ShowBottomModalTicket> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsItem.black24282E,
      child: Padding(
        padding: const EdgeInsets.all(Dimens.SPACE_15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.SPACE_5),
                    child: Text(
                      'T${widget.intId} : ${widget.ticketName}',
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_15,
                        fontWeight: FontWeight.w500,
                        color: ColorsItem.blue38A1D3,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.SPACE_4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Chip(
                                label: Text(
                                  '${widget.storyPoint} SP',
                                  style: GoogleFonts.montserrat(
                                    color: ColorsItem.whiteFEFEFE,
                                    fontSize: Dimens.SPACE_12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: ColorsItem.blue66C7D0,
                              ),
                              SizedBox(width: Dimens.SPACE_10),
                              Chip(
                                label: Text(
                                  "${widget.subType}",
                                  style: GoogleFonts.montserrat(
                                    color: ColorsItem.whiteFEFEFE,
                                    fontSize: Dimens.SPACE_12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: ColorsItem.blue66C7D0,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${widget.rawStatus}',
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.projectName != ""
                      ? Chip(
                          label: Text(
                            '${widget.projectName}',
                            style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE,
                              fontSize: Dimens.SPACE_12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: ColorsItem.blue66C7D0,
                        )
                      : SizedBox(),
                  Chip(
                    label: Text(
                      '${S.of(context).label_attachment}',
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteFEFEFE,
                        fontSize: Dimens.SPACE_12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColor: ColorsItem.yellowFFA600,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.SPACE_4),
                    child: Text(
                      '${S.of(context).status_task_assigned_to} : ${widget.assignedName}',
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteFEFEFE,
                        fontSize: Dimens.SPACE_13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Dimens.SPACE_4),
                    child: Text(
                      '${S.of(context).room_detail_authored_by_label} : ${widget.authorName}',
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.whiteFEFEFE,
                        fontSize: Dimens.SPACE_13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimens.SPACE_15),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimens.SPACE_8, horizontal: Dimens.SPACE_15),
                    child: InkWell(
                      onTap: () {
                        widget.onGotoDetail();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: ColorsItem.whiteEDEDED,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimens.SPACE_10),
                          child: Center(
                            child: Text(
                              S.of(context).status_task_open,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.black020202,
                                fontSize: Dimens.SPACE_14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimens.SPACE_8, horizontal: Dimens.SPACE_15),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          color: ColorsItem.whiteEDEDED,
                          child: Padding(
                            padding: const EdgeInsets.all(Dimens.SPACE_10),
                            child: Center(
                              child: Text(
                                S.of(context).label_close,
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.black020202,
                                  fontSize: Dimens.SPACE_14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
