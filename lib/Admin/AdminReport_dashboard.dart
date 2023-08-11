// ignore: file_names
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jasper/ADMIN%20Models/ChartCountModel.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../IpAddress.dart';
import '../ADMIN Models/ChartCountModel.dart';
import '../ADMIN Models/ChartCountModel.dart';

import '../AppConstants.dart';
import '../LoginPage.dart';
import '../SuperAdminReports/SuperAdminAllTicketsReports.dart';
import '../SuperAdminReports/WipAssignTickets.dart';

class AdminReportDashboard extends StatefulWidget {
  AdminReportDashboard({Key? key}) : super(key: key);

  @override
  AdminReportDashboardState createState() => AdminReportDashboardState();
}

class AdminReportDashboardState extends State<AdminReportDashboard> {


  TextEditingController remarksController = new TextEditingController();
  TextEditingController remarksController1= new TextEditingController();

  var remarkspassword="60454";
  var remarkspassword1="12345";

  bool passVisible = false;
  bool passwordshow = false;
  bool _validate = false;
  bool _validatep = false;

  ChartCountModel li4=ChartCountModel(result: []);

  double chartcount= 0;

  var dataMap;







  var _isHidden = true;
  late String errortextpass;
  bool validateP = false;

  var UserName = "";
  var UserID = "";
  var branchID = "";
  var BranchName = "";
  var DepartmentCode = "";
  var DepartmentName = "";
  var Location = "";

  bool loading = false;

  bool ApplyLunch= false;

  int OpenTickets = 0,
      Approved = 0,
      WIP = 0,
      ThirdParty = 0,
      Quotation = 0,
      ReSolved = 0,
       ReOpen = 0,
      Reject=0,
      Closed=0,
        ALL=0;



