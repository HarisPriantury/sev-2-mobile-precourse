import 'package:flutter/animation.dart';
import 'package:mobile_sev2/app/infrastructures/misc/base_controller.dart';
import 'package:mobile_sev2/app/ui/pages/room/media/args.dart';
import 'package:video_player/video_player.dart';

class MediaController extends BaseController {
  late MediaArgs _data;
  late VideoPlayerController _videoPlayerController;
  late final AnimationController animationController;
  bool _isMediaVisible = true;

  MediaArgs get data => _data;

  VideoPlayerController get videoPlayerController => _videoPlayerController;

  bool get isMediaVisible => _isMediaVisible;

  void playVideo(state) {
    if (state) {
      if (_videoPlayerController.value.duration == _videoPlayerController.value.position) restartVideo();
      _videoPlayerController.play();
      mediaVisibility(false);
    } else {
      _videoPlayerController.pause();
    }
    refreshUI();
  }

  void restartVideo() async {
    await _videoPlayerController.seekTo(Duration.zero);
    refreshUI();
  }

  void mediaVisibility(visibility) {
    if (!_videoPlayerController.value.isPlaying && visibility == false)
      return;
    else
      _isMediaVisible = visibility;
    refreshUI();
  }

  void toggleVisibility() {
    _isMediaVisible = !_isMediaVisible;
    refreshUI();
  }

  @override
  void disposing() {
    if (_data.type == MediaType.video) _videoPlayerController.dispose();
  }

  @override
  void getArgs() {
    if (args != null) {
      _data = args as MediaArgs;
      if (_data.type == MediaType.video) {
        _videoPlayerController = VideoPlayerController.network(_data.url)
          ..initialize().then((_) {
            _videoPlayerController.addListener(() {
              if (!_videoPlayerController.value.isPlaying &&
                  _videoPlayerController.value.isInitialized &&
                  (_videoPlayerController.value.duration == _videoPlayerController.value.position)) {
                mediaVisibility(true);
              }
              refreshUI();
            });
            refreshUI();
          });
      }
    }
  }

  @override
  void initListeners() {}

  @override
  void load() {
    // TODO: implement load
  }
}
