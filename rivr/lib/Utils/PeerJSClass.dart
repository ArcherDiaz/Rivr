@JS()
library js_interop;

import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

@JS()
external void startPeer();
@JS()
external void getPermission(String myID);
@JS()
external void connectNewUser(String theirID);

@JS("returnPeerID")
external set _returnPeerID(void Function(String myID) f);
@JS("returnStream")
external set _returnStream(void Function(String id, MediaStream stream, double streamVolume) f);
@JS("onPermissionResult")
external set _onPermissionResult(void Function(bool flag) f);




class PeerJS{
  String myPeerID;

  dynamic Function(String myID) onPeer;
  dynamic Function(String id, MediaStream stream, double streamVolume) onStream;
  dynamic Function(bool flag) onPermissionResult;
  PeerJS({@required this.onPeer, @required this.onStream, @required this.onPermissionResult}){
    if(onPeer != null){
      _returnPeerID = allowInterop((myID){
        myPeerID = myID;
        onPeer(myID);
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

  void getPermissionJS(String myID){
    getPermission(myID);
  }

  void connectNewUserJS(String theirID){
    connectNewUser(theirID);
  }

}
