import 'dart:html';
import 'package:rivr/Screens/HomeScreen.dart';
import 'package:universal_ui/universal_ui.dart';
import 'package:flutter/material.dart';
import 'package:rivr/interop.dart';
import 'package:sad_lib/CustomWidgets.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  PeerJS _peer;

  List<Map<String, dynamic>> _cams = List();
  bool _showPeerButton;
  Size _size;


  @override
  void initState() {
    _showPeerButton = false;
    super.initState();
    _peer = PeerJS(
      onPermissionResult: (flag){
        if(flag == true){ ///permission accepted
          setState(() {
            _showPeerButton = true;
          });
        }else{ ///permission denied

        }
      },
      onPeer: (id){
        _peer.getPermissionJS(id);
      },
      onStream: (MediaStream stream, String id){
        if(_cams.any((element) => element.containsValue(id))){

        }else{
          VideoElement video = VideoElement();
          video.attributes = {
            "id": id,
            "style": "object-fit: cover; width: ${_size.width/2}; height: ${_size.width/3};"
          };
          video.srcObject = stream;
          video.volume = 0.0;
          video.play();
          ui.platformViewRegistry.registerViewFactory(id, (viewID){
            return video;
          });
          setState(() {
            _cams.add({
              "id": id,
              "cam": Container(
                width: _size.width/2,
                height: _size.width/3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2.0,),
                ),
                child: HtmlElementView(
                  viewType: id,
                ),
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
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection:  Axis.vertical,
          child: Column(
            children: [
              if(_showPeerButton == false)
                ButtonView(
                  onPressed: (){
                    _peer.getPermissionJS("mine");
                  },
                  color: Colors.black54,
                  margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0,),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0,),
                  child: TextView(text: "Get Permission",
                    size: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if(_showPeerButton == true)
                ButtonView(
                  onPressed: (){
                    _peer.startPeerJS();
                  },
                  color: Colors.black54,
                  margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0,),
                  padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0,),
                  child: TextView(text: "Start Peering",
                    size: 15.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

              for(int i = 0; i < _cams.length; i++)
                _cams[i]["cam"],

            ],
          ),
        )
      ),
    );
  }


}
