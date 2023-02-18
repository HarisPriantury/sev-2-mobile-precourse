import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/project_list.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/detail_change_project/controller.dart';

class DetailChangeProjectPage extends View {
  DetailChangeProjectPage({required this.arguments});

  final Object? arguments;

  @override
  State<StatefulWidget> createState() {
    return _DetailChangeProjectPageState(
      AppComponent.getInjector().get<DetailChangeProjectController>(),
      arguments,
    );
  }
}

class _DetailChangeProjectPageState
    extends ViewState<DetailChangeProjectPage, DetailChangeProjectController> {
  _DetailChangeProjectPageState(this._controller, Object? args)
      : super(_controller) {
    _controller.args = args;
  }

  final DetailChangeProjectController _controller;

  @override
  Widget get view {
    return AnimatedTheme(
      data: Theme.of(context),
      child: ControlledWidgetBuilder<DetailChangeProjectController>(
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
                          S.of(context).label_project,
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
                      textStyle:
                          GoogleFonts.montserrat(fontSize: Dimens.SPACE_15),
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
                    : _controller.searchProject.isEmpty
                        ? SliverToBoxAdapter(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width,
                              child: EmptyList(
                                title:
                                    S.of(context).search_data_not_found_title,
                                descripton: S
                                    .of(context)
                                    .search_data_not_found_description,
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final project =
                                    _controller.searchProject[index];

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: Dimens.SPACE_20,
                                    right: Dimens.SPACE_20,
                                    bottom: Dimens.SPACE_24,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ProjectList(
                                          onTap: null,
                                          projectName: project.name ?? '',
                                          joinDate: "",
                                          status: project.isArchived
                                              ? S.of(context).label_archive
                                              : S.of(context).status_task_open,
                                          index: index,
                                        ),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          if (_controller.data.type ==
                                              DetailChangeProjectType.add) {
                                            return Theme(
                                              child: Checkbox(
                                                checkColor: Colors.black,
                                                activeColor:
                                                    ColorsItem.orangeFB9600,
                                                onChanged: (bool? value) {
                                                  _controller
                                                      .onSelectProject(project);
                                                },
                                                value: _controller
                                                    .isProjectSelected(project),
                                              ),
                                              data: ThemeData(
                                                unselectedWidgetColor:
                                                    Colors.grey,
                                              ),
                                            );
                                          }
                                          return IconButton(
                                            onPressed: () {
                                              showCustomAlertDialog(
                                                title: S
                                                    .of(context)
                                                    .add_action_remove_project_label,
                                                subtitleWidget: RichText(
                                                  text: TextSpan(
                                                    text: S
                                                            .of(context)
                                                            .label_remove +
                                                        ' ',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: Dimens.SPACE_14,
                                                      color:
                                                          ColorsItem.grey8D9299,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            project.name ?? '',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize:
                                                              Dimens.SPACE_14,
                                                          color: ColorsItem
                                                              .whiteFEFEFE,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' ' +
                                                            S
                                                                .of(context)
                                                                .add_action_from_task,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontSize:
                                                              Dimens.SPACE_14,
                                                          color: ColorsItem
                                                              .grey8D9299,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                cancelButtonText: S
                                                    .of(context)
                                                    .label_back
                                                    .toUpperCase(),
                                                confirmButtonText: S
                                                    .of(context)
                                                    .label_remove
                                                    .toUpperCase(),
                                                context: context,
                                                onConfirm: () {
                                                  _controller
                                                      .onRemoveProject(project);

                                                  Navigator.pop(context);
                                                },
                                                confirmButtonColor:
                                                    ColorsItem.redDA1414,
                                                confirmButtonTextColor:
                                                    ColorsItem.whiteFEFEFE,
                                                cancelButtonColor:
                                                    ColorsItem.whiteF2F2F2,
                                              );
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.trashCan,
                                              color: Colors.red,
                                              size: Dimens.SPACE_16,
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                              childCount: _controller.searchProject.length,
                            ),
                          ),
              ],
            ),
          );
        },
      ),
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
        title: Builder(
          builder: (context) {
            if (_controller.data.type == DetailChangeProjectType.add) {
              return Text(
                S.of(context).add_action_add_label,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_16,
                ),
              );
            } else {
              return Text(
                S.of(context).create_form_search_project_label,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_16,
                ),
              );
            }
          },
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        suffix: Builder(
          builder: (context) {
            final isValidated = _controller.validateSaveProject();

            if (_controller.data.type == DetailChangeProjectType.add) {
              return TextButton(
                onPressed: isValidated ? _controller.onSaveChangeProject : null,
                child: Text(
                  S.of(context).label_add,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimens.SPACE_14,
                    color: isValidated
                        ? ColorsItem.orangeFB9600
                        : ColorsItem.grey555555,
                  ),
                ),
              );
            } else {
              return TextButton(
                onPressed: _controller.onSaveChangeProject,
                child: Text(
                  S.of(context).label_save,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: Dimens.SPACE_14,
                    color: isValidated
                        ? ColorsItem.orangeFB9600
                        : ColorsItem.grey555555,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
