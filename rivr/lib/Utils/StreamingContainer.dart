import 'package:flutter/material.dart';
import 'package:rivr/Utils/StreamWidget.dart';
import 'package:rivr/Utils/WhiteBoard.dart';

class StreamContainer extends StatefulWidget {
  final bool isDesktop;
  final Size size;
  final List<Map<String, dynamic>> streams;
  final void Function(bool focus) onMobileFocused;
  final bool showWhiteboard;

  StreamContainer({Key key, this.isDesktop, this.size, this.streams, this.onMobileFocused, this.showWhiteboard,}) : super(key: key);
  @override
  _StreamContainerState createState() => _StreamContainerState();
}

class _StreamContainerState extends State<StreamContainer> {

  int _focusedStream;
  bool _isLandscape;

  @override
  Widget build(BuildContext context) {
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape ? true : false;
    if(_focusedStream == null){
      return unfocusedStreamingView();
    }else{
      if(widget.isDesktop == true){
        return _desktopFocusedStreamingView();
      }else{
        return _mobileFocusedStreamingView();
      }
    }
  }

  Widget _desktopFocusedStreamingView(){
    return Column(
      children: [
        Expanded(
          child: StreamWidget(
            key: ObjectKey(widget.streams[_focusedStream]["peer ID"],),
            onPressed: (){
              ///if this stream is already being focused on, remove the focus
              setState(() {
                _focusedStream = null;
              });
            },
            streamData: widget.streams[_focusedStream],
            state: SizeState.focused,
            showWhiteboard: widget.showWhiteboard == true ? widget.showWhiteboard : null,
            mobileSize: null,
            desktopSize: null,
            focusedSize: Size(double.infinity, double.infinity,),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              for(int i = 0; i < widget.streams.length; i++)
                if(_focusedStream != i)
                  StreamWidget(
                    key: ObjectKey(widget.streams[i]["peer ID"],),
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
                    desktopSize: Size(widget.size.width/8, widget.size.width/8,),
                    focusedSize: null,
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _mobileFocusedStreamingView(){
    if(_isLandscape == true){
      return Row(
        children: [
          Expanded(
            child: StreamWidget(
              key: ObjectKey(widget.streams[_focusedStream]["peer ID"],),
              onPressed: (){
                ///if this stream is already being focused on, remove the focus
                setState(() {
                  _focusedStream = null;
                });
              },
              streamData: widget.streams[_focusedStream],
              state: SizeState.focused,
              showWhiteboard: widget.showWhiteboard == true ? widget.showWhiteboard : null,
              mobileSize: null,
              desktopSize: null,
              focusedSize: Size((double.infinity), double.infinity),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                for(int i = 0; i < widget.streams.length; i++)
                  if(_focusedStream != i)
                    StreamWidget(
                      key: ObjectKey(widget.streams[i]["peer ID"],),
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
                      mobileSize: Size((widget.size.height/2.5 - 5), widget.size.height/2.5 - 5,),
                      desktopSize: null,
                      focusedSize: null,
                    ),
              ],
            ),
          ),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StreamWidget(
            key: ObjectKey(widget.streams[_focusedStream]["peer ID"],),
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
            focusedSize: Size(widget.size.width, widget.size.width),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: widget.isDesktop == true ? 20.0 : 0.0, runSpacing: 20.0,
                children: [
                  for(int i = 0; i < widget.streams.length; i++)
                    if(_focusedStream != i)
                      StreamWidget(
                        key: ObjectKey(widget.streams[i]["peer ID"],),
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
                        mobileSize: Size(widget.size.width/2, widget.size.width/3,),
                        desktopSize: null,
                        focusedSize: null,
                      ),
                ],
              ),
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
              key: ObjectKey(widget.streams[i]["peer ID"],),
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
              mobileSize: _isLandscape == true
                  ? Size(widget.size.width/3.5, widget.size.width/6,)
                  : Size(widget.size.width/2, widget.size.width/3,),
              desktopSize: Size((widget.size.width/3.5- 20), widget.size.width/6,),
              focusedSize: null,
            ),
        ],
      ),
    );
  }

}
