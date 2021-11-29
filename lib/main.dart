import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer_util.dart';
import 'package:table_lamp/Useful/NewFile.dart';
import 'package:screen/screen.dart';
import 'Screens/DashBoard.dart';

void main() {
  Screen.keepOn(true);
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(//return LayoutBuilder
        builder: (context, constraints) {
      return OrientationBuilder(//return OrientationBuilder
          builder: (context, orientation) {
        //initialize SizerUtil()
        SizerUtil().init(constraints, orientation); //initialize SizerUtil
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: DashBoard(),
        );
      });
    });
  }
}



