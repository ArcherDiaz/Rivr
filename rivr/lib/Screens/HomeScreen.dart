import 'package:flutter/cupertino.dart';
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

  List<Map> _info = [
    {
      "icon" : Icons.privacy_tip_outlined,
      "title": "Make Invite Only Rooms",
      "info": "Escape from the open world to a small paradise with your closest friends and family in a private  Rivr room"
    },
    {
      "icon" : Icons.connect_without_contact_outlined,
      "title": "Connect Across All Platforms",
      "info": "From  desktop for connecting at home, to smart phones for connecting on the go. Rivr is always available to you!"
    },
    {
      "icon" : Icons.public_outlined,
      "title": "Join Public Rooms",
      "info": "Meet and make new friends online through public audio chat rooms, video show rooms and every other stream "
    },
    {
      "icon" : Icons.chat_bubble_outline_outlined,
      "title": "Unlimited Chat Messaging",
      "info": "Chat endlessly in any online room with the benefit of our Auto-Traceless Technology"
    },
    {
      "icon" : Icons.ios_share,
      "title": "Screen Sharing",
      "info": "Share your digital content quickly with everyone by sharing your screen. The possibilities are limitless when it comes to what you want to share"
    },
  ];

  List<Map> _cardInfo = [
    {
      "icon" : Icons.whatshot_outlined,
      "title" : "Free & Unlimited",
    },
    {
      "icon" : Icons.wifi_tethering_outlined,
      "title" : "Seamless Connections",
    },
    {
      "icon" : Icons.wb_cloudy_outlined,
      "title" : "Minimalist Design",
    },
    {
      "icon" : Icons.widgets_outlined,
      "title" : "Highly Responsive",
    },
    {
      "icon" : Icons.lock_outline_rounded,
      "title" : "Privacy & Security",
    },
    {
      "icon" : Icons.group_add_outlined,
      "title" : "Just Use It...",
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
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceEvenly,
                      spacing: _size.width > 700 ? 30.0 : 20.0, runSpacing: _size.width > 700 ? 30.0 : 20.0,
                      children: [
                        for(int i = 0; i < _info.length; i++)
                          HoverWidget(
                            duration: Duration(milliseconds: 500),
                            width: _size.width > 700 ? _size.width / 4.44 : _size.width,
                            idle: ContainerChanges(
                              padding: EdgeInsets.all(0.0),
                              margin: EdgeInsets.all(20.0),
                            ),
                            onHover: ContainerChanges(
                              decoration: BoxDecoration(
                                color: colors.bgDark,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Container(
                              width: _size.width > 700 ? _size.width / 4.44 : _size.width,
                              //height: _size.width > 700 ? _size.width / 5.0 : _size.width / 2.5,
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(_info[i]["icon"], size: 50.0, color: colors.blue,),
                                  TextView(
                                    text: _info[i]["title"],
                                    padding: EdgeInsets.only(bottom: 5.0),
                                    color: colors.white,
                                    size: 15.0,
                                    fontWeight: FontWeight.w700,
                                    align: TextAlign.center,
                                  ),
                                  TextView(
                                    text: _info[i]["info"],
                                    color: colors.white,
                                    size: 15.0,
                                    fontWeight: FontWeight.w400,
                                    align: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),

                    Divider(
                      height: 1.0,
                      color: colors.white,
                    ),
                    Center(
                      child: TextView(
                        text: "DON’T MISS OUT ON THE RIVR EXPERIENCE ",
                        color: colors.white,
                        letterSpacing: 1.0,
                        size: _size.width > 700 ? 30.0 : 25.0,
                        fontWeight: FontWeight.w500,
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.spaceEvenly,
                          runAlignment: WrapAlignment.center,
                          spacing: _size.width > 700 ? 30.0 : 20.0, runSpacing: _size.width > 700 ? 30.0 : 20.0,
                          children: [
                            for(int i = 0; i < _cardInfo.length; i++)
                              Container(
                                width: _size.width > 700 ? _size.width / 4.44: _size.width,
                                //height: _size.width > 700 ? _size.width / 5.0 : _size.width / 2.5,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: colors.bgLight,
                                  borderRadius: BorderRadius.circular(5.0)
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(_cardInfo[i]["icon"], size: 50.0, color: colors.darkPurple,),
                                    Expanded(
                                      child: TextView(
                                        text: _cardInfo[i]["title"],
                                        padding: EdgeInsets.only( left: 20.0),
                                        color: colors.darkPurple,
                                        size: 20.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    Divider(
                      height: 1.0,
                      color: colors.white,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0,),
                        child: Align(
                          alignment: Alignment.center,
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
                          ),
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
        ButtonView.hover(
          onPressed: () {
            _dialogClass.textInputDialog(context, title: "Enter Room Code", positive: "join", negative: "cancel",).then((code){
              if(code != null && code.isNotEmpty){
                widget.updatePage(RoutePathClass.live({
                  "code": code,
                }));
              }
            });
          },
          onHover: ContainerChanges(
            decoration: BoxDecoration(
              color: colors.bgDark,
              border: Border.all(color: colors.bgDark, width: 1.5,),
              borderRadius: BorderRadius.circular(5.0)
            ),
          ),
          borderRadius: 2.5,
          border: Border.all(color: colors.white, width: 1.5,),
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(right: 20.0,),
          builder: (isHovering){
            return TextView(text: "Join Room",
              color: colors.white,
              size: 18.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            );
          },
        ),
        ButtonView.hover(
          onPressed: () {
            _dialogClass.textInputDialog(context, title: "Enter Room Code", positive: "join", negative: "cancel",).then((code){
              if(code != null && code.isNotEmpty){

              }
            });
          },
          onHover: ContainerChanges(
            decoration: BoxDecoration(
              color: colors.bgDark,
              border: Border.all(color: colors.bgDark, width: 1.5,),
              borderRadius: BorderRadius.circular(5.0)
            ),
          ),
          borderRadius: 2.5,
          border: Border.all(color: colors.white, width: 1.5,),
          padding: EdgeInsets.all(8.0),
          builder: (isHovering){
            return TextView(text: "Start Room",
              color: colors.white,
              size: 18.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            );
          },
        ),
      ],
    );
  }

}
