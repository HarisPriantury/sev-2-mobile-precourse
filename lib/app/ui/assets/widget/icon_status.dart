import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';

class IconStatus extends StatelessWidget {
  final String status;
  final double size;

  const IconStatus({required this.status, this.size = Dimens.SPACE_18});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FaIcon(
        status == "In Lobby" || status == ""
            ? FontAwesomeIcons.mugSaucer
            : status == "Not Available"
                ? FontAwesomeIcons.bed
                : status == "Bathroom"
                    ? FontAwesomeIcons.bath
                    : status == "Lunch"
                        ? FontAwesomeIcons.utensils
                        : status == "Me Time!"
                            ? FontAwesomeIcons.gamepad
                            : status == "Family thing"
                                ? FontAwesomeIcons.lifeRing
                                : status == "Praying"
                                    ? FontAwesomeIcons.bellSlash
                                    : status == "Other"
                                        ? FontAwesomeIcons.userSecret
                                        : FontAwesomeIcons.listCheck,
        color: ColorsItem.grey8D9299,
        size: this.size,
      ),
    );
  }
}
