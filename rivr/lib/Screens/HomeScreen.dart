import 'package:flutter/material.dart';
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
  bool _isDesktop;

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
    _isDesktop = _size.width > 700 ? true : false;
    return Material(
      color: colors.bg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: _isDesktop ? 50.0 : 25.0,
            horizontal: _isDesktop ? 100.0 : 15.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: _size.width/6, bottom: 20.0,),
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
                padding: EdgeInsets.all(_isDesktop ? 50 : 15.0,),
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: colors.white, width: 1.0,),
                      left: BorderSide(color: colors.white, width: 1.0,),
                      right: BorderSide(color: colors.white, width: 1.0,),
                    ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextView.rich(
                        textSpan: [
                          TextView(
                            text: "RIVR",
                            color: colors.white,
                            size: _isDesktop ? 50.0 : 40.0,
                            fontWeight: FontWeight.w600,
                          ),
                          TextView(
                            text: " AN ANTIGUAN AUDIO & VIDEO \nLIVE STREAMING PLATFORM",
                            color: colors.white,
                            letterSpacing: 1.0,
                            size: _isDesktop ? 30.0 : 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                        align: TextAlign.start,
                        padding: EdgeInsets.only(bottom: _isDesktop ? 40 : 20.0,),
                      ),
                    ),

                    _roomButtons(),

                    _headerImage(),

                    Divider(
                      thickness: 1.5,
                      height: 10.0,
                      color: colors.bgLight,
                    ),
                    _infoCards(),

                    Divider(
                      thickness: 1.5,
                      height: 10.0,
                      color: colors.bgLight,
                    ),
                    TextView(text: "DON’T MISS OUT ON THE RIVR EXPERIENCE ",
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      color: colors.white,
                      letterSpacing: 1.0,
                      align: TextAlign.center,
                      size: _isDesktop ? 25.0 : 22.5,
                      fontWeight: FontWeight.w500,
                    ),
                    _cards2(),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Divider(
                        thickness: 1.0,
                        height: 10.0,
                        color: colors.bgLight,
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      spacing: _size.width > 700 ? 30.0 : 10.0, runSpacing: _size.width > 700 ? 30.0 : 10.0,
                      children: [
                        TextView(text: "dmstudios268@gmail.com",
                          padding: EdgeInsets.only(right: 10.0),
                          color: colors.white,
                          size: 17.5,
                          fontWeight: FontWeight.w400,
                        ),
                        TextView(text: "Instagram",
                          padding: EdgeInsets.only(left: 10.0),
                          color: colors.white,
                          size: 17.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
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


  Widget _roomButtons(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonView.hover(
          onPressed: () {
            _dialogClass.nameDialog(context, title: "Enter Room Code", compare: [], positive: "join", negative: "cancel",).then((code){
              if(code != null && code.isNotEmpty){
                widget.updatePage(RoutePathClass.live({
                  "code": code.toLowerCase(),
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

  Widget _headerImage(){
    return ImageView.asset(imageKey: "assets/home.jpg",
      aspectRatio: 3.0,
      width: _size.width,
      colorFilter: colors.bgDark.withOpacity(0.75,),
      margin: EdgeInsets.symmetric(vertical: _isDesktop ? 40 : 20.0,),
      customLoader: Container(
        color: colors.bgLight.withOpacity(0.25,),
      ),
    );
  }

  Widget _infoCards(){
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 20.0, runSpacing: 20.0,
      children: [
        for(int i = 0; i < _info.length; i++)
          HoverWidget(
            duration: Duration(milliseconds: 500,),
            width: _isDesktop ? _size.width / 5 : _size.width,
            idle: ContainerChanges(
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(20.0),
            ),
            onHover: ContainerChanges(
              decoration: BoxDecoration(
                color: colors.bgDark,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_info[i]["icon"],
                  size: 50.0,
                  color: colors.blue,
                ),
                TextView(
                  text: _info[i]["title"],
                  padding: EdgeInsets.symmetric(vertical: 5.0,),
                  color: colors.white,
                  size: 20.0,
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
      ],
    );
  }

  Widget  _cards2(){
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.spaceEvenly,
      runAlignment: WrapAlignment.center,
      spacing: 20.0, runSpacing: 20.0,
      children: [
        for(int i = 0; i < _cardInfo.length; i++)
          Container(
            width: _isDesktop ? _size.width / 5 : _size.width,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: colors.bgLight,
              borderRadius: BorderRadius.circular(5.0,),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_cardInfo[i]["icon"],
                  size: 50.0,
                  color: colors.darkPurple,
                ),
                Expanded(
                  child: TextView(text: _cardInfo[i]["title"],
                    padding: EdgeInsets.only(left: 20.0,),
                    color: colors.darkPurple,
                    size: 17.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

}
