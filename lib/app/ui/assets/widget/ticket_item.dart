import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/infrastructures/misc/date_util.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class TicketItem extends StatelessWidget {
  final Ticket ticket;
  final Color iconColor;
  final void Function()? onTap;

  const TicketItem({required this.ticket, required this.iconColor, this.onTap})
      : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Dimens.SPACE_16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FaIcon(FontAwesomeIcons.circleExclamation,
                      color: iconColor, size: Dimens.SPACE_18),
                  SizedBox(width: Dimens.SPACE_12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          this.ticket.name!,
                          style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_16,
                              color: ColorsItem.urlColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimens.SPACE_12),
                        this.ticket.project != null &&
                                this.ticket.project?.name != ""
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_10,
                                    vertical: Dimens.SPACE_4),
                                decoration: BoxDecoration(
                                    color:
                                        ColorsItem.urlColor.withOpacity(0.15),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.SPACE_4)),
                                child: Text(
                                  this.ticket.project!.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12),
                                ))
                            : SizedBox(height: Dimens.SPACE_5),
                      ],
                    ),
                  ),
                  SizedBox(width: Dimens.SPACE_12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: Dimens.SPACE_4),
                      Text(
                        AppComponent.getInjector()
                            .get<DateUtil>()
                            .displayDateTimeFormat(
                                ticket.createdAt ?? DateTime.now()),
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_12,
                            color: ColorsItem.greyB8BBBF),
                      ),
                      SizedBox(height: Dimens.SPACE_16),
                      Row(
                        children: [
                          Text(
                            "${S.of(context).status_task_assigned_to}: ",
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                color: ColorsItem.greyB8BBBF),
                          ),
                          Text(
                            ticket.assignee != null
                                ? ticket.assignee!.name!
                                : "",
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                color: ColorsItem.urlColor),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
                color: ColorsItem.grey666B73,
                indent: Dimens.SPACE_50,
                endIndent: Dimens.SPACE_20,
                height: Dimens.SPACE_1)
          ],
        ),
      ),
    );
  }
}
