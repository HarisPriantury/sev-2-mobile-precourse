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
import 'package:mobile_sev2/app/ui/pages/detail/add_action/controller.dart';

class AddActionPage extends View {
  AddActionPage({required this.arguments});

  final Object? arguments;

  @override
  State<StatefulWidget> createState() {
    return _AddActionState(
      AppComponent.getInjector().get<AddActionController>(),
      arguments,
    );
  }
}

class _AddActionState extends ViewState<AddActionPage, AddActionController> {
  _AddActionState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  final AddActionController _controller;

  @override
  Widget get view {
    return AnimatedTheme(
      data: Theme.of(context),
      child: ControlledWidgetBuilder<AddActionController>(
        builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            body: _controller.isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder: (
                      BuildContext context,
                      bool innerBoxIsScrolled,
                    ) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          floating: true,
                          snap: true,
                          toolbarHeight:
                              MediaQuery.of(context).size.height / 10,
                          flexibleSpace: SimpleAppBar(
                            toolbarHeight:
                                MediaQuery.of(context).size.height / 10,
                            prefix: IconButton(
                              icon: FaIcon(FontAwesomeIcons.chevronLeft),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            title: Text(
                              S.of(context).room_detail_add_action,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_16),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(top: Dimens.SPACE_16),
                      child: ListView.builder(
                        itemCount: _controller.actionItems.length,
                        itemBuilder: (context, index) {
                          final actionItem = _controller.actionItems[index];

                          return _buildActionItem(
                            title: actionItem.title,
                            oActionPressed: actionItem.onPressed,
                          );
                        },
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildActionItem({
    required String title,
    required Function() oActionPressed,
  }) {
    return GestureDetector(
      onTap: oActionPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(Dimens.SPACE_16),
        margin: EdgeInsets.only(
          left: Dimens.SPACE_20,
          right: Dimens.SPACE_20,
          bottom: Dimens.SPACE_8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          border: Border.all(color: ColorsItem.black32373D),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  color: ColorsItem.grey666B73,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ButtonDefault(
              buttonIcon: Icon(
                Icons.add,
                color: ColorsItem.orangeFB9600,
              ),
              buttonText: "ACTION",
              letterSpacing: 1.5,
              buttonTextColor: ColorsItem.orangeFB9600,
              buttonColor: Colors.transparent,
              buttonLineColor: Colors.transparent,
              paddingHorizontal: 0,
              paddingVertical: 0,
              fontSize: Dimens.SPACE_12,
              onTap: null,
            )
          ],
        ),
      ),
    );
  }
}
