import 'package:flutter/material.dart';


class AppConstants {
  // Name
  static String appName = "Jasper";
//  static String LIVE_URL = "http://103.130.88.23:4207/";

  // for test 4201//
 // static String LIVE_URL = "http://106.51.48.63:4207/";

  // for Live 4205//
 static String LIVE_URL = "http://14.98.224.37:5201/";


  //////////////////////////////////////////////////////


  //UAT_TEST DATABASE__USE 4200 port//
 // static String LIVE_URL = "http://49.204.232.40:4200/";

  //ANANDHASS_SAS DATABASE--USE 4201 port//

 // static String LIVE_URL = "http://49.204.232.40:4201/";






  ///////////////////////////////////////////////////

  //static String LIVE_URL = "http://49.204.232.40:4200/";
  //static String LIVE_URL = "http://192.168.11.180:4201/";

  // Material Design Color
  static Color lightPrimary = Color(0xfffcfcff);
  static Color lightAccent = Color(0xFF3B72FF);
  static Color lightBackground = Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff707070);
  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFA1ECBF);

  // Yellow
  static Color darkYellow = Color(0xFF3ABD6F);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF3B72FF);
  static Color lightBlue = Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = Color(0xFFFFB74D);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

  static double headerHeight = 228.5;
  static double paddingSide = 30.0;
}

Widget CheckInterNet(BuildContext context,){
  print('CheckInterNet');
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;
  return  Scaffold(

    backgroundColor: Colors.white,
    body: Stack(

      children: [
        // Container(
        //   margin: EdgeInsets.only(top: height/5),
        //   height: height/2,
        //   width: width,
        //
        //   child: Lottie.asset('assets/imgs/no-internet.json'),
        // ),
        Container(
          margin: EdgeInsets.only(top: height/1.5),
          color: Colors.white,),
        Container(
            margin: EdgeInsets.only(top: height/1.5),
            child:  Column(
              children: [
                Text('Something Went Wrong',style: TextStyle(fontSize: 15,color: Colors.green),),
                Center(child: SizedBox(height: 10,)),
                Text('Please Check Your Connection and try again.',style: TextStyle(fontSize: 13,color:  Colors.green),),
              ],
            )),
        SizedBox(height: 10,),
        /*Container(
            height: height/15,
            width: width/2.5,
            decoration: BoxDecoration(
                color:String_Values.primarycolor,
                borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: TextButton(onPressed: (){

            }, child: Text('Retry',style: TextStyle(fontSize: 20,color: Colors.white),)))*/
      ],
    ),
  );

}
