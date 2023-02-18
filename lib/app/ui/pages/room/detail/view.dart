import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/resources/generated/i18n.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/simple_app_bar.dart';
import 'package:mobile_sev2/app/ui/assets/widget/empty_list.dart';
import 'package:mobile_sev2/app/ui/assets/widget/file_item.dart';
import 'package:mobile_sev2/app/ui/assets/widget/refresh_indicator.dart';
import 'package:mobile_sev2/app/ui/pages/room/detail/controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/domain/file.dart';

class RoomDetailPage extends View {
  final Object? arguments;

  RoomDetailPage({this.arguments});

  @override
  _RoomDetailState createState() => _RoomDetailState(
      AppComponent.getInjector().get<RoomDetailController>(), arguments);
}

class _RoomDetailState extends ViewState<RoomDetailPage, RoomDetailController> {
  RoomDetailController _controller;
  Map<String, PreviewData> datas = {};

  _RoomDetailState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  var isGrup = true;

  @override
  Widget get view => AnimatedTheme(
        data: Theme.of(context),
        child: ControlledWidgetBuilder<RoomDetailController>(
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
                  S.of(context).label_info,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(fontSize: Dimens.SPACE_16),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            body: Container(
              child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: Dimens.SPACE_20),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width / 13,
                                    backgroundImage: CachedNetworkImageProvider(
                                        _controller.getOtherMember().avatar!),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: Dimens.SPACE_10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: RichText(
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          text:
                                              _controller.getOtherMember().name,
                                          style: GoogleFonts.montserrat(
                                              fontSize: Dimens.SPACE_16,
                                              fontWeight: FontWeight.bold,
                                              color: ColorsItem.grey666B73),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  " (${_controller.getOtherMember().name})",
                                              style: GoogleFonts.montserrat(
                                                fontSize: Dimens.SPACE_16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dimens.SPACE_10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 6.0,
                                          backgroundColor:
                                              ColorsItem.green219653,
                                        ),
                                        SizedBox(width: Dimens.SPACE_4),
                                        Text(
                                          "Available",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Container(
                    child: DefaultTabController(
                      length: 3,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          TabBar(
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: ColorsItem.orangeFB9600,
                            unselectedLabelColor: ColorsItem.grey666B73,
                            labelColor: ColorsItem.orangeFB9600,
                            tabs: [
                              Tab(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.photoFilm),
                                      SizedBox(width: Dimens.SPACE_12),
                                      Flexible(
                                        child: Text(
                                            S
                                                .of(context)
                                                .room_detail_media_title,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14.0),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.solidFile),
                                      SizedBox(width: Dimens.SPACE_12),
                                      Flexible(
                                        child: Text(
                                            S
                                                .of(context)
                                                .room_detail_files_title,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14.0),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.link),
                                      SizedBox(width: Dimens.SPACE_12),
                                      Flexible(
                                        child: Text(
                                            S
                                                .of(context)
                                                .room_detail_links_title,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14.0),
                                            maxLines: 1,
                                            overflow: TextOverflow.fade),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                              child: Container(
                            child: TabBarView(
                              children: [
                                _controller.medias.isEmpty
                                    ? EmptyList(
                                        title: S
                                            .of(context)
                                            .room_detail_detail_empty_title,
                                        descripton: S
                                            .of(context)
                                            .room_detail_detail_empty_subtitle)
                                    : _tabMedia(),
                                _controller.docs.isEmpty
                                    ? EmptyList(
                                        title: S
                                            .of(context)
                                            .room_detail_detail_empty_title,
                                        descripton: S
                                            .of(context)
                                            .room_detail_detail_empty_subtitle)
                                    : ListView.builder(
                                        itemCount: _controller.docs.length,
                                        itemBuilder: (context, index) {
                                          var file = _controller.docs[index];
                                          return Container(
                                            padding: index == 0
                                                ? EdgeInsets.only(
                                                    top: Dimens.SPACE_20)
                                                : null,
                                            color: ColorsItem.black191C21,
                                            child: FileItem(
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
                                            ),
                                          );
                                        }),
                                _controller.links.isEmpty
                                    ? EmptyList(
                                        title: S
                                            .of(context)
                                            .room_detail_detail_empty_title,
                                        descripton: S
                                            .of(context)
                                            .room_detail_detail_empty_subtitle)
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _controller.links.length,
                                        itemBuilder: (context, index) => Align(
                                          alignment: Alignment.centerLeft,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                key: ValueKey(_controller
                                                    .links[index].url),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.all(
                                                    Dimens.SPACE_15),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.SPACE_12),
                                                  ),
                                                  color: ColorsItem.greyCCECEF
                                                      .withOpacity(0.07),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(
                                                        Dimens.SPACE_12),
                                                  ),
                                                  child: LinkPreview(
                                                    enableAnimation: true,
                                                    onPreviewDataFetched:
                                                        (data) {
                                                      setState(() {
                                                        datas = {
                                                          ...datas,
                                                          _controller
                                                              .links[index]
                                                              .url: data,
                                                        };
                                                      });
                                                    },
                                                    onLinkPressed: (link) {
                                                      _controller
                                                          .launchURL(link);
                                                    },
                                                    previewData: datas[
                                                        _controller
                                                            .links[index].url],
                                                    text: _controller
                                                        .links[index].url,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    textStyle:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteFEFEFE),
                                                    linkStyle:
                                                        GoogleFonts.montserrat(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .urlColor),
                                                    metadataTitleStyle:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_14,
                                                            color: ColorsItem
                                                                .whiteFEFEFE),
                                                    metadataTextStyle:
                                                        GoogleFonts.montserrat(
                                                            fontSize:
                                                                Dimens.SPACE_12,
                                                            color: ColorsItem
                                                                .grey666B73),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                  indent: Dimens.SPACE_15,
                                                  color: ColorsItem.grey666B73,
                                                  height: Dimens.SPACE_2)
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ))
                        ],
                      ),
                    ),
                  )),
            ),
          );
        }),
      );

  Widget _tabMedia() {
    return Container(
      color: ColorsItem.black191C21,
      child: DefaultRefreshIndicator(
        onRefresh: () => _controller.reload(type: "media"),
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(_controller.medias.length, (index) {
            return Container(
              width: MediaQuery.of(context).size.width / 3,
              child: _controller.medias[index].fileType == FileType.image
                  ? GestureDetector(
                      onTap: () {
                        _controller.goToMediaDetail(
                          MediaType.image,
                          _controller.medias[index].url,
                          _controller.medias[index].title,
                        );
                      },
                      child: Hero(
                        tag: _controller.medias[index].url,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: _controller.medias[index].url,
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        _controller.goToMediaDetail(
                          MediaType.video,
                          _controller.medias[index].url,
                          _controller.medias[index].title,
                        );
                      },
                      child: Container(
                        color: ColorsItem.black020202,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.circlePlay,
                            color: ColorsItem.whiteE0E0E0,
                            size: Dimens.SPACE_40,
                          ),
                        ),
                      ),
                    ),
            ); //robohash.org api provide you different images for any number you are giving
          }),
        ),
      ),
    );
  }
}
