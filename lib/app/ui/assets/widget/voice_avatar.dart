import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/icon_avatar.dart';

class VoiceAvatar extends StatefulWidget {
  final String avatar;
  final bool isRaisedHand;
  final bool isDeafen;
  final bool isMuted;
  final bool isTalking;
  final String name;

  const VoiceAvatar(
      {required this.avatar,
      required this.isMuted,
      required this.isTalking,
      required this.isRaisedHand,
      required this.isDeafen,
      required this.name})
      : super();

  @override
  _VoiceAvatarState createState() => _VoiceAvatarState();
}

class _VoiceAvatarState extends State<VoiceAvatar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
            child: IconAvatar(
              icon: SvgPicture.asset(
                  widget.isTalking
                      ? ImageItem.IC_ACTIVE
                      : widget.isRaisedHand
                          ? ImageItem.IC_RAISE_HAND
                          : widget.isDeafen
                              ? ImageItem.IC_SPEAKER_OFF
                              : widget.isMuted
                                  ? ImageItem.IC_OFF
                                  : ImageItem.IC_ON,
                  width: MediaQuery.of(context).size.height / 30,
                  height: MediaQuery.of(context).size.height / 30),
              right: 5.0,
              bottom: 0.0,
              avatar: CircleAvatar(
                radius: MediaQuery.of(context).size.height / 25,
                backgroundImage: CachedNetworkImageProvider(
                  widget.avatar,
                ),
                backgroundColor: Colors.transparent,
              ),
              padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_6),
              border: Border.all(
                color: widget.isTalking
                    ? ColorsItem.orangeFB9600
                    : ColorsItem.white9E9E9E,
                width: Dimens.SPACE_2,
              ),
            ),
          ),
        ),
        Text(
          widget.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
              fontSize: Dimens.SPACE_12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
