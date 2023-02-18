import 'package:flutter/material.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/data/infrastructures/date_util_interface.dart';
import 'package:mobile_sev2/domain/meta/object_reaction.dart';
import 'package:mobile_sev2/domain/reaction.dart';
import 'package:mobile_sev2/domain/user.dart';

class ReactionMapper {
  DateUtilInterface _dateUtil;

  ReactionMapper(this._dateUtil);

  List<Reaction> convertGetReactionsApiResponse(Map<String, dynamic> response) {
    var reactions = List<Reaction>.empty(growable: true);

    var data = response['result'];
    if (data != null) {
      data.forEach((value) {
        String icon = _mapIcon(value['name']);
        if (icon != ImageItem.IC_HAND) {
          reactions.add(
            Reaction(
              value['phid'],
              name: value['name'],
              emoticon: icon,
              color: _mapColor(value['name']),
            ),
          );
        }
      });
    }

    return reactions;
  }

  List<ObjectReactions> convertGetObjectReactionsApiResponse(Map<String, dynamic> response) {
    List<ObjectReactions> result = [];
    List<Reaction> reactions = AppComponent.getInjector().get<List<Reaction>>(dependencyName: "reaction_list");

    var data = response['result'];
    if (data != null) {
      data.forEach((value) {
        int idx = reactions
            .indexWhere((element) => element.emoticon != ImageItem.IC_HAND && element.id == value['tokenPHID']);
        if (idx > -1) {
          Reaction reaction = reactions[idx];
          result.add(
            ObjectReactions(
              value['objectPHID'],
              User(value['authorPHID']),
              reaction,
            ),
          );
        }
      });
    }

    return result;
  }

  String _mapIcon(String name) {
    switch (name) {
      case "Like":
        return ImageItem.IC_REACTION_LIKE;
      case "Dislike":
        return ImageItem.IC_REACTION_DISLIKE;
      case "Love":
        return ImageItem.IC_REACTION_LOVE;
      case "Heartbreak":
        return ImageItem.IC_REACTION_HEARTBREAK;
      case "Orange Medal":
        return ImageItem.IC_REACTION_ORANGE_MEDAL;
      case "Grey Medal":
        return ImageItem.IC_REACTION_GREY_MEDAL;
      case "Yellow Medal":
        return ImageItem.IC_REACTION_YELLOW_MEDAL;
      case "Mountain of Wealth":
        return ImageItem.IC_REACTION_MOUNTAIN_OF_WEALTH;
      case "Pterodactyl":
        return ImageItem.IC_REACTION_PTERODACTYL;
      case "Evil Spooky Haunted Tree":
        return ImageItem.IC_REACTION_EVIL_SPOOKY_HAUNTED_TREE;
      case "Party Time":
        return ImageItem.IC_REACTION_PARTY_TIME;
      case "Y So Serious":
        return ImageItem.IC_REACTION_Y_SO_SERIOUS;
      case "Cup of Joe":
        return ImageItem.IC_REACTION_CUP_OF_JOE;
      case "Burninate":
        return ImageItem.IC_REACTION_BURNINATE;
      case "Pirate Logo":
        return ImageItem.IC_REACTION_PIRATE_LOGO;
      case "Cool":
        return ImageItem.IC_REACTION_COOL;
      case "Handshake":
        return ImageItem.IC_REACTION_HANDSAKE;
      case "LoL":
        return ImageItem.IC_REACTION_LOL;
      case "Noted":
        return ImageItem.IC_REACTION_WELL_NOTED;
      case "OK":
        return ImageItem.IC_REACTION_OK;
      case "Cheers!":
        return ImageItem.IC_REACTION_CHEERS;
      case "Manufacturing Defect?":
        return ImageItem.IC_REACTION_MANUFACTURING_DEFECT;
      case "Haypence":
        return ImageItem.IC_REACTION_HAYPENCE;
      case "Piece of Eight":
        return ImageItem.IC_REACTION_PIECE_OF_EIGHT;
      case "Doubloon":
        return ImageItem.IC_REACTION_DOUBLOON;
      case "Baby Tequila":
        return ImageItem.IC_REACTION_BABY_TEQUILA;
      case "The World Burns":
        return ImageItem.IC_REACTION_THE_WORLD_BURNS;
      case "100":
        return ImageItem.IC_REACTION_100;
      case "Dat Boi":
        return ImageItem.IC_REACTION_DAT_BOI;
      case "Hungry Hippo":
        return ImageItem.IC_REACTION_HUNGRY_HIPPO;
      case "Get better soon":
        return ImageItem.IC_REACTION_GET_BETTER_SOON;
      case "Well noted":
        return ImageItem.IC_REACTION_WELL_NOTED;
      case "Acknowledge of inevitable event":
        return ImageItem.IC_REACTION_ACKNOWLEDGE_OF_INEVITABLE_EVENT;
      case "Thanks!":
        return ImageItem.IC_REACTION_THANKS;
      case "Sip!":
        return ImageItem.IC_REACTION_OK;
      case "Refactory Quality":
      // return ImageItem.IC_REACTION_REFACTORY_QUALITY;
      default:
        return ImageItem.IC_HAND;
    }
  }

  Color _mapColor(String name) {
    switch (name) {
      case "Like":
        return ColorsItem.urlColor;
      case "Dislike":
        return ColorsItem.redDA1414;
      case "Love":
        return ColorsItem.yellowFFA600;
      case "Heartbreak":
        return ColorsItem.redDA1414;
      case "Orange Medal":
        return ColorsItem.orangeCC6000;
      case "Grey Medal":
        return ColorsItem.grey8C8C8C;
      case "Yellow Medal":
        return ColorsItem.yellowFFA600;
      case "Mountain of Wealth":
        return ColorsItem.yellowFFA600;
      case "Pterodactyl":
        return ColorsItem.urlColor;
      case "Evil Spooky Haunted Tree":
        return ColorsItem.green219653;
      case "Party Time":
        return ColorsItem.green219653;
      case "Y So Serious":
        return ColorsItem.grey8C8C8C;
      case "Cup of Joe":
        return ColorsItem.orangeCC6000;
      case "Burninate":
        return ColorsItem.redDA1414;
      case "Pirate Logo":
        return ColorsItem.redDA1414;
      case "Cool":
        return ColorsItem.yellowFFA600;
      case "Handshake":
        return ColorsItem.urlColor;
      case "LoL":
        return ColorsItem.yellowFFA600;
      case "Noted":
        return ColorsItem.urlColor;
      case "OK":
        return ColorsItem.orangeFB9600;
      case "Cheers!":
        return ColorsItem.urlColor;
      case "Manufacturing Defect?":
      case "Haypence":
      case "Piece of Eight":
      case "Doubloon":
      case "Baby Tequila":
      case "The World Burns":
      case "100":
      case "Dat Boi":
      case "Hungry Hippo":
      case "Get better soon":
      case "Well noted":
      case "Acknowledge of inevitable event":
      case "Thanks!":
      case "Sip!":
      case "Refactory Quality":
      default:
        return ColorsItem.urlColor;
    }
  }
}
