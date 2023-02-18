import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class MemberItem extends StatelessWidget {
  final String avatar;
  final String name;
  final String fullName;
  final String status;
  final Color statusColor;
  final Widget icon;
  final void Function()? onTap;

  const MemberItem({
    required this.avatar,
    required this.name,
    required this.status,
    required this.icon,
    required this.statusColor,
    required this.fullName,
    this.onTap,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_14),
        child: Container(
          padding: EdgeInsets.all(Dimens.SPACE_8),
          child: Row(
            children: [
              CircleAvatar(
                  radius: Dimens.SPACE_5, backgroundColor: statusColor),
              SizedBox(width: Dimens.SPACE_12),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.0,
                    )),
                child: CircleAvatar(
                  radius: Dimens.SPACE_20,
                  backgroundImage: CachedNetworkImageProvider(
                    avatar,
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: Dimens.SPACE_12,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                    ),
                    status.isNotEmpty
                        ? SizedBox(
                            height: Dimens.SPACE_6,
                          )
                        : SizedBox(),
                    status.isNotEmpty
                        ? Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12,
                              color: ColorsItem.grey8D9299,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(width: Dimens.SPACE_6),
              icon
            ],
          ),
        ),
      ),
    );
  }
}
