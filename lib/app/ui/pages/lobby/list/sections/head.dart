import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/icon_status.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/list/controller.dart';
import 'package:mobile_sev2/app/ui/pages/pages.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class LobbyHead extends StatefulWidget {
  final LobbyController controller;
  const LobbyHead({Key? key, required this.controller}) : super(key: key);

  @override
  State<LobbyHead> createState() => _LobbyHeadState();
}

class _LobbyHeadState extends State<LobbyHead> {
  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Showcase(
                    key: widget.controller.seven,
                    showArrow: true,
                    disableAnimation: true,
                    animationDuration: Duration(seconds: 0),
                    contentPadding: EdgeInsets.all(Dimens.SPACE_12),
                    showcaseBackgroundColor: ColorsItem.black32373D,
                    titleTextStyle: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        color: ColorsItem.whiteFEFEFE,
                        fontWeight: FontWeight.bold),
                    descTextStyle: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12,
                      color: ColorsItem.greyB8BBBF,
                    ),
                    onToolTipClick: () {
                      widget.controller.pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear);
                    },
                    title: S.of(context).tooltip_workspace_title_1,
                    description: S.of(context).tooltip_workspace_description_1,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            widget.controller.goToWorkspaceList();
                          },
                          child: Row(
                            children: [
                              Text(
                                widget.controller.userData.workspace
                                    .capitalize(),
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_20,
                                  color: ColorsItem.orangeFB9600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: Dimens.SPACE_3,
                                  right: Dimens.SPACE_1,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.angleDown,
                                  color: ColorsItem.orangeFB9600,
                                  size: Dimens.SPACE_16,
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.pushNamed(context, Pages.notifications);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidBell,
                                    color: ColorsItem.orangeFB9600,
                                    size: Dimens.SPACE_19,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.controller.isLobbyParticipantsLoading
                          ? Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                width: Dimens.SPACE_100,
                                height: Dimens.SPACE_15,
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            )
                          : InkWell(
                              onTap: () => widget.controller.goToMember(),
                              child: Row(
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: widget.controller.availableUsers
                                            .toString(),
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14,
                                            // color: ColorsItem.greyB8BBBF,
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text:
                                          " ${S.of(context).lobby_active_label}",
                                      style: TextStyle(
                                        fontSize: Dimens.SPACE_14,
                                        // color: ColorsItem.greyB8BBBF
                                      ),
                                    )
                                  ])),
                                  SizedBox(
                                    width: Dimens.SPACE_5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                            text: widget
                                                .controller.unavailableUsers
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                // color: ColorsItem.greyB8BBBF,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              " ${S.of(context).lobby_inactive_label}",
                                          style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14,
                                            // color: ColorsItem.greyB8BBBF
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                      InkWell(
                        onTap: () => widget.controller.goToStatus(),
                        child: Container(
                          height: Dimens.SPACE_25,
                          child: Row(
                            children: [
                              Text(
                                widget.controller.getCurrentTask() == ''
                                    ? S.of(context).tooltip_lobby_title_idle
                                    : widget.controller.getCurrentTask(),
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.green00A1B0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: Dimens.SPACE_3),
                                child: IconStatus(
                                  size: Dimens.SPACE_15,
                                  status: widget.controller.getCurrentTask(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: Dimens.SPACE_2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
