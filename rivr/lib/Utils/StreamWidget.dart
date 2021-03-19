import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:sad_lib/CustomWidgets.dart';
import 'dart:html' as html;

enum SizeState {mobile, desktop, focused}

class StreamWidget extends StatefulWidget {
  final void Function() onPressed;
  final Map<String, dynamic> streamData;
  final Size mobileSize;
  final Size desktopSize;
  final Size focusedSize;
  final SizeState state;
  const StreamWidget({Key key,
    @required this.onPressed,
    @required this.streamData,
    @required this.state,
    @required this.mobileSize,
    @required this.desktopSize,
    @required this.focusedSize,
  }) : super(key: key);
  @override
  _StreamWidgetState createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {

  bool _isInverted;

  @override
  void initState() {
    _isInverted = false;
    super.initState();
    _playVideo();
  }

  @override
  void didUpdateWidget(covariant StreamWidget oldWidget) {
    _playVideo();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 750,),
      width: widget.state == SizeState.focused
          ? widget.focusedSize.width
          : widget.state == SizeState.desktop ? widget.desktopSize.width : widget.mobileSize.width,
      height: widget.state == SizeState.focused
          ?  widget.focusedSize.height
          : widget.state == SizeState.desktop ? widget.desktopSize.height : widget.mobileSize.height,
      child: Stack(
        children: [
          Transform(
            transform: Matrix4.identity()..rotateY(_isInverted == true ? 3.14 : 0.0,),
            alignment: FractionalOffset.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0,),
              child: widget.streamData["widget"],
            ),
          ),
          ButtonView.hover(
            onPressed: widget.onPressed,
            onHover: ContainerChanges(
              decoration: BoxDecoration(
                color: colors.bg.withOpacity(0.3,),
                borderRadius: BorderRadius.circular(5.0,),
                border: Border.all(color: colors.darkPurple, width: 2.5,),
              ),
            ),
            border: Border.all(
              color: widget.streamData["is talking"] == true ? colors.blue : Colors.transparent,
              width: 2.5,
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: ButtonView(
              onPressed: (){
                setState(() {
                  _isInverted = !_isInverted;
                });
              },
              padding: EdgeInsets.all(5.0,),
              child: Icon(Icons.switch_camera_outlined,
                color: colors.white,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _playVideo(){
    try{
      html.VideoElement video = html.document.getElementById(widget.streamData["id"]);
      if(video.paused){
        video.play();
      }
    }catch(e){
      print(e.toString());
    }
  }

}
