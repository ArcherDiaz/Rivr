import 'package:flutter/material.dart';
import 'package:rivr/main.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:sad_lib/CustomWidgets.dart';
import 'package:sad_lib/DialogClass.dart';

class HomeScreen2 extends StatefulWidget {
  final RoutePathClass route;
  final void Function(RoutePathClass route) updatePage;
  HomeScreen2({Key key,
    @required this.route,
    @required this.updatePage,
  }) : super(key: key,);
  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {

  DialogClass _dialogClass;

  Size _size;
  bool _isDesktop;

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
        child: Stack(
          alignment: Alignment.center,
          children: [
            _display(),
            _main(),
            _version(),
            _dm(),
            _experience(),
            _features(),
          ],
        ),
      ),
    );
  }

  Widget _dm(){
    return ButtonView.hover(
      duration: Duration(milliseconds: 250,),
      onPressed: (){

      },
      onHover: ContainerChanges(
        decoration: BoxDecoration(
          color: colors.bgDark,
          border: Border.all(color: colors.blue, width: 2.0,),
        ),
      ),
      alignment: Alignment.topLeft,
      color: colors.bgDark.withOpacity(0.5,),
      borderRadius: 0.0,
      border: Border(
        left: BorderSide(color: colors.white, width: 2.0,),
        bottom: BorderSide(color: colors.blue, width: 2.0,),
      ),
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0,),
      padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 25.0,),
      child: TextView(text: "DM STUDIOS",
        size: 12.5,
        color: colors.white,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _version(){
    return Align(
      alignment: Alignment.topRight,
      child: TextView(text: "√ Maria",
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0,),
        size: _isDesktop == true ? 15.0 : 12.5,
        isSelectable: true,
        color: colors.darkPurple,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _features(){
    return ButtonView.hover(
      duration: Duration(milliseconds: 250,),
      onPressed: (){

      },
      onHover: ContainerChanges(
        decoration: BoxDecoration(
          color: colors.bgDark,
          borderRadius: BorderRadius.circular(45.0,),
          border: Border.all(color: colors.darkPurple, width: 2.0,),
        ),
      ),
      alignment: Alignment.bottomLeft,
      color: colors.bgDark.withOpacity(0.5,),
      borderRadius: 45.0,
      border: Border.all(color: colors.white, width: 2.0,),
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0,),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0,),
      child: TextView(text: "FEATURES",
        size: _isDesktop == true ? 15.0 : 17.5,
        color: colors.white,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _experience(){
    return ButtonView.hover(
      duration: Duration(milliseconds: 250,),
      onPressed: (){

      },
      onHover: ContainerChanges(
        decoration: BoxDecoration(
          color: colors.bgDark,
          borderRadius: BorderRadius.circular(45.0,),
          border: Border.all(color: colors.blue, width: 2.0,),
        ),
      ),
      alignment: Alignment.bottomRight,
      color: colors.bgDark.withOpacity(0.5,),
      borderRadius: 45.0,
      border: Border.all(color: colors.white, width: 2.0,),
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0,),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0,),
      child: TextView(text: "THE EXPERIENCE",
        size: _isDesktop == true ? 15.0 : 17.5,
        color: colors.white,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _main(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: _isDesktop == true ? _size.width/2.25 : _size.width/1.25,
        color: colors.bg.withOpacity(0.20,),
        margin: EdgeInsets.only(left: _isDesktop == true ? _size.width/7 : 20.0,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView.rich(
              textSpan: [
                TextView(text: "RIVR",
                  size: 50.0,
                  color: colors.blue,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
                TextView(text: " ONLINE LIVE STREAMING",
                  size: 25.0,
                  color: colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ],
              isSelectable: true,
            ),
            TextView.rich(
              textSpan: [
                TextView(text: "An Antiguan-made audio and video live streaming platform available for free and unlimitedly accessible to everyone!\n",
                  size: _isDesktop == true ? 12.5 : 15.0,
                  letterSpacing: 1.0,
                  lineSpacing: 1.5,
                  color: colors.white,
                  fontWeight: FontWeight.w300,
                ),
                TextView(text: "Connect, Share and Stream, The RIVR way!",
                  size: _isDesktop == true ? 12.5 : 15.0,
                  letterSpacing: 1.0,
                  lineSpacing: 1.5,
                  color: colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ],
              lineSpacing: 1.5,
              isSelectable: true,
              padding: EdgeInsets.only(top: 10.0, bottom: 30.0,),
            ),
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
                return TextView(text: "Open Room",
                  color: colors.white,
                  size: 17.5,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _display(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        color: colors.bgDark,
        width: _isDesktop == true ? _size.width/2.25 : _size.width/1.25,
        margin: EdgeInsets.only(left: _isDesktop == true ? _size.width/7 : 20.0, right: 30.0,),
        padding: EdgeInsets.all(10.0,),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0,),
                  child: ImageView.network(imageKey: "https://media.tenor.com/images/5ac4ddc5a5305ef9e4c8a9cd5f2cd12d/tenor.gif",
                    width: (constraints.maxWidth/3)-10,
                    height: (constraints.maxWidth/3)*1.5,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0,),
                  child: ImageView.network(imageKey: "https://media.tenor.com/images/1642bf462cac187c0c0855e4051c7daa/tenor.gif",
                    width: (constraints.maxWidth/3)-10,
                    height: (constraints.maxWidth/3)*1.5,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0,),
                  child: ImageView.network(imageKey: "https://media.tenor.com/images/72126923bcc7857e40d2c355ceb09dc2/tenor.gif",
                    width: (constraints.maxWidth/3)-10,
                    height: (constraints.maxWidth/3)*1.5,
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

}
