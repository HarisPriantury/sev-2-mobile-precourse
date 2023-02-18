import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';

class TicketList extends StatelessWidget {
  final String ticketName;
  final String status;
  final int index;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const TicketList({
    required this.ticketName,
    required this.status,
    required this.index,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                width: 0.5,
                color: index == 0 ? Colors.transparent : ColorsItem.grey666B73),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ticketName,
              style: GoogleFonts.montserrat(
                fontSize: 14.0,
                color: ColorsItem.blue38A1D3,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.listCheck,
                  color: ColorsItem.grey666B73,
                  size: 16.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  " ${S.of(context).label_ticket} · $status",
                  style: GoogleFonts.montserrat(
                    fontSize: 12.0,
                    color: ColorsItem.grey666B73,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
