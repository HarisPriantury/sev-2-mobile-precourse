import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/bottomsheet/reaction_bottomsheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/comment_item.dart';
import 'package:mobile_sev2/app/ui/pages/notification/comment/controller.dart';

class CommentPage extends View {
  final Object? arguments;

  CommentPage({this.arguments});

  @override
  _MainState createState() => _MainState(
      AppComponent.getInjector().get<CommentController>(), arguments);
}

class _MainState extends ViewState<CommentPage, CommentController> {
  CommentController _controller;

  _MainState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => Container(
        color: ColorsItem.black191C21,
        child: Scaffold(
          key: globalKey,
          backgroundColor: ColorsItem.black1F2329,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: MediaQuery.of(context).size.height / 10,
            flexibleSpace: SimpleAppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              prefix: IconButton(
                icon: FaIcon(FontAwesomeIcons.chevronLeft,
                    color: ColorsItem.whiteE0E0E0),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                S.of(context).label_comment,
                style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                    color: ColorsItem.whiteEDEDED,
                    fontWeight: FontWeight.w700),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              color: ColorsItem.black191C21,
            ),
          ),
          body: _controller.isLoading
              ? Container(
                  color: ColorsItem.black191C21,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(Dimens.SPACE_20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2.0, color: Colors.white)),
                                      child: CircleAvatar(
                                        radius: Dimens.SPACE_20,
                                        backgroundImage: CachedNetworkImageProvider(
                                            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    SizedBox(width: Dimens.SPACE_8),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Zain Westervelt",
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_13,
                                                color: ColorsItem.whiteFEFEFE,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(height: Dimens.SPACE_4),
                                          Text(
                                            "Selamat! Team Kamu telah mencapai Milestone di Project Tittle\n\nTeam Engineer telah mencapai Milestone pertama yang berisi 35 tiket dalam Project Tittle.",
                                            softWrap: true,
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_14,
                                                color: ColorsItem.greyB8BBBF,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: Dimens.SPACE_6),
                                          Text(
                                            "Mon, 8 Apr 21, 08:12 AM・Project Tittle",
                                            style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_12,
                                                color: ColorsItem.grey666B73,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: Dimens.SPACE_12),
                                          Row(
                                            children: [
                                              Wrap(
                                                spacing: Dimens.SPACE_12,
                                                children: List.generate(
                                                    _controller.embraceReactions
                                                        .length,
                                                    (index) => Container(
                                                          child: Row(
                                                            children: [
                                                              // FaIcon(_controller.embraceReactions[index].emoticon,
                                                              //     color: ColorsItem.whiteFEFEFE,
                                                              //     size: Dimens.SPACE_18),
                                                              SvgPicture.asset(
                                                                _controller
                                                                    .embraceReactions[
                                                                        index]
                                                                    .emoticon!,
                                                                height: Dimens
                                                                    .SPACE_18,
                                                                width: Dimens
                                                                    .SPACE_18,
                                                              ),
                                                              SizedBox(
                                                                  width: Dimens
                                                                      .SPACE_4),
                                                              Text(
                                                                "2", //TODO: count the same reaction
                                                                style: GoogleFonts.montserrat(
                                                                    fontSize: Dimens
                                                                        .SPACE_18,
                                                                    color: ColorsItem
                                                                        .whiteE0E0E0),
                                                              ),
                                                            ],
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      Dimens
                                                                          .SPACE_5,
                                                                  vertical: Dimens
                                                                      .SPACE_4),
                                                          decoration: BoxDecoration(
                                                              color: ColorsItem
                                                                  .black32373D,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          Dimens
                                                                              .SPACE_8)),
                                                        )),
                                              ),
                                              _controller
                                                      .embraceReactions.isEmpty
                                                  ? SizedBox()
                                                  : SizedBox(
                                                      width: Dimens.SPACE_12),
                                              InkWell(
                                                onTap: () {
                                                  showReactionBottomSheet(
                                                      context: context,
                                                      reactions: [],
                                                      onReactionClicked:
                                                          (reaction) {});
                                                },
                                                child: Container(
                                                  child: FaIcon(
                                                      FontAwesomeIcons
                                                          .faceSmile,
                                                      color: ColorsItem
                                                          .whiteFEFEFE,
                                                      size: Dimens.SPACE_18),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimens.SPACE_5,
                                                      vertical: Dimens.SPACE_4),
                                                  decoration: BoxDecoration(
                                                      color: ColorsItem
                                                          .black32373D,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimens.SPACE_8)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              color: ColorsItem.grey666B73,
                              height: Dimens.SPACE_2),
                          Container(
                              margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height / 10),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: 12,
                                  itemBuilder: (context, index) {
                                    return CommentItem(
                                      avatar:
                                          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                      user: "Ashlynn Culhane",
                                      comment:
                                          "Selamat iya Zain Westervelt dan Team!",
                                      date: "Kamis, Apr 22, 4:44 PM",
                                      reactionList: [],
                                      onReact: () {
                                        showReactionBottomSheet(
                                            context: context,
                                            reactions: [],
                                            onReactionClicked: (reaction) {});
                                      },
                                    );
                                  })),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 10,
                        decoration: BoxDecoration(
                          color: ColorsItem.black24282E,
                          border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: ColorsItem.grey666B73.withOpacity(0.5)),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: Dimens.SPACE_15,
                            horizontal: Dimens.SPACE_20),
                        width: double.infinity,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: Theme(
                                data: new ThemeData(
                                  primaryColor: ColorsItem.grey666B73,
                                  primaryColorDark: ColorsItem.grey666B73,
                                ),
                                child: TextField(
                                  onSubmitted: (value) {},
                                  style: GoogleFonts.montserrat(
                                      color: ColorsItem.whiteFEFEFE,
                                      fontSize: Dimens.SPACE_14),
                                  controller: _controller.textEditingController,
                                  cursorColor: ColorsItem.whiteFEFEFE,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsItem.black32373D)),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorsItem.black32373D)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dimens.SPACE_8,
                                        vertical: Dimens.SPACE_16),
                                    hintText:
                                        S.of(context).chat_message_box_hint,
                                    fillColor: Colors.grey,
                                    hintStyle: GoogleFonts.montserrat(
                                        color: ColorsItem.grey666B73),
                                  ),
                                  focusNode: _controller.focusNodeMsg,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dimens.SPACE_10,
                            ),
                            Container(
                                child: InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(ImageItem.IC_SEND),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
}
