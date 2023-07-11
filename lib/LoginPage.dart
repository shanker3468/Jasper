import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';


import 'Admin/SuperAdminDashBoard.dart';
import 'AppConstants.dart';

import 'BranchAdminScreens/BranchAdminDashBoard.dart';
import 'DashBoard.dart';
import 'package:http/http.dart' as http;

import 'Model/LoginModel.dart';
import 'String_Values.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  var dropdownValue2 = "PRD - Production";

  bool loading = false;

  String _identifier = 'Unknown';

  static TextEditingController EdtUsername = new TextEditingController();
  static TextEditingController EdtPassword = new TextEditingController();
  bool _obscureText = true;


 late   LoginModel loginModel;



  // LoginModel loginModel;

  late StreamSubscription<ConnectivityResult> subscription;

  bool net=true;




  Future<void> initUniqueIdentifierState() async {
    String? identifier;
    try {
      identifier = (await UniqueIdentifier.serial);
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    if (!mounted) return;

    setState(() {
      _identifier = identifier!;
      print("IMIE: " + _identifier);
    });
  }



  Future<http.Response> postRequest1() async {

    print("postRequest1 is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 1,
      "UserID": "${EdtUsername.text.toUpperCase()}",
      "Password": "${EdtPassword.text.toUpperCase()}",
      "Branch": "",
      "DataBase":""
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'JasperLogin'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'JasperLogin');
      print(response.statusCode);
      print(response.body);
      print(response.statusCode);
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {


        //
        //
        // final login = jsonDecode(response.body)['result']=='[]';

        if (jsonDecode(response.body)["status"].toString() == "0") {
          Fluttertoast.showToast(
            // msg: jsonDecode(response.body)["result"],
              msg: "UserName or password is incorrect!!",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP);
        }else if (json.decode(response.body)["status"] == "0" &&
            jsonDecode(response.body)["result"].toString() == []) {
          Fluttertoast.showToast(
            // msg: jsonDecode(response.body)["result"],
              msg: "UserName or password is incorrect!!",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP);
        } else if (json.decode(response.body)["status"] == 1 &&
            jsonDecode(response.body)["result"].toString() == "[]") {
          loginModel = LoginModel.fromJson(jsonDecode(response.body));
          Fluttertoast.showToast(
            // msg: jsonDecode(response.body)["result"],
              msg: "UserName or password is incorrect!!",
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.TOP);
        }else{

          loginModel = LoginModel.fromJson(jsonDecode(response.body));


          Fluttertoast.showToast(
              msg: "Login Success",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);




          Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
          final SharedPreferences prefs = await _prefs;
          await prefs.setString("UserID", loginModel.result![0].empID.toString());
          await prefs.setString("UserName", loginModel.result![0].firstName.toString());
          await  prefs.setString(
              "BranchID", loginModel.result![0].branchCode.toString());
          await  prefs.setString(
              "BranchName", loginModel.result![0].branchName.toString());
          await prefs.setString("AdminUser",loginModel.result![0].adminUser.toString() );
          await prefs.setString("DepartmentCode", loginModel.result![0].deptCode.toString());
          await prefs.setString("DepartmentName", loginModel.result![0].department.toString());
          await prefs.setString("Location", loginModel.result![0].location.toString());
          await prefs.setString("EmpGroup", loginModel.result![0].empGroup.toString());
          await prefs.setString("VechileType", loginModel.result![0].vechileType.toString());
          await prefs.setString("branchCategory", loginModel.result![0].branchCategory.toString());
          await prefs.setString("vechileType", loginModel.result![0].vechileType.toString());
          await prefs.setBool("LoggedIn", true);

          print("Acdmin?User="+loginModel.result![0].adminUser.toString());


          if(loginModel.result![0].adminUser.toString()=='SA'){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SuperAdminDashBoard()),
            );

          }else   if(loginModel.result![0].adminUser.toString()=='S'){

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BranchAdminDashBoard()),
            );

          }else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
            );
          }


        }

      } else {
        showDialogbox(context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                backgroundColor: Colors.black,
                title: Text(
                  "No Response!..",
                  style: TextStyle(color: Colors.purple),
                ),
                content: Text(
                  "Slow Server Response or Internet connection",
                  style: TextStyle(color: Colors.white),
                )));
      });
      throw Exception('Internet is down');
    }
  }

  @override
  void initState() {

    EdtUsername.text="";
    EdtPassword.text="";
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("Connectivity Resukt"+result.toString());
      if(result.name=="none"){

        print("Connectivity Resukt1"+result.name.toString());
        net=false;
        setState((){});
        print('net${net}');
      }

      else{
        net=true;

        print("Connectivity Resukt2"+result.name.toString());
        setState((){});
        print('net${net}');
      }

    });

    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();

    //   urlTest();
    initUniqueIdentifierState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      body:!net?CheckInterNet(context)
          : loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                /*gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF00A982), Color(0xFF156C59)],
                  ),*/
                  borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset('assets/images/Jasperlogo.png'),
                  ),
                  Spacer(),
                  Visibility(
                    visible: true,
                    child: Container(
                      child: Center(
                          child: Text("DeviceID : ${_identifier}")),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'Login',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 40),
              child: Column(
                children: <Widget>[

                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 60,
                    padding: EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      controller: EdtUsername,

                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person,
                          color: String_Values.primarycolor,
                        ),
                        hintText: 'Username',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 60,
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.only(
                        top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(

                      controller: EdtPassword,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.vpn_key,
                          //  color: Colors(0xffff5d6e),
                          color: String_Values.primarycolor,
                        ),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2,),


                  SizedBox(height:2 ,),


                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, right: 32),
                      child: InkWell(
                        onTap:(){

                          print("Forgot password called");
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>forgotpassword()));
                        },
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(
                            color: String_Values.primarycolor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  //Spacer(),
                  InkWell(
                    onTap: () {

                      if (EdtUsername.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Enter Username");
                      } else if (EdtPassword.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Enter Password");
                      } else {
                        print('click');



                        postRequest1();

                        //postRequest1();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => DashBoard()),
                        // );

                      }
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF38B1E1),
                              Color(0xFF337F9B),
                            ],
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Login'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text("Version-1.0(JAS-Test)"),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future showDialogbox(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
