import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';

class VoiceAvatarLarge extends StatefulWidget {
  final String avatar;
  final bool isRaisedHand;
  final bool isDeafen;
  final bool isMuted;
  final bool isTalking;

  const VoiceAvatarLarge(
      {Key? key,
      required this.avatar,
      required this.isRaisedHand,
      required this.isDeafen,
      required this.isMuted,
      required this.isTalking})
      : super(key: key);

  @override
  _VoiceAvatarLargeState createState() => _VoiceAvatarLargeState();
}

class _VoiceAvatarLargeState extends State<VoiceAvatarLarge> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          margin: EdgeInsets.only(top: Dimens.SPACE_40),
          decoration: new BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(
                  color: widget.isTalking
                      ? ColorsItem.orangeFB9600
                      : ColorsItem.whiteFEFEFE,
                  width: 3.0)),
          child: CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.17,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(widget.avatar),
          ),
        ),
        Container(
            child: SvgPicture.asset(
                widget.isTalking
                    ? ImageItem.IC_ACTIVE
                    : widget.isRaisedHand
                        ? ImageItem.IC_RAISE_HAND
                        : widget.isDeafen
                            ? ImageItem.IC_SPEAKER_OFF
                            : widget.isMuted
                                ? ImageItem.IC_OFF
                                : ImageItem.IC_ON,
                width: MediaQuery.of(context).size.width * 0.15))
      ],
    );
  }
}
