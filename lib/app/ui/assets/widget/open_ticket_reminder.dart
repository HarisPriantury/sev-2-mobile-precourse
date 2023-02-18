import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';

class OpenTicketReminder extends StatelessWidget {
  final List<String> projectName;
  final List<String> openTicket;
  final String userName;
  final Function()? onTap;

  OpenTicketReminder({
    required this.projectName,
    required this.openTicket,
    required this.userName,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimens.SPACE_12,
        horizontal: Dimens.SPACE_14,
      ),
      decoration: BoxDecoration(
        color: ColorsItem.black32373D,
        borderRadius: BorderRadius.circular(
          Dimens.SPACE_12,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hai $userName 👋",
                style: GoogleFonts.montserrat(
                  color: ColorsItem.whiteFEFEFE,
                  fontSize: Dimens.SPACE_12,
                ),
              ),
              InkWell(
                onTap: () {
                  if (onTap != null) {
                    onTap!();
                  }
                },
                child: Icon(
                  Icons.close,
                  color: ColorsItem.whiteColor,
                  size: Dimens.SPACE_14,
                ),
              )
            ],
          ),
          ListView.builder(
              itemCount: projectName.length,
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "∙ ${S.of(context).reminder_open_ticket_placeholder_text_1} ",
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                color: ColorsItem.whiteColor,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "${openTicket[index]} ${S.of(context).label_ticket} ",
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                color: ColorsItem.orangeFB9600,
                              ),
                            ),
                            TextSpan(
                              text: "${S.of(context).reminder_open_ticket_placeholder_text_2} ",
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                color: ColorsItem.whiteColor,
                              ),
                            ),
                            TextSpan(
                              text: "${projectName[index]}",
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                                color: ColorsItem.orangeFB9600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
