import 'package:flutter/material.dart';
import 'package:rivr/Utils/ColorsClass.dart' as colors;
import 'package:sad_lib/CustomWidgets.dart';

class LoadingContainer extends StatefulWidget {
  final String text;
  LoadingContainer({Key key, this.text,}) : super(key: key);
  @override
  _LoadingContainerState createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> {

  List<String> _woii = [
    "Eren YeaGERR",
    "Thank you for choosing Rivr today.\nAlthough we already knew you would :)",
    "Are you asking me why people eat potatoes Sir?",
    "If anything goes wrong just remember that it's not me, it's you. My platform is perfect.",
    "What are they Selling?.. CHOCOLATEE!",
    "Rivir.. Rver... Rvr?.. Revir... Rivre....",
    "The only game I have is depression, and it's the one playing me",
    "Imagine if we had money or were getting paid!\nRivr would be 100x better without a doubt.. *wink*",
    "Relax a little, you deserve it.",
  ];

  int _index = 0;

  @override
  void initState() {
    _woii.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                backgroundColor: colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation(colors.bgDark),
              ),
              TextView(text: widget.text,
                padding: EdgeInsets.all(20.0),
                size: 12.5,
                align: TextAlign.center,
                isSelectable: true,
                color: colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _woiiWidget(),
        ),
      ],
    );
  }

  Widget _woiiWidget(){
    return Container(
      margin: EdgeInsets.all(15.0,),
      padding: EdgeInsets.all(10.0,),
      decoration: BoxDecoration(
        border: Border.all(color: colors.bgLight, width: 1.0,),
      ),
      child: TextView(text: _woii[_index],
        size: 13.0,
        align: TextAlign.center,
        isSelectable: true,
        lineSpacing: 2.0,
        color: colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

}
