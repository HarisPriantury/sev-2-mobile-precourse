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
import 'package:mobile_sev2/app/ui/assets/widget/option_tile.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/controller.dart';

class SettingPage extends View {
  final Object? arguments;

  SettingPage({this.arguments});

  @override
  _SettingState createState() => _SettingState(
      AppComponent.getInjector().get<SettingController>(), arguments);
}

class _SettingState extends ViewState<SettingPage, SettingController> {
  SettingController _controller;

  _SettingState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<SettingController>(
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
                  S.of(context).profile_setting_label,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: Dimens.SPACE_20),
                OptionTile(
                  title: S.of(context).setting_account_title,
                  subtitle: S.of(context).setting_account_subtitle,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToAccountPage();
                  },
                ),
                OptionTile(
                  title: S.of(context).setting_notification_title,
                  subtitle: S.of(context).setting_notification_subtitle,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToNotificationSettingPage();
                  },
                ),
                OptionTile(
                  title: S.of(context).label_appearance,
                  subtitle: S.of(context).subtitle_appearance,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToAppearancePage();
                  },
                ),
                OptionTile(
                  title: S.of(context).label_faq,
                  subtitle: S.of(context).subtitle_faq,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToFaqPage();
                  },
                ),

                // OptionTile(
                //   title: S.of(context).label_sev2_support,
                //   subtitle: S.of(context).setting_contact_us_subtitle,
                //   endIcon: FaIcon(FontAwesomeIcons.chevronRight, ),
                //   onTap: () {
                //     _controller.goToSupportPage();
                //   },
                // ),
                // OptionTile(
                //   title: S.of(context).setting_contact_us_title,
                //   subtitle: S.of(context).setting_contact_us_subtitle,
                //   endIcon: FaIcon(FontAwesomeIcons.chevronRight, ),
                //   onTap: () {
                //     _controller.goToContactPage();
                //   },
                // ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FutureBuilder<String>(
                      future: _controller.getVersionInfo(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                              S.of(context).setting_app_version +
                                  " ${snapshot.data}",
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.w600));
                        }
                        return Container();
                      },
                    ),
                    SizedBox(height: Dimens.SPACE_8),
                    Text(
                      S.of(context).setting_copyright_label(
                          _controller.getCurrentYear()),
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.grey666B73,
                          fontSize: Dimens.SPACE_10,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                )),
                SizedBox(height: Dimens.SPACE_30),
              ],
            ),
          );
        }),
      );
}

class AccountPage extends View {
  final Object? arguments;

  AccountPage({this.arguments});

  @override
  _AccountState createState() => _AccountState(
      AppComponent.getInjector().get<SettingController>(), arguments);
}

class _AccountState extends ViewState<AccountPage, SettingController> {
  SettingController _controller;

  _AccountState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<SettingController>(
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
                  S.of(context).setting_account_title,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            body: Column(
              children: [
                SizedBox(height: Dimens.SPACE_20),
                OptionTile(
                  title: S.of(context).setting_account_datetime,
                  subtitle:
                      _controller.timezoneList[_controller.userData.timezone],
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToDateTimePage();
                  },
                ),
                OptionTile(
                  title: S.of(context).setting_account_language,
                  subtitle:
                      _controller.languageList[_controller.userData.language],
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToLanguagePage();
                  },
                ),
                OptionTile(
                  title: S.of(context).setting_account_phone,
                  subtitle: _controller.getPrimaryPhone().phone,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToPhonePage();
                  },
                ),
                OptionTile(
                  title: S.of(context).setting_account_email,
                  subtitle: _controller.getPrimaryEmail().email,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    _controller.goToEmailPage();
                  },
                ),
                OptionTile(
                  title: S.of(context).delete_account,
                  subtitle: _controller.getPrimaryEmail().email,
                  endIcon: FaIcon(
                    FontAwesomeIcons.chevronRight,
                  ),
                  onTap: () {
                    showCustomAlertDialog(
                      context: context,
                      title: S.of(context).delete_account,
                      subtitle: S.of(context).delete_account_confirmation,
                      cancelButtonText: S.of(context).label_back,
                      confirmButtonText: S.of(context).delete_account,
                      onConfirm: () => _controller.deleteAccount(),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      );
}
