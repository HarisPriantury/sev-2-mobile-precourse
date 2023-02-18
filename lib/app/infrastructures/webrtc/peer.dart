import 'package:flutter_webrtc/flutter_webrtc.dart';

class PeerData {
  String peerId;
  String peerPHID;
  bool muted;
  RTCPeerConnection? pc;
  RTCDataChannel? dataChannel;
  RTCVideoRenderer? videoRenderer;

  PeerData(
    this.peerId,
    this.peerPHID, {
    this.muted = true,
    this.pc,
    this.dataChannel,
    this.videoRenderer,
  });
}
