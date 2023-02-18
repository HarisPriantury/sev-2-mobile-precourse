import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/dom.dart' as dom;
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/bottomsheet/reaction_bottomsheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/deletable_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/detail_head.dart';
import 'package:mobile_sev2/app/ui/assets/widget/project_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/transaction_item.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/detail/controller.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/args.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/calendar.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/stickit.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class DetailPage extends View {
  final Object? arguments;

  DetailPage({this.arguments});

  @override
  _DetailState createState() => _DetailState(
      AppComponent.getInjector().get<DetailController>(), arguments);
}

class _DetailState extends ViewState<DetailPage, DetailController> {
  DetailController _controller;

  _DetailState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view =>
      ControlledWidgetBuilder<DetailController>(builder: (context, controller) {
        return _controller.isLoading
            ? Container(
                color: ColorsItem.black191C21,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : WillPopScope(
                onWillPop: () async {
                  _controller.backPage();
                  return true;
                },
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
                        onPressed: () =>
                            Navigator.pop(context, controller.isChanged),
                      ),
                      title: Text(
                        _getTitle(),
                        style: GoogleFonts.montserrat(
                            fontSize: Dimens.SPACE_16,
                            color: ColorsItem.whiteEDEDED),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      color: ColorsItem.black191C21,
                      suffix: _controller.isAuthor() &&
                              _controller.getArgsType() == Ticket
                          ? _popMenu()
                          : _controller.isAuthor() &&
                                      _controller.getArgsType() == Stickit ||
                                  _controller.getArgsType() == Calendar
                              ? InkWell(
                                  onTap: () {
                                    _controller.goToEditPage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(right: 24.0),
                                    child: FaIcon(
                                        FontAwesomeIcons.solidPenToSquare,
                                        color: ColorsItem.whiteFEFEFE,
                                        size: Dimens.SPACE_16),
                                  ))
                              : _controller.getArgsType() == Project
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimens.SPACE_20),
                                      child: InkWell(
                                        onTap: () =>
                                            _controller.goToWorkboard(),
                                        child: Text(
                                          S
                                              .of(context)
                                              .label_workboard
                                              .toUpperCase(),
                                          style: GoogleFonts.montserrat(
                                            fontSize: Dimens.SPACE_12,
                                            fontWeight: FontWeight.w700,
                                            color: ColorsItem.orangeFB9600,
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.SPACE_20),
                      _detailHead(),
                      SizedBox(height: Dimens.SPACE_4),
                      _buildChips(),
                      SizedBox(height: Dimens.SPACE_12),
                      _buildTab(),
                    ],
                  ),
                ),
              );
      });

  String _getTitle() {
    switch (_controller.getArgsType()) {
      case Stickit:
        return "Detail ${S.of(context).label_stickit}";
      case Ticket:
        return "Detail ${S.of(context).label_ticket}";
      case Calendar:
        return "Detail ${S.of(context).label_calendar}";
      case Project:
        return "Detail ${_controller.projectObj!.isMilestone ? S.of(context).project_milestone_label : S.of(context).label_project}";
      default:
        return "Detail";
    }
  }

  _popMenu() {
    return PopupMenuButton(
      color: ColorsItem.black020202,
      onSelected: (value) {
        if (value == 0)
          _controller.goToEditPage();
        else if (value == 1)
          print(value);
        else if (value == 2)
          _controller.goToTaskActionPage(TaskActionType.subtask);
        else if (value == 3)
          _controller.goToTaskActionPage(TaskActionType.merge);
        else if (value == 4) print(value);
      },
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          child: FaIcon(FontAwesomeIcons.ellipsisVertical,
              color: ColorsItem.whiteFEFEFE, size: Dimens.SPACE_18)),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: Text(S.of(context).detail_task_edit_label,
                style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteE0E0E0, fontSize: Dimens.SPACE_14))),
        // PopupMenuItem(
        //     value: 1,
        //     child: Text(S.of(context).detail_subtask_create_label,
        //         style: GoogleFonts.montserrat(color: ColorsItem.whiteE0E0E0, fontSize: Dimens.SPACE_14))),
        PopupMenuItem(
            value: 2,
            child: Text(S.of(context).detail_subtask_edit_label,
                style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteE0E0E0, fontSize: Dimens.SPACE_14))),
        PopupMenuItem(
            value: 3,
            child: Text(S.of(context).detail_task_merge_label,
                style: GoogleFonts.montserrat(
                    color: ColorsItem.whiteE0E0E0, fontSize: Dimens.SPACE_14))),
        // PopupMenuItem(
        //     value: 4,
        //     child: Text(S.of(context).detail_task_add_mockup_label,
        //         style: GoogleFonts.montserrat(color: ColorsItem.whiteE0E0E0, fontSize: Dimens.SPACE_14))),
      ],
    );
  }

  Color _getTicketColor(String priority) {
    switch (priority) {
      case Ticket.STATUS_UNBREAK:
        return Colors.pink;
      case Ticket.STATUS_TRIAGE:
        return Colors.purple;
      case Ticket.STATUS_HIGH:
        return Colors.red;
      case Ticket.STATUS_NORMAL:
        return Colors.orange;
      case Ticket.STATUS_LOW:
        return Colors.yellow;
      case Ticket.STATUS_WISHLIST:
        return Colors.lightBlueAccent;
      default:
        return Colors.white;
    }
  }

  Widget _detailHead() {
    switch (_controller.getArgsType()) {
      case Stickit:
        return DetailHead(title: _controller.stickitObj!.name!);

      case Ticket:
        return DetailHead(
            title: _controller.ticketObj!.name!,
            icon: FaIcon(FontAwesomeIcons.circleExclamation,
                color: _getTicketColor(_controller.ticketObj!.priority),
                size: Dimens.SPACE_16));

      case Calendar:
        return DetailHead(
          title: _controller.calendarObj!.name!,
          icon: CircleAvatar(
            backgroundColor: ColorsItem.green219653,
            radius: Dimens.SPACE_8,
          ),
          subtitle:
              "${_controller.parseTime(_controller.calendarObj!.startTime)} - ${_controller.parseTime(_controller.calendarObj!.endTime)}",
        );

      case Project:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHead(
              title: _controller.projectObj!.name!,
              popupMenu: _controller.isAuthor()
                  ? PopupMenuButton(
                      color: ColorsItem.black1F2329,
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            _controller.editProject();
                            break;
                          case 1:
                            _controller
                                .goToMemberPage(ProjectMemberActionType.remove);
                            break;
                          case 2:
                            showCustomAlertDialog(
                              title:
                                  "${_controller.projectObj!.isArchived ? S.of(context).label_enable : S.of(context).project_archive_label} ${_controller.projectObj!.isMilestone ? S.of(context).project_milestone_label : S.of(context).label_project}",
                              subtitle: _controller.projectObj!.isMilestone
                                  ? _controller.projectObj!.isArchived
                                      ? S.of(context).milestone_active_subtitle
                                      : S.of(context).milestone_archive_subtitle
                                  : _controller.projectObj!.isArchived
                                      ? S.of(context).project_active_subtitle
                                      : S.of(context).project_archive_subtitle,
                              cancelButtonText:
                                  S.of(context).label_back.toUpperCase(),
                              confirmButtonText:
                                  _controller.projectObj!.isArchived
                                      ? S.of(context).label_enable.toUpperCase()
                                      : S
                                          .of(context)
                                          .project_archive_label
                                          .toUpperCase(),
                              context: context,
                              onConfirm: () {
                                Navigator.pop(context);
                                _controller.setProjectStatus();
                              },
                              confirmButtonColor: ColorsItem.orangeFB9600,
                              confirmButtonTextColor: ColorsItem.black020202,
                            );
                            break;
                          default:
                            break;
                        }
                      },
                      child: FaIcon(
                        FontAwesomeIcons.bars,
                        color: ColorsItem.whiteFEFEFE,
                        size: Dimens.SPACE_18,
                      ),
                      itemBuilder: (context) => _generatePopUp(context),
                    )
                  : SizedBox(),
            ),
            if (_controller.projectObj!.isMilestone &&
                _controller.getDisplayDateMilestone(context) != null) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidClock,
                      color: ColorsItem.grey666B73,
                      size: Dimens.SPACE_12,
                    ),
                    SizedBox(width: Dimens.SPACE_4),
                    Text(
                      _controller.getDisplayDateMilestone(context)!,
                      style: GoogleFonts.montserrat(
                        color: ColorsItem.grey666B73,
                        fontSize: Dimens.SPACE_12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      default:
        return DetailHead(title: _controller.data!.object.name!);
    }
  }

  List<PopupMenuEntry<int>> _generatePopUp(BuildContext context) {
    List<PopupMenuEntry<int>> popup = [];
    popup.add(
      PopupMenuItem(
        value: 0,
        child: Text(
          "${S.of(context).label_edit} ${_controller.projectObj!.isMilestone ? S.of(context).project_milestone_label : S.of(context).label_project}",
          style: GoogleFonts.montserrat(
            color: ColorsItem.whiteE0E0E0,
            fontSize: Dimens.SPACE_14,
          ),
        ),
      ),
    );

    if (_controller.isAuthor() &&
        !_controller.projectObj!.isMilestone &&
        _controller.subProjects.isEmpty) {
      popup.add(
        PopupMenuItem(
          value: 1,
          child: Text(
            S.of(context).project_member_edit_label,
            style: GoogleFonts.montserrat(
              color: ColorsItem.whiteE0E0E0,
              fontSize: Dimens.SPACE_14,
            ),
          ),
        ),
      );
    }
    popup.add(
      PopupMenuItem(
        value: 2,
        child: Text(
          "${_controller.projectObj!.isArchived ? S.of(context).label_enable : S.of(context).project_archive_label} ${_controller.projectObj!.isMilestone ? S.of(context).project_milestone_label : S.of(context).label_project}",
          style: GoogleFonts.montserrat(
            color: ColorsItem.whiteE0E0E0,
            fontSize: Dimens.SPACE_14,
          ),
        ),
      ),
    );
    return popup;
  }

  Widget _buildChips() {
    switch (_controller.getArgsType()) {
      case Stickit:
        Stickit data = _controller.data!.object as Stickit;
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_4),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                child: Chip(
                  label: Text(
                      (() {
                        switch (data.stickitType) {
                          case Stickit.TYPE_MEMO:
                            return S.of(context).stickit_type_announcement;
                          case Stickit.TYPE_MOM:
                            return S.of(context).stickit_type_mom;
                          case Stickit.TYPE_PITCH:
                            return S.of(context).stickit_type_pitch_idea;
                          case Stickit.TYPE_PRAISE:
                            return S.of(context).stickit_type_praise;
                          default:
                            return "Stick it";
                        }
                      }()),
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.whiteFEFEFE,
                          fontSize: Dimens.SPACE_12)),
                  backgroundColor: ColorsItem.black32373D,
                ),
              )
            ],
          ),
        );

      case Ticket:
        Ticket data = _controller.data!.object as Ticket;
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_4),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                child: Chip(
                  label: Text(
                      "${_controller.ticketObj!.rawStatus!.ucwords()}, ${_controller.ticketObj!.priority.ucwords()}",
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.whiteFEFEFE,
                          fontSize: Dimens.SPACE_12)),
                  backgroundColor: ColorsItem.black32373D,
                ),
              ),
              _controller.ticketObj!.project == null
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_8),
                      child: Chip(
                        avatar: FaIcon(FontAwesomeIcons.userGroup,
                            size: Dimens.SPACE_12,
                            color: ColorsItem.whiteE0E0E0),
                        label: Text(_controller.ticketObj!.project!.name!,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.whiteFEFEFE,
                                fontSize: Dimens.SPACE_12)),
                        backgroundColor: ColorsItem.black32373D,
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                child: Chip(
                  label: Text("${data.storyPoint.ceil()} Story Point(s)",
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.whiteFEFEFE,
                          fontSize: Dimens.SPACE_12)),
                  backgroundColor: ColorsItem.green219653,
                ),
              ),
            ],
          ),
        );

      case Project:
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_4),
          child: Wrap(
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                  child: Chip(
                    label: Text(_controller.getProjectStatus(context),
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_12)),
                    backgroundColor: ColorsItem.black32373D,
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                child: Chip(
                  avatar: FaIcon(FontAwesomeIcons.businessTime,
                      size: Dimens.SPACE_12, color: ColorsItem.whiteE0E0E0),
                  label: Text(_controller.userData.workspace,
                      style: GoogleFonts.montserrat(
                          color: ColorsItem.whiteFEFEFE,
                          fontSize: Dimens.SPACE_12)),
                  backgroundColor: ColorsItem.black32373D,
                ),
              ),
            ],
          ),
        );

      case Calendar:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_4),
              child: Wrap(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                    child: Chip(
                      label: Text(
                        _controller.getCalendarStatus(),
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_12),
                      ),
                      backgroundColor: ColorsItem.black32373D,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
                    child: Chip(
                      avatar: FaIcon(FontAwesomeIcons.businessTime,
                          size: Dimens.SPACE_12, color: ColorsItem.whiteE0E0E0),
                      label: Text(
                        _controller.getCalendarPolicy(),
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE,
                            fontSize: Dimens.SPACE_12),
                      ),
                      backgroundColor: ColorsItem.black32373D,
                    ),
                  ),
                  if (_controller.isJoinedOrDeclined(true) ||
                      _controller.isJoinedOrDeclined(false))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.SPACE_8),
                      child: Chip(
                        avatar: FaIcon(
                            _controller.isJoinedOrDeclined(true)
                                ? FontAwesomeIcons.check
                                : FontAwesomeIcons.xmark,
                            size: Dimens.SPACE_12,
                            color: ColorsItem.whiteE0E0E0),
                        label: Text(
                          _controller.isJoinedOrDeclined(true)
                              ? S.of(context).room_detail_attended_label
                              : S.of(context).room_detail_declined_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.whiteFEFEFE,
                              fontSize: Dimens.SPACE_12),
                        ),
                        backgroundColor: ColorsItem.black32373D,
                      ),
                    )
                ],
              ),
            ),
            _controller.isJoinedOrDeclined(true) ||
                    _controller.isJoinedOrDeclined(false)
                ? SizedBox()
                : SizedBox(height: Dimens.SPACE_12),
            _controller.isJoinedOrDeclined(true) ||
                    _controller.isJoinedOrDeclined(false)
                ? SizedBox()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDefault(
                          buttonText: S.of(context).label_no.toUpperCase(),
                          buttonTextColor: ColorsItem.whiteFEFEFE,
                          buttonColor: Colors.transparent,
                          buttonLineColor: ColorsItem.whiteFEFEFE,
                          onTap: () => _controller.onCalendarAct(false),
                          width: MediaQuery.of(context).size.width / 2.5,
                          buttonIcon: Icon(Icons.close,
                              color: ColorsItem.whiteFEFEFE,
                              size: Dimens.SPACE_12),
                          paddingVertical: Dimens.SPACE_6,
                          isVisible: _controller.isInvited(),
                        ),
                        ButtonDefault(
                          buttonText:
                              S.of(context).lobby_join_label.toUpperCase(),
                          buttonTextColor: ColorsItem.orangeFB9600,
                          buttonColor: Colors.transparent,
                          buttonLineColor: ColorsItem.orangeFB9600,
                          onTap: () => _controller.onCalendarAct(true),
                          width: MediaQuery.of(context).size.width / 2.5,
                          buttonIcon: Icon(Icons.check,
                              color: ColorsItem.orangeFB9600,
                              size: Dimens.SPACE_12),
                          paddingVertical: Dimens.SPACE_6,
                        )
                      ],
                    ),
                  )
          ],
        );

      default:
        return SizedBox();
    }
  }

  Widget _buildTab() {
    return Expanded(
      child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                  indicatorColor: ColorsItem.orangeFB9600,
                  unselectedLabelColor: ColorsItem.grey666B73,
                  labelColor: ColorsItem.orangeFB9600,
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.clockRotateLeft),
                          SizedBox(width: Dimens.SPACE_12),
                          Text(S.of(context).label_history,
                              style: GoogleFonts.montserrat())
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.circleInfo),
                          SizedBox(width: Dimens.SPACE_12),
                          Text(S.of(context).label_info,
                              style: GoogleFonts.montserrat())
                        ],
                      ),
                    ),
                  ]),
              Expanded(
                  child: TabBarView(
                children: [_tabHistory(), _tabInfo()],
              ))
            ],
          )),
    );
  }

  Widget _tabHistory() {
    switch (_controller.getArgsType()) {
      case Stickit:
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Text(
                      S.of(context).room_detail_recent_activities.toUpperCase(),
                      style:
                          GoogleFonts.montserrat(color: ColorsItem.grey858A93)),
                ),
                ListView.builder(
                    itemCount: _controller.transactions?.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Container(
                        child: TransactionItem(
                          avatar:
                              _controller.transactions![index].actor.avatar!,
                          transactionAuthor:
                              "<bold>${_controller.transactions![index].actor.name}</bold>",
                          transactionContent:
                              "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                          dateTime: _controller.parseTime(
                              _controller.transactions![index].createdAt),
                          onReact: () {
                            showReactionBottomSheet(
                                context: context,
                                reactions: [],
                                onReactionClicked: (reaction) {
                                  _controller.sendReaction(reaction.id,
                                      _controller.transactions![index].id);
                                });
                          },
                          onLongTapReaction: (reactionData, reactionId) {
                            _controller.showAuthorsReaction(
                              _controller.transactions![index].id,
                              reactionData,
                              reactionId,
                            );
                          },
                          isReactable:
                              _controller.transactions![index].isReactable(),
                          reactionList:
                              _controller.transactions![index].reactions ?? [],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.SPACE_16),
                    decoration: BoxDecoration(color: ColorsItem.black191C21),
                    child: Column(
                      children: [
                        Theme(
                          data: new ThemeData(
                            primaryColor: ColorsItem.grey666B73,
                            primaryColorDark: ColorsItem.grey666B73,
                          ),
                          child: TextField(
                            cursorColor: ColorsItem.whiteFEFEFE,
                            style: GoogleFonts.montserrat(
                                color: ColorsItem.whiteFEFEFE),
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorsItem.grey666B73)),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ColorsItem.grey666B73)),
                              hintText: S.of(context).room_detail_comment_hint,
                              hintStyle: GoogleFonts.montserrat(
                                  color: ColorsItem.grey666B73),
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            controller: _controller.commentController,
                          ),
                        ),
                        SizedBox(height: Dimens.SPACE_12),
                        ButtonDefault(
                          buttonTextColor: ColorsItem.black020202,
                          buttonText: S.of(context).label_submit,
                          buttonLineColor: Colors.transparent,
                          buttonColor: ColorsItem.orangeFB9600,
                          radius: Dimens.SPACE_4,
                          letterSpacing: 1.5,
                          onTap: _controller.createStickitTransaction,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      case Ticket:
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Text(
                      S.of(context).room_detail_recent_activities.toUpperCase(),
                      style:
                          GoogleFonts.montserrat(color: ColorsItem.grey858A93)),
                ),
                ListView.builder(
                    itemCount: _controller.transactions?.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Container(
                        child: TransactionItem(
                          avatar:
                              _controller.transactions![index].actor.avatar!,
                          transactionAuthor:
                              "<bold>${_controller.transactions![index].actor.name}</bold>",
                          transactionContent:
                              "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                          dateTime: _controller.parseTime(
                              _controller.transactions![index].createdAt),
                          onReact: () {
                            showReactionBottomSheet(
                                context: context,
                                reactions: [],
                                onReactionClicked: (reaction) {
                                  _controller.sendReaction(reaction.id,
                                      _controller.transactions![index].id);
                                });
                          },
                          onLongTapReaction: (reactionData, reactionId) {
                            _controller.showAuthorsReaction(
                              _controller.transactions![index].id,
                              reactionData,
                              reactionId,
                            );
                          },
                          isReactable:
                              _controller.transactions![index].isReactable(),
                          type: _controller.transactions![index].type!,
                          attachments:
                              _controller.transactions![index].attachments!,
                          reactionList:
                              _controller.transactions![index].reactions ?? [],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.SPACE_16),
                    decoration: BoxDecoration(color: ColorsItem.black191C21),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonDefault(
                                buttonText:
                                    S.of(context).room_detail_add_action,
                                buttonTextColor: ColorsItem.orangeFB9600,
                                buttonColor: Colors.transparent,
                                buttonLineColor: ColorsItem.orangeFB9600,
                                buttonIcon: Icon(Icons.add,
                                    color: ColorsItem.orangeFB9600),
                                radius: Dimens.SPACE_40,
                                paddingHorizontal: Dimens.SPACE_12,
                                paddingVertical: Dimens.SPACE_8,
                                letterSpacing: 1.5,
                                onTap: () {
                                  _controller.addActionClicked();
                                }),
                          ],
                        ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: Dimens.SPACE_12),
                                _buildDeletableActionItem(),
                                SizedBox(height: Dimens.SPACE_12),
                                Theme(
                                  data: new ThemeData(
                                    primaryColor: ColorsItem.grey666B73,
                                    primaryColorDark: ColorsItem.grey666B73,
                                  ),
                                  child: TextField(
                                    cursorColor: ColorsItem.whiteFEFEFE,
                                    style: GoogleFonts.montserrat(
                                        color: ColorsItem.whiteFEFEFE,
                                        fontSize: Dimens.SPACE_14),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsItem.grey666B73)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsItem.grey666B73)),
                                      hintText: S
                                          .of(context)
                                          .room_detail_comment_hint,
                                      hintStyle: GoogleFonts.montserrat(
                                          color: ColorsItem.grey666B73),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    controller: _controller.commentController,
                                  ),
                                ),
                                SizedBox(height: Dimens.SPACE_12),
                                ButtonDefault(
                                  buttonTextColor: ColorsItem.black020202,
                                  buttonText: S.of(context).label_submit,
                                  buttonLineColor: Colors.transparent,
                                  buttonColor: ColorsItem.orangeFB9600,
                                  radius: Dimens.SPACE_8,
                                  letterSpacing: 1.5,
                                  onTap: _controller.createTaskTransaction,
                                ),
                              ],
                            ),
                            _controller.onAddActionClicked
                                ? Column(
                                    children: [
                                      SizedBox(height: Dimens.SPACE_4),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: ColorsItem.black020202,
                                            borderRadius: BorderRadius.circular(
                                                Dimens.SPACE_8)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimens.SPACE_4),
                                        child: ListView.builder(
                                            itemCount:
                                                _controller.getActions().length,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemBuilder: (context, index) {
                                              if (_controller
                                                          .ticketObj!.project ==
                                                      null &&
                                                  index == 4) {
                                                return SizedBox();
                                              }
                                              return Container(
                                                  padding: EdgeInsets.all(
                                                      Dimens.SPACE_12),
                                                  color: ColorsItem.black020202,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _controller
                                                          .actionClicked(index);
                                                      _controller
                                                          .addActionClicked();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            _controller
                                                                    .getActions()[
                                                                index],
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE),
                                                          ),
                                                        ),
                                                        _controller.actionSet
                                                                .contains(index)
                                                            ? Icon(Icons.check,
                                                                color: ColorsItem
                                                                    .orangeFB9600)
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                  ));
                                            }),
                                      )
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      case Calendar:
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Text(
                      S.of(context).room_detail_recent_activities.toUpperCase(),
                      style:
                          GoogleFonts.montserrat(color: ColorsItem.grey858A93)),
                ),
                ListView.builder(
                    itemCount: _controller.transactions?.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Container(
                        child: TransactionItem(
                          avatar:
                              _controller.transactions![index].actor.avatar!,
                          transactionAuthor:
                              "<bold>${_controller.transactions![index].actor.name}</bold>",
                          transactionContent:
                              "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                          dateTime: _controller.parseTime(
                              _controller.transactions![index].createdAt),
                          onReact: () {
                            showReactionBottomSheet(
                                context: context,
                                reactions: [],
                                onReactionClicked: (reaction) {
                                  _controller.sendReaction(reaction.id,
                                      _controller.transactions![index].id);
                                });
                          },
                          onLongTapReaction: (reactionData, reactionId) {
                            _controller.showAuthorsReaction(
                              _controller.transactions![index].id,
                              reactionData,
                              reactionId,
                            );
                          },
                          isReactable:
                              _controller.transactions![index].isReactable(),
                          reactionList:
                              _controller.transactions![index].reactions ?? [],
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Container(
                    padding: EdgeInsets.all(Dimens.SPACE_16),
                    decoration: BoxDecoration(color: ColorsItem.black191C21),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonDefault(
                                buttonText:
                                    S.of(context).room_detail_add_action,
                                buttonTextColor: ColorsItem.orangeFB9600,
                                buttonColor: Colors.transparent,
                                buttonLineColor: ColorsItem.orangeFB9600,
                                buttonIcon: Icon(Icons.add,
                                    color: ColorsItem.orangeFB9600),
                                radius: Dimens.SPACE_40,
                                paddingHorizontal: Dimens.SPACE_12,
                                paddingVertical: Dimens.SPACE_8,
                                letterSpacing: 1.5,
                                onTap: () {
                                  _controller.addActionClicked();
                                }),
                          ],
                        ),
                        Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: Dimens.SPACE_12),
                                _buildDeletableActionItem(),
                                SizedBox(height: Dimens.SPACE_12),
                                Theme(
                                  data: new ThemeData(
                                    primaryColor: ColorsItem.grey666B73,
                                    primaryColorDark: ColorsItem.grey666B73,
                                  ),
                                  child: TextField(
                                    cursorColor: ColorsItem.whiteFEFEFE,
                                    style: GoogleFonts.montserrat(
                                        color: ColorsItem.whiteFEFEFE),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsItem.grey666B73)),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: ColorsItem.grey666B73)),
                                      hintText: S
                                          .of(context)
                                          .room_detail_comment_hint,
                                      hintStyle: GoogleFonts.montserrat(
                                          color: ColorsItem.grey666B73),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    controller: _controller.commentController,
                                  ),
                                ),
                                SizedBox(height: Dimens.SPACE_12),
                                ButtonDefault(
                                  buttonTextColor: ColorsItem.black020202,
                                  buttonText: S.of(context).label_submit,
                                  buttonLineColor: Colors.transparent,
                                  buttonColor: ColorsItem.orangeFB9600,
                                  radius: Dimens.SPACE_4,
                                  onTap: _controller.createCalendarTransaction,
                                ),
                              ],
                            ),
                            _controller.onAddActionClicked
                                ? Column(
                                    children: [
                                      SizedBox(height: Dimens.SPACE_4),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: ColorsItem.black020202,
                                            borderRadius: BorderRadius.circular(
                                                Dimens.SPACE_8)),
                                        padding: EdgeInsets.symmetric(
                                            vertical: Dimens.SPACE_4),
                                        child: ListView.builder(
                                            itemCount:
                                                _controller.getActions().length,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                  padding: EdgeInsets.all(
                                                      Dimens.SPACE_12),
                                                  color: ColorsItem.black020202,
                                                  child: InkWell(
                                                    onTap: () {
                                                      _controller
                                                          .actionClicked(index);
                                                      _controller
                                                          .addActionClicked();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            _controller
                                                                    .getActions()[
                                                                index],
                                                            style: GoogleFonts
                                                                .montserrat(
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE),
                                                          ),
                                                        ),
                                                        _controller.actionSet
                                                                .contains(index)
                                                            ? Icon(Icons.check,
                                                                color: ColorsItem
                                                                    .orangeFB9600)
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                  ));
                                            }),
                                      )
                                    ],
                                  )
                                : SizedBox()
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      case Project:
        return Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimens.SPACE_20),
                  child: Text(
                      S.of(context).room_detail_recent_activities.toUpperCase(),
                      style:
                          GoogleFonts.montserrat(color: ColorsItem.grey858A93)),
                ),
                ListView.builder(
                    itemCount: _controller.transactions?.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Container(
                        child: TransactionItem(
                          avatar:
                              _controller.transactions![index].actor.avatar!,
                          transactionAuthor:
                              "<bold>${_controller.transactions![index].actor.name}</bold>",
                          transactionContent:
                              "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                          dateTime: _controller.parseTime(
                              _controller.transactions![index].createdAt),
                        ),
                      );
                    }),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _tabInfo() {
    switch (_controller.getArgsType()) {
      case Stickit:
        return Container(
          padding: EdgeInsets.all(Dimens.SPACE_20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).room_detail_description_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_8),
                      HtmlWidget(
                        """${_controller.stickitObj!.htmlContent}""",
                        textStyle: TextStyle(
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.whiteFEFEFE,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500,
                        ),
                        onTapUrl: (url) => _controller.onOpen(url),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimens.SPACE_16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).room_detail_written_by_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_8),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: Dimens.SPACE_5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: Dimens.SPACE_2,
                                    color: ColorsItem.whiteFEFEFE),
                              ),
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  _controller.stickitObj!.author.avatar!,
                                ),
                                radius: Dimens.SPACE_14,
                              )),
                          SizedBox(width: Dimens.SPACE_8),
                          Text(_controller.stickitObj!.author.getFullName()!,
                              style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteFEFEFE))
                        ],
                      ),
                      SizedBox(height: Dimens.SPACE_12),
                      Text(S.of(context).room_detail_seen_by_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_8),
                      Wrap(
                        spacing: -8.0,
                        children: List.generate(
                            _controller.stickitObj!.spectators!.length,
                            (index) => Container(
                                margin: EdgeInsets.only(top: Dimens.SPACE_5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: Dimens.SPACE_2,
                                      color: ColorsItem.whiteFEFEFE),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    _controller
                                        .stickitObj!.spectators![index].avatar!,
                                  ),
                                  radius: Dimens.SPACE_14,
                                ))),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case Ticket:
        return Container(
          padding: EdgeInsets.all(Dimens.SPACE_20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_controller.hasDependencies())
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimens.SPACE_16),
                    margin: EdgeInsets.only(bottom: Dimens.SPACE_16),
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1, color: ColorsItem.black32373D),
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_controller.isHasParentTask &&
                              _controller.isHasSubtasks) ...[
                            Column(
                              children: [
                                renderDependencies(
                                  _controller.parentTaskLength,
                                  _controller,
                                  S.of(context).label_parent_task,
                                  _controller.parenTask,
                                ),
                                Divider(
                                  color: ColorsItem.black32373D,
                                  thickness: 1,
                                  height: Dimens.SPACE_25,
                                ),
                                renderDependencies(
                                  _controller.subTaskLength,
                                  _controller,
                                  S.of(context).label_branch_task,
                                  _controller.subtask,
                                ),
                              ],
                            )
                          ] else if (_controller.isHasParentTask ||
                              _controller.isHasSubtasks) ...[
                            renderDependencies(
                              _controller.parentTaskLength != 0
                                  ? _controller.parentTaskLength
                                  : _controller.subTaskLength,
                              _controller,
                              _controller.isHasParentTask
                                  ? S.of(context).label_parent_task
                                  : S.of(context).label_branch_task,
                              _controller.isHasParentTask
                                  ? _controller.parenTask
                                  : _controller.subtask,
                            ),
                          ],
                        ]),
                  ),
                _controller.hasMocks()
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Dimens.SPACE_16),
                        margin: EdgeInsets.only(bottom: Dimens.SPACE_16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: ColorsItem.black32373D),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.SPACE_8))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).detail_task_mocks_label,
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.grey666B73)),
                            SizedBox(height: Dimens.SPACE_10),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index > 0
                                        ? Divider(
                                            color: ColorsItem.black32373D,
                                            thickness: 1,
                                            height: Dimens.SPACE_25,
                                          )
                                        : SizedBox(),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.camera,
                                          color: ColorsItem.grey858A93,
                                          size: Dimens.SPACE_16,
                                        ),
                                        SizedBox(width: Dimens.SPACE_8),
                                        Expanded(
                                          child: Text(
                                            _controller.ticketObj!.name!,
                                            style: GoogleFonts.montserrat(
                                                color: ColorsItem.green00A1B0,
                                                fontSize: Dimens.SPACE_14,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                _controller.hasDuplicates()
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Dimens.SPACE_16),
                        margin: EdgeInsets.only(bottom: Dimens.SPACE_16),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: ColorsItem.black32373D),
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.SPACE_8))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).detail_task_duplicates_label,
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.grey666B73)),
                            SizedBox(height: Dimens.SPACE_10),
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    index > 0
                                        ? Divider(
                                            color: ColorsItem.black32373D,
                                            thickness: 1,
                                            height: Dimens.SPACE_25,
                                          )
                                        : SizedBox(),
                                    Row(
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.clone,
                                          color: ColorsItem.grey858A93,
                                          size: Dimens.SPACE_16,
                                        ),
                                        SizedBox(width: Dimens.SPACE_8),
                                        Expanded(
                                          child: Text(
                                            "${_controller.ticketObj!.code}: ${_controller.ticketObj!.name!}",
                                            style: GoogleFonts.montserrat(
                                                color: ColorsItem.green00A1B0,
                                                fontSize: Dimens.SPACE_14,
                                                letterSpacing: 0.2,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).room_detail_description_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_8),
                      Linkify(
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE),
                        text: _controller.ticketObj!.description,
                        onOpen: (link) {
                          _controller.onOpen(link.url);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: Dimens.SPACE_16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).room_detail_assigned_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_4),
                      _controller.ticketObj!.assignee == null
                          ? SizedBox(height: Dimens.SPACE_20)
                          : Row(
                              children: [
                                Container(
                                    margin:
                                        EdgeInsets.only(top: Dimens.SPACE_5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: Dimens.SPACE_2,
                                          color: ColorsItem.whiteFEFEFE),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        _controller
                                            .ticketObj!.assignee!.avatar!,
                                      ),
                                      radius: Dimens.SPACE_14,
                                    )),
                                SizedBox(width: Dimens.SPACE_8),
                                Text(
                                    _controller.ticketObj?.assignee
                                            ?.getFullName() ??
                                        "",
                                    style: GoogleFonts.montserrat(
                                        color: ColorsItem.whiteFEFEFE))
                              ],
                            ),
                      SizedBox(height: Dimens.SPACE_12),
                      Text(S.of(context).room_detail_authored_by_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_4),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: Dimens.SPACE_5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: Dimens.SPACE_2,
                                    color: ColorsItem.whiteFEFEFE),
                              ),
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  _controller.ticketObj!.author!.avatar!,
                                ),
                                radius: Dimens.SPACE_14,
                              )),
                          SizedBox(width: Dimens.SPACE_8),
                          Text(_controller.ticketObj!.author!.getFullName()!,
                              style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteFEFEFE))
                        ],
                      ),
                      SizedBox(height: Dimens.SPACE_12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case Calendar:
        return Container(
          padding: EdgeInsets.all(Dimens.SPACE_20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).room_detail_description_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_8),
                      Linkify(
                        style: GoogleFonts.montserrat(
                            color: ColorsItem.whiteFEFEFE),
                        text: _controller.calendarObj!.description,
                        onOpen: (link) {
                          _controller.onOpen(link.url);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(height: Dimens.SPACE_16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).room_detail_authored_by_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_4),
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: Dimens.SPACE_5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: Dimens.SPACE_2,
                                    color: ColorsItem.whiteFEFEFE),
                              ),
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  _controller.calendarObj!.host.avatar!,
                                ),
                                radius: Dimens.SPACE_14,
                              )),
                          SizedBox(width: Dimens.SPACE_8),
                          Text(_controller.calendarObj!.host.getFullName()!,
                              style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteFEFEFE))
                        ],
                      ),
                      SizedBox(height: Dimens.SPACE_12),
                      Text(S.of(context).room_detail_attended_by_label,
                          style: GoogleFonts.montserrat(
                              color: ColorsItem.grey666B73)),
                      SizedBox(height: Dimens.SPACE_4),
                      Wrap(
                        spacing: -8.0,
                        children: List.generate(
                            _controller.calendarObj!.invitees!.length,
                            (index) => Container(
                                margin: EdgeInsets.only(top: Dimens.SPACE_5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: Dimens.SPACE_2,
                                      color: ColorsItem.whiteFEFEFE),
                                ),
                                child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    _controller
                                        .calendarObj!.invitees![index].avatar!,
                                  ),
                                  radius: Dimens.SPACE_14,
                                ))),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case Project:
        return Container(
          padding: EdgeInsets.all(Dimens.SPACE_20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _controller.projectObj!.description != ""
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(Dimens.SPACE_16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: ColorsItem.black32373D),
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              Dimens.SPACE_8,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).room_detail_description_label,
                              style: GoogleFonts.montserrat(
                                color: ColorsItem.grey666B73,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: Dimens.SPACE_8),
                            Linkify(
                              style: GoogleFonts.montserrat(
                                  color: ColorsItem.whiteFEFEFE),
                              text: _controller.projectObj!.description,
                              onOpen: (link) {
                                _controller.onOpen(link.url);
                              },
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
                !_controller.projectObj!.isMilestone
                    ? SizedBox(height: Dimens.SPACE_16)
                    : SizedBox(),
                !_controller.projectObj!.isMilestone
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(Dimens.SPACE_16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: ColorsItem.black32373D),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    S.of(context).project_sub_project_label,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14.0,
                                      color: ColorsItem.grey666B73,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _controller.isAuthor() &&
                                        !_controller.projectObj!.isMilestone
                                    ? ButtonDefault(
                                        buttonIcon: Icon(
                                          Icons.add,
                                          color: ColorsItem.orangeFB9600,
                                        ),
                                        buttonText: "NEW",
                                        letterSpacing: 1.5,
                                        buttonTextColor:
                                            ColorsItem.orangeFB9600,
                                        buttonColor: Colors.transparent,
                                        buttonLineColor: Colors.transparent,
                                        paddingHorizontal: 0,
                                        paddingVertical: 0,
                                        fontSize: Dimens.SPACE_12,
                                        onTap: () {
                                          _controller.addSubProject();
                                        },
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _controller.subProjects.length,
                              itemBuilder: (context, index) {
                                return ProjectList(
                                  onTap: () {
                                    _controller.goToDetail(
                                        _controller.subProjects[index]);
                                  },
                                  projectName:
                                      _controller.subProjects[index].name!,
                                  joinDate: "",
                                  status:
                                      _controller.subProjects[index].isArchived
                                          ? S.of(context).label_archive
                                          : S.of(context).status_task_open,
                                  index: index,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                !_controller.projectObj!.isMilestone
                    ? SizedBox(height: Dimens.SPACE_16)
                    : SizedBox(),
                !_controller.projectObj!.isMilestone
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(Dimens.SPACE_16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: ColorsItem.black32373D),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    S.of(context).project_milestone_label,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 14.0,
                                      color: ColorsItem.grey666B73,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _controller.isAuthor() &&
                                        !_controller.projectObj!.isMilestone
                                    ? ButtonDefault(
                                        buttonIcon: Icon(
                                          Icons.add,
                                          color: ColorsItem.orangeFB9600,
                                        ),
                                        buttonText: "NEW",
                                        letterSpacing: 1.5,
                                        buttonTextColor:
                                            ColorsItem.orangeFB9600,
                                        buttonColor: Colors.transparent,
                                        buttonLineColor: Colors.transparent,
                                        paddingHorizontal: 0,
                                        paddingVertical: 0,
                                        fontSize: Dimens.SPACE_12,
                                        onTap: () {
                                          _controller.addMilestone();
                                        },
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _controller.milestones.length,
                              itemBuilder: (context, index) {
                                return ProjectList(
                                  onTap: () {
                                    _controller.goToDetail(
                                        _controller.milestones[index]);
                                  },
                                  projectName:
                                      _controller.milestones[index].name!,
                                  joinDate: "",
                                  isMilestone: true,
                                  status:
                                      _controller.milestones[index].isArchived
                                          ? S.of(context).label_archive
                                          : S.of(context).status_task_open,
                                  index: index,
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                SizedBox(height: Dimens.SPACE_16),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Dimens.SPACE_16),
                  decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: ColorsItem.black32373D),
                      borderRadius:
                          BorderRadius.all(Radius.circular(Dimens.SPACE_8))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              S.of(context).rooms_member_label,
                              style: GoogleFonts.montserrat(
                                fontSize: 14.0,
                                color: ColorsItem.grey666B73,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _controller.isAuthor() &&
                                  !_controller.projectObj!.isMilestone &&
                                  _controller.subProjects.isEmpty
                              ? ButtonDefault(
                                  buttonIcon: Icon(
                                    Icons.add,
                                    color: ColorsItem.orangeFB9600,
                                  ),
                                  buttonText: "NEW",
                                  letterSpacing: 1.5,
                                  buttonTextColor: ColorsItem.orangeFB9600,
                                  buttonColor: Colors.transparent,
                                  buttonLineColor: Colors.transparent,
                                  paddingHorizontal: 0,
                                  paddingVertical: 0,
                                  fontSize: Dimens.SPACE_12,
                                  onTap: () {
                                    _controller.goToMemberPage(
                                        ProjectMemberActionType.add);
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(height: Dimens.SPACE_4),
                      Wrap(
                        spacing: -8.0,
                        children: List.generate(
                          _controller.projectObj!.members!.length,
                          (index) => Container(
                            margin: EdgeInsets.only(top: Dimens.SPACE_5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: Dimens.SPACE_2,
                                  color: ColorsItem.whiteFEFEFE),
                            ),
                            child: CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(
                                _controller.projectObj!.members![index].avatar!,
                              ),
                              radius: Dimens.SPACE_14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _buildDeletableActionItem() {
    List<Widget> items = new List.empty(growable: true);
    for (int a in _controller.actionSet) {
      items.add(DeletableItem(
        action: a,
        controller: _controller,
        text: _controller.getActions()[a],
        dropdownItems: _controller.getDropdownItems(a),
        itemType: _getDeletableItemType(a),
        onDelete: () {
          _controller.onDeleteItem(a);
        },
      ));
    }
    return Column(children: items);
  }

  // Hardcoded based on getActions() from controller, fix it later
  String _getDeletableItemType(int index) {
    switch (_controller.getArgsType()) {
      case Stickit:
        return "";
      case Ticket:
        switch (index) {
          case 0:
            return DeletableItem.SEARCH_TYPE;
          case 1:
            return DeletableItem.DROPDOWN_TYPE;
          case 2:
            return DeletableItem.DROPDOWN_TYPE;
          case 3:
            return "";
          case 4:
            return DeletableItem.DROPDOWN_TYPE;
          case 5:
            return DeletableItem.SEARCH_TYPE;
          case 6:
            return DeletableItem.SEARCH_TYPE;
          default:
            return "";
        }
      case Calendar:
        return DeletableItem.SEARCH_TYPE;
      default:
        return "Detail";
    }
  }

  Widget renderDependencies(
    int length,
    DetailController _controller,
    String title,
    List<Ticket> data,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8, vertical: Dimens.SPACE_6),
          decoration: BoxDecoration(
            color: ColorsItem.black32373D,
            borderRadius: BorderRadius.circular(Dimens.SPACE_20),
          ),
          child: Text(title,
              style: GoogleFonts.montserrat(color: ColorsItem.grey666B73)),
        ),
        SizedBox(height: Dimens.SPACE_10),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                S.of(context).label_status,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  color: ColorsItem.whiteFEFEFE,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                S.of(context).create_form_assignee_label,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  color: ColorsItem.whiteFEFEFE,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                S.of(context).main_task_tab_title,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_14,
                  color: ColorsItem.whiteFEFEFE,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: Dimens.SPACE_12,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                index > 0
                    ? Divider(
                        color: ColorsItem.black32373D,
                        thickness: 1,
                        height: Dimens.SPACE_25,
                      )
                    : SizedBox(),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimens.SPACE_8,
                            vertical: Dimens.SPACE_6),
                        child: Wrap(
                          children: [
                            Text("${data[index].status}",
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.whiteFEFEFE,
                                    fontSize: Dimens.SPACE_12)),
                            Text("${data[index].priority}",
                                style: GoogleFonts.montserrat(
                                    color: ColorsItem.whiteFEFEFE,
                                    fontSize: Dimens.SPACE_12)),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: ColorsItem.black32373D,
                          borderRadius: BorderRadius.circular(Dimens.SPACE_20),
                        ),
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(width: Dimens.SPACE_6),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${data[index].assignee?.name ?? "-"}",
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.whiteFEFEFE,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: Dimens.SPACE_6),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "${data[index].code}",
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_14,
                          color: ColorsItem.green00A1B0,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
