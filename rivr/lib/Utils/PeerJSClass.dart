@JS()
library dart_peer_js;

import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

@JS()
external void startPeer();
@JS()
external void getPermission(String myID);
@JS()
external void shareScreen(String elementID);
@JS()
external void connectNewUser(String theirID);
@JS()
external void sendData(dynamic data);

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
external set _returnData(void Function(dynamic data) f);




class PeerJS{
  String myPeerID;
  bool permissionOn;
  bool isSharingScreen = false;
  bool isMicOn = true;
  bool isVideoOn = true;

  dynamic Function(String myID) onPeer;
  dynamic Function(bool flag) onPermissionResult;
  dynamic Function(String id, MediaStream stream, double streamVolume) onStream;
  dynamic Function(bool flag) onDataReceived;
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
      _returnData = allowInterop(onDataReceived);
    }
  }

  void startPeerJS(){
    startPeer();
  }


  void getPermissionJS(String myID){
    getPermission(myID);
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
  void sendDataJS(dynamic data){
    sendData(data);
  }


  void muteMyVideoJS(){
    isVideoOn = !isVideoOn;
    muteMyVideo(isVideoOn);
  }
  void muteMyAudioJS(){
    isMicOn = !isMicOn;
    muteMyAudio(isMicOn);
  }
  void leaveCallJS() {
    leaveCall();
  }


  void volumeMeter(String videoID, double volume){
    volumeMeter(videoID, volume);
  }

}
