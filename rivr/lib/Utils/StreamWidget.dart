import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:rivr/Utils/UserStream.dart';
import 'package:sad_lib/CustomWidgets.dart';

class StreamWidget extends StatefulWidget {
  final void Function() onPressed;
  final UserStream streamData;
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
    if(widget.streamData.width != null && widget.streamData.height != null) {
      ratio = widget.streamData.width / videoBoxWidth;
      if(widget.streamData.videoStatus == false){
        ///if there is no video then make the it a perfect square
        videoBoxHeight = videoBoxWidth;
      }else {
        ///else get the correct height of the video stream relative to the width
        videoBoxHeight = widget.streamData.height / ratio;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return HoverWidget(
      duration: Duration(milliseconds: 50,),
      width: videoBoxWidth,
      height: videoBoxHeight,
      idle: ContainerChanges(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.streamData.videoStatus == true ? 10.0 : 90.0,),
          border: Border.all(
            color: widget.streamData.volume >= _talkingPoint ? colors.blue : Colors.transparent,
            width: 2.5,
          ),
        ),
      ),
      onHover: ContainerChanges(
        decoration: BoxDecoration(
          color: colors.bg.withOpacity(0.3,),
          borderRadius: BorderRadius.circular(widget.streamData.videoStatus == true ? 10.0 : 90.0,),
          border: Border.all(color: colors.darkPurple, width: 2.5,),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.streamData.videoStatus == true ? videoBox() : videoCircle(),
          GestureDetector(
            onTap: widget.onPressed,
            onDoubleTap: (){

            },
            onLongPress: (){
              _dialog();
            },
          ),

          Align(
            alignment: Alignment.topLeft,
            child: ButtonView(
              onPressed: (){
                setState(() {
                  widget.streamData.switchInversion(!widget.streamData.isInverted, widget.streamData.id);
                });
              },
              padding: EdgeInsets.all(5.0,),
              child: Icon(Icons.switch_camera_outlined,
                color: colors.white,
                size: 25.0,
              ),
            ),
          ),

          if(widget.streamData.audioStatus == false)
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
      transform: Matrix4.identity()..rotateY(widget.streamData.isInverted == true ? 3.14 : 0.0,),
      alignment: FractionalOffset.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0,),
        child: widget.streamData.widget,
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


  void _dialog(){
    showModalBottomSheet(context: context, isDismissible: true, backgroundColor: colors.bg,
      elevation: 20.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0),),),
      builder: (context){
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(10.0),
              leading: ImageView.network(
                imageKey: "https://images.unsplash.com/photo-1517841905240-472988babdf9?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHBlb3BsZXxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60",
                margin: EdgeInsets.only(right: 10.0),
                aspectRatio: 1.0,
                height: MediaQuery.of(context).size.width/4,
                width: MediaQuery.of(context).size.width/4,
              ),
              title: TextView(text: "test",
                size: 20.0,
                fontWeight: FontWeight.w500,
                color: colors.white,
              ),
              subtitle: TextView(text: "test ",
                size: 17.5,
                color: colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Divider(color: colors.bgLight, thickness: 2.5, indent: 20.0, endIndent: 20.0,),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(bottom: 10.0,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ButtonView(
                    onPressed: (){

                    },
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0,),
                    children: [
                      Icon(Icons.event_note,
                        color: colors.blue,
                        size: 30.0,
                      ),
                      TextView(text: "testing button",
                        size: 17.5,
                        color: colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  ButtonView(
                    onPressed: (){

                    },
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    margin: EdgeInsets.only(left: 10.0, bottom: 5.0,),
                    children: [
                      Icon(Icons.event_note,
                        color: colors.blue,
                        size: 30.0,
                      ),
                      TextView(text: "testing button",
                        size: 17.5,
                        color: colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}
