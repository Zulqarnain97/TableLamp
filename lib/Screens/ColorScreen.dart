import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_lamp/Utils/constants.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../Widgets/ButtonWidget.dart';

class ColorScreen extends StatefulWidget {
  @override
  _ColorScreenState createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  List<int> _timeValues = [
    5,
    10,
    15,
    20,
    30,
    40,
    50,
    60,
    120,
    240,
    360
  ]; // Option 2
  int _selectedTimeValue;

  @override
  void initState() {
    //print(_currentColor);
    getColor();
    // reset();

    // TODO: implement initState
    super.initState();
  }

  void saveTime(int time) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', time);
    print('time saved' + '${time}');
  }

  var newTime = 30;

  getTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = prefs.getInt('time');

    setState(() {
      newTime = time;
      print('time= ${newTime}');
    });
  }

  Future<void> _onColorChanged(Color color) async {
    final prefs = await SharedPreferences.getInstance();

    //_currentColor = color;
    prefs.setInt('r', color.red);
    prefs.setInt('g', color.green);
    prefs.setInt('b', color.blue);
    // print('saving ${color.red}');
  }

  var currentColor = Color.fromRGBO(255, 51, 255, 1.0);

  getColor() async {
    final prefs = await SharedPreferences.getInstance();
    final r = prefs.getInt('r');
    final g = prefs.getInt('g');
    final b = prefs.getInt('b');
    //final opacity = prefs.getDouble('o');
    setState(() {
      currentColor = Color.fromRGBO(r, g, b, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: bottomNavColor,
        elevation: 0.0,
        toolbarHeight: 8.0.h,
        title: Text(
          'Change Colors',
          style: GoogleFonts.ubuntu(
              textStyle: TextStyle(color: Colors.white, fontSize: 14.0.sp)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 15.0.h,
              width: 100.0.w,
              color: Colors.grey,
              child: Center(child: Text('Advertisment')),
            ),
            SizedBox(
              height: 20.0.sp,
            ),
            CircleColorPicker(
              initialColor: currentColor,
              strokeWidth: 16,
              onChanged: _onColorChanged,
              colorCodeBuilder: (context, color) {
                return Text(
                  'rgb(${color.red}, ${color.green}, ${color.blue})',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              },
            ),

            SizedBox(
              height: 20.0.sp,
            ),

            DropdownButton(
              hint: Text(
                'Close App After /mins',
                style: TextStyle(color: Colors.black, fontSize: 10.0.sp),
              ),
              // Not necessary for Option 1
              value: _selectedTimeValue,
              onChanged: (newValue) {
                setState(() {
                  _selectedTimeValue = newValue;
                  saveTime(newValue);
                });
              },
              items: _timeValues.map((val) {
                return DropdownMenuItem(
                  child: new Text(
                    val.toString() + ' minutes',
                    style: TextStyle(color: Colors.black, fontSize: 10.0.sp),
                  ),
                  value: val,
                );
              }).toList(),
            ),
            Container(
              height: 15.0.h,
              width: 100.0.w,
              color: Colors.grey,
              child: Center(child: Text('Advertisment')),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeButton(int timeInMin) {
    return Padding(
      padding: EdgeInsets.only(left: 5.0.sp, right: 5.0.sp),
      child: RaisedButton(
        onPressed: () {
          setState(() {
            saveTime(timeInMin);
            getTime();
          });
        },
        child: Text(
          '${timeInMin}',
          style: TextStyle(fontSize: 10.0.sp),
        ),
      ),
    );
  }
}
