import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/args.dart';
import 'package:mobile_sev2/app/ui/pages/reporting/controller.dart';

class PopupReport extends View {
  final ReportArgs? arguments;

  PopupReport({this.arguments});

  @override
  _MainState createState() =>
      _MainState(AppComponent.getInjector().get<ReportController>(), arguments);
}

class _MainState extends ViewState<PopupReport, ReportController> {
  ReportController _controller;

  _MainState(this._controller, ReportArgs? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<ReportController>(
          builder: (context, controller) {
            double widthDialog = MediaQuery.of(context).size.width * 0.90;
            return SimpleDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              contentPadding: EdgeInsets.all(0),
              elevation: 0,
              children: <Widget>[
                Container(
                  width: widthDialog,
                  padding: EdgeInsets.fromLTRB(
                    Dimens.SPACE_13,
                    Dimens.SPACE_30,
                    Dimens.SPACE_13,
                    Dimens.SPACE_25,
                  ),
                  child: controller.dialogReportMode ==
                          DialogReportMode.SelectReport
                      ? _body()
                      : _done(),
                )
              ],
            );
          },
        ),
      );

  Column _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          S.of(context).label_report,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: Dimens.SPACE_20,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Dimens.SPACE_10),
        Divider(
          height: Dimens.SPACE_2,
          color: ColorsItem.grey666B73,
          thickness: Dimens.SPACE_2,
        ),
        SizedBox(height: Dimens.SPACE_10),
        Text(
          S.of(context).label_select_report,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: Dimens.SPACE_17,
          ),
          textAlign: TextAlign.center,
        ),
        if (_controller.data?.reportedType == "USER")
          Text(
            S.of(context).user_reporting_terms,
            style: GoogleFonts.montserrat(
              color: ColorsItem.grey666B73,
              fontSize: Dimens.SPACE_12,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        SizedBox(height: Dimens.SPACE_22),
        Container(
          child: ListView.separated(
            itemCount: _controller.reportOption.length,
            primary: false,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return Divider(
                color: ColorsItem.grey666B73,
                thickness: Dimens.SPACE_1,
              );
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _controller.changeMode(DialogReportMode.Done);
                  _controller.onReportedChat(_controller.reportOption[index]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_5),
                  child: Text(
                    _controller.reportOption[index],
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: Dimens.SPACE_14,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column _done() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Your report have been submitted",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: Dimens.SPACE_18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(ColorsItem.black020202),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: ColorsItem.grey858A93),
              ))),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            S.of(context).label_back,
            style: GoogleFonts.montserrat(
              color: ColorsItem.grey858A93,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
