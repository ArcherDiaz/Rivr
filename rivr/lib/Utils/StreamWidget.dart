import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:sad_lib/CustomWidgets.dart';

class StreamWidget extends StatefulWidget {
  final void Function() onPressed;
  final Map<String, dynamic> streamData;
  final Size size;
  const StreamWidget({Key key,
    @required this.onPressed,
    @required this.streamData,
    @required this.size,
  }) : super(key: key);
  @override
  _StreamWidgetState createState() => _StreamWidgetState();
}

class _StreamWidgetState extends State<StreamWidget> {

  final double _talkingPoint = 5.5;

  double ratio;
  double videoBoxWidth;
  double videoBoxHeight;

  @override
  void initState() {
    videoBoxWidth = widget.size.width;
    videoBoxHeight = widget.size.height;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StreamWidget oldWidget) {
    videoBoxWidth = widget.size.width;
    videoBoxHeight = widget.size.height;
    if(widget.streamData["stream width"] != null && widget.streamData["stream height"] != null) {
      ratio = widget.streamData["stream width"] / videoBoxWidth;
      if(widget.streamData["status"]["video"] == false){
        ///if there is no video then make the it a perfect square
        videoBoxHeight = videoBoxWidth;
      }else {
        ///else get the correct height of the video stream relative to the width
        videoBoxHeight = widget.streamData["stream height"] / ratio;
      }
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
                borderRadius: BorderRadius.circular(widget.streamData["status"]["video"] == true ? 5.0 : 90.0,),
                border: Border.all(color: colors.darkPurple, width: 2.5,),
              ),
            ),
            borderRadius: widget.streamData["status"]["video"] == true ? 5.0 : 90.0,
            border: Border.all(
              color: widget.streamData["volume"] >= _talkingPoint ? colors.blue : Colors.transparent,
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
                margin: EdgeInsets.all(5.0),
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
    return ClipOval(
      child: ImageView.network(
        imageKey: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHBlb3BsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
        aspectRatio: 1.0,
        width: videoBoxWidth,
        height: videoBoxHeight,
      ),
    );
  }

}
