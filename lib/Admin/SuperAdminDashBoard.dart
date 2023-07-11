
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jasper/Admin/WipAssignTickets.dart';
import 'package:jasper/Admin/master_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../ADMIN Models/AssignEmpListBasedOnDepartmentModel.dart';
import '../ADMIN Models/CustomerTicketsModel.dart';
import '../AppConstants.dart';
import '../LoginPage.dart';
import '../ServiceStation/reports.dart';
import '../String_Values.dart';
import '../ServiceStation/TicketCreation.dart';
import 'AdminReport_dashboard.dart';
import 'AllAssignTickets.dart';
import 'ApprovedAssignTickets.dart';
import 'AssignTickets.dart';


class SuperAdminDashBoard extends StatefulWidget {
  const SuperAdminDashBoard({Key? key}) : super(key: key);

  @override
  State<SuperAdminDashBoard> createState() => _SuperAdminDashBoardState();
}

class _SuperAdminDashBoardState extends State<SuperAdminDashBoard> {
  int _current = 0;

  int sapbone = 0;

  var UserName = "";
  var UserID = "";
  var branchID = "";
  var BranchName = "";
  var DepartmentCode = "";
  var DepartmentName = "";
  var Location = "";

  bool loading = false;

  CustomerTicketsModel li2 =CustomerTicketsModel(result: []);


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

      getOpenTickets();

      print(UserName.toString());

    });
  }


  Future<http.Response> getOpenTickets() async {

    print("getOpenTickets is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "TicketCategory": "".toString(),
      "BrachName": "".toString(),
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getOpenTickets'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getOpenTickets');
      print(response.body);
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {

        var isdata = json.decode(response.body)["status"] == 0;
        print(isdata);
        if (isdata) {
          ScaffoldMessenger.of(this.context)
              .showSnackBar(SnackBar(content: Text("No Records Found!!")));
          print('No Records Found!!');
          // CustomerTicketsModel li2 =CustomerTicketsModel(result: []);



        } else {

          print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
          print(body);
          print(response.body);

          li2 = CustomerTicketsModel.fromJson(jsonDecode(response.body));


          setState(() {

            sapbone=int.parse(li2.result!.length.toString());

          });

        }

        /* if (jsonDecode(response.body)["status"].toString() == "0") {

        }else if (json.decode(response.body)["status"] == "0" &&
            jsonDecode(response.body)["result"].toString()=="No Data") {

        } else if (json.decode(response.body)["status"] == 1 &&
            jsonDecode(response.body)["result"].toString() == "[]") {

        }else{

          li5 = BranchMasterModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li5.result!.length;i++);
          print(li5.result!.length.toString());

          setState(() {
            stringlist5.clear();
            stringlist5.add("Select Branch");
            for (int i = 0; i < li5.result!.length; i++)
              stringlist5.add(li5.result![i].branchName.toString());
          });

          setState(() {
            loading = false;
          });


        }*/

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
                        Text("SUPER ADMIN",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 18),),
                        Text("Dashboard",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 18),),

                      ],
                    ),


                    SizedBox(height: height/30,),
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

                        ))
                            .toList(),
                        options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
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
                        height: 120,
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
                        crossAxisSpacing: width / 40,
                        mainAxisSpacing: height / 50,
                        crossAxisCount: 2,
                        physics: const PageScrollPhysics(),
                        children: <Widget>[

                          InkWell(
                            onTap: () {

                              getOpenTickets().then((value) =>   showDialog<void>(
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



                                            GestureDetector(

                                              onTap: (){


                                                Navigator.pop(context);


                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => WIP_Assign_Tickets( status:"1",Tickettype:'',BranchName:''

                                                    ),
                                                  ),
                                                );


                                                //Navigator.push(context,MaterialPageRoute(builder: (context)=>TicketCreation()));
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
                                                      "Tickets",
                                                      style: TextStyle(
                                                          color: String_Values.primarycolor),
                                                    ),
                                                    Badge(
                                                      padding: EdgeInsets.all(8),
                                                      shape: BadgeShape.circle,
                                                      showBadge:
                                                      sapbone.toString() == "0"
                                                          ? false
                                                          : true,
                                                      badgeColor: Colors.deepOrange,
                                                      badgeContent: Text(
                                                        sapbone.toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      ),

                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              height: height / 50,
                                            ),

                                            GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>MasterScreens()));
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
                                                  "Master Screens",
                                                  style: TextStyle(
                                                      color: String_Values.primarycolor),
                                                ),
                                              ),
                                            ),

                                            /*SizedBox(height: height/50,),


                                              GestureDetector(

                                                child: Container(
                                                  height: 50,
                                                  // margin: EdgeInsets.only(left:16,right: 16),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(50))),
                                                  child: Text(
                                                    "Ticket Status",
                                                    style: TextStyle(
                                                        color: String_Values.primarycolor),
                                                  ),
                                                ),
                                              ),*/

                                            SizedBox(
                                              height: height / 50,
                                            ),

                                            GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=>AllAssign_Tickets(status:"1",Tickettype:'',BranchName:'')));
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
                                                  "Weekly Updation Report",
                                                  style: TextStyle(
                                                      color: String_Values.primarycolor),
                                                ),
                                              ),
                                            ),

                                            SizedBox(
                                              height: height / 50,
                                            ),

                                            // GestureDetector(
                                            //   onTap: (){
                                            //     Navigator.pop(context);
                                            //     //    Navigator.push(context,MaterialPageRoute(builder: (context)=>ReportsDashBoard()));
                                            //   },
                                            //   child: Container(
                                            //     height: 50,
                                            //     // margin: EdgeInsets.only(left:16,right: 16),
                                            //     alignment: Alignment.center,
                                            //     decoration: BoxDecoration(
                                            //         color: Colors.white,
                                            //         borderRadius: BorderRadius.all(
                                            //             Radius.circular(50))),
                                            //     child: Text(
                                            //       "Reports",
                                            //       style: TextStyle(
                                            //           color: String_Values.primarycolor),
                                            //     ),
                                            //   ),
                                            // ),
                                            //
                                            // SizedBox(
                                            //   height: height / 50,
                                            // ),



                                          ],
                                        ),
                                      ),
                                    );
                                  }));




                              //
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) => HallBooking()));
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

                              //logoutfunction(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => AdminReportDashboard()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(width),),
                              elevation: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  Icon(Icons.bar_chart_outlined,color: String_Values.primarycolor,size: height/12,),
                                  Text(
                                    "Reports",
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
