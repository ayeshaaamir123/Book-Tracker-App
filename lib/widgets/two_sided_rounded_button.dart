import 'package:book_tracker/constants/constants.dart';
import 'package:flutter/material.dart';

class TwoSidedRoundedButton extends StatelessWidget {
  const TwoSidedRoundedButton(
      {Key? key,
      this.text,
      this.radius = 30,
      this.press,
      this.color = kBlackColor})
      : super(key: key);
  final String? text;
  final double radius;
  final Function? press;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        //onTap: press as Function(),
        child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              bottomRight: Radius.circular(radius))),
      child: Text(
        text.toString(),
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
