import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:sad_lib/CustomWidgets.dart';

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
  double ratio;
  double videoBoxHeight;
  double videoBoxWidth;

  @override
  void initState() {
    _isInverted = false;
    
    videoBoxHeight = widget.state == SizeState.focused
        ?  widget.focusedSize.height
        : widget.state == SizeState.desktop ? widget.desktopSize.height : widget.mobileSize.height;

    videoBoxWidth = widget.state == SizeState.focused
        ? widget.focusedSize.width
        : widget.state == SizeState.desktop ? widget.desktopSize.width : widget.mobileSize.width;
    
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StreamWidget oldWidget) {
    if(widget.streamData["stream width"] != null && widget.streamData["stream height"] != null) {
      ratio = widget.streamData["stream width"] / videoBoxWidth;
      videoBoxHeight = widget.streamData["stream height"] / ratio;
    }    
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 750,),
      width: videoBoxWidth,
      height: videoBoxHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.streamData["status"]["video"] == true ? videoBox() : videoCircle(),
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
                  widget.streamData["switch"](!widget.streamData["is inverted"], widget.streamData["id"]);
                });
              },
              padding: EdgeInsets.all(5.0,),
              child: Icon(Icons.switch_camera_outlined,
                color: colors.white,
                size: 25.0,
              ),
            ),
          ),
          if(widget.streamData["status"]["audio"] == false)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: colors.darkPurple,
                  borderRadius: BorderRadius.circular(90.0),
                ),
                child: Icon(Icons.mic_off, size: 25.0, color: colors.white,),
              ),
            )
        ],
      ),
    );
  }

  Widget videoBox() {
    return Transform(
      transform: Matrix4.identity()..rotateY(widget.streamData["is inverted"] == true ? 3.14 : 0.0,),
      alignment: FractionalOffset.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0,),
        child: widget.streamData["widget"],
      ),
    );
  }

  Widget videoCircle() {
    double diameter = videoBoxWidth > videoBoxHeight ? videoBoxHeight : videoBoxWidth;
    return ClipOval(
      child: ImageView.network(
        imageKey: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHBlb3BsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
        aspectRatio: 1.0,
        width: diameter,
        height: diameter,
      ),
    );
  }
}
