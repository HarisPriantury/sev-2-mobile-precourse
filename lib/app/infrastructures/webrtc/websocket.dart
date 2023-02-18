import 'dart:async';
import 'dart:convert';

import 'package:mobile_sev2/app/infrastructures/misc/common.dart';
import 'package:web_socket_channel/io.dart';

typedef void OnMessageCallback(String tag, dynamic msg);
typedef void OnCloseCallback(int code, String reason);
typedef void OnOpenCallback();

const OFFER_EVENT = 'offer';
const ANSWER_EVENT = 'answer';
const LEFT_EVENT = 'left';
const JOINED_EVENT = 'joined';
const CANDIDATE_EVENT = 'candidate';
const AUTHENTICATED_EVENT = 'authenticated';
const AUTHENTICATING_EVENT = 'authenticate';

const STATE_TYPE = 'state';
const MESSAGE_TYPE = 'message';

const DC_MUTED = 'muted';

class WebSocketRoomClient with CommonUtil {
  String url;
  IOWebSocketChannel? socket;
  OnOpenCallback? onOpen;
  OnMessageCallback? onMessage;
  OnCloseCallback? onClose;

  WebSocketRoomClient(this.url);

  connect(String? roomId) {
    try {
      socket = IOWebSocketChannel.connect("$url/suite-$roomId");
      socket?.stream.listen((message) {
        print("roomwebsocket onMessage: $message");
        var msg = jsonDecode(message);

        switch (msg['event']) {
          case OFFER_EVENT:
            onMessage!(OFFER_EVENT, msg);
            break;
          case ANSWER_EVENT:
            onMessage!(ANSWER_EVENT, msg);
            break;
          case CANDIDATE_EVENT:
            onMessage!(CANDIDATE_EVENT, msg);
            break;
          case LEFT_EVENT:
            onMessage!(LEFT_EVENT, msg);
            break;
          case JOINED_EVENT:
            onMessage!(JOINED_EVENT, msg);
            break;
          case AUTHENTICATED_EVENT:
            onMessage!(AUTHENTICATED_EVENT, msg);
            break;
          case AUTHENTICATING_EVENT:
            onMessage!(AUTHENTICATING_EVENT, msg);
            break;

          default:
        }
      });
    } catch (e) {
      print(e);
      onClose!(500, e.toString());
    }
  }

  send(event, data, {toPeer}) {
    var msg = jsonEncode({'event': event, 'data': data, 'to': toPeer});
    socket?.sink.add(msg);
    print('roomwebsocket: send $msg');
  }

  close() async {
    await socket?.sink.close();
  }
}

class WebSocketDashboardClient with CommonUtil {
  String url;
  IOWebSocketChannel? socket;
  OnOpenCallback? onOpen;
  OnMessageCallback? onMessage;
  OnCloseCallback? onClose;
  StreamController? streamController;

  WebSocketDashboardClient(this.url);

  connect() {
    try {
      streamController = StreamController.broadcast();
      socket = IOWebSocketChannel.connect(url);
      streamController?.addStream(socket!.stream);
      print("dashboardwebsocket: connected");
    } catch (e) {
      print("dashboardwebsocket onClose: $e");
      if (onClose != null) onClose!(500, e.toString());
    }
  }

  subscribe(String userId, String channelId) {
    var msg = jsonEncode({
      "command": "subscribe",
      "data": [channelId, userId]
    });
    socket?.sink.add(msg);
    print('dashboardwebsocket: send $msg');
  }

  close() async {
    await socket?.sink.close();
    await streamController?.close();
  }
}
