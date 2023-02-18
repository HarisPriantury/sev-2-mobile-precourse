import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/controller.dart';

class IpDailyTask extends StatelessWidget {
  final LobbyController lobbyController;
  const IpDailyTask({super.key, required this.lobbyController});

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
                border:
                    Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(Dimens.SPACE_10.h),
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).label_daily_task,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: Dimens.SPACE_15,
                    ),
                    Divider(
                      color: ColorsItem.grey666B73,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView.builder(
                        itemCount:
                            lobbyController.actionItemDailyIpTasks.length,
                        itemBuilder: (context, index) {
                          final actionItemDailyIpTasks =
                              lobbyController.actionItemDailyIpTasks[index];

                          return _buildActionItem(
                            title: actionItemDailyIpTasks.title,
                            oActionPressed: actionItemDailyIpTasks.onPressed,
                            value: actionItemDailyIpTasks.value,
                          );
                        },
                      ),
                    ),
                  ]),
            )
          ],
        ));
  }

  Widget _buildActionItem({
    required String title,
    required Function() oActionPressed,
    required bool value,
  }) {
    return Row(
      children: [
        Checkbox(
          checkColor: ColorsItem.whiteColor,
          activeColor: ColorsItem.orangeFB9600,
          value: value,
          onChanged: (bool? value) {},
        ),
        InkWell(
          onTap: oActionPressed,
          child: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: Dimens.SPACE_14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
