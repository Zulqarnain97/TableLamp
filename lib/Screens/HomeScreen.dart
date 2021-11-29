import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:screen/screen.dart';


class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newColor= Color.fromRGBO(255, 51, 255, 1.0);

  double screenbrightness = 0.5;

  getColor() async {
    final prefs = await SharedPreferences.getInstance();
    final r = prefs.getInt('r');
    final g = prefs.getInt('g');
    final b = prefs.getInt('b');
    //final opacity = prefs.getDouble('o');
    setState(() {
      newColor = Color.fromRGBO(r, g, b, 1.0);
    });
  }

  @override
  void initState() {
    getColor();
    print(newColor);

    Future.delayed(Duration.zero,() async { //there is await function, so we use Future.delayed
      double brightness = await Screen.brightness; //get the current screen brightness
      if(brightness > 1){
        brightness = brightness / 10;
        // sometime it gives value ranging 0.0 - 10.0, so convert it to range 0.0 - 1.0
      }
      print(brightness);
      setState(() {
        screenbrightness = brightness;
        //change the variable value and update screen UI

      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.0.h,
        width: 100.0.w,
        color: newColor,
          child:Column(
           mainAxisAlignment: MainAxisAlignment.end,
            children: [

            Container(
                child: Text('$screenbrightness', style: TextStyle(
                  fontSize: 8.0.sp,
                  color: Colors.black
                ),)
            ),
            Container(
                child: Slider(//add the slider to configure brightness
                  min: 0.0,
                  max: 1.0,
                  activeColor: Colors.white,
                  onChanged: (value){ //this function will be executed when slider value is changed
                    Screen.setBrightness(value); //set screen brightness with slider value
                    setState(() {
                      screenbrightness = value; //update the UI
                    });
                  },
                  value: screenbrightness, //set default slider value
                )
            ),
              SizedBox(height: 8.0.h,),
          ],)
      ),
    );
  }
}