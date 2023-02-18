import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/args.dart';

import 'controller.dart';

class ProjectMemberPage extends View {
  final Object? arguments;

  ProjectMemberPage({this.arguments});

  @override
  _ProjectMemberState createState() => _ProjectMemberState(
      AppComponent.getInjector().get<ProjectMemberController>(), arguments);
}

class _ProjectMemberState
    extends ViewState<ProjectMemberPage, ProjectMemberController> {
  ProjectMemberController _controller;

  _ProjectMemberState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<ProjectMemberController>(
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
                  color: ColorsItem.whiteE0E0E0,
                ),
                onPressed: () => Navigator.pop(context, _controller.isChanged),
              ),
              title: Text(
                "${_controller.type == ProjectMemberActionType.add ? S.of(context).label_add : S.of(context).label_edit} ${S.of(context).rooms_member_label}",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_16,
                  color: ColorsItem.whiteEDEDED,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: ColorsItem.black191C21,
              suffix: GestureDetector(
                onTap: () {
                  if (_controller.type == ProjectMemberActionType.add) {
                    _controller.onSetMembers();
                  } else {
                    Navigator.pop(context, _controller.isChanged);
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(right: 24.0),
                  child: Text(
                    S.of(context).label_submit,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: Dimens.SPACE_14,
                      color: ColorsItem.orangeFB9600,
                    ),
                    // color: ColorsItem.orangeFB9600),
                  ),
                ),
              ),
            ),
          ),
          body: _controller.type == ProjectMemberActionType.add
              ? _addMember()
              : _removeMember(),
        );
      });

  Widget _addMember() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _controller.selectedObjects.length > 0
            ? _memberJoinedContent()
            : SizedBox(),
        Padding(
          padding: const EdgeInsets.all(Dimens.SPACE_20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).create_form_search_user_select,
                style: GoogleFonts.montserrat(
                  color: ColorsItem.greyB8BBBF,
                  fontSize: Dimens.SPACE_12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Dimens.SPACE_12),
              Theme(
                data: new ThemeData(
                  primaryColor: ColorsItem.grey666B73,
                  primaryColorDark: ColorsItem.grey666B73,
                ),
                child: TextField(
                  onChanged: (txt) {
                    _controller.streamController.add(txt);
                  },
                  controller: _controller.searchController,
                  focusNode: _controller.focusNode,
                  cursorColor: ColorsItem.whiteFEFEFE,
                  style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItem.grey666B73)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItem.grey666B73)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItem.grey666B73)),
                      hintStyle:
                          GoogleFonts.montserrat(color: ColorsItem.grey666B73),
                      suffixIcon: Container(
                          color: ColorsItem.grey666B73,
                          child: Icon(Icons.search,
                              color: ColorsItem.whiteFEFEFE))),
                ),
              ),
              SizedBox(height: Dimens.SPACE_20),
              _controller.searchController.text.isNotEmpty
                  ? RichText(
                      text: new TextSpan(
                        text: S.of(context).search_found_placeholder,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_14,
                            color: ColorsItem.grey8D9299),
                        children: <TextSpan>[
                          new TextSpan(
                              text: '"${_controller.searchController.text}"',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorsItem.whiteFEFEFE)),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Expanded(
          child: _controller.searchedObjects.isEmpty && !_controller.isLoading
              ? EmptyList(
                  title: S.of(context).search_data_not_found_title,
                  descripton: S.of(context).search_data_not_found_description)
              : ListView.builder(
                  itemCount: _controller.searchedObjects.length,
                  itemBuilder: (context, index) {
                    var pho = _controller.searchedObjects[index];
                    return MemberItem(
                      avatar: pho.avatar!,
                      name: pho.name!,
                      fullName: pho.getFullName()!,
                      status: '',
                      icon: Theme(
                        child: Checkbox(
                          checkColor: Colors.black,
                          activeColor: ColorsItem.orangeFB9600,
                          onChanged: (bool? value) {
                            _controller.onSelectObject(index, value);
                          },
                          value: _controller.isObjectSelected(index),
                        ),
                        data: ThemeData(
                          unselectedWidgetColor: Colors.grey,
                        ),
                      ),
                      statusColor: ColorsItem.green219653,
                    );
                  }),
        )
      ],
    );
  }

  Widget _removeMember() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _controller.isLoading
            ? Expanded(
                child: Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                    itemCount: _controller.participants.length,
                    itemBuilder: (context, index) {
                      final user = _controller.participants[index];
                      final status = user.currentTask ??
                          user.userStatus ??
                          "Not Available";
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_4),
                        child: MemberItem(
                          avatar: user.avatar!,
                          name: user.name!,
                          fullName: user.getFullName()!,
                          status: status,
                          icon: IconButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.zero,
                            splashRadius: Dimens.SPACE_30,
                            iconSize: Dimens.SPACE_18,
                            onPressed: () {
                              showCustomAlertDialog(
                                title:
                                    "${S.of(context).label_remove} ${S.of(context).room_member_label}",
                                subtitle:
                                    "${S.of(context).label_remove} ${user.name} ${S.of(context).label_from} ${S.of(context).label_project}",
                                cancelButtonText:
                                    S.of(context).label_back.toUpperCase(),
                                confirmButtonText:
                                    S.of(context).label_remove.toUpperCase(),
                                context: context,
                                onConfirm: () {
                                  Navigator.pop(context);
                                  _controller.onRemoveMember(user);
                                },
                                confirmButtonColor: ColorsItem.redDA1414,
                                confirmButtonTextColor: ColorsItem.whiteFEFEFE,
                              );
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.solidTrashCan,
                              size: Dimens.SPACE_18,
                              color: ColorsItem.redDA1414,
                            ),
                          ),
                          statusColor:
                              user.getStatusColor() ?? ColorsItem.grey606060,
                        ),
                      );
                    }),
              )
      ],
    );
  }

  Widget _memberJoinedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              Dimens.SPACE_20, Dimens.SPACE_20, Dimens.SPACE_20, 0.0),
          child: Text(
            S.of(context).label_list_participants,
            style: GoogleFonts.montserrat(
                color: ColorsItem.greyB8BBBF,
                fontSize: Dimens.SPACE_12,
                fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: Dimens.SPACE_12),
        SizedBox(
          height: MediaQuery.of(context).size.height / 14,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(
                  Dimens.SPACE_16, 0.0, Dimens.SPACE_16, 0.0),
              itemCount: _controller.selectedObjects.length,
              itemBuilder: (context, index) {
                var pho = _controller.selectedObjects[index];
                return Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_1),
                  child: CircleAvatar(
                    radius: Dimens.SPACE_25,
                    backgroundColor: ColorsItem.whiteColor,
                    child: CircleAvatar(
                      radius: Dimens.SPACE_20,
                      backgroundImage: CachedNetworkImageProvider(
                        pho.avatar!,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
