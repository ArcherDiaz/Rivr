import 'package:flutter/material.dart';
import 'package:rivr/Utils/PeerJSClass.dart';
import 'package:rivr/Utils/StreamWidget.dart';


class StreamContainer extends StatefulWidget {
  final bool isDesktop;
  final Size size;
  final List<Map<String, dynamic>> streams;
  final void Function(bool focus) onMobileFocused;

  StreamContainer({Key key, this.isDesktop, this.size, this.streams, this.onMobileFocused,}) : super(key: key);
  @override
  _StreamContainerState createState() => _StreamContainerState();
}

class _StreamContainerState extends State<StreamContainer> {
  int _focusedStream;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: _focusedStream != null ? _focusedStreamingView() : unfocusedStreamingView(),
      ),
    );
  }

  Widget _focusedStreamingView(){
    if(widget.isDesktop) {
      return Column(
        children: [
          Expanded(
            child: StreamWidget(
              onPressed: (){
                  ///if this stream is already being focused on, remove the focus
                  setState(() {
                    _focusedStream = null;
                  });
              },
              streamData: widget.streams[_focusedStream],
              state: SizeState.focused,
              mobileSize: null,
              desktopSize: null,
              focusedSize: Size(double.infinity, double.infinity,),
            ),
          ),
          SingleChildScrollView(
            child: Row(
              children: [
                for(int i = 0; i < widget.streams.length; i++)
                  if(_focusedStream != i)
                    StreamWidget(
                      onPressed: (){
                        if(_focusedStream == i){
                          ///if this stream is already being focused on, remove the focus
                          setState(() {
                            _focusedStream = null;
                          });
                        }else {
                          ///else set the focus
                          setState(() {
                            _focusedStream = i;
                          });
                        }
                      },
                      streamData: widget.streams[i],
                      state: SizeState.desktop,
                      mobileSize: null,
                      desktopSize: Size((widget.size.width/8 - 5), widget.size.width/8 - 5,),
                      focusedSize: null,
                    ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: StreamWidget(
              onPressed: (){
                  ///if this stream is already being focused on, remove the focus
                  setState(() {
                    _focusedStream = null;
                  });
              },
              streamData: widget.streams[_focusedStream],
              state: SizeState.focused,
              mobileSize: null,
              desktopSize: null,
              focusedSize: Size((double.infinity), double.infinity)
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                for(int i = 0; i < widget.streams.length; i++)
                  if(_focusedStream != i)
                    StreamWidget(
                      onPressed: (){
                        if(_focusedStream == i){
                          ///if this stream is already being focused on, remove the focus
                          setState(() {
                            _focusedStream = null;
                          });
                        }else {
                          ///else set the focus
                          setState(() {
                            _focusedStream = i;
                          });
                        }
                      },
                      streamData: widget.streams[i],
                      state: SizeState.mobile,
                      mobileSize: Size((widget.size.height/2.5 - 5), widget.size.width/2.5 - 5,),
                      desktopSize: null,
                      focusedSize: null,
                    ),
              ],
            ),
          ),
        ],
      );
    }

  }

  Widget unfocusedStreamingView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: widget.isDesktop == true ? 20.0 : 0.0,),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: widget.isDesktop == true ? 20.0 : 0.0, runSpacing: 20.0,
        children: [

          SizedBox(
            width: widget.size.width,
          ),

          for(int i = 0; i < widget.streams.length; i++)
            StreamWidget(
              onPressed: (){
                if(_focusedStream == i){
                  ///if this stream is already being focused on, remove the focus
                  setState(() {
                    _focusedStream = null;
                  });
                }else {
                  ///else set the focus
                  setState(() {
                    _focusedStream = i;
                  });
                  widget.onMobileFocused(true);
                }
              },
              streamData: widget.streams[i],
              state: widget.isDesktop == true ? SizeState.desktop : SizeState.mobile,
              mobileSize: Size(widget.size.width/2, widget.size.width/3,),
              desktopSize: Size((widget.size.width/3.5- 20), widget.size.width/6,),
              focusedSize: null,
            ),
        ],
      ),
    );
  }
}
