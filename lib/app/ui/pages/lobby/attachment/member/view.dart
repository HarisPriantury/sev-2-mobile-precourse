import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/icon_status.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/member/controller.dart';

class RoomMemberPage extends View {
  final Object? arguments;

  RoomMemberPage({this.arguments});

  @override
  _RoomMemberState createState() => _RoomMemberState(
      AppComponent.getInjector().get<RoomMemberController>(), arguments);
}

class _RoomMemberState extends ViewState<RoomMemberPage, RoomMemberController> {
  RoomMemberController _controller;

  _RoomMemberState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomMemberController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).room_member_label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimens.SPACE_20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: Dimens.SPACE_4,
                    ),
                    Text(
                      _controller.room.name!,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_12,
                      ),
                    ),
                  ],
                ),
                suffix: Container(
                  width: Dimens.SPACE_50,
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                controller.isLoading
                    ? Expanded(
                        child: Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: DefaultRefreshIndicator(
                          onRefresh: () => _controller.reload(),
                          child: ListView.builder(
                              itemCount: _controller.participants.length,
                              itemBuilder: (context, index) {
                                final user = _controller.participants[index];
                                final status = user.userStatus != null
                                    ? user.userStatus!
                                            .toLowerCase()
                                            .contains("channel")
                                        ? user.currentChannel!
                                        : user.userStatus!
                                    : 'Not Available';
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.SPACE_4),
                                  child: MemberItem(
                                    avatar: user.avatar!,
                                    name: user.name!,
                                    fullName: user.getFullName()!,
                                    status: status,
                                    icon: IconStatus(
                                      status: status,
                                      size: Dimens.SPACE_16,
                                    ),
                                    statusColor: status == 'Not Available'
                                        ? ColorsItem.grey606060
                                        : ColorsItem.green219653,
                                    onTap: () {
                                      _controller.goToProfile(user);
                                    },
                                  ), // TODO change based on availability
                                );
                              }),
                        ),
                      )
              ],
            ),
          );
        }),
      );
}
