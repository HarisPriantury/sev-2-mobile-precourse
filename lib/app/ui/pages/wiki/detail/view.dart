import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/detail_head.dart';
import 'package:mobile_sev2/app/ui/pages/wiki/detail/controller.dart';

class DetailWikiPage extends View {
  DetailWikiPage({this.arguments});

  final Object? arguments;

  @override
  _DetailWikiState createState() => _DetailWikiState(
      AppComponent.getInjector().get<DetailWikiController>(), arguments);
}

class _DetailWikiState extends ViewState<DetailWikiPage, DetailWikiController> {
  _DetailWikiState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  DetailWikiController _controller;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<DetailWikiController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            body: _controller.isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    child: NestedScrollView(
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
                            toolbarHeight: Dimens.SPACE_80,
                            flexibleSpace: SimpleAppBar(
                              toolbarHeight: Dimens.SPACE_80,
                              prefix: IconButton(
                                icon: FaIcon(FontAwesomeIcons.chevronLeft),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              title: Text(
                                "Detail ${S.of(context).label_wiki}",
                                style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_16),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimens.SPACE_10),
                            ),
                          ),
                        ];
                      },
                      body: ListView(
                        shrinkWrap: true,
                        children: [
                          _detailHead(controller),
                          Divider(height: Dimens.SPACE_2),
                          Container(
                            padding: EdgeInsets.all(Dimens.SPACE_20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.circleInfo,
                                      size: Dimens.SPACE_16,
                                      color: ColorsItem.grey858A93,
                                    ),
                                    SizedBox(width: Dimens.SPACE_14),
                                    Text(
                                      "Information".toUpperCase(),
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14,
                                        fontWeight: FontWeight.w700,
                                        color: ColorsItem.grey858A93,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimens.SPACE_20),
                                Container(
                                  width: double.infinity,

                                  // margin: EdgeInsets.only(bottom: 27),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: ColorsItem.black32373D,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        Dimens.SPACE_8,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: Dimens.SPACE_16,
                                            right: Dimens.SPACE_16,
                                            top: Dimens.SPACE_16),
                                        child: Text(
                                          S
                                              .of(context)
                                              .room_detail_description_label,
                                          style: GoogleFonts.montserrat(
                                            color: ColorsItem.white9E9E9E,
                                            fontWeight: FontWeight.w700,
                                            fontSize: Dimens.SPACE_14,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                      Markdown(
                                          controller:
                                              _controller.listScrollController,
                                          shrinkWrap: true,
                                          data:
                                              "${_controller.wiki?.description ?? ''}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        }),
      );

  Widget _detailHead(DetailWikiController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailHead(
          title: "${controller.wiki?.title}",
          icon: FaIcon(
            FontAwesomeIcons.wikipediaW,
            size: Dimens.SPACE_16,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.SPACE_8,
          ),
          child: Chip(
            avatar: FaIcon(
              FontAwesomeIcons.user,
              size: Dimens.SPACE_12,
            ),
            label: Text(
              "Author : ${controller.wikiAuthor?.name}",
              style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
