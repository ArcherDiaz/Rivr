@JS()
library js_interop;

import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

@JS()
external void startPeer();
@JS()
external void getPermission(String id);
@JS()
external void clearRoom();

@JS("returnPeerID")
external set _returnPeerID(void Function(String id) f);
@JS("returnStream")
external set _returnStream(void Function(String id, MediaStream stream, double streamVolume) f);
@JS("onPermissionResult")
external set _onPermissionResult(void Function(bool flag) f);




class PeerJS{
  String myPeerID;

  dynamic Function(String id) onPeer;
  dynamic Function(String id, MediaStream stream, double streamVolume) onStream;
  dynamic Function(bool flag) onPermissionResult;
  PeerJS({@required this.onPeer, @required this.onStream, @required this.onPermissionResult}){
    if(onPeer != null){
      _returnPeerID = allowInterop((id){
        myPeerID = id;
        onPeer(id);
      });
    }
    if(onStream != null){
      _returnStream = allowInterop(onStream);
    }
    if(onPermissionResult != null) {
      _onPermissionResult = allowInterop(onPermissionResult);
    }
  }

  void startPeerJS(){
    startPeer();
  }

  void getPermissionJS(String id){
    getPermission(id);
  }



  void clearRoomJS(){
    clearRoom();
  }

}
