import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/board_ticket_item.dart';
import 'package:mobile_sev2/app/ui/pages/detail_project/workboard/controller.dart';
import 'package:mobile_sev2/domain/project.dart';
import 'package:mobile_sev2/domain/ticket.dart';

class WorkboardPage extends View {
  final Object? arguments;

  WorkboardPage({this.arguments});

  @override
  _WorkboardState createState() => _WorkboardState(
        AppComponent.getInjector().get<WorkboardController>(),
        arguments,
      );
}

class _WorkboardState extends ViewState<WorkboardPage, WorkboardController> {
  WorkboardController _controller;

  _WorkboardState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<WorkboardController>(builder: (
          context,
          controller,
        ) {
          return WillPopScope(
            onWillPop: () async {
              if (_controller.isDragging) {
                return false;
              }
              return true;
            },
            child: Scaffold(
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
                      onPressed: () => _controller
                          .backToPreviousPage() //Navigator.pop(context),
                      ),
                  title: Text(
                    _controller.projectName,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_16,
                    ),
                  ),
                  suffix: Row(
                    children: [
                      _filterMenu(),
                      _popMenu(),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                ),
              ),
              body: _controller.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _controller.projectView == ProjectView.board
                      ? PageView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _controller.pageController,
                          itemCount: _controller.projectColumns.length,
                          itemBuilder: (context, index) {
                            bool isLastColumn =
                                index == _controller.projectColumns.length - 1;
                            return _dropZoneArea(
                              context: context,
                              column: _controller.projectColumns[index],
                              idxColumn: index,
                              isLastColumn: isLastColumn,
                            );
                          },
                        )
                      : SingleChildScrollView(
                          child: ListView.separated(
                            primary: false,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    SizedBox(height: Dimens.SPACE_16),
                                    _listViewProject(
                                        _controller.projectColumns[index]),
                                  ],
                                );
                              }
                              return _listViewProject(
                                  _controller.projectColumns[index]);
                            },
                            itemCount: _controller.projectColumns.length,
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: Dimens.SPACE_8);
                            },
                          ),
                        ),
            ),
          );
        }),
      );

  Widget _listViewProject(ProjectColumn projectColumns) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsItem.grey666B73),
        borderRadius: BorderRadius.circular(Dimens.SPACE_8),
      ),
      margin: EdgeInsets.symmetric(horizontal: Dimens.SPACE_12),
      padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_4),
      child: ExpandablePanel(
        theme: ExpandableThemeData(
          iconColor: ColorsItem.grey606060,
          iconSize: Dimens.SPACE_35,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
        ),
        header: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  "${projectColumns.name}",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                " (${projectColumns.tasks?.length})",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_16,
                  color: ColorsItem.grey8D9299,
                ),
              ),
            ],
          ),
        ),
        collapsed: SizedBox(),
        expanded: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: projectColumns.tasks?.length,
            itemBuilder: (context, index) {
              Ticket ticket = projectColumns.tasks![index];
              return Container(
                padding: index == 0
                    ? EdgeInsets.only(
                        top: Dimens.SPACE_12,
                        bottom: Dimens.SPACE_6,
                        left: Dimens.SPACE_12,
                        right: Dimens.SPACE_12,
                      )
                    : index + 1 == projectColumns.tasks?.length
                        ? EdgeInsets.only(
                            top: Dimens.SPACE_6,
                            bottom: Dimens.SPACE_12,
                            left: Dimens.SPACE_12,
                            right: Dimens.SPACE_12,
                          )
                        : EdgeInsets.symmetric(
                            vertical: Dimens.SPACE_6,
                            horizontal: Dimens.SPACE_12,
                          ),
                child: Column(
                  children: [
                    BoardTicketItem(
                      code: ticket.code,
                      title: ticket.name ?? '',
                      onTap: () {
                        _controller.goToDetail(projectColumns.tasks![index]);
                      },
                      avatar: ticket.avatar,
                      point: ticket.storyPoint,
                    ),
                    Divider(
                      color: ColorsItem.white9E9E9E,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _popMenu() {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 0) {
            _controller.goToCreateColumn();
          } else if (value == 2) {
            _controller.changeView();
          } else if (value == 3) {
            _controller.reportWorkboard();
          } else {
            _controller.goToColumnList();
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: FaIcon(
              FontAwesomeIcons.ellipsisVertical,
              size: Dimens.SPACE_18,
            )),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "${S.of(context).label_add} ${S.of(context).label_column}",
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // PopupMenuItem(
              //   value: 1,
              //   child: Text(
              //     "${S.of(context).label_reorder} ${S.of(context).label_column}",
              //     style: GoogleFonts.montserrat(
              //       fontSize: Dimens.SPACE_14,
              //       fontWeight: FontWeight.w500,
              //       color: ColorsItem.whiteE0E0E0,
              //     ),
              //   ),
              // ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  _controller.projectView == ProjectView.board
                      ? S.of(context).project_list_view
                      : S.of(context).project_kanban_view,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  "${S.of(context).label_report} Workboard",
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]);
  }

  Widget _dropZoneArea({
    required BuildContext context,
    required ProjectColumn column,
    required int idxColumn,
    bool isLastColumn = false,
  }) {
    return DragTarget(
      builder: (
        context,
        accepted,
        rejected,
      ) {
        return _column(
          isLastColumn,
          context,
          column,
          idxColumn,
        );
      },
      onWillAccept: (data) {
        _controller.onWillAccept(
          column.name,
          idxColumn,
        );
        return true;
      },
      onAccept: (data) {
        data as Map<String, dynamic>;
        if (idxColumn != data["movedFromIdx"]) {
          _controller.onDroppedTask(
            data["movedFromIdx"],
            idxColumn,
            data["idxTicket"],
            data["ticket"],
          );
        } else {
          _controller.clearMoveHistory();
        }
      },
    );
  }

  Widget _column(
    bool isLastColumn,
    BuildContext context,
    ProjectColumn column,
    int idxColumn,
  ) {
    return Container(
      margin: isLastColumn
          ? EdgeInsets.symmetric(vertical: Dimens.SPACE_16)
          : EdgeInsets.only(
              top: Dimens.SPACE_16,
              bottom: Dimens.SPACE_16,
              right: Dimens.SPACE_8,
            ),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsItem.grey666B73),
        borderRadius: BorderRadius.circular(Dimens.SPACE_8),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.SPACE_8),
                topRight: Radius.circular(Dimens.SPACE_8),
              ),
              color: ColorsItem.greyCCECEF.withOpacity(0.5),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_10,
              vertical: Dimens.SPACE_15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    column.name,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_18,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    softWrap: false,
                  ),
                ),
                SizedBox(width: Dimens.SPACE_6),
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == 0) {
                      _controller.goToRenameColumn(
                        column.id,
                        column.name,
                      );
                    } else if (value == 1) {
                      _controller.onMoveTicketToProject(false, column.tasks);
                    } else {
                      _controller.onMoveTicketToProject(true, column.tasks);
                    }
                  },
                  child: FaIcon(
                    FontAwesomeIcons.pencil,
                    size: Dimens.SPACE_12,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 0,
                        child: Text(S.of(context).label_column_edit,
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14))),
                    PopupMenuItem(
                        value: 1,
                        child: Text(
                            "${S.of(context).label_move_ticket_to} Kolom",
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14))),
                    PopupMenuItem(
                        value: 2,
                        child: Text(
                            "${S.of(context).label_move_ticket_to} Project",
                            style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_14))),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: _controller.columnWillAccept == column.name &&
                      _controller.columnFrom != column.name
                  ? EdgeInsets.only(
                      top: 128,
                      right: Dimens.SPACE_10,
                      bottom: Dimens.SPACE_8,
                      left: Dimens.SPACE_10,
                    )
                  : EdgeInsets.symmetric(
                      vertical: Dimens.SPACE_8,
                      horizontal: Dimens.SPACE_10,
                    ),
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: Dimens.SPACE_50),
                    child: column.tasks != null
                        ? ListView.builder(
                            itemCount: column.tasks!.length,
                            itemBuilder: (context, index) {
                              return _draggableTask(
                                columnName: column.name,
                                idxColumn: idxColumn,
                                ticket: column.tasks![index],
                                idxTicket: index,
                              );
                            })
                        : null,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: Dimens.SPACE_10),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_5),
                          child: Container(
                            height: Dimens.SPACE_40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Dimens.SPACE_20),
                              border:
                                  Border.all(color: ColorsItem.orangeFB9600),
                            ),
                            child: InkWell(
                              onTap: () =>
                                  _controller.goToCreateTaskPage(column.id),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: Dimens.SPACE_16,
                                    color: ColorsItem.orangeFB9600,
                                  ),
                                  SizedBox(width: Dimens.SPACE_4),
                                  Text(
                                    "Tugas".toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      fontSize: Dimens.SPACE_12,
                                      fontWeight: FontWeight.w700,
                                      color: ColorsItem.orangeFB9600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _draggableTask({
    required String columnName,
    required int idxColumn,
    required Ticket ticket,
    required int idxTicket,
  }) {
    return LongPressDraggable(
        data: {
          "movedFromIdx": idxColumn,
          "idxTicket": idxTicket,
          "ticket": ticket,
        },
        feedback: _draggingTask(
          dragKey: _controller.draggableKey,
          ticket: ticket,
        ),
        child: _taskCard(ticket),
        childWhenDragging: Container(
          width: double.infinity,
          height: 128,
        ),
        onDragStarted: () {
          _controller.onDragFrom(
            columnName,
            ticket.code,
          );
        });
  }

  Widget _draggingTask({
    required GlobalKey dragKey,
    required Ticket ticket,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      key: dragKey,
      decoration: BoxDecoration(
        color: ColorsItem.grey32373D,
        borderRadius: BorderRadius.circular(Dimens.SPACE_6),
        border: Border.all(color: ColorsItem.grey666B73),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimens.SPACE_16,
        vertical: Dimens.SPACE_8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorsItem.grey666B73,
              borderRadius: BorderRadius.circular(Dimens.SPACE_8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_4,
              vertical: Dimens.SPACE_2,
            ),
            child: Text(
              ticket.code,
              style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: Dimens.SPACE_8),
          Text(
            ticket.name ?? "",
            style: GoogleFonts.montserrat(
              fontSize: Dimens.SPACE_12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimens.SPACE_16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsItem.green219653,
                ),
                padding: EdgeInsets.all(Dimens.SPACE_4),
                child: Text(
                  ticket.storyPoint.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              CircleAvatar(
                radius: Dimens.SPACE_18,
                backgroundImage: CachedNetworkImageProvider(
                  ticket.avatar ??
                      "https://ui-avatars.com/api/?background=random&size=256&name=",
                ),
                backgroundColor: Colors.transparent,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _taskCard(Ticket ticket) {
    if (ticket.code == _controller.ticketOnMoveCode) {
      return Container(
        width: double.infinity,
        height: 128,
      );
    }
    return InkWell(
      onTap: () {
        _controller.goToDetail(ticket);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorsItem.grey666B73),
          borderRadius: BorderRadius.circular(Dimens.SPACE_6),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.SPACE_16,
          vertical: Dimens.SPACE_8,
        ),
        margin: EdgeInsets.only(bottom: Dimens.SPACE_8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: ColorsItem.grey666B73),
                borderRadius: BorderRadius.circular(Dimens.SPACE_8),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Dimens.SPACE_4,
                vertical: Dimens.SPACE_2,
              ),
              child: Text(
                ticket.code,
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: Dimens.SPACE_8),
            Text(
              ticket.name ?? "",
              style: GoogleFonts.montserrat(
                fontSize: Dimens.SPACE_12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Dimens.SPACE_16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsItem.green219653,
                  ),
                  padding: EdgeInsets.all(Dimens.SPACE_4),
                  child: Text(
                    ticket.storyPoint.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: Dimens.SPACE_18,
                  backgroundImage: CachedNetworkImageProvider(
                    ticket.avatar ??
                        "https://ui-avatars.com/api/?background=random&size=256&name=",
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _filterMenu() {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 0) {
            _controller.filter(TicketFilterType.All);
          } else if (value == 2) {
            _controller.filter(TicketFilterType.Open);
          } else {
            _controller.filter(TicketFilterType.AssignedTome);
          }
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: FaIcon(
              FontAwesomeIcons.filter,
              size: Dimens.SPACE_18,
            )),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "${S.of(context).status_task_all} ${S.of(context).label_ticket}",
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  S.of(context).status_task_opened_ticket,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(
                  S.of(context).status_task_assigned_to_me,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ]);
  }
}
