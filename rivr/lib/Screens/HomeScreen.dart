import 'package:flutter/material.dart';
import 'package:rivr/Screens/RoomScreen.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:rivr/main.dart';
import 'package:sad_lib/CustomWidgets.dart';
import 'package:sad_lib/DialogClass.dart';

class HomeScreen extends StatefulWidget {
  final RoutePathClass route;
  final void Function(RoutePathClass route) updatePage;
  HomeScreen({Key key,
    @required this.route,
    @required this.updatePage,
  }) : super(key: key,);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  DialogClass _dialogClass;
  Size _size;

  List<Map> _howItWorks = [
    {
      "step": "STEP 1",
      "info": "Think dark theme! If it’s not in dark theme then it’s not worth it."
    },
    {
      "step": "STEP 2",
      "info": "Know how to code. More specifically, know the power of CTRL+C and CTRL+V"
    },
    {
      "step": "STEP 3",
      "info": "Now that you have your code, and it’s somewhat working, simply skip the testing phase and JUST GET IT ON THE INTERNET!"
    },
  ];
  
  @override
  void initState() {
    _dialogClass = DialogClass(background: colors.bg, buttonColor: colors.bgDark, buttonTextColor: colors.white, textColor: colors.white,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Material(
      color: colors.bg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: _size.width > 700 ? 100.0 : 40.0, vertical: _size.width > 700 ? 50.0 : 25.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 80.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextView(
                      text: "DM STUDIOS",
                      color: colors.white,
                      size: 15.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                    ),
                    TextView(
                      text: "2021",
                      color: colors.white,
                      size: 12.5,
                      fontWeight: FontWeight.w300,
                    ),
                  ],
                ),
              ),
              Container(
                width: _size.width,
                padding: EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                    border: Border.all(color: colors.white)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView.rich(textSpan: [
                      TextView(
                        text: "RIVR",
                        color: colors.white,
                        size: _size.width > 700 ? 45.0 : 40.0,
                        fontWeight: FontWeight.w700,
                      ),
                      TextView(
                        text: " AUDIO LIVE\nSTREAMING",
                        color: colors.white,
                        letterSpacing: 1.0,
                        size: _size.width > 700 ? 40.0 : 30.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ],),
                    _roomButtons(),

                    _headerImage(),

                    Divider(
                      height: 1.0,
                      color: colors.white,
                    ),
                    TextView(
                      text: "HOW\nIT WORKS",
                      color: colors.white,
                      size: 20.0,
                      fontWeight: FontWeight.w700,
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: _size.width > 700 ? 30.0 : 20.0, runSpacing: _size.width > 700 ? 30.0 : 20.0,
                      children: [
                        for(int i = 0; i < _howItWorks.length; i++)
                          Container(
                            width: _size.width > 700 ? _size.width / 4.44 : _size.width,
                            //height: _size.width > 700 ? _size.width / 5.0 : _size.width / 2.5,
                            padding: EdgeInsets.all(20.0),
                            margin: EdgeInsets.only(bottom: 40.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  text: _howItWorks[i]["step"],
                                  padding: EdgeInsets.only(bottom: 5.0),
                                  color: colors.white,
                                  size: 15.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                TextView(
                                  text: _howItWorks[i]["info"],
                                  color: colors.white,
                                  size: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    Divider(
                      height: 1.0,
                      color: colors.white,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0,),
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          spacing: _size.width > 700 ? 30.0 : 10.0, runSpacing: _size.width > 700 ? 30.0 : 10.0,
                          children: [
                            TextView(
                                text: "dmstudios268@gmail.com",
                                color: colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w400,
                                padding: EdgeInsets.only(right: 10.0)
                            ),
                            TextView(
                                text: "Instagram",
                                color: colors.white,
                                size: 18.0,
                                fontWeight: FontWeight.w400,
                                padding: EdgeInsets.only(left: 10.0)
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerImage(){
    return ImageView.asset(imageKey: "assets/home.jpg",
      aspectRatio: 3.0,
      width: _size.width,
      colorFilter: colors.bg.withOpacity(0.5,),
      margin: EdgeInsets.only(top: 20.0, bottom: 40.0),
      customLoader: Container(
        color: colors.bg.withOpacity(0.25,),
      ),
    );
  }

  Widget _roomButtons(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonView(
          onPressed: () {
            _dialogClass.textInputDialog(context, title: "Enter Room Code", positive: "join", negative: "cancel",).then((code){
              if(code != null && code.isNotEmpty){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RoomScreen(roomCode: code,),),);
              }
            });
          },
          border: Border.all(color: colors.white),
          borderRadius: 0.0,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(right: 20.0,),
          child: TextView(text: "Join Room",
            color: colors.white,
            size: 18.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        ButtonView(
          onPressed: () {
            _dialogClass.textInputDialog(context, title: "Enter Room Code", positive: "join", negative: "cancel",).then((code){
              if(code != null && code.isNotEmpty){

              }
            });
          },
          border: Border.all(color: colors.white),
          borderRadius: 0.0,
          padding: EdgeInsets.all(8.0),
          child: TextView(text: "Start Room",
            color: colors.white,
            size: 18.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}