  final legendLabels = <String, String>{
    "Tickets": "Tickets legend",
    "Approved": "Approved legend",
    "WIP": "WIP legend",
    "ThirdParty": "Third Party legend",
    "Quotation": "Quotation legend",
    "ReSolved": "ReSolved legend",
    "ReOpen": "ReOpen legend",
    "Reject": "Reject legend",
    "Closed": "Closed legend"
  };
  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
    const Color(0xff60da19),
    const Color(0xffda1929),
    const Color(0xff947a7a),
    const Color(0xff227527)
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(223, 250, 92, 1),
      const Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      const Color.fromRGBO(108, 92, 231, 1.0),
      const Color.fromRGBO(216, 218, 234, 1.0),
    ],
    [
      const Color.fromRGBO(96, 218, 25, 1.0),
      const Color.fromRGBO(150, 211, 121, 1.0),
    ],
    [
    const Color.fromRGBO(218, 25, 41, 1.0),
    const Color.fromRGBO(218, 22, 38, 0.8),
  ],
    [
      const Color.fromRGBO(124, 124, 124, 1.0),
      const Color.fromRGBO(216, 218, 234, 1.0),
    ],
    [
      const Color.fromRGBO(34, 112, 38, 1.0),
      const Color.fromRGBO(150, 211, 121, 0.7294117647058823),
    ]
  ];


  int key = 0;

  List<_ChartData> data=[];
  late TooltipBehavior _tooltip;




  var myController = TextEditingController();





  @override
  void initState() {
    print("admin dash");
    // TODO: implement initState

    dataMap = <String, double>{
      "Open Tickets": 0,
      "Approved": 0,
      "WIP": 0,
      "Third Party": 0,
      "Quotation": 0,
      "ReSolved": 0,
      "Re Open": 0,
      "Reject": 0,
      "Closed":0
    };

    _tooltip = TooltipBehavior(enable: false);

    remarksController.text="";
    IpAddressState.check().then(
          (value) {
        if (value) {
          getStringValuesSF();
        } else {
          Fluttertoast.showToast(msg: "No Internet connection");
        }
      },
    );





    // final dataMap = <String, double>{
    //   "Open Tickets": 0,
    //   "Approved": 0,
    //   "WIP": 0,
    //   "Third Party": 0,
    //   "Quotation": 0,
    //   "ReSolved": 0
    // };


    super.initState();
  }

  final LinearGradient _linearGradient = LinearGradient(
    colors: <Color>[
      const Color(0xfffdcb6e),
      const Color(0xff0984e3),
      const Color(0xfffd79a8),
      const Color(0xffe17055),
      const Color(0xff6c5ce7),
      const Color(0xff60da19),
      const Color(0xffda1929),
      const Color(0xff947a7a),
      const Color(0xff227026)

    ],
    stops: <double>[0.1, 0.3, 0.5, 0.7, 0.9],
    // Setting alignment for the series gradient
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
          gradient:
          LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor:Colors.indigo.shade800 ,


            // centerTitle: true,
            // backgroundColor: Colors.blue,
            // elevation: 0.0,
            // flexibleSpace: Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Colors.blue.shade500, Colors.blue.shade300],
            //       stops: [0.1, 1.0],
            //     ),
            //   ),
            // ),
            title: Text(
              'ADMIN REPORTS',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            // leading: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Icon(Icons.menu),
            // ),
            // actions: [
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Icon(Icons.notifications_none),
            //   ),
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: GestureDetector(
            //       onTap: () {
            //         IpAddressState.check().then(
            //           (value) {
            //             if (value) {
            //               ResetStringValuesSF();
            //             } else {
            //               Fluttertoast.showToast(msg: "No Internet connection");
            //             }
            //           },
            //         );
            //       },
            //       child: Icon(
            //         Icons.logout,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ],
          ),
          body: Stack(
            children: [
              Container(
                width: width / 1,
                height: height / 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade800, Colors.indigo.shade300],
                    stops: [0.1, 1.0],
                  ),
                ),
                // decoration: BoxDecoration(color: Colors.blue
                //     // image: DecorationImage(fit: BoxFit.cover),
                //     ),
                child: Center(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 20.0, left: 10),
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
                                      "Welcome : ${UserName}",
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
                                      "Location : ${Location}",
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
                      color: Colors.black12,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    "Menu",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                              /*RefreshIndicator(
                                onRefresh: () {
                                  print("refreshed");
                                },
                                child: Icon(Icons.refresh),
                              ),*/
                            ],
                          ),
                          Container(
                            height: height/5,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: PieChart(
                                dataMap: dataMap!,
                                chartType: ChartType.ring,
                                baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                                colorList: colorList,

                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValuesInPercentage: true,
                                  showChartValues: true,

                                  //  showChartValuesOutside: true

                                ),
                                totalValue: chartcount
                            ),
                          ),

                          Container(
                            height: height/5,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 20),
                                tooltipBehavior: _tooltip!,
                                series: <ChartSeries<_ChartData, String>>[
                                  BarSeries<_ChartData, String>(
                                      dataSource: data,
                                      xValueMapper: (_ChartData data, _) => data.x,
                                      yValueMapper: (_ChartData data, _) => data.y,
                                      name: 'Count',
                                      gradient: LinearGradient(
                                        colors: [Colors.red,Colors.redAccent],
                                      ),
                                      color: Color.fromRGBO(8, 142, 255, 1))
                                ]),
                          ),

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
                                  crossAxisCount: 4,
                                  children: <Widget>[

                                    GestureDetector(
                                      onTap: () {
                                        myController = TextEditingController()
                                          ..text = "Open";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "O",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                showBadge:
                                                OpenTickets.toString() == "0"
                                                    ? false
                                                    : true,
                                                badgeColor: Colors.deepOrange,
                                                badgeContent: Text(
                                                  OpenTickets.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/OpenTicket.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Open",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "Work IN Progress";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "P",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                showBadge:
                                                WIP.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeColor: Colors.deepOrange,
                                                badgeContent: Text(
                                                  WIP.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/WorkInProgress.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "WIP",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "Third Party";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "T",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                ThirdParty.toString() == "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  ThirdParty.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/ThirdParty.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(3),
                                                width: double.infinity,
                                                child: Center(
                                                  child: Text(
                                                    "Third Party",
                                                    textAlign:
                                                    TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                        Color(0xFF002D58),
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        myController = TextEditingController()
                                          ..text = "Quotation";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "Q",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                Quotation.toString() == "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  Quotation.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/Quotation.jpg",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Quotation",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "Approved";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "A",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                showBadge:
                                                Approved.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeColor: Colors.deepOrange,
                                                badgeContent: Text(
                                                  Approved.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/app.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Approved",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "ReSolved";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "S",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                ReSolved.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  ReSolved.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/SollutionProvided.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Resolved",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "Re-opened";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "RO",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                ReOpen.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  ReOpen.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/reopenn.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Re-opened",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "Rejected";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "R",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                Reject.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  Reject.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/rejectpng.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Rejected",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "Closed";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "C",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                Closed.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  Closed.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/sign.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "Closed",
                                                      textAlign:
                                                      TextAlign.center,
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
                                        myController = TextEditingController()
                                          ..text = "ALL";
                                        print(myController);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SuperAdminAllTicketReports(
                                                      getScreenName:
                                                      myController.text,
                                                      getTicketType:
                                                      "ALL",
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                badgeColor: Colors.deepOrange,
                                                showBadge:
                                                ALL.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeContent: Text(
                                                  ALL.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/alltic.png",
                                                    fit: BoxFit.fill,
                                                    height: 40,
                                                    width: 40),
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.all(3),
                                                  width: double.infinity,
                                                  child: Center(
                                                    child: Text(
                                                      "All Tickets",
                                                      textAlign:
                                                      TextAlign.center,
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
    );
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      );
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

      prodCustCountData();

      print(UserName.toString());

    });
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



  /* Future prodCustCountData() async {


    print("prodCustCountData was called");
    var body = [
      {
        "FormID": 24,
        "UserID": "",
        "Password": "",
        "Branch": "",
        "DataBase":""
      }
    ];

    print(body);
    var header = {"Content-Type": "application/json"};
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse(AppConstants.LIVE_URL +'/JasperLogin'),
        body: json.encode(body),
        headers: header);

    print(jsonEncode(body));
    print(AppConstants.LIVE_URL +'/JasperLogin');
    print(response.body);
    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      var isdata = json.decode(response.body)["status"] == 0;
      print(isdata);
      if (isdata) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No Records Found!!")));
        print('No Records Found!!');
        //prodCustCountList.result.clear();
      } else {
        final Map<String, dynamic> responseList = json.decode(response.body);
        responseList['result'].forEach((forloopvalue) {
          setState(() {

            print(json.decode(response.body)["result"][0]["Count"]);
            print(json.decode(response.body)["result"][1]["Count"]);


            OpenTickets = json.decode(response.body)["result"][0]["Count"];
            Approved = json.decode(response.body)["result"][1]["Count"];
            WIP = json.decode(response.body)["result"][2]["Count"];
            ThirdParty = json.decode(response.body)["result"][3]["Count"];
            Quotation = json.decode(response.body)["result"][4]["Count"];
            ReSolved = json.decode(response.body)["result"][5]["Count"];

          });
        });
      }
    } else {
      print('Response error!!');
    }
  }*/


  Future<http.Response> prodCustCountData() async {

    print("postRequest1 is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 24,
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
      print(response.statusCode);
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {


        //
        //
        // final login = jsonDecode(response.body)['result']=='[]';

        if (jsonDecode(response.body)["status"].toString() == "0") {

        }else if (json.decode(response.body)["status"] == "0" &&
            jsonDecode(response.body)["result"].toString() == []) {

        } else if (json.decode(response.body)["status"] == 1 &&
            jsonDecode(response.body)["result"].toString() == "[]") {

        }else{

          li4 = ChartCountModel.fromJson(jsonDecode(response.body));




          print(json.decode(response.body)["result"][0]["Count"]);
          print(json.decode(response.body)["result"][1]["Count"]);

          for (int i = 0; i < li4.result!.length; i++) {
            chartcount = chartcount +double.parse(li4.result![i].count.toString());




          }

          print("chartcount="+chartcount.toString());


          OpenTickets = int.parse(li4.result![0].count.toString());
          Approved = int.parse(li4.result![1].count.toString());
          WIP = int.parse(li4.result![2].count.toString());
          ThirdParty = int.parse(li4.result![3].count.toString());
          Quotation = int.parse(li4.result![4].count.toString());
          ReSolved = int.parse(li4.result![5].count.toString());
          ReOpen=int.parse(li4.result![6].count.toString());
          Reject=int.parse(li4.result![7].count.toString());
          Closed=int.parse(li4.result![8].count.toString());




          data = [
            _ChartData('Open Tickets', double.parse(OpenTickets.toString())),
            _ChartData('Approved', double.parse(Approved.toString())),
            _ChartData('WIP', double.parse(WIP.toString())),
            _ChartData('Third Party', double.parse(ThirdParty.toString())),
            _ChartData('Quotation', double.parse(Quotation.toString())),
            _ChartData('ReSolved', double.parse(ReSolved.toString())),
            _ChartData('ReOpen', double.parse(ReOpen.toString())),
            _ChartData('Reject', double.parse(Reject.toString())),
            _ChartData('Closed', double.parse(Closed.toString())),
          ];
          _tooltip = TooltipBehavior(enable: true);



          dataMap = <String, double>{
            "Open Tickets": double.parse(OpenTickets.toString()),
            "Approved": double.parse(Approved.toString()),
            "WIP": double.parse(WIP.toString()),
            "Third Party": double.parse(ThirdParty.toString()),
            "Quotation": double.parse(Quotation.toString()),
            "ReSolved": double.parse(ReSolved.toString()),
            "ReOpen": double.parse(ReOpen.toString()),
            "Reject": double.parse(Reject.toString()),
            "Closed": double.parse(Closed.toString())
          };




        }

        setState(() {
          loading = false;
        });

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

  void ResetStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool("LoggedIn", false);
      logoutDialog();
    });
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}


