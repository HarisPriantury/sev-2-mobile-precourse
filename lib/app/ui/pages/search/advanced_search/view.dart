import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/pages/search/advanced_search/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class AdvancedSearchPage extends View {
  final Object? arguments;

  AdvancedSearchPage({this.arguments});

  @override
  _AdvancedSearchState createState() => _AdvancedSearchState(
      AppComponent.getInjector().get<AdvancedSearchController>(), arguments);
}

class _AdvancedSearchState
    extends ViewState<AdvancedSearchPage, AdvancedSearchController> {
  AdvancedSearchController _controller;

  _AdvancedSearchState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<AdvancedSearchController>(
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
                    S.of(context).search_advance_label,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_16, fontWeight: FontWeight.bold),
                  ),
                  suffix: InkWell(
                    onTap: () => _controller.goToQueries(),
                    child: Container(
                      padding: EdgeInsets.only(right: 24.0),
                      child: Text(
                        S.of(context).label_queries,
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_16,
                            color: ColorsItem.orangeFB9600,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Dimens.SPACE_20,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).label_keyword,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_10,
                            ),
                            Container(
                              padding: EdgeInsets.all(Dimens.SPACE_12),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: ColorsItem.grey666B73),
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_10))),
                              child: TextField(
                                onTap: () {},
                                controller: _controller.searchController,
                                focusNode: _controller.focusNodeSearch,
                                style: TextStyle(fontSize: 15.0),
                                decoration: InputDecoration.collapsed(
                                  border: InputBorder.none,
                                  hintText: S.of(context).label_search,
                                  fillColor: Colors.transparent,
                                  hintStyle: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                      color: ColorsItem.grey858A93),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.SPACE_10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).room_detail_authored_by_label,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_10,
                            ),
                            InkWell(
                              onTap: () => _controller.onSearchAuthors(),
                              child: Container(
                                padding: EdgeInsets.all(Dimens.SPACE_12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.SPACE_10)),
                                  border:
                                      Border.all(color: ColorsItem.grey666B73),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _controller.authoredBy.isNotEmpty
                                        ? Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: _buildSearchItems(
                                                    _controller.authoredBy),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            S
                                                .of(context)
                                                .search_choose_group_user_label,
                                            style: GoogleFonts.montserrat(
                                                color: ColorsItem.grey858A93,
                                                fontSize: Dimens.SPACE_14),
                                          ),
                                    FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: Dimens.SPACE_20,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.SPACE_10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).search_followed_by_label,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_10,
                            ),
                            InkWell(
                              onTap: () => _controller.onSearchSubscribers(),
                              child: Container(
                                padding: EdgeInsets.all(Dimens.SPACE_12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.SPACE_10)),
                                  border:
                                      Border.all(color: ColorsItem.grey666B73),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _controller.subscribedBy.isNotEmpty
                                        ? Expanded(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: _buildSearchItems(
                                                    _controller.subscribedBy),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            S
                                                .of(context)
                                                .search_choose_group_user_label,
                                            style: GoogleFonts.montserrat(
                                                color: ColorsItem.grey858A93,
                                                fontSize: Dimens.SPACE_14),
                                          ),
                                    FaIcon(
                                      FontAwesomeIcons.magnifyingGlass,
                                      size: Dimens.SPACE_20,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.SPACE_10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).search_document_type_label,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_10,
                            ),
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: Dimens.SPACE_10),
                                      labelStyle: GoogleFonts.montserrat(),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsItem.grey666B73),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Dimens.SPACE_10)))),
                                  isEmpty: _controller.documentType == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      isExpanded: true,
                                      isDense: true,
                                      value: _controller.documentType,
                                      onChanged: (String? newValue) {
                                        _controller.setDocumentType(newValue);
                                      },
                                      hint: Text(
                                        S
                                            .of(context)
                                            .create_form_search_document_select,
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14),
                                      ),
                                      items: _controller.documentTypeList
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.SPACE_10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).search_document_status_label,
                              style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: Dimens.SPACE_10,
                            ),
                            FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: Dimens.SPACE_10),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsItem.grey666B73),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  Dimens.SPACE_10)))),
                                  isEmpty: _controller.documentStatus == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      isExpanded: true,
                                      isDense: true,
                                      value: _controller.documentStatus,
                                      onChanged: (String? newValue) {
                                        _controller.setDocumentStatus(newValue);
                                      },
                                      hint: Text(
                                        S.of(context).tooltip_status_title_2,
                                        style: GoogleFonts.montserrat(
                                            color: ColorsItem.grey858A93,
                                            fontSize: Dimens.SPACE_14),
                                      ),
                                      items: _controller.documentStatusList
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => saveAlert()),
                        child: Container(
                          margin: EdgeInsets.only(top: Dimens.SPACE_30),
                          padding: EdgeInsets.all(Dimens.SPACE_12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.SPACE_10)),
                            border: Border.all(color: ColorsItem.grey666B73),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.floppyDisk,
                                color: ColorsItem.orangeFB9600,
                                size: Dimens.SPACE_20,
                              ),
                              SizedBox(
                                width: Dimens.SPACE_10,
                              ),
                              Text(
                                "${S.of(context).label_submit.toUpperCase()} ${S.of(context).label_queries.toUpperCase()}",
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.orangeFB9600,
                                    fontSize: Dimens.SPACE_14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Dimens.SPACE_15),
                        child: ButtonDefault(
                          buttonText: S.of(context).label_search.toUpperCase(),
                          buttonTextColor: ColorsItem.black1F2329,
                          buttonColor: ColorsItem.orangeFB9600,
                          buttonLineColor: ColorsItem.orangeFB9600,
                          radius: Dimens.SPACE_10,
                          rightIcon: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: ColorsItem.black1F2329,
                            size: Dimens.SPACE_20,
                          ),
                          onTap: () {
                            _controller.onSearch();
                          },
                        ),
                      ),
                      SizedBox(
                        height: Dimens.SPACE_20,
                      ),
                    ],
                  ),
                ),
              ));
        }),
      );

  saveAlert() {
    return AlertDialog(
      elevation: 0.0,
      backgroundColor: ColorsItem.black020202,
      content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 4.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).search_queries_name,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: Dimens.SPACE_10,
              ),
              Container(
                padding: EdgeInsets.all(Dimens.SPACE_12),
                decoration: BoxDecoration(
                    border: Border.all(color: ColorsItem.grey666B73),
                    borderRadius: new BorderRadius.all(
                        const Radius.circular(Dimens.SPACE_10))),
                child: TextField(
                  onTap: () {},
                  controller: _controller.queryController,
                  scrollPadding: EdgeInsets.only(bottom: Dimens.SPACE_4),
                  style: TextStyle(fontSize: 15.0),
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText:
                        "${S.of(context).label_write} ${S.of(context).search_queries_name}",
                    fillColor: Colors.transparent,
                    hintStyle: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        color: ColorsItem.grey858A93),
                  ),
                ),
              ),
              SizedBox(
                height: Dimens.SPACE_40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonDefault(
                      buttonText: S.of(context).label_cancel.toUpperCase(),
                      buttonTextColor: ColorsItem.orangeFB9600,
                      buttonColor: Colors.transparent,
                      buttonLineColor: ColorsItem.grey666B73,
                      radius: Dimens.SPACE_10,
                      width: MediaQuery.of(context).size.width / 3.2,
                      onTap: () {
                        Navigator.pop(context);
                        _controller.queryController.clear();
                      }),
                  ButtonDefault(
                      buttonText: S.of(context).label_submit.toUpperCase(),
                      buttonTextColor: ColorsItem.black1F2329,
                      buttonColor: ColorsItem.orangeFB9600,
                      buttonLineColor: ColorsItem.orangeFB9600,
                      radius: Dimens.SPACE_10,
                      width: MediaQuery.of(context).size.width / 3.2,
                      onTap: () {
                        _controller.onSaveQuery();
                        Navigator.pop(context);
                        _controller.queryController.clear();
                      })
                ],
              )
            ],
          )),
    );
  }

  List<Widget> _buildSearchItems(List<PhObject> list) {
    List<Widget> chips = new List.empty(growable: true);
    chips.add(SizedBox(width: Dimens.SPACE_4));
    for (PhObject obj in list) {
      chips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_4),
        child: Container(
          decoration: BoxDecoration(
              color: ColorsItem.grey666B73,
              borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8, vertical: Dimens.SPACE_2),
          child: Text(obj.name!,
              style: GoogleFonts.montserrat(color: ColorsItem.whiteFEFEFE)),
        ),
      ));
    }
    chips.add(SizedBox(width: Dimens.SPACE_4));
    return chips;
  }
}
