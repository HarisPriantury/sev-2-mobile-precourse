import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/default_search_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/file_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/lobby/attachment/file/controller.dart';
import 'package:mobile_sev2/domain/file.dart';
import 'package:shimmer/shimmer.dart';

class RoomFilePage extends View {
  final Object? arguments;

  RoomFilePage({this.arguments});

  @override
  _RoomFileState createState() => _RoomFileState(
      AppComponent.getInjector().get<RoomFileController>(), arguments);
}

class _RoomFileState extends ViewState<RoomFilePage, RoomFileController> {
  RoomFileController _controller;

  _RoomFileState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomFileController>(
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
                      S.of(context).room_detail_files_title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: Dimens.SPACE_20,
                          fontWeight: FontWeight.bold),
                    ),
                    if (_controller.data?.isRoom ?? false) ...[
                      SizedBox(
                        height: Dimens.SPACE_4,
                      ),
                      Text(
                        _controller.room!.name!,
                        style: GoogleFonts.montserrat(
                          fontSize: Dimens.SPACE_12,
                        ),
                      ),
                    ],
                  ],
                ),
                suffix: Container(
                  width: Dimens.SPACE_50,
                ),
              ),
            ),
            body: DefaultRefreshIndicator(
              onRefresh: () => _controller.reload(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.SPACE_16),
                  Expanded(
                    child: controller.isLoading
                        ? _shimmer()
                        : _controller.files.isEmpty
                            ? EmptyList(
                                title: S.of(context).room_empty_file_title,
                                descripton:
                                    S.of(context).room_empty_file_description)
                            : SingleChildScrollView(
                                controller: _controller.listScrollController,
                                child: Column(
                                  children: [
                                    if (!_controller.data!.isRoom) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimens.SPACE_20),
                                        child: tabSearchFile(),
                                      ),
                                    ],
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: _controller.files.length,
                                          itemBuilder: (context, index) {
                                            File file =
                                                _controller.files[index];
                                            return FileItem(
                                              fileName: file.title,
                                              authorName: file.author?.name,
                                              fileCreated: _controller.dateUtil
                                                  .displayDateTimeFormat(
                                                      file.createdAt!),
                                              isAlreadyDownloaded: _controller
                                                  .downloader
                                                  .isAlreadyDownloaded(
                                                      file.url),
                                              onOpen: () => _controller
                                                  .downloader
                                                  .openFile(file.url),
                                              onDownload: () => _controller
                                                  .downloadFile(file.url),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                  )
                ],
              ),
            ),
          );
        }),
      );

  Widget tabSearchFile() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_15),
      child: SearchBar(
        hintText:
            "${S.of(context).label_search} ${S.of(context).chat_attach_document_label}",
        border: Border.all(color: ColorsItem.grey979797.withOpacity(0.5)),
        borderRadius: BorderRadius.all(const Radius.circular(Dimens.SPACE_40)),
        innerPadding: EdgeInsets.all(Dimens.SPACE_10),
        outerPadding: EdgeInsets.symmetric(horizontal: Dimens.SPACE_15),
        controller: _controller.searchFileController,
        focusNode: _controller.focusNodeSearchFile,
        onChanged: (txt) {
          _controller.streamController.add(txt);
        },
        clearTap: () => _controller.clearSearch(),
        onTap: () => _controller.onSearchFile(true),
        endIcon: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: ColorsItem.greyB8BBBF,
          size: Dimens.SPACE_18,
        ),
        textStyle: TextStyle(fontSize: 15.0),
        hintStyle: TextStyle(color: ColorsItem.grey8D9299),
        buttonText: 'Clear',
      ),
    );
  }

  _shimmer() {
    return Container(
      margin: EdgeInsets.only(top: Dimens.SPACE_20),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              period: Duration(seconds: 1),
              baseColor: ColorsItem.grey979797,
              highlightColor: ColorsItem.grey606060,
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: 10,
                  itemBuilder: (_, __) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: Dimens.SPACE_10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Dimens.SPACE_20,
                                      right: Dimens.SPACE_10),
                                  decoration: BoxDecoration(
                                    color: ColorsItem.black32373D,
                                    borderRadius: new BorderRadius.all(
                                      const Radius.circular(
                                        Dimens.SPACE_12,
                                      ),
                                    ),
                                  ),
                                  width: Dimens.SPACE_18,
                                  height: Dimens.SPACE_18,
                                ),
                                baseColor: ColorsItem.grey979797,
                                highlightColor: ColorsItem.grey606060,
                              ),
                              Expanded(
                                child: Shimmer.fromColors(
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: Dimens.SPACE_5),
                                    decoration: BoxDecoration(
                                      color: ColorsItem.black32373D,
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(
                                              Dimens.SPACE_12)),
                                    ),
                                    height: Dimens.SPACE_18,
                                  ),
                                  baseColor: ColorsItem.grey979797,
                                  highlightColor: ColorsItem.grey606060,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Shimmer.fromColors(
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens.SPACE_5),
                                      decoration: BoxDecoration(
                                        color: ColorsItem.black32373D,
                                        borderRadius: new BorderRadius.all(
                                            const Radius.circular(
                                                Dimens.SPACE_12)),
                                      ),
                                      width: Dimens.SPACE_100,
                                      height: Dimens.SPACE_12,
                                    ),
                                    baseColor: ColorsItem.grey979797,
                                    highlightColor: ColorsItem.grey606060,
                                  ),
                                  SizedBox(height: Dimens.SPACE_4),
                                  Shimmer.fromColors(
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens.SPACE_5),
                                      decoration: BoxDecoration(
                                        color: ColorsItem.black32373D,
                                        borderRadius: new BorderRadius.all(
                                            const Radius.circular(
                                                Dimens.SPACE_12)),
                                      ),
                                      width: Dimens.SPACE_100,
                                      height: Dimens.SPACE_12,
                                    ),
                                    baseColor: ColorsItem.grey979797,
                                    highlightColor: ColorsItem.grey606060,
                                  ),
                                  SizedBox(height: Dimens.SPACE_4),
                                  Shimmer.fromColors(
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: Dimens.SPACE_5),
                                      decoration: BoxDecoration(
                                        color: ColorsItem.black32373D,
                                        borderRadius: new BorderRadius.all(
                                            const Radius.circular(
                                                Dimens.SPACE_12)),
                                      ),
                                      width: Dimens.SPACE_100,
                                      height: Dimens.SPACE_12,
                                    ),
                                    baseColor: ColorsItem.grey979797,
                                    highlightColor: ColorsItem.grey606060,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: Dimens.SPACE_6),
                          Row(
                            children: [
                              Expanded(
                                child: Shimmer.fromColors(
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Dimens.SPACE_20,
                                        right: Dimens.SPACE_10),
                                    decoration: BoxDecoration(
                                      color: ColorsItem.black32373D,
                                      borderRadius: new BorderRadius.all(
                                          const Radius.circular(
                                              Dimens.SPACE_12)),
                                    ),
                                    height: Dimens.SPACE_12,
                                  ),
                                  baseColor: ColorsItem.grey979797,
                                  highlightColor: ColorsItem.grey606060,
                                ),
                              ),
                              Shimmer.fromColors(
                                period: Duration(seconds: 1),
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: Dimens.SPACE_5),
                                  decoration: BoxDecoration(
                                    color: ColorsItem.black32373D,
                                    borderRadius: new BorderRadius.all(
                                        const Radius.circular(Dimens.SPACE_12)),
                                  ),
                                  width: Dimens.SPACE_100,
                                  height: Dimens.SPACE_12,
                                ),
                                baseColor: ColorsItem.grey979797,
                                highlightColor: ColorsItem.grey606060,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: Dimens.SPACE_20,
                              top: Dimens.SPACE_10,
                            ),
                            child: Shimmer.fromColors(
                              period: Duration(seconds: 1),
                              child: Container(
                                margin: EdgeInsets.only(right: Dimens.SPACE_5),
                                decoration: BoxDecoration(
                                  color: ColorsItem.black32373D,
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(Dimens.SPACE_12)),
                                ),
                                height: Dimens.SPACE_1,
                              ),
                              baseColor: ColorsItem.grey979797,
                              highlightColor: ColorsItem.grey606060,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
