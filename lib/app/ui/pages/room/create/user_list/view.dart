import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/pages/room/create/user_list/controller.dart';
import 'package:shimmer/shimmer.dart';

class UserListPage extends View {
  final Object? arguments;

  UserListPage({this.arguments});

  @override
  _UserListState createState() => _UserListState(
      AppComponent.getInjector().get<UserListController>(), arguments);
}

class _UserListState extends ViewState<UserListPage, UserListController> {
  UserListController _controller;

  _UserListState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<UserListController>(
            builder: (context, controller) {
          return Container(
            child: Scaffold(
              key: globalKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                flexibleSpace: SimpleAppBar(
                  padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  prefix: IconButton(
                    icon: FaIcon(FontAwesomeIcons.chevronLeft),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    S.of(context).create_room_title,
                    style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Dimens.SPACE_20),
                    child: SearchBar(
                      hintText: S.of(context).create_form_search_user_label,
                      border: Border.all(
                          color: ColorsItem.grey979797.withOpacity(0.5)),
                      borderRadius: BorderRadius.all(
                          const Radius.circular(Dimens.SPACE_40)),
                      innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                      outerPadding:
                          EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
                      controller: _controller.searchController,
                      focusNode: _controller.focusNode,
                      onChanged: (txt) {
                        _controller.streamController.add(txt);
                      },
                      clear: true,
                      clearTap: () => _controller.clearSearch(),
                      onTap: () => _controller.onSearch(true),
                      endIcon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: Dimens.SPACE_18,
                      ),
                      textStyle: TextStyle(fontSize: Dimens.SPACE_15),
                      hintStyle: TextStyle(color: ColorsItem.grey8D9299),
                      buttonText: 'Clear',
                    ),
                  ),
                  _controller.isSearch &&
                          _controller.searchController.text.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: RichText(
                                text: TextSpan(
                                  text: S.of(context).search_found_placeholder,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '"${_controller.searchController.text}"',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_12),
                          ],
                        )
                      : SizedBox(),
                  _controller.isLoading
                      ? _shimmerLoading()
                      : _controller.users.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  itemCount: _controller.users.length,
                                  itemBuilder: (context, index) {
                                    var user = _controller.users[index];
                                    return MemberItem(
                                      avatar: user.avatar!,
                                      name: user.name!,
                                      fullName: user.getFullName()!,
                                      status: user.availability,
                                      icon: SizedBox(),
                                      statusColor: ColorsItem.green219653,
                                      onTap: () {
                                        _controller
                                            .chatUser(_controller.users[index]);
                                      },
                                    );
                                  }),
                            )
                          : Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      S.of(context).search_data_not_found_title,
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      S
                                          .of(context)
                                          .search_data_not_found_description,
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
            ),
          );
        }),
      );

  _shimmerLoading() {
    return Expanded(
        child: Container(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              period: Duration(seconds: 1),
              baseColor: ColorsItem.grey979797,
              highlightColor: ColorsItem.grey606060,
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 10,
                  itemBuilder: (_, __) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_20,
                          vertical: Dimens.SPACE_10),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: ColorsItem.black32373D,
                                shape: BoxShape.circle),
                            width: Dimens.SPACE_10,
                            height: Dimens.SPACE_10,
                          ),
                          SizedBox(width: Dimens.SPACE_20),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorsItem.black32373D,
                                shape: BoxShape.circle),
                            width: Dimens.SPACE_40,
                            height: Dimens.SPACE_40,
                          ),
                          Shimmer.fromColors(
                            period: Duration(seconds: 1),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              decoration: BoxDecoration(
                                color: ColorsItem.black32373D,
                                borderRadius: new BorderRadius.all(
                                    const Radius.circular(Dimens.SPACE_12)),
                              ),
                              width: 200,
                              height: Dimens.SPACE_16,
                            ),
                            baseColor: ColorsItem.grey979797,
                            highlightColor: ColorsItem.grey606060,
                          ),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    ));
  }
}
