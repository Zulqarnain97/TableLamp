import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:table_lamp/Utils/constants.dart';



class MoreScreen extends StatefulWidget {

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Future remove() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove("time");
    pref.remove('r');
    pref.remove('g');
    pref.remove('b');





  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bottomNavColor,
        elevation: 0.0,
        toolbarHeight: 8.0.h,
        title: Text(
          'More Options',
          style: GoogleFonts.ubuntu(textStyle: TextStyle(color: Colors.white, fontSize: 14.0.sp)),
        ),
      ),
      body: Container(
        height: 92.0.h,
        width: 100.0.w,
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              height: 10.0.sp,
            ),
            MoreScreenItem('Remmove Ads', Icons.monetization_on),
            MoreScreenItem('Tutorial', Icons.school),
           // Divider(),
            GestureDetector(
                onTap: (){
                  showAlertDialog(context);
                },
                child: MoreScreenItem('Reset Colors', Icons.restore)),
           // MoreScreenItem('BookMark', Icons.bookmark),
            Divider(),
            MoreScreenItem('Rate 5 Star', Icons.star_rate),
            MoreScreenItem('Share', Icons.share),
            GestureDetector(
                onTap: (){
                  showSecondAlertDialog(context);
                },
                child: MoreScreenItem('Exit', Icons.exit_to_app_outlined)),
          ],
        ),
      ),
    );
  }

  Widget MoreScreenItem(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultMargin / 2, vertical: kDefaultMargin / 2),
      child: Container(
          height: 8.0.h,
          width: 100.0.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius.sp)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultMargin.sp / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.blueGrey,
                  size: 22.0.sp,
                ),
                SizedBox(
                  width: kDefaultMargin.sp / 2,
                ),
                Text(
                  title,
                  style: GoogleFonts.lora(textStyle: TextStyle(color: Colors.blueGrey, fontSize: 12.0.sp)),
                ),
              ],
            ),
          ),

      ),
    );
  }
  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        remove();
        Navigator.pop(context);

      },
    );

    Widget noButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("Simple Alert"),
      content: Text("Do you want to Reset Colors?"),
      actions: [okButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showSecondAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        SystemNavigator.pop();

      },
    );

    Widget noButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("Simple Alert"),
      content: Text("Do you want to Exit?"),
      actions: [okButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
