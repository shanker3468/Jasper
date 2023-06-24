// ignore: file_names
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../IpAddress.dart';
import '../AppConstants.dart';
import '../LoginPage.dart';

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

  int sapbone = 7,
      sfourhana = 5,
      einvoice = 3,
      sapbyd = 6,
      mobileapp = 9,
      sapecc = 0,
      webportal = 0,
      datacenter = 0,
      sappos = 0,
      cloud = 0,
      saperp = 0;


  final dataMap = <String, double>{
    "Open Tickets": 15,
    "Approved": 3,
    "WIP": 2,
    "Third Party": 2,
    "Quotation": 6,
    "ReSolved": 8
  };

  final legendLabels = <String, String>{
    "Tickets": "Tickets legend",
    "Approved": "Approved legend",
    "WIP": "WIP legend",
    "ThirdParty": "Third Party legend",
    "Quotation": "Quotation legend",
    "ReSolved": "ReSolved legend"
  };
  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
    const Color(0xff60da19)
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
  ]
  ];


  int key = 0;

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;




  var myController = TextEditingController();





  @override
  void initState() {
    print("admin dash");
    // TODO: implement initState

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




    data = [
      _ChartData('Open Tickets', 15),
      _ChartData('Approved', 3),
      _ChartData('WIP', 2),
      _ChartData('Third Party', 2),
      _ChartData('Quotation', 6),
      _ChartData('ReSolved', 8),
    ];
    _tooltip = TooltipBehavior(enable: true);


    super.initState();
  }

  final LinearGradient _linearGradient = LinearGradient(
    colors: <Color>[
      const Color(0xfffdcb6e),
      const Color(0xff0984e3),
      const Color(0xfffd79a8),
      const Color(0xffe17055),
      const Color(0xff6c5ce7),
      const Color(0xff60da19)

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
            centerTitle: true,
            backgroundColor: Colors.blue,
            elevation: 0.0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade500, Colors.blue.shade300],
                  stops: [0.1, 1.0],
                ),
              ),
            ),
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
                        } else {
                          Fluttertoast.showToast(msg: "No Internet connection");
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade500, Colors.blue.shade300],
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
                      color: Colors.white,
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
                                        color: Color(0xD0073E6C),
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
                          dataMap: dataMap,
                          chartType: ChartType.ring,
                          baseChartColor: Colors.grey[50]!.withOpacity(0.15),
                          colorList: colorList,

                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                            showChartValues: true,

                          //  showChartValuesOutside: true

                          ),
                          totalValue: 36,
                        ),
                      ),

                        Container(
                          height: height/5,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                              tooltipBehavior: _tooltip,
                              series: <ChartSeries<_ChartData, String>>[
                                BarSeries<_ChartData, String>(
                                    dataSource: data,
                                    xValueMapper: (_ChartData data, _) => data.x,
                                    yValueMapper: (_ChartData data, _) => data.y,
                                    name: 'Gold',
                                    gradient: LinearGradient(
                                      colors: [Colors.red,Colors.white],
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
                                  crossAxisCount: 3,
                                  children: <Widget>[

                                      GestureDetector(
                                        onTap: () {
                                          myController = TextEditingController()
                                            ..text = "Open Tickets";
                                          print(myController);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OpenTicketCustomerList(
                                          //               getScreenName:
                                          //                   myController.text,
                                          //             )));
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
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Image.asset(
                                                        "assets/images/OpenTicket.png",
                                                        fit: BoxFit.fill,
                                                        height: 60,
                                                        width: 60),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                ),
                                                Container(
                                                    padding: EdgeInsets.all(3),
                                                    width: double.infinity,
                                                    child: Center(
                                                      child: Text(
                                                        "Open Tickets",
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
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             OpenTicketCustomerList(
                                        //               getScreenName:
                                        //                   myController.text,
                                        //             ))).then(
                                        //     (value) => setState(() {}));
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
                                              Badge(
                                                padding: EdgeInsets.all(8),
                                                shape: BadgeShape.circle,
                                                showBadge:
                                                sfourhana.toString() ==
                                                    "0"
                                                    ? false
                                                    : true,
                                                badgeColor: Colors.deepOrange,
                                                badgeContent: Text(
                                                  sfourhana.toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                child: Image.asset(
                                                    "assets/images/app.png",
                                                    fit: BoxFit.fill,
                                                    height: 70,
                                                    width: 70),
                                              ),
                                              SizedBox(
                                                height: 10,
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
                                            ..text = "Work IN Progress";
                                          print(myController);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OpenTicketCustomerList(
                                          //               getScreenName:
                                          //                   myController.text,
                                          //             ))).then(
                                          //     (value) => setState(() {}));
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
                                                Badge(
                                                  padding: EdgeInsets.all(8),
                                                  shape: BadgeShape.circle,
                                                  showBadge:
                                                      sfourhana.toString() ==
                                                              "0"
                                                          ? false
                                                          : true,
                                                  badgeColor: Colors.deepOrange,
                                                  badgeContent: Text(
                                                    sfourhana.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  child: Image.asset(
                                                      "assets/images/WorkInProgress.png",
                                                      fit: BoxFit.fill,
                                                      height: 70,
                                                      width: 70),
                                                ),
                                                SizedBox(
                                                  height: 10,
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
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OpenTicketCustomerList(
                                          //               getScreenName:
                                          //                   myController.text,
                                          //             )));
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
                                                Badge(
                                                  padding: EdgeInsets.all(8),
                                                  shape: BadgeShape.circle,
                                                  badgeColor: Colors.deepOrange,
                                                  showBadge:
                                                      einvoice.toString() == "0"
                                                          ? false
                                                          : true,
                                                  badgeContent: Text(
                                                    einvoice.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  child: Image.asset(
                                                      "assets/images/ThirdParty.png",
                                                      fit: BoxFit.fill,
                                                      height: 70,
                                                      width: 70),
                                                ),
                                                SizedBox(
                                                  height: 10,
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
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OpenTicketCustomerList(
                                          //               getScreenName:
                                          //                   myController.text,
                                          //             )));
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
                                                Badge(
                                                  padding: EdgeInsets.all(8),
                                                  shape: BadgeShape.circle,
                                                  badgeColor: Colors.deepOrange,
                                                  showBadge:
                                                      sapbyd.toString() == "0"
                                                          ? false
                                                          : true,
                                                  badgeContent: Text(
                                                    sapbyd.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  child: Image.asset(
                                                      "assets/images/Quotation.jpg",
                                                      fit: BoxFit.fill,
                                                      height: 70,
                                                      width: 70),
                                                ),
                                                SizedBox(
                                                  height: 10,
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
                                            ..text = "Resolved";
                                          print(myController);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             OpenTicketCustomerList(
                                          //               getScreenName:
                                          //                   myController.text,
                                          //             )));
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
                                                Badge(
                                                  padding: EdgeInsets.all(8),
                                                  shape: BadgeShape.circle,
                                                  badgeColor: Colors.deepOrange,
                                                  showBadge:
                                                      mobileapp.toString() ==
                                                              "0"
                                                          ? false
                                                          : true,
                                                  badgeContent: Text(
                                                    mobileapp.toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  child: Image.asset(
                                                      "assets/images/SollutionProvided.png",
                                                      fit: BoxFit.fill,
                                                      height: 70,
                                                      width: 70),
                                                ),
                                                SizedBox(
                                                  height: 10,
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



  Future prodCustCountData() async {


    print("prodCustCountData was called");
    var body = [
      {
        "FormID": 4,
        "Type": "",
        "EmpID": UserID.toString(),
        "CustomerName": ""
      }
    ];

    print(body);
    var header = {"Content-Type": "application/json"};
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + '/getEmployeeAssignedTask'),
        body: json.encode(body),
        headers: header);
    print(json.decode(response.body));
    print(jsonEncode(body));
    print(AppConstants.LIVE_URL  + '/getEmployeeAssignedTask');
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


            sapbone = json.decode(response.body)["result"][0]["sapbone"];
            sfourhana = json.decode(response.body)["result"][0]["sfourhana"];
            einvoice = json.decode(response.body)["result"][0]["einvoice"];
            sapbyd = json.decode(response.body)["result"][0]["sapbyd"];
            mobileapp = json.decode(response.body)["result"][0]["mobileapp"];
            sapecc = json.decode(response.body)["result"][0]["sapecc"];
            webportal = json.decode(response.body)["result"][0]["webportal"];
            datacenter = json.decode(response.body)["result"][0]["datacenter"];
            sappos = json.decode(response.body)["result"][0]["sappos"];
            cloud = json.decode(response.body)["result"][0]["cloud"];
            saperp = json.decode(response.body)["result"][0]["saperp"];
          });
        });
      }
    } else {
      print('Response error!!');
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
