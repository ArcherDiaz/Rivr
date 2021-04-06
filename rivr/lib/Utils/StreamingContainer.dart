import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rivr/Utils/StreamWidget.dart';

class StreamContainer extends StatefulWidget {
  final bool isDesktop;
  final Size size;
  final List<Map<String, dynamic>> streams;

  StreamContainer({Key key, this.isDesktop, this.size, this.streams,}) : super(key: key);
  @override
  _StreamContainerState createState() => _StreamContainerState();
}

class _StreamContainerState extends State<StreamContainer> {

  int _focusedStreamIndex;
  bool _isLandscape;

  @override
  Widget build(BuildContext context) {
    _isLandscape = MediaQuery.of(context).orientation == Orientation.landscape ? true : false;
    return Center(
      child: _staggered(),
    );
  }

  Widget _desktopFocusedStreamingView(){
    return Column(
      children: [
        Expanded(
          child: StreamWidget(
            onPressed: (){
              ///if this stream is already being focused on, remove the focus
              setState(() {
                _focusedStreamIndex = null;
              });
            },
            streamData: widget.streams[_focusedStreamIndex],
            size: Size(double.infinity, double.infinity,),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: [
              for(int i = 0; i < widget.streams.length; i++)
                if(_focusedStreamIndex != i)
                  StreamWidget(
                    onPressed: (){
                      if(_focusedStreamIndex == i){
                        ///if this stream is already being focused on, remove the focus
                        setState(() {
                          _focusedStreamIndex = null;
                        });
                      }else {
                        ///else set the focus
                        setState(() {
                          _focusedStreamIndex = i;
                        });
                      }
                    },
                    streamData: widget.streams[i],
                    size: Size(widget.size.width/8, widget.size.width/8,),
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
              onPressed: (){
                ///if this stream is already being focused on, remove the focus
                setState(() {
                  _focusedStreamIndex = null;
                });
              },
              streamData: widget.streams[_focusedStreamIndex],
              size: Size((double.infinity), double.infinity),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                for(int i = 0; i < widget.streams.length; i++)
                  if(_focusedStreamIndex != i)
                    StreamWidget(
                      key: ObjectKey(widget.streams[i]["peer ID"],),
                      onPressed: (){
                        if(_focusedStreamIndex == i){
                          ///if this stream is already being focused on, remove the focus
                          setState(() {
                            _focusedStreamIndex = null;
                          });
                        }else {
                          ///else set the focus
                          setState(() {
                            _focusedStreamIndex = i;
                          });
                        }
                      },
                      streamData: widget.streams[i],
                      size: Size((widget.size.height/2.5 - 5), widget.size.height/2.5 - 5,),
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
            onPressed: (){
              ///if this stream is already being focused on, remove the focus
              setState(() {
                _focusedStreamIndex = null;
              });
            },
            streamData: widget.streams[_focusedStreamIndex],
            size: Size(widget.size.width, widget.size.width),
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
                    if(_focusedStreamIndex != i)
                      StreamWidget(
                        onPressed: (){
                          if(_focusedStreamIndex == i){
                            ///if this stream is already being focused on, remove the focus
                            setState(() {
                              _focusedStreamIndex = null;
                            });
                          }else {
                            ///else set the focus
                            setState(() {
                              _focusedStreamIndex = i;
                            });
                          }
                        },
                        streamData: widget.streams[i],
                        size: Size(widget.size.width/2, widget.size.width/3,),
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
              onPressed: (){
                if(_focusedStreamIndex == i){
                  ///if this stream is already being focused on, remove the focus
                  setState(() {
                    _focusedStreamIndex = null;
                  });
                }else {
                  ///else set the focus
                  setState(() {
                    _focusedStreamIndex = i;
                  });
                }
              },
              streamData: widget.streams[i],
              size: widget.isDesktop || _isLandscape == true
                  ? Size(widget.size.width/3.5 - 20, widget.size.width/6,)
                  : Size(widget.size.width/2, widget.size.width/3,),
            ),
        ],
      ),
    );
  }


  Widget _staggered(){
    return StaggeredGridView.countBuilder(
      crossAxisCount: widget.isDesktop == true || _isLandscape
          ? 4
          : 2,
      staggeredTileBuilder: (index){
        if(index == _focusedStreamIndex){ ///if this stream is focused on
          return StaggeredTile.fit(widget.isDesktop == true || _isLandscape
              ? 3
              : 2,
          );
        }else {
          return StaggeredTile.fit(1);
        }
      },
      itemCount: widget.streams.length,
      padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: widget.isDesktop ? 50.0 : 10.0,),
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      itemBuilder: (newContext, i){
        return LayoutBuilder(
          builder: (context, constraints){
            return StreamWidget(
              key: ObjectKey(widget.streams[i]["id"]),
              onPressed: (){
                if(_focusedStreamIndex == i){
                  ///if this stream is already being focused on, remove the focus
                  setState(() {
                    _focusedStreamIndex = null;
                  });
                }else {
                  ///else set the focus
                  setState(() {
                    _focusedStreamIndex = i;
                  });
                }
              },
              streamData: widget.streams[i],
              size: Size(constraints.maxWidth, constraints.maxWidth,),
            );
          },
        );
      },
    );
  }

}
