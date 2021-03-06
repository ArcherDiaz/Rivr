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
external set _returnStream(void Function(MediaStream stream, String id) f);
@JS("onPermissionResult")
external set _onPermissionResult(void Function(bool flag) f);




class PeerJS{

  dynamic Function(String id) onPeer;
  dynamic Function(MediaStream stream, String id) onStream;
  dynamic Function(bool flag) onPermissionResult;
  PeerJS({@required this.onPeer, @required this.onStream, @required this.onPermissionResult}){
    if(onPeer != null){
      _returnPeerID = allowInterop(onPeer);
    }
    if(onStream != null){
      _returnStream = allowInterop(onStream);
    }
    if(onPermissionResult != null) {
      _onPermissionResult = allowInterop(onPermissionResult);
    }
  }

  void getPermissionJS(String id){
    getPermission(id);
  }

  void startPeerJS(){
    startPeer();
  }



  void clearRoomJS(){
    clearRoom();
  }

}
