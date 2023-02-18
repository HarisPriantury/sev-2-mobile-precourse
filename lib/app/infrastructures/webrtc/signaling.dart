import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mobile_sev2/app/infrastructures/misc/common.dart';
import 'package:mobile_sev2/app/infrastructures/misc/user_data.dart';
import 'package:mobile_sev2/app/infrastructures/webrtc/peer.dart';

import 'websocket.dart';

enum SignalingState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

typedef void StreamStateCallback(MediaStream stream);
typedef void EventCallback(String event, dynamic data);
typedef void DataChannelMessageCallback(
    RTCDataChannel dc, RTCDataChannelMessage data);
typedef void DataChannelCallback(RTCDataChannel dc);
typedef void IceConnectionStateCallback(RTCIceConnectionState state);

class Signaling with CommonUtil {
  WebSocketRoomClient _socket;
  String _turnUrl;
  String _username;
  String _password;
  UserData _userData;

  late Map<String, dynamic> _iceServers;
  late Map<String, dynamic> _constraints;

  PeerData? _local;
  List<PeerData> _peers = [];
  MediaStream? _localStream;

  StreamStateCallback? onLocalStream;
  StreamStateCallback? onAddRemoteStream;
  StreamStateCallback? onRemoveRemoteStream;
  EventCallback? onEventCallback;
  DataChannelMessageCallback? onDataChannelMessage;
  DataChannelCallback? onDataChannel;
  IceConnectionStateCallback? onConnectionStateChange;

  PeerData? get localData => _local;

  List<PeerData> get peers => _peers;

