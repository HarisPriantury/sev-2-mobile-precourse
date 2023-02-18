import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/domain/user.dart';

class MemberItemTile extends StatelessWidget {
  const MemberItemTile({
    Key? key,
    required this.user,
    required this.suffix,
  }) : super(key: key);

  final User user;
  final Widget suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.SPACE_16,
        right: Dimens.SPACE_16,
        bottom: Dimens.SPACE_16,
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(
              right: Dimens.SPACE_16,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ColorsItem.whiteColor,
                width: Dimens.SPACE_2,
              ),
            ),
            child: CircleAvatar(
              radius: Dimens.SPACE_20,
              backgroundImage: CachedNetworkImageProvider(
                user.avatar ?? '',
              ),
              backgroundColor: Colors.transparent,
            ),
          ),
          Builder(
            builder: (context) {
              final Widget child = Text(
                user.name ?? '',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.clip,
                maxLines: 1,
              );

              if (user.name!.length + user.fullName!.length > 20) {
                return Expanded(
                  child: child,
                );
              }

              return child;
            },
          ),
          const SizedBox(
            width: Dimens.SPACE_4,
          ),
          Builder(
            builder: (context) {
              final Widget child = Text(
                '(${user.fullName ?? ''})',
                style: GoogleFonts.montserrat(
                  color: ColorsItem.grey666B73,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              );

              if (user.name!.length + user.fullName!.length > 20) {
                return Expanded(
                  child: child,
                );
              }

              return child;
            },
          ),
          Spacer(),
          suffix,
        ],
      ),
    );
  }
}
