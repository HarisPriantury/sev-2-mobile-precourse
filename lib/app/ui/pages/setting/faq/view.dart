import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/option_tile.dart';
import 'package:mobile_sev2/app/ui/assets/widget/search_item.dart';
import 'package:mobile_sev2/app/ui/pages/setting/faq/controller.dart';

class FaqPage extends View {
  final Object? arguments;

  FaqPage({this.arguments});

  @override
  _FaqState createState() =>
      _FaqState(AppComponent.getInjector().get<FaqController>(), arguments);
}

class _FaqState extends ViewState<FaqPage, FaqController> {
  FaqController _controller;

  _FaqState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<FaqController>(
            builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              if (_controller.isSearch) {
                _controller.onSearch(false);
                return false;
              } else {
                Navigator.pop(context);
                return true;
              }
            },
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    "${_controller.isSearch ? "Pencarian " : ""}FAQ(s)",
                    style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                  ),
                  suffix: _controller.isSearch
                      ? null
                      : InkWell(
                          onTap: () {
                            _controller.onSearch(true);
                          },
                          child: Container(
                              padding: EdgeInsets.only(right: 24.0),
                              child: FaIcon(
                                FontAwesomeIcons.magnifyingGlass,
                                size: Dimens.SPACE_18,
                              ))),
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
              body: _controller.rfaqList.isNotEmpty || _controller.isSearch
                  ? SingleChildScrollView(
                      child: _controller.isSearch
                          ? _searchMode()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: Dimens.SPACE_10),
                                ListView.builder(
                                    primary: false,
                                    shrinkWrap: true,
                                    itemCount: _controller.faqList.length,
                                    itemBuilder: (context, index) {
                                      return OptionTile(
                                        title: _controller
                                            .faqList[index].questionTitle,
                                        endIcon: FaIcon(
                                            FontAwesomeIcons.chevronRight),
                                        onTap: () {
                                          _controller.goToFaqDetail(
                                              _controller.faqList[index]);
                                        },
                                      );
                                    }),
                              ],
                            ))
                  : Container(
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).size.height *
                                      0.15),
                              child: Image.asset(
                                ImageItem.IC_NO_NOTIF,
                                width: MediaQuery.of(context).size.width * 0.8,
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "FAQ(s)",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: Dimens.SPACE_25,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: Dimens.SPACE_2),
                                  Text(
                                    "Belum terdapat FAQ(s)",
                                    style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          );
        }),
      );

  Widget _searchMode() {
    return Padding(
      padding: const EdgeInsets.all(Dimens.SPACE_20),
      child: Column(
        children: [
          SearchBar(
            hintText: "Apa yang kamu cari?",
            border: Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
            borderRadius:
                BorderRadius.all(const Radius.circular(Dimens.SPACE_40)),
            innerPadding: EdgeInsets.all(Dimens.SPACE_10),
            outerPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
            controller: _controller.searchController,
            focusNode: _controller.focusNodeSearch,
            onChanged: (txt) {
              _controller.streamController.add(txt);
            },
            clear: true,
            clearTap: () => _controller.clearSearch(),
            onTap: () => _controller.onSearch(true),
            endIcon: FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              color: ColorsItem.greyB8BBBF,
              size: Dimens.SPACE_18,
            ),
            textStyle: TextStyle(fontSize: Dimens.SPACE_15),
            hintStyle: TextStyle(color: ColorsItem.grey8D9299),
            buttonText: 'Clear',
          ),
          SizedBox(height: Dimens.SPACE_10),
          _controller.isSearch && _controller.searchController.text.isNotEmpty
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _controller.searchController.text.isNotEmpty
                          ? RichText(
                              text: TextSpan(
                                text: 'Menampilkan hasil untuk ',
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    color: ColorsItem.grey8D9299),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          '"${_controller.searchController.text}"',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: Dimens.SPACE_10),
                      _controller.faqList.isNotEmpty
                          ? ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _controller.faqList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    _controller.goToFaqDetail(
                                        _controller.faqList[index]);
                                  },
                                  child: SearchItem(
                                    title: _controller
                                        .faqList[index].questionTitle,
                                    verticalPadding: Dimens.SPACE_20,
                                  ),
                                );
                              })
                          : Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Data Tidak Ditemukan",
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Coba gunakan kata kunci lainnya \n untuk melakukan pencarian",
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_14,
                                          color: ColorsItem.grey8D9299),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class FaqDetailPage extends View {
  final Object? arguments;

  FaqDetailPage({this.arguments});

  @override
  _FaqDetailState createState() => _FaqDetailState(
      AppComponent.getInjector().get<FaqController>(), arguments);
}

class _FaqDetailState extends ViewState<FaqDetailPage, FaqController> {
  FaqController _controller;

  _FaqDetailState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<FaqController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(FontAwesomeIcons.chevronLeft),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  _controller.faqData!.questionTitle,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(Dimens.SPACE_20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: Text(_controller.faqData!.questionDescription,
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.grey858A93,
                            fontSize: Dimens.SPACE_12,
                            fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(height: Dimens.SPACE_20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: Text(_controller.faqData!.answers,
                        style:
                            GoogleFonts.montserrat(fontSize: Dimens.SPACE_14)),
                  ),
                ],
              ),
            ),
          );
        }),
      );
}
