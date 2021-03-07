import 'dart:html';
import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:rivr/Utils/PeerJSClass.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:sad_lib/DialogClass.dart';
import 'package:universal_ui/universal_ui.dart';

class RoomScreen extends StatefulWidget {
  final String roomCode;
  RoomScreen({Key key, this.roomCode,}) : super(key: key);
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {

  PeerJS _peer;

  List<Map<String, dynamic>> _streams = List();
  bool _hasPeerID;

  Size _size;
  bool _isDesktop;

  @override
  void initState() {
    _isDesktop = true;
    _hasPeerID = false;
    super.initState();
    _peer = PeerJS(
      onPeer: (id){
        setState(() {
          _hasPeerID = true;
        });
        _peer.getPermissionJS(id);
      },
      onPermissionResult: (flag){
        if(flag == true){ ///permission accepted
          getOtherUsers();
        }else{ ///permission denied

        }
      },
      onStream: (String id, MediaStream stream, double streamVolume){
        if(_streams.any((element) => element["peer ID"] == id,)){
          int _index = _streams.indexWhere((element) => element["peer ID"] == id,);
          setState(() {
            if(streamVolume >= 5.5){
              _streams[_index]["is talking"] = true;
            }else{
              _streams[_index]["is talking"] = false;
            }
          });
        }else{
          VideoElement video = VideoElement();
          video.attributes = {
            "id": id,
            "style": "object-fit: cover;"
          };
          video.srcObject = stream;
          video.volume = 0.0;
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
        child: _hasPeerID == true ? _streamingView() : _loadingView(),
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
          TextView(text: "Microphone access is required to join a live room. Please allow the permissions requested to contine.",
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
            child: TextView(text: "Get Permission",
              size: 15.0,
              color: colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
        spacing: 20.0, runSpacing: 20.0,
        children: [
          if(_streams.any((element) => element["peer ID"] == _peer.myPeerID) == false)
            _permissionView(),

          SizedBox(
            width: _size.width,
          ),

          for(int i = 0; i < _streams.length; i++)
            Container(
              width: _isDesktop == true ? (_size.width/3- 20) : _size.width/2,
              height: _isDesktop == true ? _size.width/6 : _size.width/3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0,),
                border: Border.all(
                  color: _streams[i]["is talking"] == true ? Colors.lightBlue : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: _streams[i]["widget"],
            ),

        ],
      ),
    );
  }

  /*-------------------------------------------------------------------------*/

  void getOtherUsers(){
    ///in a firestore transaction do the following:
      ///add my own data to the room document in database; peerID, username, photo,
      ///from that same database document, get ther other user's  data; peer IDs, usernames and photos

    ///then with their data, connect to each one of them
  }

}