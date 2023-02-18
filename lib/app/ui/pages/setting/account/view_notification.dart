import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/option_tile.dart';
import 'package:mobile_sev2/app/ui/pages/setting/account/controller.dart';

class NotificationSettingPage extends View {
  final Object? arguments;

  NotificationSettingPage({this.arguments});

  @override
  _NotificationSettingState createState() => _NotificationSettingState(
      AppComponent.getInjector().get<SettingController>(), arguments);
}

class _NotificationSettingState
    extends ViewState<NotificationSettingPage, SettingController> {
  SettingController _controller;

  _NotificationSettingState(this._controller, Object? args)
      : super(_controller) {
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
                  S.of(context).setting_notification_title,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16.w),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimens.SPACE_35.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20.w),
                  child: Text(
                    S.of(context).setting_notification_subtitle.toUpperCase(),
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.grey858A93,
                      fontSize: Dimens.SPACE_12.w,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (!controller.userData.batteryPermissionGranted) ...[
                  SizedBox(height: Dimens.SPACE_35.w),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimens.SPACE_20.w),
                    child: InkWell(
                      onTap: () {
                        controller.checkBatteryPermission();
                      },
                      child: Text(
                        S.of(context).setting_allow_background_permission,
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.orangeFA8C16,
                            fontWeight: FontWeight.w700,
                            fontSize: Dimens.SPACE_14.w.sp),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.SPACE_35.w),
                  Divider(
                    height: 0,
                    color: ColorsItem.grey666B73,
                    indent: Dimens.SPACE_20.w,
                  ),
                ],
                OptionTile(
                  title:
                      "${S.of(context).main_chat_tab_title}, ${S.of(context).notification_mention_label}, Reaction",
                  endIcon: Switch(
                    value: _controller.getNotifSetting('chat'),
                    onChanged: (value) {
                      _controller.onSetNotification('chat', value);
                    },
                    activeColor: ColorsItem.orangeFB9600,
                  ),
                ),
                OptionTile(
                  title: S.of(context).notification_stream_label,
                  endIcon: Switch(
                    value: _controller.getNotifSetting('stream'),
                    onChanged: (value) {
                      _controller.onSetNotification('stream', value);
                    },
                    activeColor: ColorsItem.orangeFB9600,
                  ),
                ),
                OptionTile(
                  title: S.of(context).notification_embrace_label,
                  endIcon: Switch(
                    value: _controller.getNotifSetting('embrace'),
                    onChanged: (value) {
                      _controller.onSetNotification('embrace', value);
                    },
                    activeColor: ColorsItem.orangeFB9600,
                  ),
                ),
                SizedBox(height: Dimens.SPACE_20.w),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20.w),
                  child: Text(S.of(context).label_other.toUpperCase(),
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.grey858A93,
                          fontSize: Dimens.SPACE_12.w,
                          fontWeight: FontWeight.w700)),
                ),
                OptionTile(
                  title: "E-mail & SMS",
                  endIcon: Switch(
                    value: _controller.getNotifSetting('email'),
                    onChanged: (value) {
                      _controller.onSetNotification('email', value);
                    },
                    activeColor: ColorsItem.orangeFB9600,
                  ),
                ),
              ],
            ),
          );
        }),
      );
}
