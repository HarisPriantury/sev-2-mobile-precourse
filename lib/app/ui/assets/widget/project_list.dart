import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';

class ProjectList extends StatelessWidget {
  final String projectName;
  final String joinDate;
  final String status;
  final int index;
  final void Function()? onTap;
  final bool isMilestone;

  const ProjectList({
    required this.projectName,
    required this.status,
    required this.joinDate,
    required this.index,
    required this.onTap,
    this.isMilestone = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              projectName,
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
                  isMilestone ? FontAwesomeIcons.locationDot : FontAwesomeIcons.suitcase,
                  color: ColorsItem.grey666B73,
                  size: 16.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "${isMilestone ? "Milestone" : "Project"} · $status",
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
