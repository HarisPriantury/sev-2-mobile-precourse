import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/project_list.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_action/controller.dart';

import 'widgets/member_item_tile.dart';

class DetailActionPage extends View {
  DetailActionPage({required this.arguments});

  final Object? arguments;

  @override
  State<StatefulWidget> createState() {
    return _DetailActionState(
      AppComponent.getInjector().get<DetailActionController>(),
      arguments,
    );
  }
}

class _DetailActionState
    extends ViewState<DetailActionPage, DetailActionController> {
  _DetailActionState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  final DetailActionController _controller;

  @override
  Widget get view {
    return AnimatedTheme(
      data: Theme.of(context),
      child: ControlledWidgetBuilder<DetailActionController>(
        builder: (context, controller) {
          return Scaffold(
            key: globalKey,
            body: _controller.isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      _buildAppBar(),
                      ..._buildContentSection(),
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
          builder: (_) {
            switch (_controller.data.type) {
              case DetailActionType.assign:
                return Text(
                  S.of(context).add_action_assign_claim,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                );
              case DetailActionType.changeStatus:
                return Text(
                  S.of(context).add_action_change_status,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                );
              case DetailActionType.changePriority:
                return Text(
                  S.of(context).add_action_change_priority,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                );
              case DetailActionType.updateStoryPoint:
                return Text(
                  S.of(context).add_action_update_story_point,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                );
              case DetailActionType.changeProjectLabel:
                return Text(
                  S.of(context).add_action_change_project_label,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                );
              case DetailActionType.changeSubscriber:
                return Text(
                  S.of(context).add_action_change_subscribers,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                  ),
                );
              default:
                return Text(
                  'No action',
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
            switch (_controller.data.type) {
              case DetailActionType.assign:
                if (_controller.isAssigneeChanged) {
                  return TextButton(
                    onPressed: () {
                      _controller.saveAssign();
                    },
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
              case DetailActionType.changeStatus:
                if (_controller.ticket.rawStatus != _controller.ticketStatus) {
                  return TextButton(
                    onPressed: () {
                      _controller.saveStatus();
                    },
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
              case DetailActionType.changePriority:
                if (_controller.ticket.priority != _controller.ticketPriority) {
                  return TextButton(
                    onPressed: () {
                      _controller.savePriority();
                    },
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
              case DetailActionType.updateStoryPoint:
                if (_controller.ticket.storyPoint.toString() !=
                    _controller.storyPoints) {
                  return TextButton(
                    onPressed: () {
                      _controller.saveStoryPoint();
                    },
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
              case DetailActionType.changeProjectLabel:
                if (_controller.validateSaveProject()) {
                  return TextButton(
                    onPressed: () {
                      _controller.saveChangeProjectLabel();
                    },
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
              case DetailActionType.changeSubscriber:
                if (_controller.validateSaveSubscriber()) {
                  return TextButton(
                    onPressed: () {
                      _controller.saveChangeSubscriber();
                    },
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
              default:
                return TextButton(
                  onPressed: () {
                    _controller.saveAssign();
                  },
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
          },
        ),
      ),
    );
  }

  List<Widget> _buildContentSection() {
    switch (_controller.data.type) {
      case DetailActionType.assign:
        return [
          _addAssignerSection(),
          if (_controller.assignee != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.SPACE_24,
                  left: Dimens.SPACE_16,
                  bottom: Dimens.SPACE_24,
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tag,
                      color: ColorsItem.grey858A93,
                      size: Dimens.SPACE_14,
                    ),
                    const SizedBox(width: Dimens.SPACE_8),
                    Text(
                      '1',
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.grey858A93,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ' + S.of(context).add_action_assign_claim.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.grey858A93,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_controller.assignee != null)
            SliverToBoxAdapter(
              child: MemberItemTile(
                user: _controller.assignee!,
                suffix: IconButton(
                  onPressed: () {
                    showCustomAlertDialog(
                      title: S.of(context).add_action_remove_receiver,
                      subtitleWidget: Row(
                        children: [
                          Text(
                            S.of(context).label_remove + ' ',
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              color: ColorsItem.grey8D9299,
                            ),
                          ),
                          Text(
                            "${_controller.assignee!.name}",
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14),
                          ),
                          Text(
                            ' ' + S.of(context).add_action_from_task,
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_14,
                              color: ColorsItem.grey8D9299,
                            ),
                          ),
                        ],
                      ),
                      cancelButtonText: S.of(context).label_back.toUpperCase(),
                      confirmButtonText:
                          S.of(context).label_remove.toUpperCase(),
                      context: context,
                      onConfirm: () {
                        _controller.onRemoveAssignee(_controller.assignee!);
                        Navigator.pop(context);
                      },
                    );
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.trashCan,
                    color: ColorsItem.redDA1414,
                    size: Dimens.SPACE_18,
                  ),
                ),
              ),
            ),
        ];
      case DetailActionType.changeStatus:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Dimens.SPACE_16,
                left: Dimens.SPACE_20,
                right: Dimens.SPACE_20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).label_status,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.ticketStatus == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.ticketStatus,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onTicketStatusChanged(newValue);
                            },
                            items: _controller.ticketStatuses
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14),
                                        ),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ];
      case DetailActionType.changePriority:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Dimens.SPACE_16,
                left: Dimens.SPACE_20,
                right: Dimens.SPACE_20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).label_priority,
                    style: GoogleFonts.montserrat(
                      color: ColorsItem.greyB8BBBF,
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Dimens.SPACE_8),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_16),
                            labelStyle: GoogleFonts.montserrat(),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorsItem.grey666B73))),
                        isEmpty: _controller.ticketPriority == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _controller.ticketPriority,
                            isDense: true,
                            onChanged: (String? newValue) {
                              _controller.onTicketPriorityChanged(newValue);
                            },
                            items: _controller.ticketPriorities
                                .map((key, value) {
                                  return MapEntry(
                                      key,
                                      DropdownMenuItem<String>(
                                        value: key,
                                        child: Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14),
                                        ),
                                      ));
                                })
                                .values
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ];
      case DetailActionType.updateStoryPoint:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Dimens.SPACE_16,
                left: Dimens.SPACE_20,
                right: Dimens.SPACE_20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).profile_story_point_title,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Dimens.SPACE_8),
                  Theme(
                    data: new ThemeData(
                      primaryColor: ColorsItem.grey666B73,
                      primaryColorDark: ColorsItem.grey666B73,
                    ),
                    child: TextField(
                      controller: _controller.storyPointsController,
                      style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_14),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: Dimens.SPACE_16),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItem.grey666B73),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItem.grey666B73),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: ColorsItem.grey666B73),
                        ),
                        hintStyle: GoogleFonts.montserrat(
                            color: ColorsItem.grey666B73),
                        hintText: S.of(context).profile_story_point_title,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      case DetailActionType.changeProjectLabel:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              height: Dimens.SPACE_60,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _controller.goToAddLabel();
                  },
                  splashColor: ColorsItem.grey2E353A,
                  highlightColor: ColorsItem.grey2E353A,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Dimens.SPACE_16,
                      left: Dimens.SPACE_16,
                      right: Dimens.SPACE_16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: ColorsItem.orangeFB9600,
                            ),
                            const SizedBox(
                              width: Dimens.SPACE_10,
                            ),
                            Text(
                              S.of(context).add_action_add_label,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.orangeFB9600,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Divider(
                              color: ColorsItem.grey32373D,
                              thickness: Dimens.SPACE_1,
                              height: Dimens.SPACE_1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_controller.projects.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Dimens.SPACE_16,
                  right: Dimens.SPACE_16,
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tag,
                      color: ColorsItem.grey858A93,
                      size: Dimens.SPACE_16,
                    ),
                    const SizedBox(width: Dimens.SPACE_8),
                    Text(
                      _controller.projects.length.toString(),
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.grey858A93,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' ' +
                          S.of(context).add_action_project_label.toUpperCase(),
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.grey858A93,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        _controller.gotoSearchLabel();
                      },
                      icon: FaIcon(
                        FontAwesomeIcons.magnifyingGlass,
                        color: ColorsItem.orangeFB9600,
                        size: Dimens.SPACE_16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_controller.projects.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final project = _controller.projects[index];

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: Dimens.SPACE_16,
                      right: Dimens.SPACE_16,
                      bottom: Dimens.SPACE_24,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ProjectList(
                            onTap: () {
                              _controller.goToDetailProject(project);
                            },
                            projectName: project.name ?? '',
                            joinDate: "",
                            status: project.isArchived
                                ? S.of(context).label_archive
                                : S.of(context).status_task_open,
                            index: index,
                          ),
                        ),
                        if (_controller.projects.length > 1)
                          IconButton(
                            onPressed: () {
                              showCustomAlertDialog(
                                title: S
                                    .of(context)
                                    .add_action_remove_project_label,
                                subtitleWidget: RichText(
                                  text: TextSpan(
                                    text: S.of(context).label_remove + ' ',
                                    style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_14,
                                      color: ColorsItem.grey8D9299,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: project.name ?? '',
                                        style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_14,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      TextSpan(
                                        text: ' ' +
                                            S.of(context).add_action_from_task,
                                        style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_14,
                                          color: ColorsItem.grey8D9299,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                cancelButtonText:
                                    S.of(context).label_back.toUpperCase(),
                                confirmButtonText:
                                    S.of(context).label_remove.toUpperCase(),
                                context: context,
                                onConfirm: () {
                                  _controller.onRemoveProject(project);

                                  Navigator.pop(context);
                                },
                              );
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.trashCan,
                              color: Colors.red,
                              size: Dimens.SPACE_16,
                            ),
                          ),
                      ],
                    ),
                  );
                },
                childCount: _controller.projects.length,
              ),
            ),
        ];
      case DetailActionType.changeSubscriber:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              height: Dimens.SPACE_60,
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _controller.goToAddSubscriber();
                  },
                  splashColor: ColorsItem.grey2E353A,
                  highlightColor: ColorsItem.grey2E353A,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Dimens.SPACE_16,
                      left: Dimens.SPACE_16,
                      right: Dimens.SPACE_16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: ColorsItem.orangeFB9600,
                            ),
                            const SizedBox(
                              width: Dimens.SPACE_10,
                            ),
                            Text(
                              S.of(context).add_action_add_subsciber,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.orangeFB9600,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Divider(
                              color: ColorsItem.grey32373D,
                              thickness: Dimens.SPACE_1,
                              height: Dimens.SPACE_1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _controller.subscribers.isEmpty
              ? SliverToBoxAdapter()
              : SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: Dimens.SPACE_16,
                      right: Dimens.SPACE_16,
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.userGroup,
                          color: ColorsItem.grey858A93,
                          size: Dimens.SPACE_16,
                        ),
                        const SizedBox(width: Dimens.SPACE_8),
                        Text(
                          _controller.subscribers.length.toString(),
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.grey858A93,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' ' + S.of(context).label_subscriber.toUpperCase(),
                          style: GoogleFonts.montserrat(
                            color: ColorsItem.grey858A93,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _controller.goToSearchSubscriber();
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: ColorsItem.orangeFB9600,
                            size: Dimens.SPACE_16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          _controller.subscribers.isEmpty
              ? SliverToBoxAdapter()
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final user = _controller.subscribers[index];

                      return MemberItemTile(
                        user: user,
                        suffix: IconButton(
                          onPressed: () {
                            showCustomAlertDialog(
                              title: S.of(context).add_action_remove_receiver,
                              subtitleWidget: Row(children: [
                                Text(
                                  S.of(context).label_remove + ' ',
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    color: ColorsItem.grey8D9299,
                                  ),
                                ),
                                Text(
                                  user.name ?? '',
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                  ),
                                ),
                                Text(
                                  ' ' + S.of(context).add_action_from_task,
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    color: ColorsItem.grey8D9299,
                                  ),
                                ),
                              ]),
                              cancelButtonText:
                                  S.of(context).label_back.toUpperCase(),
                              confirmButtonText:
                                  S.of(context).label_remove.toUpperCase(),
                              context: context,
                              onConfirm: () {
                                _controller.onRemoveSubscriber(user);
                                Navigator.pop(context);
                              },
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.trashCan,
                            color: ColorsItem.redDA1414,
                            size: Dimens.SPACE_18,
                          ),
                        ),
                      );
                    },
                    childCount: _controller.subscribers.length,
                  ),
                ),
        ];
      default:
        return [SliverToBoxAdapter(child: Text('No Action'))];
    }
  }

  SliverToBoxAdapter _addAssignerSection() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: Dimens.SPACE_60,
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              _controller.goToAddAssigner();
            },
            splashColor: ColorsItem.grey2E353A,
            highlightColor: ColorsItem.grey2E353A,
            child: Padding(
              padding: const EdgeInsets.only(
                top: Dimens.SPACE_16,
                left: Dimens.SPACE_16,
                right: Dimens.SPACE_16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: ColorsItem.orangeFB9600,
                      ),
                      const SizedBox(
                        width: Dimens.SPACE_10,
                      ),
                      Text(
                        S.of(context).add_action_add_receiver,
                        style: GoogleFonts.montserrat(
                          color: ColorsItem.orangeFB9600,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        color: ColorsItem.grey32373D,
                        thickness: Dimens.SPACE_1,
                        height: Dimens.SPACE_1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
