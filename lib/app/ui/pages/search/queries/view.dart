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
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/pages/search/queries/controller.dart';
import 'package:mobile_sev2/domain/query.dart';

class QueriesPage extends View {
  final Object? arguments;

  QueriesPage({this.arguments});

  @override
  _QueriesState createState() => _QueriesState(
      AppComponent.getInjector().get<QueriesController>(), arguments);
}

class _QueriesState extends ViewState<QueriesPage, QueriesController> {
  QueriesController _controller;

  _QueriesState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<QueriesController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              elevation: 0,
              flexibleSpace: SimpleAppBar(
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                titleMargin: Dimens.SPACE_10,
                title: Text(
                  S.of(context).query_title,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _controller.queries.isNotEmpty
                      ? Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: Dimens.SPACE_20, left: Dimens.SPACE_20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S
                                      .of(context)
                                      .query_personal_label
                                      .toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: Dimens.SPACE_5,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _controller.queries.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(
                                                _controller.queries[index]);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(width: 1.0),
                                              ),
                                            ),
                                            padding: EdgeInsets.only(
                                              top: Dimens.SPACE_16,
                                              bottom: Dimens.SPACE_16,
                                              right: Dimens.SPACE_20,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  _controller
                                                      .queries[index].queryName,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: Dimens.SPACE_14,
                                                      color: ColorsItem
                                                          .green00A1B0),
                                                ),
                                                InkWell(
                                                  onTap: () =>
                                                      showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        deleteAlert(_controller
                                                            .queries[index]),
                                                  ),
                                                  child: FaIcon(
                                                    FontAwesomeIcons.xmark,
                                                    size: Dimens.SPACE_20,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: EmptyList(
                            title: S.of(context).room_detail_detail_empty_title,
                            descripton:
                                S.of(context).room_detail_detail_empty_subtitle,
                          ),
                        ),
                ],
              ),
            ),
          );
        }),
      );

  deleteAlert(Query query) {
    return AlertDialog(
      elevation: 0.0,
      backgroundColor: ColorsItem.black020202,
      content: Container(
          height: MediaQuery.of(context).size.height / 4.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).query_delete_title,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Dimens.SPACE_10,
              ),
              Text(
                S.of(context).query_delete_subtitle,
                style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: Dimens.SPACE_20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonDefault(
                      buttonText: S.of(context).label_back.toUpperCase(),
                      buttonColor: Colors.transparent,
                      buttonLineColor: ColorsItem.grey666B73,
                      radius: Dimens.SPACE_10,
                      width: MediaQuery.of(context).size.width / 3.2,
                      onTap: () => Navigator.pop(context)),
                  ButtonDefault(
                      buttonText: S.of(context).label_delete.toUpperCase(),
                      buttonColor: ColorsItem.redDA1414,
                      buttonLineColor: ColorsItem.redDA1414,
                      radius: Dimens.SPACE_10,
                      width: MediaQuery.of(context).size.width / 3.2,
                      onTap: () {
                        _controller.onDeleteQuery(query);
                        Navigator.pop(context);
                      })
                ],
              )
            ],
          )),
    );
  }
}
