@JS()
library dart_peer_js;

import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';
import 'dart:convert';

@JS()
external void startPeer();
@JS()
external void getPermission(String myID, bool isGettingPermission, String facingMode);
@JS()
external void shareScreen(String elementID);
@JS()
external void connectNewUser(String theirID);
@JS()
external void sendData(String data);

@JS()
external void muteMyVideo(bool flag);
@JS()
external void muteMyAudio(bool flag);
@JS()
external void leaveCall();

@JS()
external void volumeMeter(String videoID, double volume);


@JS("returnPeerID")
external set _returnPeerID(void Function(String myID) f);
@JS("returnPermissionResult")
external set _returnPermissionResult(void Function(bool flag) f);
@JS("onScreenShareClosed")
external set _onScreenShareClosed(void Function() f);
@JS("returnStream")
external set _returnStream(void Function(String id, MediaStream stream, double streamVolume) f);
@JS("returnData")
external set _returnData(void Function(String data) f);




class PeerJS{
  final String frontCam = "user";
  final String backCam = "environment";

  String myPeerID;
  bool permissionOn;
  bool isCamFacingFront = true;
  bool isSharingScreen = false;
  bool isMicOn = true;
  bool isVideoOn = true;

  dynamic Function(String myID) onPeer;
  dynamic Function(bool flag) onPermissionResult;
  dynamic Function(String id, MediaStream stream, double streamVolume) onStream;
  dynamic Function(Map<String, dynamic> data) onDataReceived;
  PeerJS({@required this.onPeer, @required this.onPermissionResult, @required this.onStream, this.onDataReceived,}){
    if(onPeer != null){
      _returnPeerID = allowInterop(onPeer);
    }
    if(onPermissionResult != null) {
      _returnPermissionResult = allowInterop(onPermissionResult);
    }
    if(onStream != null){
      _returnStream = allowInterop(onStream);
    }
    if(onDataReceived != null) {
      _returnData = allowInterop((String data) {
        onDataReceived(json.decode(data));
      });
    }
  }

  void startPeerJS(){
    startPeer();
  }


  void getPermissionJS(String myID, bool isGettingPermission, String facingMode){
    getPermission(myID, isGettingPermission, facingMode,);
  }
  void shareScreenJS(String elementID, Function() onClose){
    isSharingScreen = !isSharingScreen;
    if(isSharingScreen == true){
      shareScreen(elementID);
      _onScreenShareClosed = allowInterop((){
        onClose();
      });
    }
  }
  void connectNewUserJS(String theirID){
    connectNewUser(theirID);
  }
  void sendDataJS(Map<String, dynamic> data){
    sendData(json.encode(data));
  }


  void toggleVideoJS(){
    isVideoOn = !isVideoOn;
    muteMyVideo(isVideoOn);
    sendDataJS({
      "id" : myPeerID,
      "audio" : isMicOn,
      "video" : isVideoOn,
    });
  }
  void toggleAudioJS(){
    isMicOn = !isMicOn;
    muteMyAudio(isMicOn);
    sendDataJS({
      "id" : myPeerID,
      "audio" : isMicOn,
      "video" : isVideoOn,
    });
  }
  void toggleCameraFaceJS(){
    isCamFacingFront = !isCamFacingFront;
    getPermissionJS(myPeerID, false, isCamFacingFront ? frontCam : backCam,);
  }

  void leaveCallJS() {
    leaveCall();
  }

  void volumeMeter(String videoID, double volume){
    volumeMeter(videoID, volume);
  }

}
