import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_list_tile.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/controller.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class TaskActionPage extends View {
  final Object? arguments;

  TaskActionPage({this.arguments});

  @override
  _TaskActionState createState() => _TaskActionState(
      AppComponent.getInjector().get<TaskActionController>(), arguments);
}

class _TaskActionState extends ViewState<TaskActionPage, TaskActionController> {
  TaskActionController _controller;

  _TaskActionState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<TaskActionController>(
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
                  _controller.data.type == TaskActionType.subtask
                      ? S.of(context).detail_subtask_edit_label
                      : S.of(context).detail_task_merge_label,
                  style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16, fontWeight: FontWeight.bold),
                ),
                suffix: GestureDetector(
                  onTap: () {
                    if (_controller.validate()) {
                      if (_controller.data.type == TaskActionType.subtask) {
                        _controller.onAddSubtask();
                      } else {
                        _controller.onMergeTask();
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 24.0),
                    child: Text(
                      S.of(context).label_submit.ucwords(),
                      style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                          fontWeight: FontWeight.bold,
                          color: _controller.validate()
                              ? ColorsItem.orangeFB9600
                              : ColorsItem.grey8D9299),
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            body:
                // _controller.isLoading
                //     ? Container(
                //         color: ColorsItem.black1F2329,
                //         child: Center(
                //           child: CircularProgressIndicator(),
                //         ),
                //       )
                //     :
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: SearchBar(
                    hintText: S.of(context).status_task_find_label,
                    textStyle: TextStyle(color: Colors.white, fontSize: 15.0),
                    hintStyle: TextStyle(color: Colors.grey),
                    outerPadding:
                        EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
                    innerPadding: EdgeInsets.all(Dimens.SPACE_10),
                    controller: _controller.searchController,
                    focusNode: _controller.focusNodeSearch,
                    onChanged: (txt) {
                      _controller.streamController.add(txt);
                    },
                    clearTap: () => _controller.clearSearch(),
                    onTap: () => _controller.onSearch(true),
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(40.0)),
                    border: Border.all(color: ColorsItem.grey666B73),
                    endIcon: FaIcon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: ColorsItem.greyB8BBBF,
                    ),
                    buttonText: 'Cancel',
                  ),
                ),
                _buildChips(),
                SizedBox(height: Dimens.SPACE_15),
                Expanded(
                  child: _controller.isLoading && _controller.isFirstRequest
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : SingleChildScrollView(
                          controller: _controller.listScrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _controller.isSearch
                                  ? _controller.resultTasks.isEmpty
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: Center(
                                            child: EmptyList(
                                                title: S
                                                    .of(context)
                                                    .search_data_not_found_title,
                                                descripton: S
                                                    .of(context)
                                                    .search_data_not_found_description),
                                          ),
                                        )
                                      : SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimens.SPACE_20),
                                          child: Text(
                                              _controller.data.type ==
                                                      TaskActionType.subtask
                                                  ? S
                                                      .of(context)
                                                      .action_task_selected_subtask
                                                      .toUpperCase()
                                                  : S
                                                      .of(context)
                                                      .action_task_selected_merged_task
                                                      .toUpperCase(),
                                              style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_12,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.3,
                                              )),
                                        ),
                                        SizedBox(height: Dimens.SPACE_15),
                                        _controller.relatedTasks.isEmpty
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimens.SPACE_20,
                                                    vertical: Dimens.SPACE_8),
                                                child: Text(
                                                    _controller.data.type ==
                                                            TaskActionType
                                                                .subtask
                                                        ? S
                                                            .of(context)
                                                            .action_task_empty_subtask
                                                        : S
                                                            .of(context)
                                                            .action_task_empty_merged_task,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: Dimens.SPACE_14,
                                                      letterSpacing: 0.2,
                                                    )),
                                              )
                                            : ListView.builder(
                                                itemCount: _controller
                                                    .relatedTasks.length,
                                                primary: false,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      CustomListTile(
                                                        title:
                                                            "${_controller.relatedTasks[index].code}: ${_controller.relatedTasks[index].name}",
                                                        padding: EdgeInsets.all(
                                                            Dimens.SPACE_20),
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize: Dimens
                                                                    .SPACE_14),
                                                        icon: InkWell(
                                                            onTap: () {
                                                              if (_controller
                                                                      .data
                                                                      .type ==
                                                                  TaskActionType
                                                                      .subtask) {
                                                                showCustomAlertDialog(
                                                                    context:
                                                                        context,
                                                                    title: S
                                                                        .of(
                                                                            context)
                                                                        .action_task_delete_subtask_title,
                                                                    subtitle: S
                                                                        .of(
                                                                            context)
                                                                        .action_task_delete_subtask_subtitle,
                                                                    onConfirm:
                                                                        () {
                                                                      _controller
                                                                          .onRemoveSubtask(
                                                                              _controller.relatedTasks[index]);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    onCancel:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    cancelButtonText: S
                                                                        .of(
                                                                            context)
                                                                        .label_back
                                                                        .toUpperCase(),
                                                                    confirmButtonText: S
                                                                        .of(context)
                                                                        .label_delete
                                                                        .toUpperCase());
                                                              } else {
                                                                showCustomAlertDialog(
                                                                    heightBoxDialog:
                                                                        MediaQuery.of(context).size.height /
                                                                            4,
                                                                    context:
                                                                        context,
                                                                    title: S
                                                                        .of(
                                                                            context)
                                                                        .action_task_delete_merged_task_title,
                                                                    subtitle: S
                                                                        .of(
                                                                            context)
                                                                        .action_task_delete_merged_task_subtitle,
                                                                    onConfirm:
                                                                        () {
                                                                      _controller
                                                                          .onRemoveMergedTask(
                                                                              _controller.relatedTasks[index]);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    onCancel:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    cancelButtonText: S
                                                                        .of(
                                                                            context)
                                                                        .label_back
                                                                        .toUpperCase(),
                                                                    confirmButtonText: S
                                                                        .of(context)
                                                                        .label_delete
                                                                        .toUpperCase());
                                                              }
                                                            },
                                                            child: FaIcon(
                                                                FontAwesomeIcons
                                                                    .trashCan,
                                                                color: ColorsItem
                                                                    .redDA1414)),
                                                      ),
                                                      Divider(
                                                        color: ColorsItem
                                                            .black292D33,
                                                        height: Dimens.SPACE_2,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                        SizedBox(height: Dimens.SPACE_30),
                                      ],
                                    ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_20),
                                child: Text(
                                    _controller.isSearch
                                        ? _controller.resultTasks.isEmpty
                                            ? ""
                                            : S
                                                .of(context)
                                                .status_task_available_label
                                                .toUpperCase()
                                        : _controller.data.type ==
                                                TaskActionType.subtask
                                            ? S
                                                .of(context)
                                                .action_task_add_subtask
                                                .toUpperCase()
                                            : S
                                                .of(context)
                                                .action_task_add_merged_task
                                                .toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    )),
                              ),
                              SizedBox(height: Dimens.SPACE_15),
                              ListView.builder(
                                itemCount: _controller.resultTasks.length,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      CustomListTile(
                                        title:
                                            "${_controller.resultTasks[index].code}: ${_controller.resultTasks[index].name}",
                                        padding: EdgeInsets.only(
                                            left: Dimens.SPACE_20,
                                            top: Dimens.SPACE_8,
                                            bottom: Dimens.SPACE_8,
                                            right: Dimens.SPACE_8),
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14),
                                        icon: Theme(
                                          child: Checkbox(
                                            checkColor: Colors.black,
                                            activeColor:
                                                ColorsItem.orangeFB9600,
                                            onChanged: (bool? value) {
                                              _controller.onSelectUser(
                                                  index, value);
                                            },
                                            value: _controller
                                                .isObjectSelected(index),
                                          ),
                                          data: ThemeData(
                                            unselectedWidgetColor: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: ColorsItem.black292D33,
                                        height: Dimens.SPACE_2,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        }),
      );

  Widget _buildChips() {
    List<Widget> chips = new List.empty(growable: true);

    for (int i = 0; i < _controller.chipOptions.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _controller.selectedChip == i,
        label: Text(_controller.chipOptions[i],
            style: GoogleFonts.montserrat(
                color: _controller.selectedChip == i
                    ? ColorsItem.whiteColor
                    : null)),
        selectedColor: ColorsItem.blue3FB5ED,
        onSelected: (bool selected) {
          if (!_controller.isLoading) _controller.selectChip(selected, i);
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips,
      ),
    );
  }
}
