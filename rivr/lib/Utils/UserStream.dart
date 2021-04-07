import 'dart:html';
import 'package:flutter/widgets.dart';
import 'package:universal_ui/universal_ui.dart';

class UserStream {

  String id;
  double volume = 0.0, height, width;
  HtmlElementView widget;
  bool isInverted = false, videoStatus = true, audioStatus = true;
  void Function(bool flag, String id) switchInversion;

  UserStream({@required this.id, this.volume, @required this.switchInversion, bool muteVideo = false, @required MediaStream mediaStream,}){
    VideoElement video = VideoElement();
    video.attributes = {
      "id": id,
      "style": "object-fit: contain;",
    };
    video.srcObject = mediaStream;
    if(muteVideo == true){
      video.volume = 0.0;
    }
    video.play();
    video.addEventListener("pause", (event){
      video.play();
    });

    ui.platformViewRegistry.registerViewFactory(id, (viewID){
      return video;
    });
    this.widget = HtmlElementView(
      viewType: id,
    );
  }

}
