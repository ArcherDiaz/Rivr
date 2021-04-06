import 'package:flutter/cupertino.dart';

class UserStream {
  String id;
  double volume, height, width;
  HtmlElementView widget;
  bool isInverted, videoStatus, audioStatus;
  void Function(bool flag, String id) switchInversion;

  UserStream({this.id, this.volume, this.height, this.width, this.widget, this.isInverted, this.videoStatus, this.audioStatus, this.switchInversion,});

}