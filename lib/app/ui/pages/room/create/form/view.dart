import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/form/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class CreateRoomPage extends View {
  final Object? arguments;

  CreateRoomPage({this.arguments});

  @override
  _CreateRoomState createState() => _CreateRoomState(
      AppComponent.getInjector().get<CreateRoomController>(), arguments);
}

class _CreateRoomState extends ViewState<CreateRoomPage, CreateRoomController> {
  CreateRoomController _controller;

  _CreateRoomState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<CreateRoomController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 5.0,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                toolbarHeight: MediaQuery.of(context).size.height / 8,
                title: Text(
                  _controller.type == FormType.create
                      ? S.of(context).create_room_title
                      : S.of(context).lobby_edit_room,
                  style: TextStyle(
                      fontSize: Dimens.SPACE_17, fontWeight: FontWeight.bold),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    if (_controller.isFormReady()) {
                      _controller.onCreateRoom();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text(
                      _controller.type == FormType.create
                          ? S.of(context).label_add
                          : S.of(context).label_update,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: Dimens.SPACE_14,
                          color: _controller.isFormReady()
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.white9E9E9E),
                    ),
                  ),
                ),
              ),
            ),
            body: _controller.isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_20,
                                vertical: Dimens.SPACE_15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).create_room_name_label,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: Dimens.SPACE_10),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: Dimens.SPACE_1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.SPACE_10),
                                  child: Container(
                                    child: TextField(
                                      style:
                                          TextStyle(fontSize: Dimens.SPACE_15),
                                      controller:
                                          _controller.titleGroupController,
                                      decoration: InputDecoration(
                                        hintText:
                                            S.of(context).create_room_name_hint,
                                        hintStyle: GoogleFonts.montserrat(),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimens.SPACE_15,
                                ),
                                Text(
                                  S.of(context).create_room_topic_label,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: Dimens.SPACE_10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: Dimens.SPACE_1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Dimens.SPACE_10),
                                  child: Container(
                                    child: TextField(
                                      style:
                                          TextStyle(fontSize: Dimens.SPACE_15),
                                      controller:
                                          _controller.topicGroupController,
                                      decoration: InputDecoration(
                                        hintText: S
                                            .of(context)
                                            .create_room_topic_hint,
                                        hintStyle: GoogleFonts.montserrat(
                                            color: ColorsItem.grey666B73),
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dimens.SPACE_15,
                                ),
                                Text(
                                  S.of(context).create_room_member_label,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: Dimens.SPACE_10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _controller.onSearchUsers();
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius:
                                          BorderRadius.circular(Dimens.SPACE_4),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: _buildSearchItems(
                                                  _controller.members),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: ColorsItem.grey666B73,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    Dimens.SPACE_14),
                                                child: FaIcon(
                                                    FontAwesomeIcons
                                                        .magnifyingGlass,
                                                    color:
                                                        ColorsItem.whiteFEFEFE,
                                                    size: Dimens.SPACE_16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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

  List<Widget> _buildSearchItems(List<PhObject> list) {
    List<Widget> chips = new List.empty(growable: true);
    chips.add(SizedBox(width: Dimens.SPACE_4));
    for (PhObject obj in list) {
      chips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_4),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.SPACE_4)),
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8, vertical: Dimens.SPACE_2),
          child: Text(obj.name!, style: GoogleFonts.montserrat()),
        ),
      ));
    }
    chips.add(SizedBox(width: Dimens.SPACE_4));
    return chips;
  }
}
