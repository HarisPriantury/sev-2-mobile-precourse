import 'package:flutter/material.dart';

abstract class DownloaderInterface {
  Future<String?> startDownloadOrOpen(String url, BuildContext context);
  Future<String?> startDownload(String url, BuildContext context);
  void cancel(String taskId);
  void cancelAll();
  void pause(String taskId);
  Future<String?> resume(String taskId);
  Future<String?> retry(String taskId);
  bool isAlreadyDownloaded(String url);
  void openFile(String url);
}
