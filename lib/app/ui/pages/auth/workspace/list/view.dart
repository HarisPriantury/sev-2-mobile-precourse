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
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/workspace_item.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/list/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class WorkspaceListPage extends View {
  final Object? arguments;

  WorkspaceListPage({this.arguments});

  @override
  _WorkspaceListState createState() => _WorkspaceListState(
      AppComponent.getInjector().get<WorkspaceListController>(), arguments);
}

class _WorkspaceListState
    extends ViewState<WorkspaceListPage, WorkspaceListController> {
  WorkspaceListController _controller;

  _WorkspaceListState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<WorkspaceListController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  prefix: SizedBox(),
                  titleMargin: 0,
                  title: Text(
                    S.of(context).label_space,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  suffix: _popMenu(),
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimens.SPACE_22,
                    vertical: Dimens.SPACE_10,
                  ),
                ),
              ),
              body: _controller.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_20),
                      child: Stack(children: [
                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(Dimens.SPACE_8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Dimens.SPACE_12),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _controller.goToPublicSpaceList();
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 68,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorsItem.white9E9E9E,
                                                width: 0.5,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.SPACE_8)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: Dimens.SPACE_25,
                                                horizontal: Dimens.SPACE_16,
                                              ),
                                              child: Text(
                                                " 🌏 ${S.of(context).label_world}",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: Dimens.SPACE_14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: Dimens.SPACE_18,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              S.of(context).label_work_space,
                                              style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(width: Dimens.SPACE_8),
                                            Expanded(
                                                child: Divider(
                                              height: Dimens.SPACE_2,
                                              thickness: Dimens.SPACE_2,
                                              color: ColorsItem.grey32373D,
                                            ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: _controller.workspaces.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: Dimens.SPACE_12),
                                      child: WorkspaceItem(
                                        workspaceName: _controller
                                            .workspaces[index].workspaceId
                                            .capitalize(),
                                        planPackage: "Diamond Plan",
                                        selected: _controller.isSelected(
                                            _controller.workspaces[index]),
                                        onTap: () {
                                          _controller.joinWorkspace(
                                              _controller.workspaces[index]);
                                        },
                                        onLogOut: () {
                                          showCustomAlertDialog(
                                              context: context,
                                              title: S
                                                  .of(context)
                                                  .login_exit_workspace_title,
                                              subtitle: S
                                                  .of(context)
                                                  .login_exit_workspace_subtitle,
                                              onConfirm: () {
                                                _controller.deleteWorkspace(
                                                    _controller
                                                        .workspaces[index],
                                                    index);
                                                Navigator.pop(context);
                                              },
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                              cancelButtonText: S
                                                  .of(context)
                                                  .label_no
                                                  .toUpperCase(),
                                              confirmButtonText: S
                                                  .of(context)
                                                  .label_yes
                                                  .toUpperCase());
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: Container(
                        //     margin: EdgeInsets.only(bottom: Dimens.SPACE_55),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         ButtonDefault(
                        //             buttonText: S
                        //                 .of(context)
                        //                 .label_workspace
                        //                 .toUpperCase(),
                        //             buttonTextColor: ColorsItem.orangeFB9600,
                        //             buttonColor: Colors.transparent,
                        //             buttonLineColor: ColorsItem.orangeFB9600,
                        //             buttonIcon: Icon(
                        //               Icons.add,
                        //               color: ColorsItem.orangeFB9600,
                        //               size: Dimens.SPACE_18,
                        //             ),
                        //             radius: Dimens.SPACE_40,
                        //             paddingHorizontal: Dimens.SPACE_12,
                        //             paddingVertical: Dimens.SPACE_12,
                        //             letterSpacing: 1.5,
                        //             onTap: () {
                        //               _controller.goToWorkspaceLogin();
                        //             }),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ]),
                    ),
            ),
          );
        }),
      );

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          showCustomAlertDialog(
            context: context,
            title: "Log Out",
            subtitle: "Kamu yakin ingin log out dari aplikasi SEV-2?",
            cancelButtonText: S.of(context).label_back,
            confirmButtonText: "Log Out",
            onConfirm: () => _controller.logout(),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_12),
        child: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          size: Dimens.SPACE_18,
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
            padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            value: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  size: Dimens.SPACE_18,
                ),
                SizedBox(width: Dimens.SPACE_8),
                Text(
                  S.of(context).label_logout,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                  ),
                )
              ],
            )),
      ],
    );
  }
}
