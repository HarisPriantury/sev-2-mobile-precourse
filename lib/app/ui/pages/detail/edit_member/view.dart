import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/pages/detail/edit_member/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class EditMemberPage extends View {
  final Object? arguments;
  EditMemberPage({this.arguments});

  @override
  _EditMemberState createState() => _EditMemberState(
      AppComponent.getInjector().get<EditMemberController>(), arguments);
}

class _EditMemberState extends ViewState<EditMemberPage, EditMemberController> {
  _EditMemberState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }
  EditMemberController _controller;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<EditMemberController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "${S.of(context).label_edit} ${S.of(context).label_participant}",
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                suffix: GestureDetector(
                  onTap: () {
                    controller.onEditMember();
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: Dimens.SPACE_24),
                    child: Text(
                      S.of(context).label_save,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.orangeFB9600),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_14),
                  child: Column(
                    children: [
                      SizedBox(height: Dimens.SPACE_20),
                      InkWell(
                        onTap: () => controller.onSearchEventMember(),
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.circlePlus,
                              size: Dimens.SPACE_16,
                              color: ColorsItem.orangeFB9600,
                            ),
                            SizedBox(width: Dimens.SPACE_14),
                            Text(
                              "${S.of(context).label_add} ${S.of(context).label_participant}",
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14,
                                fontWeight: FontWeight.w500,
                                color: ColorsItem.orangeFB9600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Dimens.SPACE_20),
                      Divider(
                        color: ColorsItem.grey666B73,
                        height: Dimens.SPACE_2,
                      ),
                      SizedBox(height: Dimens.SPACE_20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.userGroup,
                                size: Dimens.SPACE_14,
                                color: ColorsItem.grey858A93,
                              ),
                              SizedBox(width: Dimens.SPACE_14),
                              Text(
                                "${_controller.memberList.length} ${S.of(context).label_participant}",
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsItem.grey858A93,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => controller.goToSearchMember(),
                            child: FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              color: ColorsItem.orangeFB9600,
                              size: Dimens.SPACE_16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.SPACE_30),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _controller.memberList.length,
                    itemBuilder: (context, index) {
                      var par = _controller.memberList[index];
                      return MemberItem(
                        avatar: par.avatar!,
                        name: par.name!,
                        fullName: par.fullName!,
                        status: '',
                        icon: InkWell(
                          child: FaIcon(FontAwesomeIcons.trashCan,
                              color: ColorsItem.redDA1414,
                              size: Dimens.SPACE_14),
                          onTap: () => onDeleteMember(par),
                        ),
                        statusColor: ColorsItem.green219653,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      );

  void onDeleteMember(PhObject member) {
    showCustomAlertDialog(
        context: context,
        title: "${S.of(context).label_remove} ${S.of(context).label_member}",
        subtitle:
            "${S.of(context).label_remove} ${member.name} ${S.of(context).label_from} ${S.of(context).label_agenda}",
        cancelButtonText: S.of(context).label_cancel.toUpperCase(),
        confirmButtonText: S.of(context).label_delete.toUpperCase(),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          _controller.removeMember([member]);
        });
  }
}
