import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Admin/SuperAdminDashBoard.dart';
import 'BranchAdminScreens/BranchAdminDashBoard.dart';
import 'DashBoard.dart';
import 'LoginPage.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  var islogged = false;
  late String SessionAdminUser;


  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      islogged = prefs.getBool!('LoggedIn')!;
      SessionAdminUser = prefs.getString('AdminUser')!;
    });
  }


  @override
  void initState() {
    super.initState();
     getStringValuesSF();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Timer(
        Duration(seconds: 2),
            () =>
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>islogged == true ?(SessionAdminUser.trim()=='SA'?SuperAdminDashBoard():SessionAdminUser.trim()=='S'?BranchAdminDashBoard():DashBoard()):LoginPage())));

    // Timer(
    //     Duration(seconds: 4),
    //         () => Navigator.of(context).pushReplacement(MaterialPageRoute(
    //         builder: (BuildContext context) => islogged == true ? DashBoard() : LoginPage())));
    var assetsImage = new AssetImage(
        'assets/images/Jasperlogo.png'); //<- Creates an object that fetches an image.
    var image = new Image(
      image: assetsImage,
      height:height,
      width: width,); //<- Creates a widget that displays an image.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /* appBar: AppBar(


          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(
            child: image,
          ),
        ), //<- place where the image appears
      ),
    );
  }
}
