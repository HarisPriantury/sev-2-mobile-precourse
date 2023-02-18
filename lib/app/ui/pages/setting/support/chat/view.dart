import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:mobile_sev2/app/ui/pages/setting/support/chat/controller.dart';
import 'package:rich_text_view/rich_text_view.dart';

class ChatSupportPage extends View {
  final Object? arguments;

  ChatSupportPage({this.arguments});

  @override
  _ChatSupportState createState() => _ChatSupportState(
      AppComponent.getInjector().get<ChatSupportController>(), arguments);
}

class _ChatSupportState
    extends ViewState<ChatSupportPage, ChatSupportController> {
  ChatSupportController _controller;

  _ChatSupportState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => ControlledWidgetBuilder<ChatSupportController>(
        builder: (context, controller) {
          return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Scaffold(
              key: globalKey,
              backgroundColor: ColorsItem.black1F2329,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                backgroundColor: ColorsItem.black24282E,
                flexibleSpace: SimpleAppBar(
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  color: ColorsItem.black24282E,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  prefix: IconButton(
                      icon: FaIcon(FontAwesomeIcons.chevronLeft,
                          color: ColorsItem.whiteE0E0E0),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).label_sev2_support,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.SPACE_20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  suffix: Container(
                    padding: EdgeInsets.only(right: Dimens.SPACE_24),
                    child: Row(
                      children: [
                        PopupMenuButton(
                          color: ColorsItem.black020202,
                          onSelected: (value) {},
                          child: FaIcon(FontAwesomeIcons.ellipsisVertical,
                              color: ColorsItem.whiteFEFEFE,
                              size: Dimens.SPACE_18),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.magnifyingGlass,
                                        color: ColorsItem.whiteE0E0E0,
                                        size: Dimens.SPACE_18),
                                    SizedBox(width: Dimens.SPACE_8),
                                    Expanded(
                                        child: Text(S.of(context).label_search,
                                            style: GoogleFonts.montserrat(
                                                color: ColorsItem.whiteE0E0E0,
                                                fontSize: Dimens.SPACE_14)))
                                  ],
                                )),
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  FaIcon(FontAwesomeIcons.trashCan,
                                      color: ColorsItem.whiteE0E0E0,
                                      size: Dimens.SPACE_18),
                                  SizedBox(width: Dimens.SPACE_8),
                                  Expanded(
                                      child: Text(S.of(context).label_delete,
                                          style: GoogleFonts.montserrat(
                                              color: ColorsItem.whiteE0E0E0,
                                              fontSize: Dimens.SPACE_14)))
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              body: Container(
                color: ColorsItem.black24282E,
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).label_question_type,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsItem.grey8D9299,
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_8),
                                    Text(
                                      S.of(context).label_ticket_project,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_16,
                                        fontWeight: FontWeight.w700,
                                        color: ColorsItem.whiteFEFEFE,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimens.SPACE_16,
                                    ),
                                    Text(
                                      S
                                          .of(context)
                                          .room_detail_description_label,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsItem.grey8D9299,
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_8),
                                    Text(
                                      "Cras fames platea mauris eleifend mattis ultrices nibh gravida ornare. Porta nisl, arcu urna pulvinar vitae dolor elit pellentesque. Urna fringilla in eu egestas leo, fermentum massa. Viverra pharetra nunc est sollicitudin tincidunt. Vulputate posuere metus bibendum at suscipit integer risus ut placerat. Lacus leo ultrices egestas condimentum purus, molestie nec egestas viverra. Nisl varius mattis pulvinar nulla enim. Ut elementum ne",
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_14,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsItem.whiteFEFEFE,
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimens.SPACE_16,
                                    ),
                                    Text(
                                      S.of(context).label_attachment,
                                      style: GoogleFonts.montserrat(
                                        fontSize: Dimens.SPACE_16,
                                        fontWeight: FontWeight.w500,
                                        color: ColorsItem.grey8D9299,
                                      ),
                                    ),
                                    SizedBox(height: Dimens.SPACE_8),
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://pandagila.com/wp-content/uploads/2020/08/error-404-not-found.jpg",
                                      width: MediaQuery.of(context).size.width *
                                          0.90,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichTextView.editor(
                                // key: _controller.messageKey,
                                backgroundColor: ColorsItem.black24282E,
                                containerDecoration: BoxDecoration(
                                  color: ColorsItem.black24282E,
                                  border: Border(
                                    top: BorderSide(
                                      width: 1.0,
                                      color: ColorsItem.grey666B73
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                containerPadding: EdgeInsets.symmetric(
                                  vertical: Dimens.SPACE_15,
                                  horizontal: Dimens.SPACE_10,
                                ),
                                containerWidth: double.infinity,
                                onChanged: (value) {
                                  // _controller.updateMessageFieldSize();
                                },
                                prefix: Container(
                                  padding:
                                      EdgeInsets.only(bottom: Dimens.SPACE_12),
                                  child: InkWell(
                                    // onTap: () => _settingModalBottomSheet(),
                                    child: SvgPicture.asset(
                                      ImageItem.IC_URL,
                                      color: ColorsItem.grey8D9299,
                                    ),
                                  ),
                                ),
                                suffix: Container(
                                  padding:
                                      EdgeInsets.only(bottom: Dimens.SPACE_12),
                                  child: InkWell(
                                    onTap: () {
                                      // if (!_controller.isSendingMessage) _controller.sendMessage();
                                    },
                                    child: SvgPicture.asset(ImageItem.IC_SEND),
                                  ),
                                ),
                                separator: Dimens.SPACE_10,
                                suggestionPosition: SuggestionPosition.top,
                                style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteFEFEFE,
                                  fontSize: Dimens.SPACE_14,
                                ),
                                // controller: _controller.textEditingController,
                                cursorColor: ColorsItem.whiteFEFEFE,
                                decoration: InputDecoration(
                                  // isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorsItem.black32373D,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorsItem.black32373D,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_8,
                                    vertical: Dimens.SPACE_16,
                                  ),
                                  hintText: S.of(context).chat_message_box_hint,
                                  fillColor: Colors.grey,
                                  hintStyle: GoogleFonts.montserrat(
                                      color: ColorsItem.grey666B73),
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 4,
                                // focusNode: _controller.focusNodeMsg,
                                // mentionSuggestions: _controller.userSuggestion,
                                // onSearchPeople: (term) async {
                                //   return _controller.filterUserSuggestion(term);
                                // },
                                titleStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.whiteFEFEFE,
                                ),
                                subtitleStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  color: ColorsItem.grey8D9299,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
}
