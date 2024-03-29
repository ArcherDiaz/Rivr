import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:sad_lib/CustomWidgets.dart';

class WhiteBoard extends StatefulWidget {
  @override
  _WhiteBoardState createState() => _WhiteBoardState();
}

class _WhiteBoardState extends State<WhiteBoard> {
  Color selectedColor = Colors.white;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = [];
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = StrokeCap.butt;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<Color> boardColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.amber,
    Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth
              ));
            });
          },
          onPanStart: (details) {
            setState(() {
              RenderBox renderBox = context.findRenderObject();
              points.add(DrawingPoints(
                  points: renderBox.globalToLocal(details.globalPosition),
                  paint: Paint()
                    ..strokeCap = strokeCap
                    ..isAntiAlias = true
                    ..color = selectedColor.withOpacity(opacity)
                    ..strokeWidth = strokeWidth
              ));
            });
          },
          onPanEnd: (details) {
            setState(() {
              points.add(null);
            });
          },
          child: CustomPaint(
            size: Size.infinite,
            painter: DrawingPainter(pointsList: points),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: colors.darkPurple,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonView(
                          onPressed: () {
                            setState(() {
                              if(selectedMode == SelectedMode.StrokeWidth) {
                                showBottomList = !showBottomList;
                              }
                              selectedMode = SelectedMode.StrokeWidth;
                            });
                          },
                          child: Icon(Icons.album),
                        ),
                        ButtonView(
                          onPressed: () {
                            setState(() {
                              if(selectedMode == SelectedMode.Opacity) {
                                showBottomList = !showBottomList;
                              }
                              selectedMode = SelectedMode.Opacity;
                            });
                          },
                          child: Icon(Icons.opacity),
                        ),
                        ButtonView(
                          onPressed: () {
                            setState(() {
                              if(selectedMode == SelectedMode.Color) {
                                showBottomList = !showBottomList;
                              }
                              selectedMode = SelectedMode.Color;
                            });
                          },
                          child: Icon(Icons.color_lens),
                        ),
                        ButtonView(
                          onPressed: () {
                            setState(() {
                              showBottomList = false;
                              points.clear();
                            });
                          },
                          child: Icon(Icons.clear),
                        ),
                      ],
                    ),
                    Visibility(
                      child: (selectedMode == SelectedMode.Color) ?
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Divider(
                              thickness: 1.5,
                              height: 10.0,
                              color: colors.white.withOpacity(0.30),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: getColorList(),
                          ),
                        ],
                      ) :
                      Slider(
                        value: (selectedMode == SelectedMode.StrokeWidth) ? strokeWidth : opacity,
                        max: (selectedMode == SelectedMode.StrokeWidth) ? 50.0 : 1.0,
                        min: 0.0,
                        onChanged: (val) {
                          setState(() {
                            if(selectedMode == SelectedMode.StrokeWidth) {
                              strokeWidth = val;
                            } else {
                              opacity = val;
                            }
                          });
                        },
                      ),
                      visible: showBottomList,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getColorList() {
    List<Widget> listWidget = [];
    for(Color color in boardColors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  showLabel: true,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                ButtonView(
                  child: Text('Save'),
                  onPressed: () {
                    setState(() => selectedColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: ClipOval(
        child: Container(
          height: 36,
          width: 36,
          padding: const EdgeInsets.only(bottom: 16.0, top: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.green, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0, top: 10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(width: 2.0, color: selectedColor == color ? Colors.white : Colors.transparent,),
          ),
          height: 36,
          width: 36,
        ),
      ),
    );
  }

}

class DrawingPainter extends CustomPainter {

  DrawingPainter({this.pointsList});
  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if(pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
          pointsList[i].points,
          pointsList[i + 1].points,
          pointsList[i].paint,
        );
      } else if(pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
          pointsList[i].points.dx + 0.1,
          pointsList[i].points.dy + 0.1,
        ));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;

}

class DrawingPoints {

  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});

}

enum SelectedMode { StrokeWidth, Opacity, Color }
