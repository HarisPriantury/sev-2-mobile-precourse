import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/button_default.dart';
import 'package:mobile_sev2/app/ui/assets/widget/custom_alert.dart';
import 'package:mobile_sev2/app/ui/assets/widget/detail_head.dart';
import 'package:mobile_sev2/app/ui/assets/widget/project_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/transaction_item.dart';
import 'package:mobile_sev2/app/ui/pages/detail/detail_project/controller.dart';
import 'package:mobile_sev2/app/ui/pages/project/member/args.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';

class DetailProjectPage extends View {
  final Object? arguments;

  DetailProjectPage({this.arguments});

  @override
  _DetailProjectState createState() => _DetailProjectState(
      AppComponent.getInjector().get<DetailProjectController>(), arguments);
}

class _DetailProjectState
    extends ViewState<DetailProjectPage, DetailProjectController> {
  DetailProjectController _controller;

  _DetailProjectState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<DetailProjectController>(
          builder: (context, controller) {
            return Scaffold(
              key: globalKey,
              body: _controller.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder: (
                        BuildContext context,
                        bool innerBoxIsScrolled,
                      ) {
                        return [
                          _buildAppBar(),
                        ];
                      },
                      body: ListView(
                        children: [
                          SizedBox(height: Dimens.SPACE_18),
                          _detailHead(),
                          _buildChips(),
                          Divider(
                            color: ColorsItem.black32373D,
                            thickness: Dimens.SPACE_1,
                            height: Dimens.SPACE_25,
                          ),
                          GestureDetector(
                            onTap: () {
                              _controller.goToWorkboard();
                            },
                            child: Container(
                              height: Dimens.SPACE_41,
                              margin: EdgeInsets.only(
                                left: Dimens.SPACE_50,
                                right: Dimens.SPACE_50,
                                bottom: Dimens.SPACE_20,
                                top: Dimens.SPACE_8,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimens.SPACE_32,
                                vertical: Dimens.SPACE_10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorsItem.orangeFB9600,
                                  width: Dimens.SPACE_1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimens.SPACE_100,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    S
                                        .of(context)
                                        .detail_project_open_workboard
                                        .toUpperCase(),
                                    style: GoogleFonts.montserrat(
                                      color: ColorsItem.orangeFB9600,
                                      fontSize: Dimens.SPACE_14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: Dimens.SPACE_12),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: ColorsItem.orangeFB9600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: Dimens.SPACE_20,
                              bottom: Dimens.SPACE_20,
                            ),
                            child: Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.circleInfo,
                                  size: Dimens.SPACE_16,
                                  color: ColorsItem.grey858A93,
                                ),
                                SizedBox(width: Dimens.SPACE_14),
                                Text(
                                  S
                                      .of(context)
                                      .room_detail_information_label
                                      .toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_14,
                                    fontWeight: FontWeight.w700,
                                    color: ColorsItem.grey858A93,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimens.SPACE_16,
                            ),
                            child: Column(
                              children: [
                                !_controller.projectObj!.isMilestone
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.all(Dimens.SPACE_16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                              color: ColorsItem.black32373D),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .project_sub_project_label,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 14.0,
                                                      color:
                                                          ColorsItem.grey666B73,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                _controller.isAuthor() &&
                                                        !_controller.projectObj!
                                                            .isMilestone
                                                    ? ButtonDefault(
                                                        buttonIcon: Icon(
                                                          Icons.add,
                                                          color: ColorsItem
                                                              .orangeFB9600,
                                                        ),
                                                        buttonText: "NEW",
                                                        letterSpacing: 1.5,
                                                        buttonTextColor:
                                                            ColorsItem
                                                                .orangeFB9600,
                                                        buttonColor:
                                                            Colors.transparent,
                                                        buttonLineColor:
                                                            Colors.transparent,
                                                        paddingHorizontal: 0,
                                                        paddingVertical: 0,
                                                        fontSize:
                                                            Dimens.SPACE_12,
                                                        onTap: () {
                                                          _controller
                                                              .addSubProject();
                                                        },
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount: _controller
                                                  .subProjects.length,
                                              itemBuilder: (context, index) {
                                                return ProjectList(
                                                  onTap: () {
                                                    _controller
                                                        .goToDetailProject(
                                                            _controller
                                                                    .subProjects[
                                                                index]);
                                                  },
                                                  projectName:
                                                      "#${_controller.subProjects[index].intId} : ${_controller.subProjects[index].name!}",
                                                  joinDate: "",
                                                  status: _controller
                                                          .subProjects[index]
                                                          .isArchived
                                                      ? S
                                                          .of(context)
                                                          .label_archive
                                                      : S
                                                          .of(context)
                                                          .status_task_open,
                                                  index: index,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                !_controller.projectObj!.isMilestone
                                    ? SizedBox(height: Dimens.SPACE_8)
                                    : SizedBox(),
                                !_controller.projectObj!.isMilestone
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.all(Dimens.SPACE_16),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          border: Border.all(
                                              color: ColorsItem.black32373D),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    S
                                                        .of(context)
                                                        .project_milestone_label,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 14.0,
                                                      color:
                                                          ColorsItem.grey666B73,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                _controller.isAuthor() &&
                                                        !_controller.projectObj!
                                                            .isMilestone
                                                    ? ButtonDefault(
                                                        buttonIcon: Icon(
                                                          Icons.add,
                                                          color: ColorsItem
                                                              .orangeFB9600,
                                                        ),
                                                        buttonText: "NEW",
                                                        letterSpacing: 1.5,
                                                        buttonTextColor:
                                                            ColorsItem
                                                                .orangeFB9600,
                                                        buttonColor:
                                                            Colors.transparent,
                                                        buttonLineColor:
                                                            Colors.transparent,
                                                        paddingHorizontal: 0,
                                                        paddingVertical: 0,
                                                        fontSize:
                                                            Dimens.SPACE_12,
                                                        onTap: () {
                                                          _controller
                                                              .addMilestone();
                                                        },
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            ListView.builder(
                                              primary: false,
                                              shrinkWrap: true,
                                              itemCount:
                                                  _controller.milestones.length,
                                              itemBuilder: (context, index) {
                                                return ProjectList(
                                                  onTap: () {
                                                    _controller
                                                        .goToDetailProject(
                                                            _controller
                                                                    .milestones[
                                                                index]);
                                                  },
                                                  projectName:
                                                      "#${_controller.milestones[index].intId!} : ${_controller.milestones[index].name!}",
                                                  joinDate: "",
                                                  isMilestone: true,
                                                  status: _controller
                                                          .milestones[index]
                                                          .isArchived
                                                      ? S
                                                          .of(context)
                                                          .label_archive
                                                      : S
                                                          .of(context)
                                                          .status_task_open,
                                                  index: index,
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
                                  margin: EdgeInsets.only(
                                    top: Dimens.SPACE_8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: ColorsItem.black32373D,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        Dimens.SPACE_8,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  !_controller.projectObj!
                                                      .isMilestone &&
                                                  _controller
                                                      .subProjects.isEmpty
                                              ? ButtonDefault(
                                                  buttonIcon: Icon(
                                                    Icons.add,
                                                    color:
                                                        ColorsItem.orangeFB9600,
                                                  ),
                                                  buttonText: "NEW",
                                                  letterSpacing: 1.5,
                                                  buttonTextColor:
                                                      ColorsItem.orangeFB9600,
                                                  buttonColor:
                                                      Colors.transparent,
                                                  buttonLineColor:
                                                      Colors.transparent,
                                                  paddingHorizontal: 0,
                                                  paddingVertical: 0,
                                                  fontSize: Dimens.SPACE_12,
                                                  onTap: () {
                                                    _controller.goToMemberPage(
                                                        ProjectMemberActionType
                                                            .add);
                                                  },
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.SPACE_4),
                                      Wrap(
                                        spacing: -8.0,
                                        children: List.generate(
                                          _controller
                                              .projectObj!.members!.length,
                                          (index) => Container(
                                            margin: EdgeInsets.only(
                                                top: Dimens.SPACE_5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  width: Dimens.SPACE_2,
                                                  color:
                                                      ColorsItem.whiteFEFEFE),
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                _controller.projectObj!
                                                    .members![index].avatar!,
                                              ),
                                              radius: Dimens.SPACE_14,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _controller.projectObj!.description != ""
                                    ? Stack(
                                        alignment: Alignment.bottomCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.only(
                                              top: Dimens.SPACE_8,
                                              bottom: 27,
                                            ),
                                            padding: EdgeInsets.all(
                                              Dimens.SPACE_16,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: Dimens.SPACE_1,
                                                color: ColorsItem.black32373D,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  Dimens.SPACE_8,
                                                ),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  S
                                                      .of(context)
                                                      .room_detail_description_label,
                                                  style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorsItem.grey666B73,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: Dimens.SPACE_8),
                                                Linkify(
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorsItem
                                                          .whiteFEFEFE),
                                                  text: _controller
                                                      .projectObj!.description,
                                                  maxLines: _controller
                                                          .isExpandDescription
                                                      ? null
                                                      : 3,
                                                  overflow: _controller
                                                          .isExpandDescription
                                                      ? TextOverflow.clip
                                                      : TextOverflow.ellipsis,
                                                  onOpen: (link) {
                                                    _controller
                                                        .onOpen(link.url);
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                _controller
                                                    .onExpandDescription();
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(
                                                  Dimens.SPACE_15,
                                                ),
                                                child: FaIcon(
                                                  _controller
                                                          .isExpandDescription
                                                      ? FontAwesomeIcons
                                                          .circleChevronUp
                                                      : FontAwesomeIcons
                                                          .circleChevronDown,
                                                  color: ColorsItem.green00A1B0,
                                                  size: Dimens.SPACE_24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(
                                  Dimens.SPACE_20,
                                ),
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.circleInfo,
                                      size: Dimens.SPACE_16,
                                      color: ColorsItem.grey858A93,
                                    ),
                                    SizedBox(width: Dimens.SPACE_14),
                                    Text(
                                      S
                                          .of(context)
                                          .room_detail_recent_activities
                                          .toUpperCase(),
                                      style: GoogleFonts.montserrat(
                                        color: ColorsItem.grey858A93,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                  itemCount: _controller.transactions?.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: TransactionItem(
                                        avatar: _controller
                                            .transactions![index].actor.avatar!,
                                        transactionAuthor:
                                            "<bold>${_controller.transactions![index].actor.name}</bold>",
                                        transactionContent:
                                            "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                        dateTime: _controller.parseTime(
                                            _controller.transactions![index]
                                                .createdAt),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
            );
          },
        ),
      );

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      snap: true,
      toolbarHeight: MediaQuery.of(context).size.height / 10,
      flexibleSpace: SimpleAppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 10,
        prefix: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Text(
          "Detail ${S.of(context).label_project}",
          style: GoogleFonts.montserrat(
            fontSize: Dimens.SPACE_16,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        suffix: _buildPopupMenu(),
      ),
    );
  }

  PopupMenuButton<int> _buildPopupMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 0:
            _controller.editProject();
            break;
          case 1:
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
              cancelButtonText: S.of(context).label_back.toUpperCase(),
              confirmButtonText: _controller.projectObj!.isArchived
                  ? S.of(context).label_enable.toUpperCase()
                  : S.of(context).project_archive_label.toUpperCase(),
              context: context,
              onConfirm: () {
                Navigator.pop(context);
                _controller.setProjectStatus();
              },
              confirmButtonColor: ColorsItem.orangeFB9600,
              confirmButtonTextColor: ColorsItem.black020202,
            );
            break;
          case 2:
            _controller.reportProject();
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 0,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: Dimens.SPACE_16,
                  right: Dimens.SPACE_16,
                  bottom: Dimens.SPACE_16,
                ),
                child: Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.penToSquare,
                      size: Dimens.SPACE_18,
                    ),
                    const SizedBox(
                      width: Dimens.SPACE_10,
                    ),
                    Text(
                      S.of(context).project_edit_label,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 1,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimens.SPACE_16,
              right: Dimens.SPACE_16,
              bottom: Dimens.SPACE_16,
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.box,
                  size: Dimens.SPACE_18,
                ),
                const SizedBox(
                  width: Dimens.SPACE_10,
                ),
                Text(
                  S.of(context).project_archive_label,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              left: Dimens.SPACE_16,
              right: Dimens.SPACE_16,
              bottom: Dimens.SPACE_16,
            ),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.flag,
                  size: Dimens.SPACE_18,
                ),
                const SizedBox(
                  width: Dimens.SPACE_10,
                ),
                Text(
                  "${S.of(context).label_report} Project",
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
        child: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          size: Dimens.SPACE_18,
        ),
      ),
    );
  }

  Widget _detailHead() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DetailHead(
          title:
              "#${_controller.projectObj!.intId!} : ${_controller.projectObj!.name!}",
        ),
        if (_controller.projectObj!.isMilestone &&
            _controller.getDisplayDateMilestone(context) != null) ...[
          Container(
            padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidClock,
                  size: Dimens.SPACE_12,
                ),
                SizedBox(width: Dimens.SPACE_4),
                Text(
                  _controller.getDisplayDateMilestone(context)!,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.SPACE_16,
        vertical: Dimens.SPACE_4,
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8,
            ),
            child: Chip(
              label: Text(
                _controller.getProjectStatus(context),
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8,
            ),
            child: Chip(
              avatar: FaIcon(
                FontAwesomeIcons.businessTime,
                size: Dimens.SPACE_12,
              ),
              label: Text(
                _controller.userData.workspace.capitalize(),
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
