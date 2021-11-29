import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:table_lamp/Utils/constants.dart';

import 'package:flutter_masked_text/flutter_masked_text.dart';

import '../Widgets/ButtonWidget.dart';

class OldColorScreen extends StatefulWidget {
  @override
  _OldColorScreenState createState() => _OldColorScreenState();
}

class _OldColorScreenState extends State<OldColorScreen> {
 // final _formKey = GlobalKey<FormState>();

  void saveColor(int r, int g, int b, double opacity) async {
    print('Color saved');
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('r', r);
    prefs.setInt('g', g);
    prefs.setInt('b', b);
    prefs.setDouble('o', opacity);

  }

  var newColor = Color.fromRGBO(255, 51, 255, 1.0);

  getColor() async {
    final prefs = await SharedPreferences.getInstance();
    final r = prefs.getInt('r');
    final g = prefs.getInt('g');
    final b = prefs.getInt('b');
    final opacity = prefs.getDouble('o');
    setState(() {
      newColor = Color.fromRGBO(r, g, b, opacity);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getColor();
    reset();
    super.initState();
  }

  var countdownDuration = Duration(minutes: 30);
  Duration duration = Duration();
  Timer timer;

  bool countDown = true;

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
    } else {
      setState(() => duration = Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  TextEditingController hourController = new MaskedTextController(mask: '00');
  TextEditingController minuteController = new MaskedTextController(mask: '00');
  TextEditingController secondController = new MaskedTextController(mask: '00');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bottomNavColor,
        elevation: 0.0,
        toolbarHeight: 8.0.h,
        title: Text(
          'Change Colors',
          style: GoogleFonts.ubuntu(textStyle: TextStyle(color: Colors.white, fontSize: 14.0.sp)),
        ),
      ),
      body: Container(
        height: 92.0.h,
        width: 100.0.w,
        color: newColor,
        child: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding.sp, vertical: kDefaultPadding.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    colorBox(0, 0, 204, 1.0),
                    colorBox(0, 0, 255, 1.0),
                    colorBox(102, 102, 255, 1.0),
                    colorBox(153, 153, 255, 1.0),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    colorBox(204, 0, 204, 1.0),
                    colorBox(255, 51, 255, 1.0),
                    colorBox(255, 153, 255, 1.0),
                    colorBox(255, 204, 255, 1.0),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    colorBox(0, 204, 0, 1.0),
                    colorBox(0, 255, 0, 1.0),
                    colorBox(102, 255, 178, 1.0),
                    colorBox(204, 255, 229, 1.0),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    colorBox(255, 255, 0, 1.0),
                    colorBox(255, 255, 51, 1.0),
                    colorBox(255, 255, 102, 1.0),
                    colorBox(255, 255, 204, 1.0),
                  ],
                ),
                SizedBox(
                  height: 20.0.sp,
                ),
                Text(
                  'Select Reading Duration',
                  style: TextStyle(
                    fontSize: 8.0.sp,
                  ),
                ),
                SizedBox(
                  height: 5.0.sp,
                ),
                // GestureDetector(
                //     onTap: () {
                //       showDialog(
                //           context: context,
                //           builder: (BuildContext context) {
                //             return AlertDialog(
                //               content: Stack(
                //                 overflow: Overflow.visible,
                //                 children: <Widget>[
                //                   Positioned(
                //                     right: -40.0,
                //                     top: -40.0,
                //                     child: InkResponse(
                //                       onTap: () {
                //                         Navigator.of(context).pop();
                //                       },
                //                       child: CircleAvatar(
                //                         child: Icon(Icons.close),
                //                         backgroundColor: Colors.red,
                //                       ),
                //                     ),
                //                   ),
                //                   Form(
                //                     key: _formKey,
                //                     child: Column(
                //                       mainAxisSize: MainAxisSize.min,
                //                       children: <Widget>[
                //                         Padding(
                //                           padding: EdgeInsets.all(8.0),
                //                           child: TextFormField(
                //                             controller: hourController,
                //                             keyboardType: TextInputType.number,
                //                             decoration: InputDecoration(
                //                                 hintText: 'Enter Hours'
                //                             ),
                //                           ),
                //                         ),
                //                         Padding(
                //                           padding: EdgeInsets.all(8.0),
                //                           child: TextFormField(
                //                             controller: minuteController,
                //                             keyboardType: TextInputType.number,
                //                             decoration: InputDecoration(
                //                                 hintText: 'Enter Minutes'
                //                             ),
                //                           ),
                //                         ),
                //                         Padding(
                //                           padding: EdgeInsets.all(8.0),
                //                           child: TextFormField(
                //                             controller: secondController,
                //                             keyboardType: TextInputType.number,
                //                             decoration: InputDecoration(
                //                                 hintText: 'Enter Seconds'
                //                             ),
                //                           ),
                //                         ),
                //                         Padding(
                //                           padding: const EdgeInsets.all(8.0),
                //                           child: RaisedButton(
                //                             child: Text("Submit"),
                //                             onPressed: () {
                //                               if (_formKey.currentState.validate()) {
                //                                 _formKey.currentState.save();
                //                               }
                //                             },
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             );
                //           });
                //     },
                //     child:
                buildTime(),
                // ),
                SizedBox(
                  height: 20.0.sp,
                ),
                buildButtons(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget colorBox(int R, int G, int B, double O) {
    return GestureDetector(
      onTap: () {
        saveColor(R, G, B, O);
        getColor();
      },
      child: Material(
        elevation: 4,
        child: Container(
          height: 30.0.sp,
          width: 30.0.sp,
          color: Color.fromRGBO(R, G, B, O),
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      SizedBox(
        width: 5.0.sp,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      SizedBox(
        width: 5.0.sp,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({String time, String header}) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(kDefaultPadding.sp / 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(kDefaultBorderRadius.sp / 2)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22.0.sp),
            ),
          ),
          SizedBox(
            height: 10.0.sp,
          ),
          Text(header,
              style: TextStyle(color: Colors.black45, fontSize: 8.0.sp)),
        ],
      );

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer.isActive;
    final isCompleted = duration.inSeconds == 0;
    return isRunning || isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  text: 'STOP',
                  onClicked: () {
                    if (isRunning) {
                      stopTimer(resets: false);
                    }
                  }),
              SizedBox(
                width: 12,
              ),
              ButtonWidget(text: "CANCEL", onClicked: stopTimer),
            ],
          )
        : ButtonWidget(
            text: "Start Timer!",
            color: Colors.white,
            backgroundColor: Colors.red,
            onClicked: () {
              startTimer();
            });
  }
}
