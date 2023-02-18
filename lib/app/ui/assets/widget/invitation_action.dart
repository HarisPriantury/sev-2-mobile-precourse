import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';

class InvitationAction extends StatelessWidget {
  final String sendingUser;
  final String roomName;
  final void Function()? onReject;
  final void Function()? onAccept;

  const InvitationAction(
      {required this.roomName, required this.sendingUser, required this.onReject, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: ColorsItem.green00A1B0,
      padding: EdgeInsets.all(Dimens.SPACE_20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "👋 ${sendingUser.toString()} has invites you to join the room “${roomName.toString()}”",
            style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_16, color: ColorsItem.whiteFEFEFE, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: Dimens.SPACE_15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonDefault(
                  buttonText: "REJECT",
                  buttonTextColor: ColorsItem.whiteFEFEFE,
                  buttonColor: ColorsItem.green00A1B0,
                  buttonLineColor: ColorsItem.whiteFEFEFE,
                  paddingHorizontal: Dimens.SPACE_15,
                  paddingVertical: Dimens.SPACE_10,
                  onTap: onReject),
              SizedBox(
                width: Dimens.SPACE_20,
              ),
              ButtonDefault(
                  buttonText: "ACCEPT",
                  buttonTextColor: ColorsItem.green00A1B0,
                  buttonColor: ColorsItem.whiteFEFEFE,
                  buttonLineColor: ColorsItem.green00A1B0,
                  paddingHorizontal: Dimens.SPACE_15,
                  paddingVertical: Dimens.SPACE_10,
                  onTap: onAccept)
            ],
          )
        ],
      ),
    );
  }
}