  Signaling(
    this._turnUrl,
    this._username,
    this._password,
    this._socket,
    this._userData,
  ) {
    _iceServers = {
      'iceServers': [
        {
          'urls': _turnUrl,
        },
      ]
    };

    _constraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': false,
      },
      'optional': [],
    };
  }

  String get sdpSemantics =>
      WebRTC.platformIsWindows ? 'plan-b' : 'unified-plan';

  init() async {
    _localStream = await _createStream();
    print("localStream created ${_localStream!.id}");
  }

  PeerData? _findPeerByPeerId(String peerId) {
    int idx = _peers.indexWhere((element) => element.peerId == peerId);
    if (idx == -1) return null;
    return _peers[idx];
  }

  PeerData? _findPeerByPHID(String phid) {
    int idx = _peers.indexWhere((element) => element.peerPHID == phid);
    if (idx == -1) return null;
    return _peers[idx];
  }

  void switchCamera() {
    if (_localStream != null) {
      Helper.switchCamera(_localStream!.getVideoTracks()[0]);
    }
  }

  close() async {
    print("signaling: close called");
    if (_local != null) {
      await _clearLocal();
      print("signaling: local != null");
      await _clearPeers();
      await _socket.close();
    }
  }

  _clearLocal() async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    _localStream?.dispose();
    _localStream = null;
    if (_local != null) {
      _local?.muted = true;
      _local?.dataChannel = null;
      await _local?.dataChannel?.close();
      await _local?.pc?.close();
      if (_local?.videoRenderer != null) await _local?.videoRenderer?.dispose();
      _local = null;
    }
  }

  _clearPeers() async {
    await Future.forEach(_peers, (PeerData p) async {
      await p.dataChannel?.close();
      await p.videoRenderer?.dispose();
      await p.pc?.close();
      print("peer ${p.peerId} cleared");
    });
    print("peer cleared");
    _peers.clear();
  }

  void onMessage(event, message) async {
    print("Signaling onMessage: $event $message");
    switch (event) {
      case OFFER_EVENT:
        {
          var id = message['from'];
          var description = message['data'];
          PeerData? peer = _findPeerByPeerId(id);
          if (peer == null) {
            await _createPeerConnection(id, "", isHost: false);
            peer = _findPeerByPeerId(id);
          }
          await peer?.pc?.setRemoteDescription(
              RTCSessionDescription(description['sdp'], description['type']));
          await _createAnswer(id, peer!.pc!);
        }
        break;
      case ANSWER_EVENT:
        {
          var id = message['from'];
          var description = message['data'];
          if (_findPeerByPeerId(id) != null) {
            _findPeerByPeerId(id)!.pc?.setRemoteDescription(
                RTCSessionDescription(description['sdp'], description['type']));
          }
        }
        break;
      case CANDIDATE_EVENT:
        {
          var id = message['from'];
          var candidateMap = message['data'];

          if (candidateMap != null) {
            if (_findPeerByPeerId(id) != null) {
              RTCIceCandidate candidate = RTCIceCandidate(
                  candidateMap['candidate'],
                  candidateMap['id'],
                  candidateMap['label']);
              if (_findPeerByPeerId(id)!.pc != null) {
                await _findPeerByPeerId(id)!.pc?.addCandidate(candidate);
              }
            }
          }
        }
        break;

      case JOINED_EVENT:
        {
          var peerId = message['data']['peer_id'];
          var username = message['data']['username'];

          if (_findPeerByPeerId(peerId) != null) {
            _findPeerByPeerId(peerId)!.peerPHID = username;
          }
          await _createPeerConnection(peerId, username, isHost: true);
          this.onEventCallback!(event, {"id": username});
        }
        break;

      case LEFT_EVENT:
        {
          var peerId = message['data']['peer_id'];
          var username = message['data']['username'];

          if (_findPeerByPeerId(peerId) != null) {
            _findPeerByPeerId(peerId)!.pc?.close();
            _findPeerByPeerId(peerId)!
                .videoRenderer
                ?.srcObject
                ?.getTracks()
                .forEach((track) {
              track.stop();
            });
            _findPeerByPeerId(peerId)!.videoRenderer?.srcObject = null;
            _peers.remove(_findPeerByPeerId(peerId));
          }

          this.onEventCallback!(event, {"id": username});
        }
        break;
      case AUTHENTICATED_EVENT:
        {
          // var localStream = await _createStream();
          var videoRenderer = RTCVideoRenderer();
          await videoRenderer.initialize().then((value) {
            videoRenderer.srcObject = _localStream;
          });
          _local = new PeerData(message['data']['peer_id'], _username,
              videoRenderer: videoRenderer);
          _createPeerConnection(_local?.peerId, _local?.peerPHID, isHost: true);
          _setMute(_username, true);
          enableSpeaker(true);
          if (onEventCallback != null)
            onEventCallback!(event, {"id": _username});
        }
        break;
      default:
        break;
    }
  }

  void connect(String roomId) async {
    init();
    _socket.onMessage = (tag, message) {
      print('signaling: received data $tag - $message');
      this.onMessage(tag, message);
    };

    _socket.onClose = (int code, String reason) {
      print('Closed by server [$code => $reason]!');
    };

    // connect
    _socket.connect(roomId);

    // authenticating
    _send(AUTHENTICATING_EVENT, {'username': _username, 'password': _password});
  }

  Future<MediaStream> _createStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false,
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    if (this.onLocalStream != null) {
      this.onLocalStream!(stream);
    }
    return stream;
  }

  Future<RTCPeerConnection> _createPeerConnection(peerId, peerPHID,
      {isHost = false}) async {
    print("onCreatePeerConnection: $peerId $peerPHID");
    RTCPeerConnection pc = await createPeerConnection({
      ..._iceServers,
      ...{'sdpSemantics': sdpSemantics}
    });
    pc.onTrack = (event) async {
      if (event.streams.length > 0 && _local?.peerId != peerId) {
        MediaStream remoteStream;
        if (_findPeerByPeerId(peerId)?.videoRenderer?.srcObject != null)
          remoteStream = _findPeerByPeerId(peerId)!.videoRenderer!.srcObject!;
        else
          remoteStream = await _createStream();
        event.streams.first.getTracks().forEach((track) {
          track.onEnded = () {
            print("onTrackEnded: ${track.id}");
          };
          remoteStream.addTrack(track);
        });
        _findPeerByPeerId(peerId)?.videoRenderer?.srcObject = null;
        _findPeerByPeerId(peerId)?.videoRenderer?.srcObject = remoteStream;
      }
      onAddRemoteStream?.call(event.streams[0]);
    };

    pc.onIceCandidate = (candidate) {
      final iceCandidate = {
        'label': candidate.sdpMLineIndex,
        'id': candidate.sdpMid,
        'candidate': candidate.candidate
      };
      emitIceCandidateEvent(peerId, iceCandidate);
    };

    pc.onIceConnectionState = (state) {
      print('onIceConnectionState $state');
      if (state == RTCIceConnectionState.RTCIceConnectionStateClosed ||
          state == RTCIceConnectionState.RTCIceConnectionStateFailed) {
        // _clearPeers();
      }

      if (onConnectionStateChange != null) onConnectionStateChange!.call(state);
    };

    if (_local?.videoRenderer?.srcObject != null) {
      _local?.videoRenderer?.srcObject!.getTracks().forEach((track) {
        if (_local?.videoRenderer?.srcObject != null)
          pc.addTrack(track, _local!.videoRenderer!.srcObject!);
      });
    }

    var dataChannel;
    if (_findPeerByPeerId(peerId) != null) {
      dataChannel = await _createDataChannel(_findPeerByPeerId(peerId)!, pc);
    } else {
      dataChannel = await _createDataChannel(_local!, pc);
    }

    if (peerPHID == _local?.peerPHID) {
      if (_local?.pc == null) {
        _local?.pc = pc;
      }
      if (_local?.dataChannel == null) {
        _local?.dataChannel = dataChannel;
      }
    } else {
      _peers.add(PeerData(peerId, peerPHID,
          dataChannel: dataChannel, pc: pc, muted: true));
    }
    if (isHost && peerId != _local?.peerId) {
      _createOffer(peerId, pc);
    }

    return pc;
  }

  void _setMute(String peerPHID, bool muted, {bool broadcasted = true}) {
    if (broadcasted) {
      if (_local?.videoRenderer?.srcObject != null) {
        _local?.videoRenderer?.srcObject?.getAudioTracks()[0].enabled = !muted;
      }

      _local?.muted = muted;

      // broadcast to all peers
      _peers.forEach((p) {
        _sendDataChannel(p, {
          "peerId": _local?.peerId,
          "phid": _local?.peerPHID,
          "type": "media_state",
          "muted": muted
        });
      });
      print("broadcasted peers total: ${_peers.length}");
    } else {
      print(
          "onSetMute: $peerPHID muted: $muted, isfound: ${_findPeerByPHID(peerPHID) != null}");
      _findPeerByPHID(peerPHID)?.muted = muted;
    }
  }

  void muteMic(bool muted) {
    _setMute(_local!.peerPHID, muted, broadcasted: true);
  }

  void enableSpeaker(bool state) {
    _local?.videoRenderer?.srcObject
        ?.getAudioTracks()
        .first
        .enableSpeakerphone(state);
  }

  _sendDataChannel(PeerData p, dynamic value) {
    print(
        "onSendMessage: ${p.peerPHID} ${p.dataChannel != null} ${p.dataChannel?.state} $value");
    if (p.peerPHID != _username &&
        p.dataChannel != null &&
        p.dataChannel?.state == RTCDataChannelState.RTCDataChannelOpen) {
      // var msg = {"peerId": p.peerId, "phid": p.peerPHID, "type": type, "value": value};
      print("sendMessage: $value to ${p.peerId}");
      p.dataChannel?.send(RTCDataChannelMessage(jsonEncode(value)));
    }
  }

  _addDataChannel(PeerData data, RTCDataChannel channel) {
    channel.onDataChannelState = (e) {
      switch (e) {
        case RTCDataChannelState.RTCDataChannelOpen:
          print("data channel on open");
          channel.send(
            RTCDataChannelMessage(
              jsonEncode(
                {
                  "peerId": _local?.peerId,
                  "phid": _local?.peerPHID,
                  "type": "ehlo",
                  "name": _userData.name,
                  "image": _userData.avatar,
                },
              ),
            ),
          );
          break;
        default:
          break;
      }
    };
    channel.onMessage = (RTCDataChannelMessage data) {
      var text = jsonDecode(data.text);
      print("channel OnMessage: $text");
      if (text['type'] == "ehlo") {
        print("user identified: ${text['phid']}");
        _findPeerByPeerId(text['peerId'])?.peerPHID = text['phid'];
      } else if (text['type'] == "media_state") {
        _setMute(text['phid'], text['muted'] as bool, broadcasted: false);
        print(
            "channel OnMessage: onMute ${text['phid']} ${text['muted']} typeOf ${text['muted'].runtimeType}");
      }
      if (this.onDataChannelMessage != null)
        this.onDataChannelMessage!(channel, data);
    };

    if (this.onDataChannel != null) this.onDataChannel!(channel);
  }

  Future<RTCDataChannel> _createDataChannel(
      PeerData peerData, RTCPeerConnection pc,
      {label: 'side'}) async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    dataChannelDict.negotiated = true;
    dataChannelDict.id = 0;
    RTCDataChannel channel = await pc.createDataChannel(label, dataChannelDict);
    _addDataChannel(peerData, channel);
    return channel;
  }

  _createOffer(String id, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createOffer(_constraints);
      pc.setLocalDescription(s);
      print("createOffer");
      final description = {'sdp': s.sdp, 'type': s.type};
      emitOfferEvent(id, description);
    } catch (e) {
      print(e.toString());
    }
  }

  _createAnswer(String id, RTCPeerConnection pc) async {
    try {
      RTCSessionDescription s = await pc.createAnswer(_constraints);
      pc.setLocalDescription(s);
      print("createAnswer");
      final description = {'sdp': s.sdp, 'type': s.type};
      emitAnswerEvent(id, description);
    } catch (e) {
      print("createAnswer error: ${e.toString()}");
    }
  }

  _send(event, data, {toPeer}) {
    _socket.send(event, data, toPeer: toPeer);
  }

  emitOfferEvent(peerId, description) {
    _send(OFFER_EVENT, description, toPeer: peerId);
  }

  emitAnswerEvent(peerId, description) {
    _send(ANSWER_EVENT, description, toPeer: peerId);
  }

  emitIceCandidateEvent(peerId, candidate) {
    _send(CANDIDATE_EVENT, candidate, toPeer: peerId);
  }
}
