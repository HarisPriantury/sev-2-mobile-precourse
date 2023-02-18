import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sev2/app/infrastructures/di/app_component.dart';
import 'package:mobile_sev2/app/ui/assets/resources/colors/colors.dart';
import 'package:mobile_sev2/app/ui/assets/resources/dimens/dimens.dart';
import 'package:mobile_sev2/app/ui/assets/widget/app_bar/sliding_app_bar.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/controller.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class MediaPage extends View {
  final Object? arguments;

  MediaPage({this.arguments});

  @override
  _MediaState createState() =>
      _MediaState(AppComponent.getInjector().get<MediaController>(), arguments);
}

class _MediaState extends ViewState<MediaPage, MediaController>
    with SingleTickerProviderStateMixin {
  MediaController _controller;

  _MediaState(this._controller, Object? args) : super(_controller) {
    _controller.args = args;
  }

  @override
  void initState() {
    super.initState();
    _controller.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget get view =>
      ControlledWidgetBuilder<MediaController>(builder: (context, controller) {
        if (_controller.data.type == MediaType.image) {
          return Scaffold(
            key: globalKey,
            backgroundColor: Colors.black,
            extendBodyBehindAppBar: true,
            appBar: SlidingAppBar(
              child: AppBar(
                backgroundColor: Colors.transparent,
                bottomOpacity: 0.0,
                elevation: 0.0,
                toolbarHeight: MediaQuery.of(context).size.height / 10,
                titleSpacing: 0,
                leading: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: ColorsItem.whiteE0E0E0,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  _controller.data.title,
                  style: GoogleFonts.montserrat(
                    fontSize: Dimens.SPACE_18,
                    color: ColorsItem.whiteEDEDED,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              controller: _controller.animationController,
              visible: _controller.isMediaVisible,
            ),
            body: GestureDetector(
              onTap: () {
                _controller.toggleVisibility();
              },
              child: Center(
                child: Hero(
                  tag: _controller.data.url,
                  child: PhotoView(
                    imageProvider:
                        CachedNetworkImageProvider(_controller.data.url),
                    // child: CachedNetworkImage(
                    //   imageUrl: _controller.data.url,
                    // ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              key: globalKey,
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: SlidingAppBar(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  bottomOpacity: 0.0,
                  elevation: 0.0,
                  toolbarHeight: MediaQuery.of(context).size.height / 10,
                  titleSpacing: 0,
                  leading: IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.chevronLeft,
                      color: ColorsItem.whiteE0E0E0,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    _controller.data.title,
                    style: GoogleFonts.montserrat(
                      fontSize: Dimens.SPACE_18,
                      color: ColorsItem.whiteEDEDED,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                controller: _controller.animationController,
                visible: _controller.isMediaVisible,
              ),
              body: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.mediaVisibility(true);
                      if (_controller.videoPlayerController.value.isPlaying) {
                        _controller.delay(() {
                          print("MediaPage: onTap outside button");
                          _controller.mediaVisibility(false);
                        }, period: 2);
                      }
                    },
                    child: Center(
                      child:
                          _controller.videoPlayerController.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller
                                      .videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(
                                      _controller.videoPlayerController),
                                )
                              : CircularProgressIndicator(
                                  color: ColorsItem.whiteE0E0E0),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("MediaPage: button play clicked");
                      if (_controller.isMediaVisible)
                        _controller.playVideo(
                            !_controller.videoPlayerController.value.isPlaying);
                    },
                    child: Center(
                      child: _controller
                              .videoPlayerController.value.isInitialized
                          ? AnimatedOpacity(
                              opacity: _controller.isMediaVisible ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 400),
                              child: FaIcon(
                                _controller
                                        .videoPlayerController.value.isPlaying
                                    ? FontAwesomeIcons.circlePause
                                    : FontAwesomeIcons.circlePlay,
                                color: ColorsItem.whiteE0E0E0,
                                size: Dimens.SPACE_60,
                              ),
                            )
                          : SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      });
}
