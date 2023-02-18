import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/domain/room.dart';

import 'button_default.dart';

class PreviousRoom extends StatelessWidget {
  final Room previousRoom;
  final Function(Room)? onTap;

  PreviousRoom({
    required this.previousRoom,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: Theme.of(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: Dimens.SPACE_12,
          horizontal: Dimens.SPACE_14,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(
            Dimens.SPACE_12,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: S.of(context).previous_room_placeholder_text_1,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12.sp,
                        color: ColorsItem.grey979797,
                      ),
                    ),
                    TextSpan(
                      text: " ${previousRoom.name} ",
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12.sp,
                        color: ColorsItem.orangeFB9600,
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).previous_room_placeholder_text_2,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12.sp,
                        color: ColorsItem.grey979797,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: Dimens.SPACE_4),
            ButtonDefault(
              buttonText: S.of(context).label_back,
              buttonTextColor: ColorsItem.black020202,
              buttonColor: ColorsItem.green00A1B0,
              buttonLineColor: ColorsItem.green00A1B0,
              paddingHorizontal: Dimens.SPACE_14,
              paddingVertical: Dimens.SPACE_6,
              fontSize: Dimens.SPACE_12.sp,
              onTap: () {
                if (onTap != null) {
                  onTap!(previousRoom);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
