import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:rivr/Utils/PeerJSClass.dart';
import 'package:rivr/main.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:sad_lib/DialogClass.dart';
import 'package:universal_ui/universal_ui.dart';

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

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PeerJS _peer;
  List<Map<String, dynamic>> _streams = [];

  DialogClass _dialogClass;

  Size _size;
  bool _isDesktop;

  @override
  void initState() {
    _dialogClass = DialogClass(background: colors.bg, buttonColor: colors.bgDark, buttonTextColor: colors.white, textColor: colors.white,);
    _isDesktop = true;
    super.initState();
    _peer = PeerJS(
      onPeer: (id){
        setState(() {
          _peer.myPeerID = id;
        });
      },
      onPermissionResult: (flag){
        if(flag == true){ ///permission accepted
          _getOtherUsers();
        }else{ ///permission denied

        }
      },
      onStream: (String id, MediaStream stream, double streamVolume){
        if(_streams.any((element) => element["peer ID"] == id,)){ ///if any element in the streams array has its "peer ID" field == [id]
          int _index = _streams.indexWhere((element) => element["peer ID"] == id,); ///get the index of the stream where "peer ID" field == [id]
          setState(() {
            if(streamVolume >= 5.5){
              _streams[_index]["is talking"] = true;
            }else{
              _streams[_index]["is talking"] = false;
            }
          });
        }else{
          ///else if there is no stream in the list with its "peer ID" field == [id], create it
          VideoElement video = VideoElement();
          video.attributes = {
            "id": id,
            "style": "object-fit: cover; -webkit-transform:rotateY(180deg);",
          };
          video.srcObject = stream;
          if(id == _peer.myPeerID){
            video.volume = 0.0;
          }
          video.play();
          ui.platformViewRegistry.registerViewFactory(id, (viewID){
            return video;
          });
          setState(() {
            _streams.add({
              "peer ID": id,
              "is talking": (streamVolume >= 5.5) ? true : false,
              "widget": HtmlElementView(
                viewType: id,
              ),
            });
          });
        }
      },
    );
    _peer.startPeerJS();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _isDesktop = _size.width > 700 ? true : false;
    return Material(
      color: colors.bg,
      child: SafeArea(
        child: _peer.myPeerID == null
            ? _loadingView()
            : _streamingControls(),
      ),
    );
  }

  Widget _loadingView(){
    return Center(
      child: CustomLoader(
        color1: colors.white,
        color2: colors.bgDark,
      ),
    );
  }

  Widget _permissionView(){
    return Container(
      margin: EdgeInsets.all(15.0,),
      padding: EdgeInsets.all(10.0,),
      decoration: BoxDecoration(
        border: Border.all(color: colors.bgLight, width: 1.0,),
      ),
      child: Column(
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
              _peer.getPermissionJS(_peer.myPeerID);
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
    );
  }

  Widget _streamingControls(){
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            Container(
              width: _size.width,
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: colors.bgDark,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: colors.bgLight.withOpacity(0.15),
                  )
                ],
              ),
              child: TextView.rich(textSpan: [
                TextView(
                  text: "RIVR/",
                  color: colors.white,
                  size: _size.width > 700 ? 30.0 : 25.0,
                  fontWeight: FontWeight.w700,
                ),
                TextView(
                  text: widget.route.extra["code"],
                  color: colors.white,
                  letterSpacing: 1.0,
                  size: _size.width > 700 ? 20.0 : 18.0,
                  fontWeight: FontWeight.w500,
                ),
              ],),
            ),
            _streamingView(),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(
              color: colors.bgDark,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: colors.bgLight.withOpacity(0.15),
                )
              ],
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                ButtonView(
                  onPressed: () {
                    setState(() {
                      _peer.muteMyAudioJS();
                    });
                  },
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(_peer.isMicOn == true ? Icons.mic : Icons.mic_off, size: 30.0, color: colors.white,),
                ),
                ButtonView(
                  onPressed: () {
                    setState(() {
                      _peer.muteMyVideoJS();
                    });
                  },
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(_peer.isVideoOn == true ? Icons.videocam : Icons.videocam_off, size: 30.0, color: colors.white,),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  width: 1,
                  height: 30.0,
                  color: colors.bgLight,
                ),
                ButtonView(
                  onPressed: () {},
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(Icons.chat, size: 25.0, color: colors.white,),
                ),
                ButtonView(
                  onPressed: () {
                    setState(() {
                      _peer.leaveCall();
                    });
                  },
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Icon(Icons.call_end, size: 30.0, color: colors.red,),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _streamingView(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: _isDesktop == true ? 20.0 : 0.0,),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: _isDesktop == true ? 20.0 : 0.0, runSpacing: 20.0,
        children: [
          if(_streams.any((element) => element["peer ID"] == _peer.myPeerID) == false)
            _permissionView(),

          SizedBox(
            width: _size.width,
          ),

          for(int i = 0; i < _streams.length; i++)
            ButtonView.hover(
              onPressed: (){

              },
              onHover: ContainerChanges(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2.5,),
                ),
              ),
              width: _isDesktop == true ? (_size.width/3- 20) : _size.width/2,
              height: _isDesktop == true ? _size.width/6 : _size.width/3,
              color: colors.bgLight,
              borderRadius: 5.0,
              border: Border.all(
                color: _streams[i]["is talking"] == true ? Colors.lightBlue : Colors.transparent,
                width: 2.5,
              ),
              child: _streams[i]["widget"],
            ),

        ],
      ),
    );
  }

  /*-------------------------------------------------------------------------*/

  void _getOtherUsers(){
    String _roomCode = widget.route.extra["code"];
    DocumentReference _roomRef = _firestore.collection("FakeZoom").doc(_roomCode);
    _firestore.runTransaction((transaction) async {
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
    _firestore.collection("FakeZoom").doc(_roomCode).set({}).then((value){
      print("Document Cleared!");
    }).catchError((onError){
      print("ERROR Clearing Document!: ${onError.toString()}");
    });
  }

}
