import 'package:flutter/material.dart';
import 'package:sad_lib/CustomWidgets.dart';

class Shooter extends StatefulWidget {
  @override
  _ShooterState createState() => _ShooterState();
}

class _ShooterState extends State<Shooter> {

  Size _size;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _gameScreen(),
            _controls(),
          ],
        ),
      ),
    );
  }

  Widget _gameScreen(){
    return Container(
      width: _size.width,
      height: _size.height/2,
      color: Colors.red,
    );
  }

  Widget _controls(){
    return Container(
      width: _size.width,
      height: _size.height/2,
      color: Colors.grey.shade900,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0,),
      child: Column(
        children: [
          TextView(text: "GAMEBOY",
            size: 15.0,
            letterSpacing: 7.5,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: _buttons(),
          ),
          TextView(text: "ADVANCED",
            size: 15.0,
            letterSpacing: 1.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buttons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ButtonView(
                  onPressed: (){

                  },
                  margin: EdgeInsets.all(5.0,),
                  border: Border.all(color: Colors.white, width: 2.5,),
                  padding: EdgeInsets.all(5.0,),
                  child: TextView(text: "b",
                    size: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ButtonView(
              onPressed: (){

              },
              margin: EdgeInsets.only(top: 50.0, left: 5.0, right: 5.0,),
              border: Border.all(color: Colors.white, width: 2.5,),
              padding: EdgeInsets.all(5.0,),
              child: TextView(text: "b",
                size: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            ButtonView(
              onPressed: (){

              },
              margin: EdgeInsets.symmetric(horizontal: 5.0,),
              border: Border.all(color: Colors.white, width: 2.5,),
              padding: EdgeInsets.all(5.0,),
              child: TextView(text: "a",
                size: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
