import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/pages/auth/workspace/login/controller.dart';

class WorkspaceLoginPage extends View {
  final Object? arguments;

  WorkspaceLoginPage({this.arguments});

  @override
  _WorkspaceLoginPageState createState() => _WorkspaceLoginPageState(
      AppComponent.getInjector().get<WorkspaceLoginController>(), arguments);
}

class _WorkspaceLoginPageState
    extends ViewState<WorkspaceLoginPage, WorkspaceLoginController> {
  WorkspaceLoginController _controller;

  _WorkspaceLoginPageState(this._controller, Object? args)
      : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<WorkspaceLoginController>(
          builder: (context, controller) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            key: globalKey,
            home: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageItem.BG_MILKY_WAY),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                // resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: _controller.hasOrigin()
                    ? AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: SimpleAppBar(
                          toolbarHeight:
                              MediaQuery.of(context).size.height / 10,
                          prefix: IconButton(
                            icon: FaIcon(FontAwesomeIcons.chevronLeft,
                                color: ColorsItem.whiteE0E0E0),
                            onPressed: () => Navigator.pop(context),
                          ),
                          title: Text(
                            S.of(context).label_back,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_16,
                                color: ColorsItem.whiteEDEDED),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          color: Colors.transparent,
                        ),
                      )
                    : null,
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4 * 2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              ImageItem.SUITE_LOGO,
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                            SizedBox(height: Dimens.SPACE_15),
                            Text(
                              S.of(context).app_name,
                              style: GoogleFonts.orbitron(
                                fontSize: Dimens.SPACE_25,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.15,
                                color: ColorsItem.whiteColor,
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_8),
                            Text(
                              S.of(context).mobile_label,
                              style: GoogleFonts.orbitron(
                                fontSize: Dimens.SPACE_13,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.8,
                                color: ColorsItem.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_40),
                          child: Column(
                            children: [
                              Theme(
                                data: new ThemeData(
                                  primaryColor: ColorsItem.grey666B73,
                                  primaryColorDark: ColorsItem.grey666B73,
                                  splashColor: ColorsItem.black020202,
                                ),
                                child: TextField(
                                  onChanged: (val) {
                                    _controller.refresh();
                                  },
                                  cursorColor: ColorsItem.whiteFEFEFE,
                                  scrollPadding:
                                      EdgeInsets.only(bottom: Dimens.SPACE_4),
                                  controller:
                                      _controller.workspaceTextController,
                                  style: GoogleFonts.montserrat(
                                      color: ColorsItem.whiteFEFEFE,
                                      fontSize: Dimens.SPACE_14),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimens.SPACE_16),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsItem.grey666B73)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsItem.grey666B73)),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsItem.grey666B73)),
                                    hintStyle: GoogleFonts.montserrat(
                                        color: ColorsItem.grey666B73),
                                    hintText:
                                        S.of(context).login_workspace_label,
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimens.SPACE_8),
                              Row(
                                children: [
                                  _controller.workspaceFound
                                      ? _controller.alreadyLoggedIn
                                          ? Flexible(
                                              child: Text(
                                                S
                                                    .of(context)
                                                    .login_workspace_signed_label,
                                                style: GoogleFonts.montserrat(
                                                  color: ColorsItem.redDA1414,
                                                  fontSize: Dimens.SPACE_12,
                                                ),
                                              ),
                                            )
                                          : SizedBox()
                                      : SizedBox()
                                  // Flexible(
                                  //     child: Text(
                                  //       S.of(context).login_workspace_not_found_label,
                                  //       style: GoogleFonts.montserrat(
                                  //         color: ColorsItem.redDA1414,
                                  //         fontSize: Dimens.SPACE_12,
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                              SizedBox(height: Dimens.SPACE_16),
                              ButtonDefault(
                                buttonText: S
                                    .of(context)
                                    .on_board_login_btn_label
                                    .toUpperCase(),
                                buttonTextColor: ColorsItem.black191C21,
                                buttonColor: ColorsItem.orangeFB9600,
                                buttonLineColor: ColorsItem.orangeFB9600,
                                disabledTextColor: ColorsItem.black191C21,
                                disabledButtonColor: ColorsItem.grey8C8C8C,
                                disabledLineColor: Colors.transparent,
                                letterSpacing: 1.5,
                                paddingHorizontal: Dimens.SPACE_80,
                                paddingVertical: Dimens.SPACE_14,
                                radius: Dimens.SPACE_8,
                                isDisabled: _controller
                                        .workspaceTextController.text.isEmpty ||
                                    _controller.isLoading,
                                onTap: () {
                                  _controller.proceed();
                                },
                              ),
                              SizedBox(height: Dimens.SPACE_35),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    S
                        .of(context)
                        .login_copyright_label(_controller.getCurrentYear()),
                    style: GoogleFonts.montserrat(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: Dimens.SPACE_12,
                        height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ));
      });
}
