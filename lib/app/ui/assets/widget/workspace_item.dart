import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class WorkspaceItem extends StatelessWidget {
  final String workspaceName;
  final bool selected;
  final String? planPackage;
  final void Function()? onTap;
  final void Function()? onLogOut;
  final bool showLogoutButton;

  const WorkspaceItem({
    required this.workspaceName,
    required this.selected,
    this.planPackage,
    this.onTap,
    this.onLogOut,
    this.showLogoutButton = false,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.SPACE_12),
            border: Border.all(
              color:
                  selected ? ColorsItem.orangeFB9600 : ColorsItem.white9E9E9E,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspaceName,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: Dimens.SPACE_4),
                    planPackage != null
                        ? Text(
                            planPackage!,
                            style: GoogleFonts.montserrat(
                              color: ColorsItem.greyB8BBBF,
                              fontSize: Dimens.SPACE_14,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              showLogoutButton
                  ? InkWell(
                      onTap: onLogOut,
                      child: FaIcon(
                        FontAwesomeIcons.rightFromBracket,
                        size: Dimens.SPACE_20,
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
