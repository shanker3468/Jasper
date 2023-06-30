// ignore: file_names
import 'dart:convert';


import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jasper/ServiceStation/report_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstants.dart';


class ReportsDashBoard extends StatefulWidget {
  const ReportsDashBoard({Key? key}) : super(key: key);

  @override
  _ReportsDashBoardState createState() => _ReportsDashBoardState();
}

class _ReportsDashBoardState extends State<ReportsDashBoard> {
  late String sessioncustID, sessionCustName, sessionCustLocation, sessionEmail;

  late  String UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location;



  bool loading = false;
  int openTickets = 0;
  int wipTickets = 0;
  int solProvidTickets = 0;
  int reopenTickets = 0;
  int closedTickets = 0;
  int rejectTickets = 0;
  int deleteTickets = 0;
  int QuotationTickets = 0;
  int ApprovedTickets = 0;
  int ThirdPartyTickets =0;

  int sapbone = 8;

  @override
  void initState() {
    // TODO: implement initState
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xff3A9BDC), Color(0xff3A9BDC)])),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Ticket Reports"),
              elevation: 1,
            ),
            body: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: ListView(
                children: [
                  babyCard("openTickets", "O", openTickets),
                  babyCard("Approved Tickets", "A", ApprovedTickets),
                  babyCard("Third Party", "T", ThirdPartyTickets),
                  babyCard("Quotation", "Q", QuotationTickets),
                  babyCard("WIP Tickets", "P", wipTickets),

                  babyCard("Resolved Tickets", "S", solProvidTickets),
                  babyCard("Reject Tickets", "R", rejectTickets),
                  babyCard("Deleted Tickets", "D", deleteTickets),
                  babyCard("Closed Tickets", "C", closedTickets),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget babyCard(String name, String letter, int count) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportList(
                      ticketType: letter,
                      ticketName: name,
                    )));

        print(name);
        print(letter);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.teal.shade200,
                  Colors.grey.shade100,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topLeft: Radius.circular(5),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  trailing: Container(
                    width: MediaQuery.of(context).size.width / 13,
                    height: MediaQuery.of(context).size.height / 24,
                    // color: Colors.lightBlue,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.white,
                        gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.redAccent
                            ],
                          ),
                        border: new Border.all(color: Colors.white12)),
                    child: loading != true
                        ? Center(
                            child: Text(
                              "${count}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13,
                                  color: Colors.white),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                  ),
                  // leading: Image.asset("");
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade600,
                    child: Center(
                      child: Text(
                        "${letter}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  title: Row(

                    children: [
                      Text(
                        ' ${name}',
                        style: TextStyle(color: Colors.black),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
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

                            ),
                          ],
                        ),
                      ),*/

                    ],
                  ),
                ),
              ),
            ])),
      ),
    );
  }

  void getStringValuesSF() async {

    print("getStringValuesSF()");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserID = prefs.getString('UserID').toString();
      UserName = prefs.getString('UserName').toString();
      branchID = prefs.getString('BranchID').toString();
      BranchName = prefs.getString('BranchName').toString();
      DepartmentCode = prefs.getString('DepartmentCode').toString();
      DepartmentName = prefs.getString('DepartmentName').toString();
      Location = prefs.getString('Location').toString();
      // FromBranchController.text = sessionfromBranchName;


      getTicketCount();

      print(UserName.toString());

    });
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => DashBoard()));
    return Future.value(true);
  }

  Future<http.Response> getTicketCount() async {
    setState(() {
      loading = true;
    });

    print("inside");
    var body = {
      "FormID": 9,
      "UserID":UserID.toString(),
      "Password": "",
      "Branch": "",
      "DataBase":""
    };
    print((body));
    var headers = {"Content-Type": "application/json"};

    final response = await http.post(
      Uri.parse(AppConstants.LIVE_URL + 'JasperLogin'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "No Data!!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            fontSize: 16.0);
      } else {
        setState(() {
          print(response.body.toString());
          openTickets = json.decode(response.body)["result"][0]["OpenTickets"];
          wipTickets = json.decode(response.body)["result"][0]["WIP"];
          solProvidTickets =
              json.decode(response.body)["result"][0]["SolutionProvided"];
          reopenTickets =
              json.decode(response.body)["result"][0]["ReopenTickets"];
          closedTickets =
              json.decode(response.body)["result"][0]["ClosedTickets"];
          rejectTickets =
              json.decode(response.body)["result"][0]["RejectTickets"];
          deleteTickets =
              json.decode(response.body)["result"][0]["DeleteTickets"];
          QuotationTickets =
              json.decode(response.body)["result"][0]["QuotationTickets"];
          ApprovedTickets =
              json.decode(response.body)["result"][0]["ApprovedTickets"];

          ThirdPartyTickets=
          json.decode(response.body)["result"][0]["ThirdPartyTickets"];


        });
      }

      setState(() {
        loading = false;
      });
      return response;
    } else {
      throw Exception('Something went wrong??!!');
    }
  }
}
