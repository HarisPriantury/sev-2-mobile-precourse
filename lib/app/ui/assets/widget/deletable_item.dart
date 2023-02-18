import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/pages/detail/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class DeletableItem extends StatelessWidget {
  static const DROPDOWN_TYPE = "Dropdown Type";
  static const SEARCH_TYPE = "Search Type";

  final int action;
  final String itemType;
  final String text;
  final List<String> dropdownItems;
  final void Function()? onDelete;
  final DetailController controller;

  const DeletableItem({
    required this.action,
    required this.itemType,
    required this.text,
    required this.controller,
    this.dropdownItems = const [],
    this.onDelete,
  }) : super();

  @override
  Widget build(BuildContext context) {
    switch (itemType) {
      case DeletableItem.DROPDOWN_TYPE:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimens.SPACE_12),
            Text(text, style: GoogleFonts.montserrat(color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
            SizedBox(height: Dimens.SPACE_8),
            Row(
              children: [
                Expanded(
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            labelStyle: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: controller.dropdownCurrentValue(action) == '',
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              canvasColor: ColorsItem.black020202,
                            ),
                            child: DropdownButton<String>(
                              value: controller.dropdownCurrentValue(action),
                              isDense: true,
                              style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                              onChanged: (String? newValue) {
                                controller.setDropdownValue(action, newValue);
                              },
                              items: dropdownItems.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: Dimens.SPACE_16),
                InkWell(onTap: onDelete, child: FaIcon(FontAwesomeIcons.trashCan, color: ColorsItem.redDA1414))
              ],
            ),
          ],
        );
      case DeletableItem.SEARCH_TYPE:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimens.SPACE_12),
            Text(text, style: GoogleFonts.montserrat(color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
            SizedBox(height: Dimens.SPACE_8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorsItem.grey888888, width: 1),
                        borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _buildSearchItems(controller.getSearchResults(action)),
                            ),
                          ),
                        ),
                        Container(
                          color: ColorsItem.grey666B73,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(Dimens.SPACE_14),
                                child: InkWell(
                                  onTap: () => controller.onObjectSearch(action),
                                  child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                                      color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Dimens.SPACE_16),
                InkWell(onTap: onDelete, child: FaIcon(FontAwesomeIcons.trashCan, color: ColorsItem.redDA1414))
              ],
            )
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Dimens.SPACE_12),
            Text(text, style: GoogleFonts.montserrat(color: ColorsItem.greyB8BBBF, fontSize: Dimens.SPACE_12)),
            SizedBox(height: Dimens.SPACE_8),
            Row(
              children: [
                Expanded(
                  child: Theme(
                    data: new ThemeData(
                      primaryColor: ColorsItem.grey666B73,
                      primaryColorDark: ColorsItem.grey666B73,
                    ),
                    child: TextField(
                      controller: controller.getTextController(action),
                      cursorColor: ColorsItem.whiteFEFEFE,
                      style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: ColorsItem.grey666B73)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: ColorsItem.grey666B73)),
                        hintStyle: GoogleFonts.montserrat(color: ColorsItem.grey666B73),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimens.SPACE_16),
                InkWell(onTap: onDelete, child: FaIcon(FontAwesomeIcons.trashCan, color: ColorsItem.redDA1414))
              ],
            ),
          ],
        );
    }
  }

  List<Widget> _buildSearchItems(List<PhObject> list) {
    List<Widget> chips = new List.empty(growable: true);
    chips.add(SizedBox(width: Dimens.SPACE_4));
    for (PhObject obj in list) {
      chips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_4),
        child: Container(
          decoration: BoxDecoration(color: ColorsItem.grey666B73, borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_8, vertical: Dimens.SPACE_2),
          child: Text(obj.name!, style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE)),
        ),
      ));
    }
    chips.add(SizedBox(width: Dimens.SPACE_4));
    return chips;
  }
}
