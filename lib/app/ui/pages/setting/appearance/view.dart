import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/setting/appearance/controller.dart';

class AppearancePage extends View {
  @override
  _AppereanceState createState() => _AppereanceState(
        AppComponent.getInjector().get<AppearanceController>(),
      );
}

class _AppereanceState extends ViewState<AppearancePage, AppearanceController> {
  AppearanceController _controller;

  _AppereanceState(this._controller) : super(_controller);

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<AppearanceController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  title: Text(
                    S.of(context).label_appearance,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_18, fontWeight: FontWeight.w700),
                  ),
                  titleMargin: 0,
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(top: Dimens.SPACE_20),
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.optAppearanceMethod.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        ColorsItem.greyd8d8d8),
                                child: RadioListTile<String>(
                                  value: controller.optAppearanceMethod[index]
                                      .appearanceMethodName,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  groupValue: controller.selectedAppearance,
                                  title: Text(
                                      controller.optAppearanceMethod[index]
                                          .appearanceMethodName,
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_14)),
                                  activeColor: ColorsItem.orangeFB9600,
                                  onChanged: (val) {
                                    controller.setSelectedAppearance(val!);
                                  },
                                  selected: controller.selectedAppearance ==
                                      _controller.optAppearanceMethod[index]
                                          .appearanceMethodName,
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        }),
      );
}
