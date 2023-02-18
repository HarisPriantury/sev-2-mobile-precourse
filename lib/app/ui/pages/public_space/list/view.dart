import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/message_list_item.dart';
import 'package:mobile_sev2/app/ui/pages/public_space/list/controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';

class PublicSpace extends View {
  final Object? arguments;

  PublicSpace({this.arguments});

  @override
  _PublicSpaceState createState() => _PublicSpaceState(
      AppComponent.getInjector().get<PublicSpaceController>(), arguments);
}

class _PublicSpaceState extends ViewState<PublicSpace, PublicSpaceController> {
  PublicSpaceController _controller;

  _PublicSpaceState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<PublicSpaceController>(
            builder: (context, controller) {
          return ShowCaseWidget(
            onComplete: (index, key) {
              if (key == _controller.eight) {
                _controller.userData.workspaceTooltipFinished = true;
                _controller.userData.save();
              }
            },
            autoPlay: false,
            autoPlayLockEnable: false,
            builder: Builder(builder: (context) {
              return Scaffold(
                key: globalKey,
                appBar: AppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: SimpleAppBar(
                    toolbarHeight: MediaQuery.of(context).size.height / 10,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                    prefix: SizedBox(),
                    titleMargin: 0,
                    title: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Showcase(
                                  key: _controller.eight,
                                  showArrow: true,
                                  disableAnimation: true,
                                  animationDuration: Duration(seconds: 0),
                                  contentPadding:
                                      EdgeInsets.all(Dimens.SPACE_12),
                                  titleTextStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  descTextStyle: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_12,
                                    color: ColorsItem.greyB8BBBF,
                                  ),
                                  title:
                                      S.of(context).tooltip_workspace_title_2,
                                  description: S
                                      .of(context)
                                      .tooltip_workspace_description_2,
                                  child: InkWell(
                                    onTap: () {
                                      _controller.goToWorkspaceList();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          S.of(context).label_world,
                                          style: GoogleFonts.montserrat(
                                            color: ColorsItem.orangeFB9600,
                                            fontSize: Dimens.SPACE_18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: Dimens.SPACE_3,
                                            right: Dimens.SPACE_1,
                                          ),
                                          child: FaIcon(
                                            FontAwesomeIcons.caretDown,
                                            color: ColorsItem.orangeFB9600,
                                            size: Dimens.SPACE_16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      S.of(context).room_subtitle,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          // _controller.isFilter
                          //     ?
                          DropdownButton(
                            icon: FaIcon(
                              FontAwesomeIcons.filter,
                              color: ColorsItem.orangeFFB200,
                              size: Dimens.SPACE_14,
                            ),
                            isDense: true,
                            underline:
                                DropdownButtonHideUnderline(child: Container()),
                            dropdownColor: ColorsItem.black020202,
                            iconEnabledColor: ColorsItem.urlColor,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14,
                                fontWeight: FontWeight.bold,
                                color: ColorsItem.green00A1B0),
                            items: _controller.filterType
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: new Text(value),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              _controller.filter(newValue!);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                body: _controller.isLoading
                    ? Container(
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                child: Container(
                                  margin: EdgeInsets.all(Dimens.SPACE_20),
                                  width: double.infinity,
                                  height: Dimens.SPACE_35,
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        const Radius.circular(Dimens.SPACE_40)),
                                  ),
                                ),
                                baseColor: ColorsItem.grey979797,
                                highlightColor: ColorsItem.grey606060,
                              ),
                              SizedBox(height: Dimens.SPACE_15),
                              Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                baseColor: ColorsItem.grey979797,
                                highlightColor: ColorsItem.grey606060,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: 10,
                                    itemBuilder: (_, __) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: Dimens.SPACE_20,
                                            vertical: Dimens.SPACE_10),
                                        child: Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: ColorsItem.black32373D,
                                                  shape: BoxShape.circle),
                                              width: Dimens.SPACE_40,
                                              height: Dimens.SPACE_40,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Shimmer.fromColors(
                                                  period: Duration(seconds: 1),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    decoration: BoxDecoration(
                                                      color: ColorsItem
                                                          .black32373D,
                                                      borderRadius:
                                                          new BorderRadius
                                                              .all(const Radius
                                                                  .circular(
                                                              Dimens.SPACE_12)),
                                                    ),
                                                    width: 200,
                                                    height: Dimens.SPACE_16,
                                                  ),
                                                  baseColor:
                                                      ColorsItem.black32373D,
                                                  highlightColor:
                                                      ColorsItem.grey606060,
                                                ),
                                                SizedBox(
                                                    height: Dimens.SPACE_6),
                                                Shimmer.fromColors(
                                                  period: Duration(seconds: 1),
                                                  child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: Dimens
                                                                .SPACE_20),
                                                    decoration: BoxDecoration(
                                                      color: ColorsItem
                                                          .black32373D,
                                                      borderRadius:
                                                          new BorderRadius
                                                              .all(const Radius
                                                                  .circular(
                                                              Dimens.SPACE_12)),
                                                    ),
                                                    width: Dimens.SPACE_100,
                                                    height: Dimens.SPACE_12,
                                                  ),
                                                  baseColor:
                                                      ColorsItem.black32373D,
                                                  highlightColor:
                                                      ColorsItem.grey606060,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: listChatPublic(context),
                      ),
                bottomNavigationBar:
                    _controller.isLogin() ? null : loginButton(),
              );
            }),
          );
        }),
      );

  Column listChatPublic(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(Dimens.SPACE_20),
          child: SearchBar(
            hintText: S.of(context).label_search + " Workspace",
            border: Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
            borderRadius:
                new BorderRadius.all(const Radius.circular(Dimens.SPACE_40)),
            innerPadding: EdgeInsets.all(Dimens.SPACE_10),
            outerPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
            controller: _controller.searchController,
            focusNode: _controller.focusNodeSearch,
            onChanged: (txt) {
              _controller.streamController.add(txt);
            },
            // clearTap: () => _controller.clearSearch(),
            // onTap: () => _controller.onSearch(true),
            endIcon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: ColorsItem.greyB8BBBF,
              size: Dimens.SPACE_18,
            ),
            textStyle: TextStyle(fontSize: 15.0),
            hintStyle: TextStyle(color: ColorsItem.grey8D9299),
            buttonText: S.of(context).label_clear,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _controller.workspaces.length,
            itemBuilder: (context, index) {
              var workspace = _controller.workspaces[index];
              return MessageListItem(
                username: workspace.name ?? "",
                message: workspace.publicSpace != null &&
                        workspace.publicSpace!.lastMessage != null
                    ? workspace.publicSpace!.lastMessage!
                    : "",
                avatar: workspace.imagePath != null ? workspace.imagePath! : "",
                time: workspace.publicSpace != null &&
                        workspace.publicSpace!.lastMessageCreatedAt != null
                    ? _controller.formatChatTime(
                        workspace.publicSpace!.lastMessageCreatedAt)
                    : "",
                unreadMessageCount: workspace.publicSpace != null
                    ? workspace.publicSpace!.unreadChats
                    : 0,
                isUser: false,
                onTap: () {
                  _controller.joinRoom(workspace);
                },
              );
            },
          ),
        )
      ],
    );
  }

  Container loginButton() {
    return Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.SPACE_12,
            horizontal: Dimens.SPACE_40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.SPACE_40,
                ),
                child: Text(
                  S.of(context).label_enter_to_join_room,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimens.SPACE_12),
              ButtonDefault(
                buttonText: S.of(context).login_now_label.toUpperCase(),
                buttonColor: ColorsItem.orangeFB9600,
                buttonLineColor: ColorsItem.orangeFB9600,
                disabledTextColor: ColorsItem.black191C21,
                disabledButtonColor: ColorsItem.grey8C8C8C,
                disabledLineColor: Colors.transparent,
                letterSpacing: 1.5,
                paddingVertical: Dimens.SPACE_14,
                radius: Dimens.SPACE_8,
                onTap: () {
                  _controller.loginNow();
                },
              ),
            ],
          ),
        ));
  }
}
