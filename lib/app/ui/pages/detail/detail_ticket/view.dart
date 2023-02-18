import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/resources/images/images.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/bottomsheet/reaction_bottomsheet.dart';
import 'package:mobile_sev2/app/ui/assets/widget/detail_head.dart';
import 'package:mobile_sev2/app/ui/assets/widget/transaction_item.dart';
import 'package:mobile_sev2/app/ui/pages/create/task_action/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/data/infrastructures/extension.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:mobile_sev2/domain/ticket.dart';
import 'package:rich_text_view/rich_text_view.dart';

import 'controller.dart';

class DetailTicketPage extends View {
  final Object? arguments;

  DetailTicketPage({this.arguments});

  @override
  _DetailTicketState createState() => _DetailTicketState(
      AppComponent.getInjector().get<DetailTicketController>(), arguments);
}

class _DetailTicketState
    extends ViewState<DetailTicketPage, DetailTicketController> {
  DetailTicketController _controller;

  _DetailTicketState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<DetailTicketController>(
          builder: (context, controller) {
            return Scaffold(
              key: globalKey,
              body: _controller.isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(this.context).size.height / 10,
                          ),
                          child: NestedScrollView(
                            floatHeaderSlivers: true,
                            headerSliverBuilder: (
                              BuildContext context,
                              bool innerBoxIsScrolled,
                            ) {
                              return [
                                SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  floating: true,
                                  snap: true,
                                  toolbarHeight: Dimens.SPACE_80,
                                  flexibleSpace: SimpleAppBar(
                                    toolbarHeight: Dimens.SPACE_80,
                                    prefix: IconButton(
                                      icon:
                                          FaIcon(FontAwesomeIcons.chevronLeft),
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                    ),
                                    title: Text(
                                      "Detail ${S.of(context).label_ticket}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: Dimens.SPACE_16),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimens.SPACE_10),
                                    suffix: _popMenu(),
                                  ),
                                ),
                              ];
                            },
                            body: ListView(
                              children: [
                                _detailHead(),
                                _buildChips(),
                                Divider(height: Dimens.SPACE_2),
                                Container(
                                  padding: EdgeInsets.all(Dimens.SPACE_20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.circleInfo,
                                            size: Dimens.SPACE_16,
                                            color: ColorsItem.grey858A93,
                                          ),
                                          SizedBox(width: Dimens.SPACE_14),
                                          Text(
                                            "Information".toUpperCase(),
                                            style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_14,
                                              fontWeight: FontWeight.w700,
                                              color: ColorsItem.grey858A93,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.SPACE_20),
                                      if (_controller.hasDependencies())
                                        Container(
                                          width: double.infinity,
                                          padding:
                                              EdgeInsets.all(Dimens.SPACE_16),
                                          margin: EdgeInsets.only(
                                              bottom: Dimens.SPACE_16),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color:
                                                      ColorsItem.black32373D),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      Dimens.SPACE_8))),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (_controller
                                                        .isHasParentTask &&
                                                    _controller
                                                        .isHasSubtasks) ...[
                                                  Column(
                                                    children: [
                                                      renderDependencies(
                                                        _controller
                                                            .parentTaskLength,
                                                        _controller,
                                                        S
                                                            .of(context)
                                                            .label_parent_task,
                                                        _controller.parenTask,
                                                      ),
                                                      Divider(
                                                        color: ColorsItem
                                                            .black32373D,
                                                        thickness: 1,
                                                        height: Dimens.SPACE_25,
                                                      ),
                                                      renderDependencies(
                                                        _controller
                                                            .subTaskLength,
                                                        _controller,
                                                        S
                                                            .of(context)
                                                            .label_branch_task,
                                                        _controller.subtask,
                                                      ),
                                                    ],
                                                  )
                                                ] else if (_controller
                                                        .isHasParentTask ||
                                                    _controller
                                                        .isHasSubtasks) ...[
                                                  renderDependencies(
                                                    _controller.parentTaskLength !=
                                                            0
                                                        ? _controller
                                                            .parentTaskLength
                                                        : _controller
                                                            .subTaskLength,
                                                    _controller,
                                                    _controller.isHasParentTask
                                                        ? S
                                                            .of(context)
                                                            .label_parent_task
                                                        : S
                                                            .of(context)
                                                            .label_branch_task,
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
                                              padding: EdgeInsets.all(
                                                  Dimens.SPACE_16),
                                              margin: EdgeInsets.only(
                                                  bottom: Dimens.SPACE_16),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: ColorsItem
                                                          .black32373D),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              Dimens.SPACE_8))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      S
                                                          .of(context)
                                                          .detail_task_mocks_label,
                                                      style: GoogleFonts
                                                          .montserrat()),
                                                  SizedBox(
                                                      height: Dimens.SPACE_10),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: 4,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          index > 0
                                                              ? Divider(
                                                                  color: ColorsItem
                                                                      .black32373D,
                                                                  thickness: 1,
                                                                  height: Dimens
                                                                      .SPACE_25,
                                                                )
                                                              : SizedBox(),
                                                          Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .camera,
                                                                size: Dimens
                                                                    .SPACE_16,
                                                              ),
                                                              SizedBox(
                                                                  width: Dimens
                                                                      .SPACE_8),
                                                              Expanded(
                                                                child: Text(
                                                                  _controller
                                                                          .ticketObj
                                                                          ?.name ??
                                                                      '',
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    color: ColorsItem
                                                                        .green00A1B0,
                                                                    fontSize: Dimens
                                                                        .SPACE_14,
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                              ),
                                            )
                                          : SizedBox(),
                                      _controller.hasDuplicates()
                                          ? Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(
                                                  Dimens.SPACE_16),
                                              margin: EdgeInsets.only(
                                                  bottom: Dimens.SPACE_16),
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
                                                  Text(
                                                    S
                                                        .of(context)
                                                        .detail_task_duplicates_label,
                                                    style: GoogleFonts
                                                        .montserrat(),
                                                  ),
                                                  SizedBox(
                                                    height: Dimens.SPACE_10,
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    primary: false,
                                                    itemCount: 4,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          index > 0
                                                              ? Divider(
                                                                  color: ColorsItem
                                                                      .black32373D,
                                                                  thickness: 1,
                                                                  height: Dimens
                                                                      .SPACE_25,
                                                                )
                                                              : SizedBox(),
                                                          Row(
                                                            children: [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .clone,
                                                                color: ColorsItem
                                                                    .grey858A93,
                                                                size: Dimens
                                                                    .SPACE_16,
                                                              ),
                                                              SizedBox(
                                                                  width: Dimens
                                                                      .SPACE_8),
                                                              Expanded(
                                                                child: Text(
                                                                  "${_controller.ticketObj?.code ?? ''}: ${_controller.ticketObj?.name ?? ''}",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                    color: ColorsItem
                                                                        .green00A1B0,
                                                                    fontSize: Dimens
                                                                        .SPACE_14,
                                                                    letterSpacing:
                                                                        0.2,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                              ),
                                            )
                                          : SizedBox(),
                                      Stack(
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding:
                                                EdgeInsets.all(Dimens.SPACE_16),
                                            margin: EdgeInsets.only(bottom: 27),
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
                                                Text(
                                                  S
                                                      .of(context)
                                                      .room_detail_description_label,
                                                  style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorsItem.white9E9E9E,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: Dimens.SPACE_14,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimens.SPACE_8,
                                                ),
                                                HtmlWidget(
                                                  """${_controller.ticketObj?.htmlDescription ?? ''}""",
                                                  textStyle: TextStyle(
                                                    fontSize: Dimens.SPACE_14,
                                                    letterSpacing: 0.2,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  onTapUrl: (url) =>
                                                      _controller.onOpen(url),
                                                ),
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
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding:
                                            EdgeInsets.all(Dimens.SPACE_16),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: ColorsItem.black32373D),
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
                                                  .room_detail_assigned_label,
                                              style: GoogleFonts.montserrat(
                                                color: ColorsItem.white9E9E9E,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: Dimens.SPACE_4),
                                            _controller.ticketObj?.assignee ==
                                                    null
                                                ? SizedBox(
                                                    height: Dimens.SPACE_20,
                                                  )
                                                : Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          top: Dimens.SPACE_5,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              width: Dimens
                                                                  .SPACE_2),
                                                        ),
                                                        child: CircleAvatar(
                                                          backgroundImage:
                                                              CachedNetworkImageProvider(
                                                            _controller
                                                                    .ticketObj
                                                                    ?.assignee
                                                                    ?.avatar ??
                                                                '',
                                                          ),
                                                          radius:
                                                              Dimens.SPACE_14,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width:
                                                              Dimens.SPACE_8),
                                                      Text(
                                                        _controller.ticketObj
                                                                ?.assignee
                                                                ?.getFullName() ??
                                                            "",
                                                        style: GoogleFonts
                                                            .montserrat(),
                                                      )
                                                    ],
                                                  ),
                                            SizedBox(height: Dimens.SPACE_12),
                                            Text(
                                              S
                                                  .of(context)
                                                  .room_detail_authored_by_label,
                                              style: GoogleFonts.montserrat(
                                                color: ColorsItem.white9E9E9E,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: Dimens.SPACE_4),
                                            Row(
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: Dimens.SPACE_5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width:
                                                              Dimens.SPACE_2),
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                        _controller
                                                                .ticketObj
                                                                ?.author
                                                                ?.avatar ??
                                                            '',
                                                      ),
                                                      radius: Dimens.SPACE_14,
                                                    )),
                                                SizedBox(width: Dimens.SPACE_8),
                                                Text(
                                                  _controller.ticketObj?.author
                                                          ?.getFullName() ??
                                                      '',
                                                  style:
                                                      GoogleFonts.montserrat(),
                                                ),
                                              ],
                                            ),
                                            // SizedBox(height: Dimens.SPACE_12),
                                            // Text(
                                            //   S
                                            //       .of(context)
                                            //       .room_detail_tags_label,
                                            //   style: GoogleFonts.montserrat(
                                            //     color: ColorsItem.white9E9E9E,
                                            //   ),
                                            // ),
                                            // SizedBox(height: Dimens.SPACE_4),
                                            // Wrap(
                                            //   children: List.generate(
                                            //     1,
                                            //     (index) => Padding(
                                            //       padding:
                                            //           const EdgeInsets.only(
                                            //         right: Dimens.SPACE_16,
                                            //       ),
                                            //       child: Chip(
                                            //         label: Text(
                                            //           /// TODO: Tags name
                                            //           "Refactory",
                                            //           style: GoogleFonts
                                            //               .montserrat(
                                            //             color: ColorsItem
                                            //                 .whiteFEFEFE,
                                            //             fontSize:
                                            //                 Dimens.SPACE_12,
                                            //           ),
                                            //         ),
                                            //         backgroundColor:
                                            //             ColorsItem.black32373D,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            SizedBox(height: Dimens.SPACE_12),
                                            Text(
                                              S.of(context).label_subscriber,
                                              style: GoogleFonts.montserrat(
                                                color: ColorsItem.white9E9E9E,
                                                fontWeight: FontWeight.w700,
                                                fontSize: Dimens.SPACE_14,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(height: Dimens.SPACE_8),
                                            Wrap(
                                              spacing: -8.0,
                                              children: List.generate(
                                                _controller
                                                    .formerSubscribers.length,
                                                (index) {
                                                  return Container(
                                                    margin: EdgeInsets.only(
                                                      top: Dimens.SPACE_5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width:
                                                              Dimens.SPACE_2),
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                        _controller
                                                                .formerSubscribers[
                                                                    index]
                                                                .avatar ??
                                                            "",
                                                      ),
                                                      radius: Dimens.SPACE_14,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: Dimens.SPACE_20,
                                    right: Dimens.SPACE_20,
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
                                        child: _controller.transactions![index]
                                                    .attachments!.length ==
                                                0
                                            ? TransactionItem(
                                                avatar: _controller
                                                    .transactions![index]
                                                    .actor
                                                    .avatar!,
                                                transactionAuthor:
                                                    "<bold>${_controller.transactions![index].actor.name}</bold>",
                                                type: 'text',
                                                onOpenLink: (url) {
                                                  _controller.onOpen(url);
                                                },
                                                data: _controller.mapData[
                                                    _controller
                                                        .transactions![index]
                                                        .id],
                                                onPreviewDataFetched: (data) {
                                                  _controller.onGetPreviewData(
                                                      _controller
                                                          .transactions![index]
                                                          .id,
                                                      data);
                                                },
                                                transactionContent:
                                                    "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                                dateTime: _controller.parseTime(
                                                  _controller
                                                      .transactions![index]
                                                      .createdAt,
                                                ),
                                                onReact: () {
                                                  showReactionBottomSheet(
                                                    context: context,
                                                    reactions: [],
                                                    onReactionClicked:
                                                        (reaction) {
                                                      _controller.sendReaction(
                                                        reaction.id,
                                                        _controller
                                                            .transactions![
                                                                index]
                                                            .id,
                                                      );
                                                    },
                                                  );
                                                },
                                                onLongTapReaction:
                                                    (reactionData, reactionId) {
                                                  _controller
                                                      .showAuthorsReaction(
                                                    _controller
                                                        .transactions![index]
                                                        .id,
                                                    reactionData,
                                                    reactionId,
                                                  );
                                                },
                                                isReactable: _controller
                                                    .transactions![index]
                                                    .isReactable(),
                                                reactionList: _controller
                                                        .transactions![index]
                                                        .reactions ??
                                                    [],
                                              )
                                            : TransactionItem(
                                                avatar: _controller
                                                    .transactions![index]
                                                    .actor
                                                    .avatar!,
                                                transactionAuthor:
                                                    "<bold>${_controller.transactions![index].actor.name}</bold>",
                                                type: 'document',
                                                onOpenLink: (url) {
                                                  _controller.onOpen(url);
                                                },
                                                data: _controller.mapData[
                                                    _controller
                                                        .transactions![index]
                                                        .id],
                                                onPreviewDataFetched: (data) {
                                                  _controller.onGetPreviewData(
                                                      _controller
                                                          .transactions![index]
                                                          .id,
                                                      data);
                                                },
                                                attachments: _controller
                                                    .transactions![index]
                                                    .attachments!,
                                                transactionContent:
                                                    "${_controller.transactions![index].action} <bold>${_controller.transactions![index].target.name}</bold>",
                                                dateTime: _controller.parseTime(
                                                    _controller
                                                        .transactions![index]
                                                        .createdAt),
                                                onReact: () {
                                                  showReactionBottomSheet(
                                                    context: context,
                                                    reactions: [],
                                                    onReactionClicked:
                                                        (reaction) {
                                                      _controller.sendReaction(
                                                        reaction.id,
                                                        _controller
                                                            .transactions![
                                                                index]
                                                            .id,
                                                      );
                                                    },
                                                  );
                                                },
                                                onLongTapReaction:
                                                    (reactionData, reactionId) {
                                                  _controller
                                                      .showAuthorsReaction(
                                                    _controller
                                                        .transactions![index]
                                                        .id,
                                                    reactionData,
                                                    reactionId,
                                                  );
                                                },
                                                onTap: (fileIndex) {
                                                  _controller
                                                              .transactions![
                                                                  index]
                                                              .attachments![
                                                                  fileIndex]
                                                              .fileType ==
                                                          FileType.document
                                                      ? _controller
                                                          .downloadOrOpenFile(
                                                              _controller
                                                                  .transactions![
                                                                      index]
                                                                  .attachments![
                                                                      fileIndex]
                                                                  .url)
                                                      : _controller
                                                                  .transactions![
                                                                      index]
                                                                  .attachments![
                                                                      fileIndex]
                                                                  .fileType ==
                                                              FileType.video
                                                          ? _controller
                                                              .goToMediaDetail(
                                                              MediaType.video,
                                                              _controller
                                                                  .transactions![
                                                                      index]
                                                                  .attachments![
                                                                      fileIndex]
                                                                  .url,
                                                              _controller
                                                                  .transactions![
                                                                      index]
                                                                  .attachments![
                                                                      fileIndex]
                                                                  .title,
                                                            )
                                                          : _controller
                                                              .goToMediaDetail(
                                                              MediaType.image,
                                                              _controller
                                                                  .transactions![
                                                                      index]
                                                                  .attachments![
                                                                      fileIndex]
                                                                  .url,
                                                              _controller
                                                                  .transactions![
                                                                      index]
                                                                  .attachments![
                                                                      fileIndex]
                                                                  .title,
                                                            );
                                                },
                                                isReactable: _controller
                                                    .transactions![index]
                                                    .isReactable(),
                                                reactionList: _controller
                                                        .transactions![index]
                                                        .reactions ??
                                                    [],
                                              ));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _controller.isUploading
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimens.SPACE_25),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : _controller.uploadedFiles.isNotEmpty &&
                                          !_controller.isUploading
                                      ? Container(
                                          padding:
                                              EdgeInsets.all(Dimens.SPACE_12),
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: _controller
                                                  .uploadedFiles.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  child: _controller
                                                              .uploadedFiles[
                                                                  index]
                                                              .fileType ==
                                                          FileType.image
                                                      ? Column(
                                                          children: [
                                                            Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: InkWell(
                                                                  onTap: () => _controller
                                                                      .cancelUpload(
                                                                          _controller
                                                                              .uploadedFiles[index]),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: Dimens
                                                                        .SPACE_20,
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE,
                                                                  ),
                                                                )),
                                                            CachedNetworkImage(
                                                              imageUrl: _controller
                                                                  .uploadedFiles[
                                                                      index]
                                                                  .url,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  11,
                                                            ),
                                                          ],
                                                        )
                                                      : Column(
                                                          children: [
                                                            Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: InkWell(
                                                                  onTap: () => _controller
                                                                      .cancelUpload(
                                                                          _controller
                                                                              .uploadedFiles[index]),
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: Dimens
                                                                        .SPACE_20,
                                                                    color: ColorsItem
                                                                        .whiteFEFEFE,
                                                                  ),
                                                                )),
                                                            Center(
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .all(Dimens
                                                                        .SPACE_10),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              Dimens.SPACE_5)),
                                                                  border: Border
                                                                      .all(
                                                                    color: ColorsItem
                                                                        .whiteColor,
                                                                    width: 1.0,
                                                                  ),
                                                                ),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.3,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .article_outlined,
                                                                      color: Colors
                                                                          .white,
                                                                      size:
                                                                          30.0,
                                                                    ),
                                                                    SizedBox(
                                                                      width: Dimens
                                                                          .SPACE_10,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width / 1.8,
                                                                          child: Text(
                                                                              _controller.uploadedFiles[index].title,
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12, color: ColorsItem.whiteColor, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                        Text(
                                                                            "${_controller.uploadedFiles[index].getFileSizeWording()}",
                                                                            style:
                                                                                GoogleFonts.montserrat(
                                                                              fontSize: Dimens.SPACE_12,
                                                                              color: ColorsItem.greyB8BBBF,
                                                                            ))
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                );
                                              }),
                                        )
                                      : SizedBox(),
                              RichTextView.editor(
                                containerPadding: EdgeInsets.symmetric(
                                  vertical: Dimens.SPACE_15,
                                  horizontal: Dimens.SPACE_10,
                                ),
                                containerWidth: double.infinity,
                                onChanged: (value) {},
                                prefix: Container(
                                  padding:
                                      EdgeInsets.only(bottom: Dimens.SPACE_12),
                                  child: InkWell(
                                    onTap: () => _settingModalBottomSheet(),
                                    child: SvgPicture.asset(
                                      ImageItem.IC_URL,
                                      color: ColorsItem.grey8D9299,
                                    ),
                                  ),
                                ),
                                suffix: Container(
                                  padding:
                                      EdgeInsets.only(bottom: Dimens.SPACE_12),
                                  child: InkWell(
                                    onTap: () {
                                      if (!_controller.isSendingMessage)
                                        _controller.sendMessage();
                                    },
                                    child: _controller.isSendingMessage
                                        ? SizedBox(
                                            width: Dimens.SPACE_24,
                                            height: Dimens.SPACE_24,
                                            child: CircularProgressIndicator(
                                              color: ColorsItem.grey8D9299,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            ImageItem.IC_SEND,
                                            color: ColorsItem.grey8D9299,
                                          ),
                                  ),
                                ),
                                separator: Dimens.SPACE_10,
                                suggestionPosition: SuggestionPosition.top,
                                style: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                ),
                                controller: _controller.textEditingController,
                                decoration: InputDecoration(
                                  // isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorsItem.black32373D,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: ColorsItem.black32373D,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dimens.SPACE_8,
                                    vertical: Dimens.SPACE_16,
                                  ),
                                  hintText: S.of(context).chat_comment_box_hint,
                                  fillColor: Colors.grey,
                                  hintStyle: GoogleFonts.montserrat(
                                      color: ColorsItem.white9E9E9E),
                                ),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 4,
                                focusNode: _controller.isSendingMessage
                                    ? _controller.focusNodeMsg
                                    : null,
                                mentionSuggestions: _controller.userSuggestion,
                                onSearchPeople: (term) async {
                                  return _controller.filterUserSuggestion(term);
                                },
                                titleStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_14,
                                  color: ColorsItem.whiteFEFEFE,
                                ),
                                subtitleStyle: GoogleFonts.montserrat(
                                  fontSize: Dimens.SPACE_12,
                                  color: ColorsItem.grey8D9299,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      );

  _popMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          _controller.goToEditPage();

          // BELOW EXAMPLE OF USAGE DEEP LINK
          // FirebaseDynamicLinkService.createDynamicLink(
          //     true, _controller.ticketObj?.intId ?? 0); //, Pages.ticketDetail);
        } else if (value == 1) {
          _controller.goToAddActionPage();
        } else if (value == 2) {
          _controller.goToEditPage(isSubTask: true);
        } else if (value == 3) {
          _controller.goToTaskActionPage(TaskActionType.subtask);
        } else if (value == 4) {
          _controller.goToTaskActionPage(TaskActionType.merge);
        } else if (value == 6) {
          _controller.reportRoom();
        } else {
          /// TODO: Add Mockup
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_20),
        child: FaIcon(
          FontAwesomeIcons.ellipsisVertical,
          size: Dimens.SPACE_18,
        ),
      ),
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
                      S.of(context).detail_task_edit_label,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: ColorsItem.white9E9E9E,
                height: Dimens.SPACE_1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 1,
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
                      FontAwesomeIcons.circlePlus,
                      size: Dimens.SPACE_18,
                    ),
                    const SizedBox(
                      width: Dimens.SPACE_10,
                    ),
                    Text(
                      S.of(context).room_detail_add_action,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: ColorsItem.white9E9E9E,
                height: Dimens.SPACE_1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 2,
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
                      FontAwesomeIcons.tableList,
                      size: Dimens.SPACE_18,
                    ),
                    const SizedBox(
                      width: Dimens.SPACE_10,
                    ),
                    Text(
                      S.of(context).detail_subtask_create_label,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: ColorsItem.white9E9E9E,
                height: Dimens.SPACE_1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: 3,
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
                      S.of(context).detail_subtask_edit_label,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: ColorsItem.white9E9E9E,
                height: Dimens.SPACE_1,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          padding: EdgeInsets.zero,
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
                      FontAwesomeIcons.codeBranch,
                      size: Dimens.SPACE_18,
                    ),
                    const SizedBox(
                      width: Dimens.SPACE_10,
                    ),
                    Text(
                      S.of(context).detail_task_merge_label,
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: ColorsItem.white9E9E9E,
                height: Dimens.SPACE_1,
              ),
            ],
          ),
        ),
        // PopupMenuItem(
        //   value: 5,
        //   child: Row(
        //     children: [
        //       FaIcon(
        //         FontAwesomeIcons.image,
        //
        //         size: Dimens.SPACE_18,
        //       ),
        //       const SizedBox(
        //         width: Dimens.SPACE_10,
        //       ),
        //       Text(
        //         S.of(context).detail_task_add_mockup_label,
        //         style: GoogleFonts.montserrat(
        //
        //           fontSize: Dimens.SPACE_14,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        PopupMenuItem(
          value: 6,
          padding: EdgeInsets.zero,
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
                      FontAwesomeIcons.flag,
                      size: Dimens.SPACE_18,
                    ),
                    const SizedBox(
                      width: Dimens.SPACE_10,
                    ),
                    Text(
                      "${S.of(context).label_report} Ticket",
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: ColorsItem.white9E9E9E,
                height: Dimens.SPACE_1,
              ),
            ],
          ),
        ),
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
    return DetailHead(
      title:
          "T${_controller.ticketObj?.intId} : ${_controller.ticketObj?.name}",
      icon: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: _getTicketColor(_controller.ticketObj?.priority ?? ""),
        size: Dimens.SPACE_16,
      ),
    );
  }

  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.SPACE_16, vertical: Dimens.SPACE_4),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
            child: Chip(
              label: Text(
                  "${_controller.ticketObj?.rawStatus?.ucwords() ?? ''}, ${_controller.ticketObj?.priority.ucwords() ?? ''}",
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.SPACE_8,
            ),
            child: Chip(
              avatar: FaIcon(
                FontAwesomeIcons.userGroup,
                size: Dimens.SPACE_12,
              ),
              label: Text(
                _controller.getTicketPolicy(),
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_12,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.SPACE_8),
            child: Chip(
              label: Text(
                "${_controller.ticketObj?.storyPoint.ceil()} Story Point",
                style: GoogleFonts.montserrat(
                  fontSize: Dimens.SPACE_12,
                ),
              ),
              backgroundColor: ColorsItem.green219653,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDependencies(
    int length,
    DetailTicketController _controller,
    String title,
    List<Ticket> data,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: ColorsItem.white9E9E9E,
            fontWeight: FontWeight.w700,
            fontSize: Dimens.SPACE_14,
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: Dimens.SPACE_10),
        Padding(
          padding: const EdgeInsets.only(left: Dimens.SPACE_20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  S.of(context).label_status,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_14,
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
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Dimens.SPACE_12,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: length,
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(top: index == 0 ? Dimens.SPACE_8 : 0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Builder(
                        builder: (context) {
                          if (length > 1) {
                            if (index < length - 1) {
                              return Container(
                                height: Dimens.SPACE_60,
                                width: Dimens.SPACE_2,
                                color: Colors.red,
                              );
                            }
                          }
                          return SizedBox();
                        },
                      ),
                      Container(
                        height: Dimens.SPACE_10,
                        width: Dimens.SPACE_10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(Dimens.SPACE_3),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: Dimens.SPACE_8),
                    child: Chip(
                      label: Column(
                        children: [
                          Text(
                            "${data[index].status}",
                            style: GoogleFonts.montserrat(
                              fontSize: Dimens.SPACE_12,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "${data[index].priority}",
                              style: GoogleFonts.montserrat(
                                fontSize: Dimens.SPACE_12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // backgroundColor: ColorsItem.black32373D,
                    ),
                  ),
                ),
                SizedBox(width: Dimens.SPACE_6),
                Expanded(
                  flex: 3,
                  child: Text(
                    "${data[index].assignee?.name ?? "-"}",
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_14,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: Dimens.SPACE_6),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _controller.goToDepedencyTicket(data[index]);
                    },
                    child: Text(
                      "${data[index].code}",
                      style: GoogleFonts.montserrat(
                        fontSize: Dimens.SPACE_14,
                        color: ColorsItem.green00A1B0,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 375),
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      height: Dimens.SPACE_4,
                      width: Dimens.SPACE_40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.0,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.SPACE_20, vertical: Dimens.SPACE_10),
                    child: Center(
                      child: Text(
                        S.of(context).chat_attach_title,
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.2,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _controller.upload(FileType.image);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 0.5),
                              ),
                            ),
                            margin: EdgeInsets.only(left: Dimens.SPACE_20),
                            padding: EdgeInsets.only(
                                top: Dimens.SPACE_15,
                                bottom: Dimens.SPACE_15,
                                right: Dimens.SPACE_20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.images,
                                    size:
                                        MediaQuery.of(context).size.width / 14),
                                SizedBox(
                                  width: Dimens.SPACE_10,
                                ),
                                Text(
                                  S.of(context).chat_attach_image_label,
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _controller.upload(FileType.video);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.only(left: Dimens.SPACE_20),
                            padding: EdgeInsets.only(
                                top: Dimens.SPACE_15,
                                bottom: Dimens.SPACE_15,
                                right: Dimens.SPACE_20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.video,
                                    size:
                                        MediaQuery.of(context).size.width / 14),
                                SizedBox(
                                  width: Dimens.SPACE_10,
                                ),
                                Text(
                                  S.of(context).chat_attach_video_label,
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _controller.upload(FileType.document);
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.only(left: Dimens.SPACE_20),
                            padding: EdgeInsets.only(
                                top: Dimens.SPACE_15,
                                bottom: Dimens.SPACE_15,
                                right: Dimens.SPACE_20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FaIcon(FontAwesomeIcons.folderOpen,
                                    size:
                                        MediaQuery.of(context).size.width / 14),
                                SizedBox(
                                  width: Dimens.SPACE_10,
                                ),
                                Text(
                                  S.of(context).chat_attach_document_label,
                                  style: GoogleFonts.montserrat(
                                    fontSize: Dimens.SPACE_16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
