import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_assignee/controller.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/widgets/member_item_tile.dart';

class DetailChangeAssigneePage extends View {
  DetailChangeAssigneePage({required this.arguments});

  final Object? arguments;

  @override
  State<StatefulWidget> createState() {
    return _DetailChangeSubscriberState(
      AppComponent.getInjector().get<DetailChangeAssigneeControler>(),
      arguments,
    );
  }
}

class _DetailChangeSubscriberState
    extends ViewState<DetailChangeAssigneePage, DetailChangeAssigneeControler> {
  _DetailChangeSubscriberState(this._controller, Object? args)
      : super(_controller) {
    _controller.args = args;
  }

  final DetailChangeAssigneeControler _controller;

  @override
  Widget get view {
    return AnimatedTheme(
      data: Theme.of(context),
      child: ControlledWidgetBuilder<DetailChangeAssigneeControler>(
          builder: (context, controller) {
        return Scaffold(
          key: globalKey,
          body: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.SPACE_20,
                    vertical: Dimens.SPACE_16,
                  ),
                  child: SearchBar(
                    hintText: S.of(context).label_search +
                        ' ' +
                        S.of(context).create_form_assignee_label,
                    border: Border.all(
                      color: ColorsItem.grey979797.withOpacity(0.5),
                    ),
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(Dimens.SPACE_40),
                    ),
                    innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                    outerPadding: EdgeInsets.symmetric(
                      horizontal: Dimens.SPACE_15,
                    ),
                    controller: _controller.searchController,
                    focusNode: _controller.focusNodeSearch,
                    onChanged: (txt) {
                      _controller.streamController.add(txt);
                    },
                    clearTap: () => _controller.clearSearch(),
                    onTap: () => _controller.onSearch(true),
                    endIcon: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: ColorsItem.greyB8BBBF,
                      size: Dimens.SPACE_18,
                    ),
                    textStyle: TextStyle(color: Colors.white, fontSize: 15.0),
                    hintStyle: TextStyle(color: ColorsItem.grey8D9299),
                    buttonText: S.of(context).label_clear,
                  ),
                ),
              ),
              _controller.isLoading
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : _controller.searchAssignee.isEmpty
                      ? SliverToBoxAdapter(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            child: EmptyList(
                              title: S.of(context).search_data_not_found_title,
                              descripton: S
                                  .of(context)
                                  .search_data_not_found_description,
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final user = _controller.searchAssignee[index];
                              return MemberItemTile(
                                user: user,
                                suffix: Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor:
                                        ColorsItem.greyd8d8d8,
                                  ),
                                  child: Radio<String>(
                                    value: user.id,
                                    groupValue: _controller.selectedUser?.id,
                                    onChanged: (value) {
                                      _controller.onSelectUser(value);
                                    },
                                    activeColor: ColorsItem.orangeFB9600,
                                  ),
                                ),
                              );
                            },
                            childCount: _controller.searchAssignee.length,
                          ),
                        ),
            ],
          ),
        );
      }),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      snap: true,
      toolbarHeight: MediaQuery.of(context).size.height / 10,
      flexibleSpace: SimpleAppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 10,
        prefix: IconButton(
          icon: FaIcon(FontAwesomeIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          S.of(context).add_action_add_receiver,
          style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        suffix: Builder(
          builder: (context) {
            if (_controller.validateCurrentAssignee()) {
              return TextButton(
                onPressed: _controller.onSaveAddAssignee,
                child: Text(
                  S.of(context).label_save,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimens.SPACE_14,
                    color: ColorsItem.orangeFB9600,
                  ),
                ),
              );
            }

            return TextButton(
              onPressed: null,
              child: Text(
                S.of(context).label_save,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: Dimens.SPACE_14,
                  color: ColorsItem.grey555555,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
