import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mobile_sev2/app/infrastructures/events/download.dart';
import 'package:mobile_sev2/app/infrastructures/misc/utils.dart';
import 'package:mobile_sev2/data/infrastructures/downloader_interface.dart';

class Downloader implements DownloaderInterface {
  List<DownloadTask> _tasks = [];
  ReceivePort _port = ReceivePort();
  EventBus _eventBus;

  Downloader(this._eventBus) {
    _getDownloadedTasks();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      print('Download progress: $id, $status, $progress');
      if (status == DownloadTaskStatus.complete) {
        Future.delayed(
          Duration(milliseconds: 1000),
          () {
            _getDownloadedTasks().then((value) {
              if (progress <= 100 && progress >= 0)
                _eventBus.fire(DownloaderEvent(id, status, progress));
              // FlutterDownloader.open(taskId: id);
            });
          },
        );
      }
      if (status == DownloadTaskStatus.running) {
        if (progress <= 100 && progress >= 0)
          _eventBus.fire(DownloaderEvent(id, status, progress));
      }
    });
  }

  @override
  void cancel(String taskId) {
    FlutterDownloader.cancel(taskId: taskId);
  }

  @override
  void cancelAll() {
    FlutterDownloader.cancelAll();
  }

  @override
  void pause(String taskId) {
    FlutterDownloader.pause(taskId: taskId);
  }

  @override
  Future<String?> resume(String taskId) async {
    return FlutterDownloader.resume(taskId: taskId);
  }

  @override
  Future<String?> retry(String taskId) {
    return FlutterDownloader.retry(taskId: taskId);
  }

  @override
  Future<String?> startDownload(String url, BuildContext context) async {
    return await FlutterDownloader.enqueue(
      url: url,
      savedDir: await Utils.getDownloadDir(context),
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  @override
  bool isAlreadyDownloaded(String url) {
    var idx = _tasks.indexWhere((element) => element.url == url);
    if (idx > -1)
      return true;
    else
      return false;
  }

  @override
  void openFile(String url) {
    var idx = _tasks.indexWhere((element) => element.url == url);
    print("openFile index: $idx");
    if (idx > -1) {
      FlutterDownloader.open(taskId: _tasks[idx].taskId);
    }
  }

  @override
  Future<String?> startDownloadOrOpen(String url, BuildContext context) async {
    var value = await FlutterDownloader.loadTasksWithRawQuery(
        query: 'SELECT * FROM task WHERE status=3');
    if (value != null) {
      _tasks.clear();
      _tasks.addAll(value);
      var idx = value.indexWhere((element) => element.url == url);
      print("startDownloadOrOpen index: $idx");
      if (idx == -1) {
        return startDownload(url, context);
      } else {
        openFile(url);
        return Future.value(value[idx].taskId);
      }
    }
    return '';
  }

  Future<void> _getDownloadedTasks() async {
    await FlutterDownloader.loadTasksWithRawQuery(
            query: 'SELECT * FROM task WHERE status=3')
        .then((value) {
      if (value != null) {
        _tasks.clear();
        _tasks.addAll(value);
      }
    });
  }
}
