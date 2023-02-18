import 'package:flutter_downloader/flutter_downloader.dart';

class DownloaderEvent {
  String id;
  DownloadTaskStatus status;
  int progress;

  DownloaderEvent(this.id, this.status, this.progress);
}