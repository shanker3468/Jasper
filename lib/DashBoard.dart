
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'ADMIN Models/WeekUpdateAdminModel.dart';
import 'AppConstants.dart';
import 'LoginPage.dart';
import 'ServiceStation/TicketCreationfinal.dart';
import 'ServiceStation/WeeklyUpdate.dart';
import 'ServiceStation/reports.dart';
import 'String_Values.dart';
import 'ServiceStation/TicketCreation.dart';
import 'package:http/http.dart' as http;

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _current = 0;

  var UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location,EmpGroup,VechileType;

  bool loading = false;

  bool Newticket =false;

  bool WeeklyUpdate1=false;

  bool Reports=false;


  WeekUpdateAdminModel li2 =WeekUpdateAdminModel(result: []);

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



  Future<http.Response> getWeeklyTicketCount() async {

    print("getWeeklyTicketCount is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "BrachName": BranchName.toString(),
      "EmpID": UserID.toString(),
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getWeeklyUpdateUserLock'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getWeeklyUpdateUserLock');
      print(response.body);
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {

        var isdata = json.decode(response.body)["status"] == 0;
        print(isdata);
        if (isdata) {

          print('No Records Found!!');
          // CustomerTicketsModel li2 =CustomerTicketsModel(result: []);

          print("li2.result.length1"+li2.result!.length.toString());


          setState(() {

            Newticket =false;

            WeeklyUpdate1=true;

            Reports=false;



          });


     //     Navigator.push(context,MaterialPageRoute(builder: (context)=>WeeklyUpdate()));

          li2.result!.clear();

        } else {

          print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
          print(body);
          print(response.body);

          //
          // ScaffoldMessenger.of(this.context)
          //     .showSnackBar(SnackBar(content: Text("Weekly Update already done!!")));

          li2 = WeekUpdateAdminModel.fromJson(jsonDecode(response.body));

          print("li2.result.length"+li2.result!.length.toString());

        //  Navigator.push(context,MaterialPageRoute(builder: (context)=>DashBoard()));







          setState(() {

            Newticket =true;

            WeeklyUpdate1=false;

            Reports=true;



          });

        }


      } else {
        showDialogbox(this.context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: this.context,
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

  Future<http.Response> getWeeklyTicketCount1() async {

    print("getWeeklyTicketCount1 is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "BrachName": BranchName.toString(),
      "EmpID": UserID.toString(),
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getWeeklyUpdateUserLock'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getWeeklyUpdateUserLock');
      print(response.body);
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {

        var isdata = json.decode(response.body)["status"] == 0;
        print(isdata);
        if (isdata) {

          print('No Records Found!!');
          // CustomerTicketsModel li2 =CustomerTicketsModel(result: []);

          print("li2.result.length1"+li2.result!.length.toString());


              Navigator.push(context,MaterialPageRoute(builder: (context)=>WeeklyUpdate()));

          li2.result!.clear();

        } else {

          print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
          print(body);
          print(response.body);


          ScaffoldMessenger.of(this.context)
              .showSnackBar(SnackBar(content: Text("Weekly Update already done!!")));

          li2 = WeekUpdateAdminModel.fromJson(jsonDecode(response.body));

          print("li2.result.length"+li2.result!.length.toString());







          setState(() {




          });

        }


      } else {
        showDialogbox(this.context, "Failed to Login API");
      }
      return response;
    } on SocketException {
      setState(() {
        loading = false;
        showDialog(
            context: this.context,
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



  static logoutfunction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("LoggedIn", false);

    // AppConstants.LIVE_URL = "http://49.204.232.40:4200/";
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
          (route) => false,
    );
  }


  Future<http.Response> CheckTicketStatus() async {

    print("CheckTicketStatus is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 22,
      "UserID": "",
      "Password": "",
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
      print(response.body);
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {

        if (jsonDecode(response.body)["status"].toString() == "0") {

        }else if (json.decode(response.body)["status"] == "0" &&
            jsonDecode(response.body)["result"].toString() == []) {

        } else if (json.decode(response.body)["status"] == 1 &&
            jsonDecode(response.body)["result"].toString() == "[]") {

        }else{

          String Day1 =
          jsonDecode(response.body)["result"][0]["Day1"].toString();
          print("Day1: " + Day1);


          String Day =
          jsonDecode(response.body)["result"][0]["Day"].toString();
          print("Day: " + Day);

          setState(() {

            if(Day1==Day){




              Newticket =false;

              WeeklyUpdate1=false;

              Reports=false;

              setState(() {

              });

              getWeeklyTicketCount();


            }else{

              setState(() {

              });

               Newticket =true;

               WeeklyUpdate1=false;

               Reports=true;

            }

          });

          setState(() {
            loading = false;
          });


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

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserID = prefs.getString('UserID').toString();
      UserName = prefs.getString('UserName').toString();
      branchID = prefs.getString('BranchID').toString();
      BranchName = prefs.getString('BranchName').toString();
      DepartmentCode = prefs.getString('DepartmentCode').toString();
      DepartmentName = prefs.getString('DepartmentName').toString();
      Location = prefs.getString('Location').toString();
      EmpGroup=prefs.getString('EmpGroup').toString();
      VechileType=prefs.getString('VechileType').toString();


      // FromBranchController.text = sessionfromBranchName;

      print(UserName.toString());


      CheckTicketStatus();
      //getWeeklyTicketCount();

    });
  }


  @override
  void initState() {
    getStringValuesSF();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final List<String> imgList = [
      'assets/images/Jasperlogo.png',
      'assets/images/Jasperlogo.png'
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: height/4                                ,
              width: width/2,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset("assets/images/Jasperlogo.png"),
                  ),
                  Container(
                    color: Colors.white,
                    // padding: EdgeInsets.only(right: 10),
                    height: 20,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Welcome',
                            style: TextStyle(fontStyle:FontStyle.italic,fontSize: 20)),
                        Text(' ${
                            UserName.toString()}',
                          style: TextStyle(fontWeight: FontWeight.w900,fontStyle:FontStyle.italic,color: Colors.indigo,fontSize: 20),

                        ),
                      ],
                    ),
                  ),
                  Text(' ${
                      EmpGroup.toString()+'-'+VechileType.toString()}',
                    style: TextStyle(fontWeight: FontWeight.w900,fontStyle:FontStyle.italic,color: Colors.indigo,fontSize: 15),

                  ),
                  Text(' ${
                      BranchName.toString()}',
                    style: TextStyle(fontWeight: FontWeight.w900,fontStyle:FontStyle.italic,color: Colors.indigo,fontSize: 15),

                  ),
                ],
              ),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.only(bottomRight: Radius.circular(width))
              ),

            ),

            Expanded(
              child: Container(

                decoration:
                BoxDecoration(
                    color: String_Values.primarycolor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(width/6),topRight: Radius.circular(width/6))
                ),
                child: Column(
                  children: [

                    SizedBox(height: height/15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Dashboard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 18),),

                      ],
                    ),


                    SizedBox(height: height/20,),
                    /*CarouselSlider(
                        items: imgList
                            .map((item) => Container(
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: new NetworkImage(
                                item,
                              ),
                              fit: BoxFit.fill,
                            ),
                            border: Border.all(
                                color: Colors.white, width: 2),
                            borderRadius:
                            BorderRadius.all(Radius.circular(width / 20)),
                          ),

                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                        ))
                            .toList(),
                        options: CarouselOptions(
                            });
                          },
                          initialPage: 0,
                          height: 180,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: true,

                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        )),*/

                    CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        height: 100,
                        initialPage: 0,
                        autoPlay: true,
                      ),
                      items: imgList
                          .map((e) => ClipRRect(
                        borderRadius:
                        BorderRadius.circular(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Image.asset(
                              e,
                              width: width,
                              height: 190,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                    SizedBox(height: height/40,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imgList.map((url) {
                        int index = imgList.indexOf(url);
                        return Container(
                          width: _current == index ? 10 : 8.0,
                          height: _current == index ? 10 : 8.0,
                          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ?Colors.white
                            // ? Color.fromRGBO(51, 155, 111, 1)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: height/40,),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: height/3,
                      child: GridView.count(
// physics: PageScrollPhysics,
                        crossAxisSpacing: width / 40,
                        mainAxisSpacing: height / 50,
                        crossAxisCount: 2,
                        physics: const PageScrollPhysics(),
                        children: <Widget>[


                          InkWell(
                            onTap: () {
                              //
                              // Navigator.pushReplacement(context,
                              //     MaterialPageRoute(builder: (context) => DashBoard()));

                              // setState(() {
                              //   Newticket =false;
                              //
                              //   WeeklyUpdate1=false;
                              //
                              //   Reports=false;
                              // });




                             // CheckTicketStatus().then((value) =>
                                  showDialog<void>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white.withOpacity(0),
                                          title: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(

                                                  child: Image.asset(
                                                    "assets/images/Jasperlogo.png",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height / 30,
                                                ),
                                                Text(
                                                  "Please Choose",
                                                  style: TextStyle(
                                                      color: Colors.amber, fontSize: 16),
                                                ),
                                                SizedBox(
                                                  height: height / 30,
                                                ),

                                                SizedBox(
                                                  height: height / 50,
                                                ),

                                                Visibility(
                                                  visible:Newticket ,
                                                  child: GestureDetector(

                                                    onTap: (){


                                                      Navigator.pop(context);
                                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>TicketCreation()));
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      // margin: EdgeInsets.only(left:16,right: 16),
                                                      alignment: Alignment.center,

                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50))),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                        children: [


                                                          Text(
                                                            "New ticket",
                                                            style: TextStyle(
                                                                color: String_Values.primarycolor),
                                                          ),


                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(height: height/50,),

                                                Visibility(
                                                  visible: WeeklyUpdate1,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      getWeeklyTicketCount1();
                                                      //
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      // margin: EdgeInsets.only(left:16,right: 16),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50))),
                                                      child: Text(
                                                        "Weekly Update",
                                                        style: TextStyle(
                                                            color: String_Values.primarycolor),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: height / 50,
                                                ),




                                                Visibility(
                                                  visible:Reports ,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ReportsDashBoard()));
                                                    },
                                                    child: Container(
                                                      height: 50,
                                                      // margin: EdgeInsets.only(left:16,right: 16),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(50))),
                                                      child: Text(
                                                        "Reports",
                                                        style: TextStyle(
                                                            color: String_Values.primarycolor),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: height / 50,
                                                ),



                                              ],
                                            ),
                                          ),
                                        );
                                      });
                            //);



                              //

                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width),),
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  Icon(Icons.dashboard_customize,color: String_Values.primarycolor,size: height/12,),
                                  Text(
                                    "Dash Board",
                                    style: TextStyle( color: String_Values.primarycolor,fontWeight: FontWeight.w800),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {

                              logoutfunction(context);
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width),),
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  Icon(Icons.logout,color: String_Values.primarycolor,size: height/12,),
                                  Text(
                                    "Log Out",
                                    style: TextStyle( color: String_Values.primarycolor,fontWeight: FontWeight.w800),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(onPressed: () {

        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (route) => false);
        logoutfunction(context);
      },
        backgroundColor: Colors.white,

        child: Icon(Icons.logout,color: String_Values.primarycolor,),),
      // appBar: AppBar(
      //
      //     title: Center(
      //         child: Text(
      //   "DashBoard",
      //   style: TextStyle(fontWeight: FontWeight.w700),
      // )),
      // actions: [IconButton(icon: Icon(Icons.logout,color: Colors.white,), onPressed:(){ Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context)=>LoginPage()), (route) => false);})],),

    );
  }
}
