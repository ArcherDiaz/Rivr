import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:rivr/Utils/LoadingContainer.dart';
import 'package:rivr/Utils/PeerJSClass.dart';
import 'package:rivr/Utils/StreamingContainer.dart';
import 'package:rivr/Utils/UserStream.dart';
import 'package:rivr/Utils/WhiteBoard.dart';
import 'package:rivr/main.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:sad_lib/DialogClass.dart';
import 'package:flutter/services.dart';

class RoomScreen extends StatefulWidget {
  final RoutePathClass route;
  final void Function(RoutePathClass route) updatePage;
  RoomScreen({Key key,
    @required this.route,
    @required this.updatePage,
  }) : super(key: key,);
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {

  //TODO: listen for when a user leaves the call, so that you can remove their video box

  //TODO: random idea i got from someone while looking for hang up call fixes, have room notifications:
    //  when a user just enters a room send out the message; [notify]: A new user has entered the room
    //  then on retrieval of this message, because it has "[notify]:" it won't show up in the chat but rather as a notification
    //  [notify]: A user has left the room
    //  [notify]: A user is sharing their screen
    //  [notify]: A user is being an ass

  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DialogClass _dialogClass;

  PeerJS _peer;
  List<UserStream> _streams = [];

  Size _size;
  bool _isDesktop;
  bool _showBoard;

  @override
  void dispose() {
    _peer.leaveCallJS();
    print("closing this page");
    super.dispose();
  }

  @override
  void initState() {
    _dialogClass = DialogClass(background: colors.bg, buttonColor: colors.bgDark, buttonTextColor: colors.white, textColor: colors.white,);
    _isDesktop = true;
    _showBoard = false;
    super.initState();
    _peer = PeerJS(
      onPeer: (id){
        setState(() {
          _peer.myPeerID = id;
        });
        _peer.getPermissionJS(id, true, _peer.frontCam,);
      },
      onPermissionResult: (flag){
        if(flag == true){ ///permission accepted
          setState(() {
            _peer.permissionOn = true;
          });
          _getOtherUsers();
        }else{ ///permission denied
          setState(() {
            _peer.permissionOn = false;
          });
        }
      },
      onDataReceived: (data){
        int i = _streams.indexWhere((element) => element.id == data["id"],);
        setState(() {
          _streams[i].audioStatus = data["audio"];
          _streams[i].videoStatus = data["video"];
        });


      },
      onStream: (String id, MediaStream stream, double streamVolume){
        if(_streams.any((element) => element.id == id,)){ ///if any stream has its "id" field equal to [id]
          int _index = _streams.indexWhere((element) => element.id == id,); ///get the index of the stream where "id" field == [id]
          setState(() {
            _streams[_index].height = stream.getVideoTracks()[0].getSettings()["height"];
            _streams[_index].width = stream.getVideoTracks()[0].getSettings()["width"];
            _streams[_index].volume = streamVolume;
          });
        }else{
          ///else if there is no stream in the list with its "id" field == [id], create it
          setState(() {
            _streams.add(UserStream(
              id: id,
              volume: streamVolume,
              muteVideo: id == _peer.myPeerID ? true : false,
              mediaStream: stream,
              switchInversion: (bool flag, String id) {
                int i = _streams.indexWhere((element) => element.id == id,);
                setState(() {
                  _streams[i].isInverted = flag;
                });
              },
            ));
          });
        }
      },
    );
    _peer.startPeerJS();
  }

  Future<bool> _onBackPressed(){
    print("back pressed!!");
    if(_peer.isSharingScreen){
      return _dialogClass.assureDialog(context,
        message: "Please stop live streaming your device screen first before leaving the room.",
        positive: "Okay",
        negativeButton: false,
      ).then((flag){
        return false;
      });
    }else{
      _peer.leaveCallJS();
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _isDesktop = _size.width > 700 && _size.height > 500 ? true : false;
    return BackButtonListener(
      onBackPressed: _onBackPressed,
      child: Material(
        color: colors.bg,
        child: SafeArea(
          child: _load(),
        ),
      ),
    );
  }

  Widget _load(){
    if(_peer.myPeerID == null || _peer.permissionOn == null){
      return LoadingContainer(
        text: _peer.myPeerID == null ? "Starting up servers.. " : "Retrieving access to media devices.. ",
      );
    }else if(_peer.permissionOn == false){
      return Center(
        child: Container(
          margin: EdgeInsets.all(15.0,),
          padding: EdgeInsets.all(10.0,),
          decoration: BoxDecoration(
            border: Border.all(color: colors.bgLight, width: 1.0,),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextView(text: "Microphone access is required to join a live room. Please allow the permissions requested to continue.",
                size: 17.5,
                align: TextAlign.center,
                isSelectable: true,
                lineSpacing: 2.0,
                color: colors.white,
                fontWeight: FontWeight.w500,
              ),
              ButtonView(
                onPressed: (){
                  _peer.getPermissionJS(_peer.myPeerID, true, _peer.frontCam,);
                },
                color: colors.bgDark,
                margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0,),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0,),
                child: TextView(text: "Give Permission",
                  size: 15.0,
                  color: colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      return _streamingControls();
    }
  }

  Widget _streamingControls(){
    return Column(
      children: [
        _topPanel(),
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              StreamContainer(
                isDesktop: _isDesktop,
                size: _size,
                streams: _streams,
              ),
              if(_showBoard == true)
                Container(
                  color: colors.bgDark,
                  width: _size.width / 2,
                  height: _size.width / 2,
                  child: WhiteBoard(),
                ),

              Align(
                alignment: Alignment.bottomCenter,
                child: _controlPanel(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /*-------------------------------------------------------------------------*/

  Widget _topPanel(){
    return Container(
      width: _size.width,
      color: colors.bgDark,
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonView(
            child: TextView.rich(
              textSpan: [
                TextView(text: "RIVR/",
                  color: colors.white,
                  size: 20.0,
                  letterSpacing: 2.0,
                ),
                TextView(text: widget.route.extra["code"],
                  color: colors.blue,
                  letterSpacing: 0.5,
                  size: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
            onPressed: () {Clipboard.setData(new ClipboardData(text: "https://rivrlive.web.app/live?code=${widget.route.extra["code"]}"));},
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.5),
            padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0,),
            decoration: BoxDecoration(
              color: colors.red,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Row(
              children: [
                Icon(Icons.stop,
                  size: _isDesktop == true ? 25.0 : 30.0,
                  color: colors.white,
                ),
                TextView(text: "00:00:00",
                  color: colors.white,
                  letterSpacing: 1.0,
                  size: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          ButtonView.hover(
            onPressed: () {
              if(_peer.isSharingScreen){
                _dialogClass.assureDialog(context,
                  message: "Please stop live streaming your device screen first before leaving the room.",
                  positive: "Okay",
                  negativeButton: false,
                );
              }else{
                _peer.leaveCallJS();
                Navigator.of(context).pop();
              }
            },
            onHover: ContainerChanges(
              decoration: BoxDecoration(
                color: colors.red.withOpacity(0.50),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5.0,),
            builder: (isHovering){
              return Row(
                children: [
                  Icon(Icons.call_end,
                    size: _isDesktop == true ? 25.0 : 30.0,
                    color: isHovering == true ? colors.white : colors.red,
                  ),
                  TextView(text: "Leave",
                    color: isHovering == true ? colors.white : colors.red,
                    size: 17.5,
                    fontWeight: FontWeight.w500,
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _controlPanel(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0,),
      margin: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: colors.bgDark,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: colors.bgDark.withOpacity(0.5,),
            offset: Offset(0.0, 5.0,),
            blurRadius: 15.0,
          )
        ],
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        spacing: 10.0, runSpacing: 10.0,
        children: [
          ButtonView(
            onPressed: () {
              setState(() {
                _peer.toggleAudioJS();
              });
              int i = _streams.indexWhere((element) => element.id == _peer.myPeerID,);
              setState(() {
                _streams[i].audioStatus = _peer.isMicOn;
              });
            },
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            borderRadius: 90.0,
            color: _peer.isMicOn == true ? colors.white : colors.red,
            padding: EdgeInsets.all(5.0),
            child: Icon(_peer.isMicOn == true ? Icons.mic : Icons.mic_off,
              size: _isDesktop == true ? 25.0 : 30.0,
              color: _peer.isMicOn == true ? colors.bg : colors.white,
            ),
          ),
          ButtonView(
            onPressed: () {
              setState(() {
                _peer.toggleVideoJS();
              });
              int i = _streams.indexWhere((element) => element.id == _peer.myPeerID,);
              setState(() {
                _streams[i].videoStatus = _peer.isVideoOn;
              });
            },
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            borderRadius: 90.0,
            color: _peer.isVideoOn == true ? colors.white : colors.red,
            padding: EdgeInsets.all(5.0),
            child: Icon(_peer.isVideoOn == true ? Icons.videocam : Icons.videocam_off,
              size: _isDesktop == true ? 25.0 : 30.0,
              color: _peer.isVideoOn == true ? colors.bg : colors.white,
            ),
          ),
          ButtonView(
            onPressed: () {
              setState(() {
                _showBoard = !_showBoard;
              });
            },
            borderRadius: 90.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.chat,
              size: _isDesktop == true ? 25.0 : 30.0,
              color: colors.white,
            ),
          ),
          if(_isDesktop == true)
            ButtonView(
              onPressed: () {
                if(_peer.isSharingScreen == false){
                  setState(() {
                    _peer.shareScreenJS(_peer.myPeerID, (){
                      ///this is a callback for the user stops the screen share
                      ///when the screen share is closed, this little function is triggered
                      setState(() {
                        _peer.isSharingScreen = false;
                      });
                    });
                  });
                }
              },
              borderRadius: 90.0,
              color: _peer.isSharingScreen == true ? colors.white : colors.bg,
              padding: EdgeInsets.all(7.0),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(_peer.isSharingScreen == true ? Icons.stop_screen_share_outlined : Icons.screen_share_outlined,
                size: _isDesktop == true ? 25.0 : 30.0,
                color: _peer.isSharingScreen == true ? colors.bg :  colors.white,
              ),
            ),

          if(_isDesktop == false && 0 == 9)
            ButtonView(
              onPressed: () {
                setState(() {
                  _peer.toggleCameraFaceJS();
                });
                _peer.sendDataJS({});
              },
              borderRadius: 90.0,
              color: _peer.isSharingScreen == true ? colors.white : colors.bg,
              padding: EdgeInsets.all(7.0),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(_peer.isCamFacingFront == true ? Icons.camera_front_outlined : Icons.camera_rear_outlined,
                size: _isDesktop == true ? 25.0 : 30.0,
                color: _peer.isSharingScreen == true ? colors.bg :  colors.white,
              ),
            ),
        ],
      ),
    );
  }

  /*-------------------------------------------------------------------------*/

  void _getOtherUsers(){
    String _roomCode = widget.route.extra["code"];
    DocumentReference _roomRef = _fireStore.collection("FakeZoom").doc(_roomCode);
    _fireStore.runTransaction((transaction) async {
      List<dynamic> _users = [];
      DocumentSnapshot _snapshot = await transaction.get(_roomRef);
      if(_snapshot.exists == true && _snapshot.data().containsKey("users")){
        _users = _snapshot.data()["users"];
      }
      _users.add({
        "peer ID": _peer.myPeerID,
        "user ID": "",
        "username": "",
        "photo URL": "",
      });

      transaction.set(_roomRef, {
          "users": FieldValue.arrayUnion(_users,),
      },);

      return _users;
    }).then((users){
      users.forEach((element) {
        if(element["peer ID"] != _peer.myPeerID){ ///if the "peer ID" field of this element != my own peer id, the connect to them
          _peer.connectNewUserJS(element["peer ID"],);
        }
      });
    }).catchError((onError){
      _dialogClass.assureDialog(context, message: "Something went wrong while trying to establish a connection."
          "\nPlease check your internet connection and try again."
          "\n\n${onError.toString()}");
    });
  }

  void _clearRoom(){
    String _roomCode = widget.route.extra["code"];
    _fireStore.collection("FakeZoom").doc(_roomCode).set({}).then((value){
      print("Document Cleared!");
    }).catchError((onError){
      print("ERROR Clearing Document!: ${onError.toString()}");
    });
  }

}
