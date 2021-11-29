import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewFile extends StatefulWidget {
  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  @override

  void saveTime(int time) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('time', time);
    print('time saved' + '${time}');


  }

  var newTime= 30;

  getTime() async {
    final prefs = await SharedPreferences.getInstance();
    final time = prefs.getInt('time');

    setState(() {
      newTime = time;
      print('time= ${time}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40,),
          RaisedButton(
            onPressed: () {
              setState(() {
                // Timer(const Duration(milliseconds: 5000), () {
                //   print('timer stopped after one minute');
                  saveTime(7000);
                  getTime();
                  // Future.delayed(const Duration(milliseconds: 5000), () {
                  //   setState(() {
                  //     SystemNavigator.pop();
                  //     // Here you can write your code for open new view
                  //   });
                  // });
                // });
              });
            },
            child: Text('Timer One'),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                Timer(const Duration(minutes: 2), () {
                  print('timer stopped after two minute');
                });
              });
            },
            child: Text('Timer Two'),
          ),
        ],
      ),
    );
  }
}
