import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rivr/Utils/StreamWidget.dart';
import 'package:rivr/Utils/UserStream.dart';

class StreamContainer extends StatefulWidget {
  final bool isDesktop;
  final Size size;
  final List<UserStream> streams;

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
    if(widget.streams.length == 1){
      ///if there is only one stream
      return singleStream();
    }else if(widget.streams.length == 2){
      ///if there are only two streams
      return pairStream();
    }else{
      ///when there is more than 2 streams
      return _staggered();
    }
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
              key: ObjectKey(widget.streams[i].id),
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

  Widget singleStream() {
    return Center(
      child: StreamWidget(
        onPressed: (){},
        streamData: widget.streams[0],
        size: widget.isDesktop || _isLandscape == true
            ? Size(widget.size.width/2, widget.size.width/2,)
            : Size(widget.size.width, widget.size.width,),
      ),
    );
  }

  Widget pairStream() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: widget.isDesktop == true ? 20.0 : 10.0,),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: widget.isDesktop == true ? 20.0 : 10.0, runSpacing: 20.0,
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
                  ? _focusedStreamIndex == i ? Size(widget.size.width/1.35, widget.size.width/6,) : Size(widget.size.width/3, widget.size.width/6,)
                  : _focusedStreamIndex == i ? Size(widget.size.width - 20, widget.size.width/3 - 10,) : Size(widget.size.width/2 - 20, widget.size.width/3 - 10,),
            ),
        ],
      ),
    );
  }

}
