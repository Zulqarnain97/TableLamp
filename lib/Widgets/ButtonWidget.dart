import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:table_lamp/Utils/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key key,
      this.text,
      this.onClicked,
      this.color = Colors.black,
      this.backgroundColor = Colors.grey})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding.sp / 2,
              vertical: kDefaultPadding.sp / 3)),
      onPressed: onClicked,
      child: Text(text,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(fontSize: 10.0.sp, color: color),
          )));
}
