import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/channel_setting/controller.dart';

class ChannelSetting extends View {
  final Object? arguments;

  ChannelSetting({this.arguments});

  @override
  _ChannelSettingState createState() => _ChannelSettingState(
      AppComponent.getInjector().get<ChannelSettingController>(), arguments);
}

class _ChannelSettingState
    extends ViewState<ChannelSetting, ChannelSettingController> {
  ChannelSettingController _controller;

  _ChannelSettingState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ChannelSettingController>(
            builder: ((context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _controller.room?.name ?? "",
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimens.SPACE_20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: Dimens.SPACE_4,
                    ),
                    Text(
                      S.of(context).profile_setting_label,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                      ),
                    ),
                  ],
                ),
                suffix: Container(
                  width: Dimens.SPACE_50,
                ),
              ),
            ),
            body: Container(
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).notification_title,
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
                            value: controller.isSwitchOn,
                            onChanged: (switchChanged) {
                              _controller.switchOnChangeHandler(switchChanged);
                            },
                            activeColor: ColorsItem.orangeFB9600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        })),
      );
}
