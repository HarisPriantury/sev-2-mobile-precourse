import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/domain/reaction.dart';

Future<dynamic> showReactionBottomSheet({
  required BuildContext context,
  required List<Reaction> reactions,
  final void Function(Reaction reaction)? onReactionClicked,
}) {
  if (reactions.isEmpty) {
    reactions = AppComponent.getInjector()
        .get<List<Reaction>>(dependencyName: "reaction_list");
  }
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        if (reactions.isNotEmpty) {
          return Wrap(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(Dimens.SPACE_30),
                        topRight: const Radius.circular(Dimens.SPACE_30))),
                padding: EdgeInsets.all(Dimens.SPACE_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimens.SPACE_15),
                    Text(
                      "Select Emoji",
                      style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                          color: ColorsItem.grey858A93),
                    ),
                    SizedBox(height: Dimens.SPACE_20),
                    Wrap(
                      runSpacing: MediaQuery.of(context).size.width / 20,
                      spacing: MediaQuery.of(context).size.width / 20,
                      children: List.generate(
                          reactions.length,
                          (index) => InkWell(
                                onTap: () {
                                  if (onReactionClicked != null)
                                    onReactionClicked(reactions[index]);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    child: SvgPicture.asset(
                                  reactions[index].emoticon!,
                                  height:
                                      MediaQuery.of(context).size.width / 12,
                                  width: MediaQuery.of(context).size.width / 12,
                                )
                                    // FaIcon(reactions[index].emoticon,
                                    //     color: reactions[index].color != null
                                    //         ? reactions[index].color!
                                    //         : ColorsItem.whiteFEFEFE,
                                    //     size: MediaQuery.of(context).size.width / 12
                                    //     ),
                                    ),
                              )),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height /
                            ((reactions.length / 8).ceil() * 3))
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container(
            decoration: BoxDecoration(
                color: ColorsItem.black020202,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(Dimens.SPACE_30),
                    topRight: const Radius.circular(Dimens.SPACE_30))),
            height: MediaQuery.of(context).size.height / 2,
            child: EmptyList(
                title: S.of(context).setting_data_empty,
                descripton: S.of(context).setting_data_empty_subtitle),
          );
        }
      });
}
