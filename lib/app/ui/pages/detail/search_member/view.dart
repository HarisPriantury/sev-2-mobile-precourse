import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/adaptive_listview.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/member_item.dart';
import 'package:mobile_sev2/app/ui/pages/detail/search_member/controller.dart';
import 'package:mobile_sev2/domain/phobject.dart';

class SearchMemberPage extends View {
  SearchMemberPage({this.arguments});

  final Object? arguments;

  @override
  _SearchMemberState createState() => _SearchMemberState(
      AppComponent.getInjector().get<SearchMemberController>(), arguments);
}

class _SearchMemberState
    extends ViewState<SearchMemberPage, SearchMemberController> {
  _SearchMemberState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  SearchMemberController _controller;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<SearchMemberController>(
            builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: MediaQuery.of(context).size.height / 10,
              flexibleSpace: SimpleAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                prefix: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                  ),
                  onPressed: () =>
                      Navigator.pop(context, controller.memberList),
                ),
                title: Text(
                  "${S.of(context).label_search} ${S.of(context).label_participant}",
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_18, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: SearchBar(
                    buttonText: "Clear",
                    hintText:
                        "${S.of(context).label_search} ${S.of(context).label_participant}",
                    border: Border.all(
                        color: ColorsItem.grey979797.withOpacity(0.5)),
                    borderRadius: new BorderRadius.all(
                        const Radius.circular(Dimens.SPACE_40)),
                    innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                    outerPadding:
                        EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
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
                      size: Dimens.SPACE_18,
                    ),
                    textStyle: TextStyle(fontSize: Dimens.SPACE_15),
                  ),
                ),
                _controller.isSearch &&
                        _controller.searchController.text.isNotEmpty
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.SPACE_20),
                              child: RichText(
                                text: new TextSpan(
                                  text: S.of(context).search_found_placeholder,
                                  style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                      color: ColorsItem.grey8D9299),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text:
                                            '"${_controller.searchController.text}"',
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_12),
                            _controller.searchedMember.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        itemCount:
                                            _controller.searchedMember.length,
                                        itemBuilder: (context, index) {
                                          var mem =
                                              _controller.searchedMember[index];
                                          return MemberItem(
                                            avatar: mem.avatar!,
                                            name: mem.name!,
                                            fullName: mem.fullName!,
                                            status: '',
                                            icon: InkWell(
                                              child: FaIcon(
                                                  FontAwesomeIcons.trashCan,
                                                  color: ColorsItem.redDA1414,
                                                  size: Dimens.SPACE_14),
                                              onTap: () => onDeleteMember(mem),
                                            ),
                                            statusColor: ColorsItem.green219653,
                                          );
                                        }),
                                  )
                                : Expanded(
                                    child: SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                S
                                                    .of(context)
                                                    .search_data_not_found_title,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: Dimens.SPACE_18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                S
                                                    .of(context)
                                                    .search_data_not_found_description,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: Dimens.SPACE_14,
                                                    color:
                                                        ColorsItem.grey8D9299),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: AdaptiveListview(
                          onRefresh: () => _controller.reload(),
                          item: (context, index) {
                            var mem = _controller.memberList[index];
                            return MemberItem(
                              avatar: mem.avatar!,
                              name: mem.name!,
                              fullName: mem.fullName!,
                              status: '',
                              icon: InkWell(
                                child: FaIcon(FontAwesomeIcons.trashCan,
                                    color: ColorsItem.redDA1414,
                                    size: Dimens.SPACE_14),
                                onTap: () => onDeleteMember(mem),
                              ),
                              statusColor: ColorsItem.green219653,
                            );
                          },
                          itemCount: _controller.memberList.length,
                        ),
                      )
              ],
            ),
          );
        }),
      );

  void onDeleteMember(PhObject member) {
    showCustomAlertDialog(
        context: context,
        title: "${S.of(context).label_remove} ${S.of(context).label_member}",
        subtitle:
            "${S.of(context).label_remove} ${member.name} ${S.of(context).label_from} ${S.of(context).label_agenda}",
        cancelButtonText: S.of(context).label_cancel.toUpperCase(),
        confirmButtonText: S.of(context).label_delete.toUpperCase(),
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          _controller.removeMember([member]);
        });
  }
}
