
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jasper/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../IpAddress.dart';
import 'AdminDashBoard.dart';
import 'Assignemployee_details_report.dart';
import 'employee_details_report.dart';



class MasterScreens extends StatefulWidget {
  MasterScreens({Key? key}) : super(key: key);

  @override
  _MasterScreensState createState() => _MasterScreensState();
}

class _MasterScreensState extends State<MasterScreens> {

  var UserName = "";
  var UserID = "";
  var branchID = "";
  var BranchName = "";
  var DepartmentCode = "";
  var DepartmentName = "";
  var Location = "";

  var myController = TextEditingController();
  @override
  void initState() {
    print("admin dash");

    getStringValuesSF();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: WillPopScope(
            onWillPop: _willPopCallback,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.blue,
                elevation: 0.0,
                title: Text(
                  'ADMIN PORTAL',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.menu),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.notifications_none),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        IpAddressState.check().then(
                          (value) {
                            if (value) {
                              ResetStringValuesSF();
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => LoginPage()));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "No Internet connection");
                            }
                          },
                        );
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    width: width / 1,
                    height: height / 1,
                    decoration: BoxDecoration(color: Colors.blue
                        // image: DecorationImage(fit: BoxFit.cover),
                        ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20.0, left: 10),
                                  child: Container(
                                    child: Image.asset(
                                      'assets/images/avataricon.png',
                                      height: 80,
                                      width: 80,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          // 'Welcome Mr.$sessionName',
                                          "Welcome : ${UserName.toString()}",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          // 'Branch :$sessionbranchname',
                                          "Location : ${Location.toString()}",
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 100),
                        height: height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Master Datas",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xD0073E6C),
                                      fontSize: 20),
                                ),
                              )),
                              Expanded(
                                child: Center(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    height: height - height / 20,
                                    // width: width,
                                    child: GridView.count(
                                      childAspectRatio: 1,
                                      // crossAxisSpacing: width / 20,
                                      // mainAxisSpacing: height / 20,
                                      crossAxisCount: 2,
                                      children: <Widget>[

                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AssignEmployeeDetailsReport()));
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/newcust.png",
                                                        fit: BoxFit.fill,
                                                        height: 60,
                                                        width: 70),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Ticket Assign Employee Creation",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EmployeeDetailsReport()));

                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/newemp.jpg",
                                                        fit: BoxFit.fill,
                                                        height: 60,
                                                        width: 70),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Employee Creation",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                         /* GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AssignCustomerToEmployee()));
                                              //  logoutfunction(context);
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/empcus.png",
                                                        fit: BoxFit.fill,
                                                        height: 60,
                                                        width: 70),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "Assign Customer",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          IMEINoUpdate()));
                                              //  logoutfunction(context);
                                            },
                                            child: Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/imei.png",
                                                        fit: BoxFit.fill,
                                                        height: 70,
                                                        width: 70),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                        padding:
                                                            EdgeInsets.all(3),
                                                        width: double.infinity,
                                                        child: Center(
                                                          child: Text(
                                                            "IMEI Update",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF002D58),
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),*/



                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserID = prefs.getString('UserID')!;
      UserName = prefs.getString('UserName')!;
      branchID = prefs.getString('BranchID')!;
      BranchName = prefs.getString('BranchName')!;
      DepartmentCode = prefs.getString('DepartmentCode')!;
      DepartmentName = prefs.getString('DepartmentName')!;
      Location = prefs.getString('Location')!;
      // FromBranchController.text = sessionfromBranchName;

      print(UserName.toString());

    });
  }

  void logoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: AlertDialog(
              content: StatefulBuilder(
                builder: (BuildContext context,
                    void Function(void Function()) setState) {
                  return Container(
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // To make the card compact
                          children: <Widget>[
                            Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  child:
                                      Image.asset("assets/images/logalert.png"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: Text(" Are you sure Logout!!"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextButton.icon(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => LoginPage()),
                                        (route) => false,
                                      );

                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => LoginPage(),
                                      //   ),
                                      // );
                                    },
                                    icon: Icon(
                                      Icons.assignment_turned_in_outlined,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ]),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  void ResetStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("LoggedIn", false);
      logoutDialog();
    });
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AdminDashBoard()),
        (Route<dynamic> route) => false);
    return Future.value(true);
  }
}
