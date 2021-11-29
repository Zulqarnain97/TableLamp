import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:table_lamp/Useful/NewFile.dart';
import 'package:table_lamp/Useful/OldColorsScreen.dart';
import 'package:table_lamp/Screens/HomeScreen.dart';
import 'package:table_lamp/Screens/MoreScreen.dart';
import 'package:table_lamp/Screens/RelaxScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_lamp/Screens/ColorScreen.dart';
import 'package:table_lamp/Utils/constants.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedItemIndex = 0;

  bool showBottomNavbar = false;

  void changeShowStatus() {
    showBottomNavbar = !showBottomNavbar;
  }

  @override
  void initState() {
    showToast();
    // setState(() {
    //   getTime();
    // });
    // TODO: implement initState
    super.initState();
  }



  showToast() {
    return Fluttertoast.showToast(
        msg: "Touch The Screen To View Other Features",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0.sp);
  }

  var newTime = 30;

  closeAppFunction(int time){
    Future.delayed(Duration(minutes: time), () {
      setState(() {
        SystemNavigator.pop();
        // Here you can write your code for open new view
      });
    });
  }

  getTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = prefs.getInt('time');

    setState(() {
      newTime = time;
      print('time= ${time}');
      if (time == 5) {
        closeAppFunction(5);
      }
      else if (time == 10) {
        closeAppFunction(10);
      }
      else if (time == 15) {
        closeAppFunction(15);
      }
      else if (time == 20) {
        closeAppFunction(20);
      }
      else if (time == 30) {
        closeAppFunction(30);
      }
      else if (time == 40) {
        closeAppFunction(40);
      }
      else if (time == 50) {
        closeAppFunction(50);
      }
      else if (time == 60) {
        closeAppFunction(60);
      }
      else if (time == 120) {
        closeAppFunction(120);
      }
      else if (time == 240) {
        closeAppFunction(240);
      }
      else if (time == 360) {
        closeAppFunction(360);
      }
      else {
        closeAppFunction(60);
      }
    });
  }

  final List<Widget> _children = [
    HomeScreen(),
    ColorScreen(),
    RelaxScreen(),
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    getTime();
    return WillPopScope(
      onWillPop: () async {
        if (_selectedItemIndex == 0) return true;
        setState(() {
          _selectedItemIndex = 0;
        });
        return false;
      },
      child: Scaffold(
          body: GestureDetector(
              onTap: () {
                setState(() {
                  changeShowStatus();
                });
              },
              child: _children[_selectedItemIndex]),
          bottomNavigationBar: showBottomNavbar != false
              ? Container(
                  height: 10.0.h,
                  color: bottomNavColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        bottomOption('Lamp', Icons.highlight, 0),
                        bottomOption('Colors', Icons.color_lens, 1),
                        bottomOption('Music', Icons.music_note_outlined, 2),
                        bottomOption('More', Icons.more_horiz, 3),
                      ],
                    ),
                  ),
                )
              : SizedBox()),
    );
  }

  Widget bottomOption(String title, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        height: 8.0.h,
        width: 20.0.w,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: index == _selectedItemIndex ? 22.0.sp : 20.0.sp,
              color: bottomNavItemColor,
            ),
            Text(title,
                style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                      fontSize: index == _selectedItemIndex ? 12.0.sp : 10.0.sp,
                      color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
