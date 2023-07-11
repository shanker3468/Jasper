
import 'dart:convert';


import 'package:blinking_text/blinking_text.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstants.dart';
import '../Model/EditTicketModel.dart';
import '../Model/TicketStatusModel.dart';
import 'reports.dart';

class ReportList extends StatefulWidget {
  ReportList({Key? key, required this.ticketType, required this.ticketName}) : super(key: key);
  String ticketType, ticketName;

  @override
  ReportListState createState() => ReportListState();
}

class ReportListState extends State<ReportList> {
  late  String UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location,EmpGroup;
  late bool sessionLoggedIn;
  bool loading = false;
  late String alterTicketNo,
      alterCustName,
      alterCustomerID,
      altercontactno,
      alteremail;
  int formid = 0;

  var ticketNoController = TextEditingController();
  var dateController = TextEditingController();
  var descriptionController = TextEditingController();
  var wipEmpController = TextEditingController();
  var solutionController = TextEditingController();
  var rejectionController = TextEditingController();
  var deleteController = TextEditingController();
  var SearchContText = TextEditingController();
  var _AlertControler = new TextEditingController();
  var Description = new TextEditingController();
  var RequiredDate = new TextEditingController();
  var createdEmployee = new TextEditingController();
  TextEditingController mobilenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late String selecteddate;
  var TicketNo = new TextEditingController();
  var TicketCategory = new TextEditingController();
  late String U_Remarks;
  List<String> empStringList = [];
  int Rejectvalidation = 0;
  String alterempname = "";

   TicketStatusModel custTicketStatuslist= TicketStatusModel(result: []);

   EditTicketModel editTicketDataList =EditTicketModel(result: []);

  @override
  void initState() {
    // TODO: implement initState
    getStringValuesSF();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var SH = MediaQuery.of(context).size.height;
    var SW = MediaQuery.of(context).size.width;
    print(widget.ticketType);
    print(widget.ticketName);
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Container(
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
                title: Column(
                  children: [
                    Text("${widget.ticketName}"),
                  ],
                ),
              ),
              body: !loading
                  ? custTicketStatuslist.result!.isNotEmpty
                      ? Container(
                          width: SW,
                          height: SH,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.2),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              colors: [
                                Colors.lightBlueAccent.shade100,
                                Colors.greenAccent.shade100,
                              ],
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: AnimationLimiter(
                              child: ListView.builder(
                                  itemCount: custTicketStatuslist.result!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 100),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FlipAnimation(
                                          child: InkWell(
                                            onTap: () {
                                              if (widget.ticketType == "S") {
                                                print('Yes');
                                                Dialogs.materialDialog(
                                                  msg:
                                                      'Do you want Accept And Rejact',
                                                  title: "TIC NO-" +
                                                      custTicketStatuslist
                                                          .result![index]
                                                          .ticketNo
                                                          .toString(),
                                                  color: Colors.white,
                                                  context: context,
                                                  actions: [
                                                    IconsButton(
                                                      onPressed: () {
                                                        print(Rejectvalidation);
                                                        if (Rejectvalidation ==
                                                            0) {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child:
                                                                    AlertDialog(
                                                                  content:
                                                                      StatefulBuilder(
                                                                    builder: (BuildContext
                                                                            context,
                                                                        void Function(void Function())
                                                                            setState) {
                                                                      return Container(
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min, // To make the card compact
                                                                            children: <Widget>[
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1),
                                                                                child: TextField(
                                                                                    controller: rejectionController,
                                                                                    enabled: true,
                                                                                    maxLines: 3,
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
                                                                                      labelText: 'Reject Reason',
                                                                                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                                                                    )),
                                                                              ),
                                                                              SizedBox(height: 24.0),
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: TextButton.icon(
                                                                                      onPressed: () {
                                                                                        Fluttertoast.showToast(msg: "Cancelled!!", backgroundColor: Colors.red);
                                                                                        Navigator.pop(context);
                                                                                        rejectionController.text = "";
                                                                                      },
                                                                                      icon: const Icon(
                                                                                        Icons.cancel,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      label: const Text(
                                                                                        'Cancel',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      style: TextButton.styleFrom(
                                                                                        backgroundColor: Colors.red,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(8.0),
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
                                                                                        alterTicketNo = custTicketStatuslist.result![index].ticketNo!;
                                                                                        print(rejectionController.text);
                                                                                        if (rejectionController.text == "") {
                                                                                          Fluttertoast.showToast(msg: "Rejection Reason should not left empty!!", backgroundColor: Colors.deepOrange);
                                                                                        } else {
                                                                                          formid = 4;
                                                                                          updateTicketStatus(formid);

                                                                                          // Fluttertoast
                                                                                          //     .showToast(
                                                                                          //         msg: "Ticket Closed..");
                                                                                        }
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons.assignment_turned_in_outlined,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      label: Text(
                                                                                        'ReOpen',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      style: TextButton.styleFrom(
                                                                                        backgroundColor: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        } else if (Rejectvalidation ==
                                                            10) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Rejectvalidation = 0;

                                                          print(
                                                              Rejectvalidation);
                                                          //SendMail();
                                                        } else {}
                                                      },
                                                      text: 'Reject',
                                                      iconData:
                                                          Icons.cancel_outlined,
                                                      color: Colors.red,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                    ),
                                                    IconsButton(
                                                      onPressed: () {

                                                        alterTicketNo =
                                                            custTicketStatuslist
                                                                .result![index]
                                                                .ticketNo!;

                                                        formid = 3;
                                                        updateTicketStatus(
                                                            formid);

                                                        // Navigator.of(context).pop();
                                                      },
                                                      text: 'Accept',
                                                      iconData: Icons.check,
                                                      color: Colors.lightGreen,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                    ),
                                                  ],
                                                );
                                              } else if (widget.ticketType ==
                                                  "O") {
                                                print('Yes');
                                                Dialogs.materialDialog(
                                                  msg:
                                                      'Are you modify Ticket!!',
                                                  title: "Ticket No - " +
                                                      custTicketStatuslist
                                                          .result![index]
                                                          .ticketNo!
                                                          .toString(),
                                                  color: Colors.white,
                                                  context: context,
                                                  actions: [
                                                    IconsButton(
                                                      onPressed: () {
                                                        print(Rejectvalidation);
                                                        if (Rejectvalidation ==
                                                            0) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child:
                                                                    AlertDialog(
                                                                  content:
                                                                      StatefulBuilder(
                                                                    builder: (BuildContext
                                                                            context,
                                                                        void Function(void Function())
                                                                            setState) {
                                                                      return Container(
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min, // To make the card compact
                                                                            children: <Widget>[
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1),
                                                                                child: TextField(
                                                                                    controller: deleteController,
                                                                                    enabled: true,
                                                                                    maxLines: 3,
                                                                                    decoration: const InputDecoration(
                                                                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.cyan)),
                                                                                      labelText: 'Delete Reason',
                                                                                      labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                                                                                    )),
                                                                              ),
                                                                              SizedBox(height: 24.0),
                                                                              Row(
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: TextButton.icon(
                                                                                      onPressed: () {
                                                                                        Fluttertoast.showToast(msg: "Cancelled!!", backgroundColor: Colors.red);
                                                                                        Navigator.pop(context);
                                                                                        deleteController.text = "";
                                                                                      },
                                                                                      icon: const Icon(
                                                                                        Icons.cancel,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      label: const Text(
                                                                                        'Cancel',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      style: TextButton.styleFrom(
                                                                                        backgroundColor: Colors.red,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(8.0),
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
                                                                                        // alterCustName = custTicketStatuslist.result[index].customerName;
                                                                                        // alterCustomerID = custTicketStatuslist.result[index].customerID;
                                                                                        alterTicketNo = custTicketStatuslist.result![index].ticketNo!;
                                                                                        print(deleteController.text);
                                                                                        if (deleteController.text == "") {
                                                                                          Fluttertoast.showToast(msg: "Delete Reason should not left empty!!", backgroundColor: Colors.deepOrange, gravity: ToastGravity.TOP);
                                                                                        } else {
                                                                                          formid = 5;
                                                                                          // Navigator.pop(context);
                                                                                          updateTicketStatus(formid);
                                                                                        }
                                                                                      },
                                                                                      icon: Icon(
                                                                                        Icons.assignment_turned_in_outlined,
                                                                                        color: Colors.white,
                                                                                      ),
                                                                                      label: Text(
                                                                                        'Delete',
                                                                                        style: TextStyle(color: Colors.white),
                                                                                      ),
                                                                                      style: TextButton.styleFrom(
                                                                                        backgroundColor: Colors.lightGreen,
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 8,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        } else if (Rejectvalidation ==
                                                            10) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Rejectvalidation = 0;

                                                          print(
                                                              Rejectvalidation);
                                                          //SendMail();
                                                        } else {}
                                                      },
                                                      text: 'Delete',
                                                      iconData:
                                                          Icons.cancel_outlined,
                                                      color: Colors.red,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                    ),
                                                    IconsButton(
                                                      onPressed: () {
                                                        // alterCustName =
                                                        //     custTicketStatuslist
                                                        //         .result![index]
                                                        //         .customerName!;
                                                        // alterCustomerID =
                                                        //     custTicketStatuslist
                                                        //         .result[index]
                                                        //         .customerID;
                                                        alterTicketNo =
                                                            custTicketStatuslist
                                                                .result![index]
                                                                .ticketNo!;
                                                        Navigator.of(context)
                                                            .pop();
                                                        cusTicketDetails().then(
                                                            (value) =>
                                                                showalert());
                                                      },
                                                      text: 'Edit',
                                                      iconData: Icons.check,
                                                      color: Colors.lightGreen,
                                                      textStyle: TextStyle(
                                                          color: Colors.white),
                                                      iconColor: Colors.white,
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                print('No....');
                                              }
                                            },
                                            child: Container(
                                              // height: SH / 5,
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                // color: Colors.white70,
                                                color: Colors.black12,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(
                                                        0.0, 1.0), //(x,y)
                                                    blurRadius: 6.0,
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(5),
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(5),
                                                  bottomRight:
                                                      Radius.circular(30),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: SH / 12,
                                                    width: SW / 5,
                                                    // color: Colors.pinkAccent,
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          minRadius: SH / 25,
                                                          backgroundColor:
                                                              Colors.pinkAccent
                                                                  .withOpacity(
                                                                      0.2),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "TicketNo",
                                                                style: TextStyle(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                custTicketStatuslist
                                                                    .result![
                                                                        index]
                                                                    .ticketNo
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        SH / 40,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        /*CircleAvatar(
                                                          backgroundColor: Colors.pinkAccent
                                                              .withOpacity(0.2),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                "Ageing Days",
                                                                style: TextStyle(
                                                                    fontSize: 9,
                                                                    color: Colors.black),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Text(
                                                                custTicketStatuslist
                                                                    .result[index].ticketNo
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: SH / 40,
                                                                    color: Colors.black),
                                                              ),dsthfsdhsd
                                                            ],
                                                          ),
                                                        ),*/
                                                        /* Container(
                                                          height: SH / 30,
                                                          width: SW / 9,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.blue.shade900,
                                                            child: Text(
                                                              widget.ticketType != "C"
                                                                  ? DateTime.now()
                                                                      .difference(DateFormat(
                                                                              "yyyy-MM-dd")
                                                                          .parse(custTicketStatuslist
                                                                              .result[index]
                                                                              .createdDate))
                                                                      .inDays
                                                                      .toString()
                                                                  : DateFormat("yyyy-MM-dd")
                                                                      .parse(
                                                                          custTicketStatuslist
                                                                              .result[index]
                                                                              .closedDate)
                                                                      .difference(DateFormat(
                                                                              "yyyy-MM-dd")
                                                                          .parse(custTicketStatuslist
                                                                              .result[index]
                                                                              .createdDate))
                                                                      .inDays
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 9,
                                                                  color: Colors.white,
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),*/
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    // height: SH / 7,
                                                    width: SW / 1.5,
                                                    // color: Colors.redAccent,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        widget.ticketType ==
                                                                    "O" ||
                                                                widget.ticketType ==
                                                                    "S"
                                                            ? const SizedBox(
                                                                height: 5,
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        widget.ticketType ==
                                                                    "O" ||
                                                                widget.ticketType ==
                                                                    "S"
                                                            ? BlinkText(
                                                                widget.ticketType ==
                                                                        "S"
                                                                    ? 'Tap to Accept or Reject!!'
                                                                    : "Tap to Modify Ticket!!",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                ),
                                                                beginColor: Colors
                                                                    .lightGreen,
                                                                endColor:
                                                                    Colors.red,
                                                                textScaleFactor:
                                                                    1.0,
                                                                //  times: 10,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1))
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),

                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                          children: [
                                                            Container(
                                                                width: SW / 2.5,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'Created Date :',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text: DateFormat("dd-MM-yyyy").format(DateTime.parse(custTicketStatuslist.result![index].createdDate.toString())).toString(),
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black),
                                                                        ),
                                                                      ],
                                                                    )) /*Text(
                                                                "Ageing Days : ${custTicketStatuslist.result[index].ticketNo.toString()}",
                                                                style: TextStyle(
                                                                    fontSize: SH / 60,
                                                                    color: Colors.black),
                                                              ),*/
                                                            ),
                                                            Container(
                                                                width: SW / 2.5,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'RequiredDate :',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '${custTicketStatuslist.result![index].requiredDate.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),

                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                          children: [
                                                            Container(
                                                                width: SW / 2.5,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'Ticket Type :',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].category.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(
                                                              width: SW / 2.5,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'Ageing Days :',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text: widget.ticketType !=
                                                                              "C"
                                                                              ? '${DateTime.now().difference(DateFormat("yyyy-MM-dd").parse(custTicketStatuslist.result![index].createdDate.toString())).inDays.toString()}'
                                                                              : '${DateFormat("yyyy-MM-dd").parse(custTicketStatuslist.result![index].closedDate.toString()).difference(DateFormat("yyyy-MM-dd").parse(custTicketStatuslist.result![index].createdDate.toString())).inDays.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black),
                                                                        ),
                                                                      ],
                                                                    )) /*Text(
                                                                "Ageing Days : ${custTicketStatuslist.result[index].ticketNo.toString()}",
                                                                style: TextStyle(
                                                                    fontSize: SH / 60,
                                                                    color: Colors.black),
                                                              ),*/
                                                            ),

                                                          ],
                                                        ),

                                                        const SizedBox(
                                                          height: 5,
                                                        ),

                                                        /*Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                                width: SW / 2,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'RequiredDate :',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].requiredDate.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),*/
                                                        custTicketStatuslist.result![index].assetName.toString().isNotEmpty&&custTicketStatuslist.result![index].assetName.toString()!=null?Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                                width: SW / 2,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'Asset Name :',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].assetName.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(),
                                                          ],
                                                        ):Container(),

                                              custTicketStatuslist.result![index].assetName.toString().isNotEmpty?const SizedBox(
                                                          height: 5,
                                                        ):Container(),
                                                        custTicketStatuslist.result![index].itemName.toString().isNotEmpty?Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                                width: SW / 2,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'Item Name :',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].itemName.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(),
                                                          ],
                                                        ):Container(),

                                                        custTicketStatuslist.result![index].itemName.toString().isNotEmpty?const SizedBox(
                                                          height: 5,
                                                        ):Container(),
                                                        custTicketStatuslist.result![index].quotation.toString()!="null"||custTicketStatuslist.result![index].quotation!.isNotEmpty||custTicketStatuslist.result![index].quotation.toString()!=""?Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(
                                                                width: SW / 2,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'quotation:',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].quotation.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(),
                                                          ],
                                                        ):Container(),

                                                        custTicketStatuslist.result![index].quotation.toString()!="null"||custTicketStatuslist.result![index].quotation!.isNotEmpty||custTicketStatuslist.result![index].quotation.toString()!=""?const SizedBox(
                                                          height: 5,
                                                        ):Container(),
                                                        custTicketStatuslist.result![index].issueCatrgory.toString().isNotEmpty?Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Container(

                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'IssueCatrgory:',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].issueCatrgory.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(),
                                                          ],
                                                        ):Container(),

                                                        custTicketStatuslist.result![index].issueCatrgory.toString().isNotEmpty?const SizedBox(
                                                          height: 5,
                                                        ):Container(),
                                                        custTicketStatuslist.result![index].issueType.toString().isNotEmpty?Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [

                                                            Container(

                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'IssueType:',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                          '  ${custTicketStatuslist.result![index].issueType.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize: SH /
                                                                                  60,
                                                                              color:
                                                                              Colors.black),
                                                                        ),
                                                                      ],
                                                                    ))
                                                              /*Text(
                                                                "RequiredDate : ${custTicketStatuslist.result[index].requiredDate.toString()}",
                                                                overflow:
                                                                    TextOverflow.ellipsis,
                                                                softWrap: true,
                                                                style: TextStyle(
                                                                    fontSize: SH / 60),
                                                              ),*/
                                                            ),
                                                            Container(),
                                                          ],
                                                        ):Container(),

                                                        custTicketStatuslist.result![index].issueType.toString().isNotEmpty? SizedBox(
                                                          height: 5,
                                                        ):Container(),
                                                        Container(
                                                            width: SW,
                                                            child: RichText(
                                                                text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      'Ticket Description: ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SH /
                                                                              60,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '\n  ${custTicketStatuslist.result![index].description.toString()}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SH /
                                                                              60,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ],
                                                            ))

                                                            /*Text(
                                                            "Ticket Description: \n" +
                                                                custTicketStatuslist
                                                                    .result[index]
                                                                    .description
                                                                    .toString(),
                                                            maxLines: 15,
                                                            overflow: TextOverflow.ellipsis,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontSize: SH / 60,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ),*/
                                                            ),



                                                        widget.ticketType == "P"
                                                            ? const SizedBox(
                                                                height: 5,
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        widget.ticketType == "P"
                                                            ? Row(
                                                                children: [
                                                                  Container(
                                                                      width:
                                                                          SW /
                                                                              2,
                                                                      child: RichText(
                                                                          text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Assigned Emp:',
                                                                            style: TextStyle(
                                                                                fontSize: SH / 60,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '  ${custTicketStatuslist.result![index].assignEmpName.toString()}',
                                                                            style:
                                                                                TextStyle(fontSize: SH / 60, color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ))
                                                                      /*Text(
                                                                      "Name :${custTicketStatuslist.result[index].empName != null ? custTicketStatuslist.result[index].empName : ""} ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              SH / 60),
                                                                    ),*/
                                                                      ),
                                                                  /* Container(
                                                                    width: SW / 6,
                                                                    child: Text(
                                                                      custTicketStatuslist
                                                                                  .result[
                                                                                      index]
                                                                                  .empContactNo !=
                                                                              null
                                                                          ? custTicketStatuslist
                                                                              .result[index]
                                                                              .empContactNo
                                                                              .toString()
                                                                          : "",
                                                                      style: TextStyle(
                                                                          fontSize: SH / 70,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                    ),
                                                                  ),*/
                                                                ],
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        widget.ticketType ==
                                                                    "P" &&
                                                                custTicketStatuslist
                                                                        .result![
                                                                            index]
                                                                        .assignEmpcontactNo !=
                                                                    null
                                                            ? const SizedBox(
                                                                height: 5,
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                        if (widget.ticketType ==
                                                                    "P" &&
                                                                custTicketStatuslist
                                                                        .result![
                                                                            index]
                                                                        .assignEmpcontactNo !=
                                                                    null) Row(
                                                                children: [
                                                                  /* Container(
                                                              width: SW / 5,
                                                              child: Text(
                                                                custTicketStatuslist
                                                                    .result[
                                                                index]
                                                                    .empName !=
                                                                    null
                                                                    ? custTicketStatuslist
                                                                    .result[index]
                                                                    .empName
                                                                    : "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    SH / 60),
                                                              ),
                                                            ),*/

                                                                  Container(
                                                                      width:
                                                                          SW /
                                                                              2,
                                                                      child: Row(

                                                                        children: [
                                                                          Text(
                                                                                'ContactNo :',
                                                                            style: TextStyle(
                                                                                fontSize: SH / 60,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          Text(
                                                                                '  ${custTicketStatuslist.result![index].assignEmpcontactNo.toString()}',
                                                                            style:
                                                                                TextStyle(fontSize: SH / 60, color: Colors.black)),

                                                                          custTicketStatuslist.result![index].assignEmpcontactNo!=null
                                                                              &&
                                                                              custTicketStatuslist.result![index].assignEmpcontactNo!.length>9?
                                                                          Center(
                                                                              child: InkWell(
                                                                                // onTap:() async {
                                                                                //   var url='tel:${list.mobileNo}';
                                                                                //
                                                                                //
                                                                                //   await launch(url);
                                                                                //
                                                                                // },
                                                                                  child: InkWell(
                                                                                      onTap: () async {
                                                                                        var url = 'tel:${custTicketStatuslist.result![index].assignEmpcontactNo}';

                                                                                        await launch(url);
                                                                                      },
                                                                                      child: Icon(
                                                                                        Icons.call,
                                                                                        color: Colors.green,
                                                                                      )))
                                                                          ):Container()

                                                                        ],
                                                                      )

                                                                      /*Text(
                                                                      "ContactNo: ${custTicketStatuslist.result[index].empContactNo.toString()}",
                                                                      style: TextStyle(
                                                                          fontSize: SH / 70,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                    ),*/
                                                                      ),
                                                                ],
                                                              ) else Container(),
                                                        widget.ticketType ==
                                                                    "P" &&
                                                                custTicketStatuslist
                                                                        .result![
                                                                            index].empMailid !=
                                                                    null
                                                            ? const SizedBox(
                                                                height: 5,
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),

                                                        widget.ticketType ==
                                                                    "S" ||
                                                                widget.ticketType ==
                                                                        "C" &&
                                                                    custTicketStatuslist
                                                                            .result![
                                                                                index]
                                                                            .solutionProvided !=
                                                                        null
                                                            ? const SizedBox(
                                                                height: 5,
                                                              )
                                                            : Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0)),
                                                       /* widget.ticketType ==
                                                                    "S" ||
                                                                widget.ticketType ==
                                                                    "C"
                                                            ? Row(
                                                                children: [
                                                                  Container(
                                                                      width:
                                                                          SW /
                                                                              2,
                                                                      child: RichText(
                                                                          text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'SolutionProvided :',
                                                                            style: TextStyle(
                                                                                fontSize: SH / 60,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                          TextSpan(
                                                                            text:
                                                                                '\n  ${custTicketStatuslist.result![index].solutionProvided.toString()}',
                                                                            style:
                                                                                TextStyle(fontSize: SH / 60, color: Colors.black),
                                                                          ),
                                                                        ],
                                                                      ))

                                                                      /* Text(
                                                                      custTicketStatuslist
                                                                          .result[index]
                                                                          .solutionProvided,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              SH / 60),
                                                                    ),*/
                                                                      ),
                                                                ],
                                                              )
                                                            : Container(),*/
                                                        /* widget.ticketType == "R"
                                                            ? const SizedBox(
                                                                height: 5,
                                                              )
                                                            : Padding(
                                                                padding: EdgeInsets.all(0)),
                                                        widget.ticketType == "R"
                                                            ? Row(
                                                                children: [
                                                                  Container(
                                                                      width: SW / 2,
                                                                      child: RichText(
                                                                          text: TextSpan(
                                                                        children: [
                                                                          TextSpan(
                                                                            text:
                                                                                'Reject Reason :',
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    SH / 60,
                                                                                color: Colors
                                                                                    .black,
                                                                                fontWeight:
                                                                                    FontWeight
                                                                                        .bold),
                                                                          ),
                                                                          */ /* TextSpan(
                                                                          text:
                                                                          '\n  ${custTicketStatuslist.result[index].solutionProvided.toString()}',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH / 60,
                                                                              color: Colors
                                                                                  .black),
                                                                        ),*/ /*
                                                                        ],
                                                                      ))

                                                                      */ /* Text(
                                                                      custTicketStatuslist
                                                                          .result[index]
                                                                          .solutionProvided,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              SH / 60),
                                                                    ),*/ /*
                                                                      ),
                                                                ],
                                                              )
                                                            : Container(),*/

                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        if(widget.ticketType=="R")Row(
                                                          children: [
                                                            Container(
                                                              //width: SW / 2,
                                                                child: RichText(
                                                                    text:
                                                                    TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text:
                                                                          'Reject Reason :',
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        ),
                                                                        TextSpan(
                                                                          text: custTicketStatuslist.result![index].rejectRemarks.toString(),
                                                                          style: TextStyle(
                                                                              fontSize:
                                                                              SH /
                                                                                  60,
                                                                              color: Colors
                                                                                  .black),
                                                                        ),
                                                                      ],
                                                                    )) /*Text(
                                                                "Ageing Days : ${custTicketStatuslist.result[index].ticketNo.toString()}",
                                                                style: TextStyle(
                                                                    fontSize: SH / 60,
                                                                    color: Colors.black),
                                                              ),*/
                                                            ),
                                                          ],
                                                        ),


                                                      
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                 /* custTicketStatuslist.result![index].attachFileName != null?GestureDetector(
                                                    onTap: (){

                                                      Container(
                                                        padding:
                                                        EdgeInsets.all(16),
                                                        height: 100,
                                                        width: 100,
                                                        child: custTicketStatuslist.result![index].attachFileName.toString()
                                                            .endsWith(
                                                            ".jpg")
                                                            ? Image.network(
                                                          AppConstants.LIVE_URL+
                                                              custTicketStatuslist.result![index].attachFileName.toString(),

                                                        ):Container());


                                                    },
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          minRadius: SH / 50,
                                                          backgroundColor:
                                                          Colors.red
                                                              .withOpacity(
                                                              0.8),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: [

                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Icon(Icons.attachment)
                                                            ],
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ):Container(),*/
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        )
                      : Container(
                          child: Center(
                            child: Column(
                              children: [
                                Image.asset("assets/images/nodata.png"),
                                // Text("No Tickets!!"),
                              ],
                            ),
                          ),
                        )
                  : Center(
                      child: CircularProgressIndicator(),
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
      UserID = prefs.getString('UserID').toString();
      UserName = prefs.getString('UserName').toString();
      branchID = prefs.getString('BranchID').toString();
      BranchName = prefs.getString('BranchName').toString();
      DepartmentCode = prefs.getString('DepartmentCode').toString();
      DepartmentName = prefs.getString('DepartmentName').toString();
      Location = prefs.getString('Location').toString();
      EmpGroup=prefs.getString('EmpGroup').toString();

      cutTicketStatusData();
    });
  }

  Future cutTicketStatusData() async {

    print("cutTicketStatusData was called");
    var body = {"CustName": UserID, "TicketType": widget.ticketType};

    print(body);
    var header = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'getTicktStatusStation'),
        body: json.encode(body),
        headers: header);
    print(json.decode(response.body));

    print(AppConstants.LIVE_URL+ 'getTicktStatusStation');

    if (response.statusCode == 200) {
      var isdata = json.decode(response.body)["status"] == 0;
      print(isdata);
      if (isdata) {

      } else {
        final Map<String, dynamic> responseList = json.decode(response.body);
        responseList['result'].forEach((forloopvalue) {
          setState(() {
            custTicketStatuslist =
                TicketStatusModel.fromJson(json.decode(response.body));
          });
          print("DataSize" + custTicketStatuslist.result!.length.toString());
        });
      }
      print("DataSize" + custTicketStatuslist.result!.length.toString());
    } else {
      print('Response error!!');
    }
    setState(() {
      loading = false;
    });
  }

  Future cusTicketDetails() async {
    print("cusTicketDetails()  was called");
    var body = [
      {
        "FormID": "1",
        "TicketNo": alterTicketNo,
        "CustomerID":branchID,
        "CustomerName": "",
        "EmpID": "",
        "EmpName": ""
      }
    ];
    var header = {"Content-Type": "application/json"};

    print(body);
    setState(() {
      loading = true;
    });
    var response = await http.post(
        Uri.parse(AppConstants.LIVE_URL  + 'getTicketEditDetails'),
        body: json.encode(body),
        headers: header);
    print(response.body);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      var isdata = json.decode(response.body)["status"] == 0;
      print(isdata);
      if (isdata) {
        print(("If"));

      } else {

        print(("Else"));
        final Map<String, dynamic> responseList = json.decode(response.body);
        responseList['result'].forEach((forloopvalue) {
          setState(() {

            editTicketDataList = EditTicketModel.fromJson(jsonDecode(response.body));
            // editTicketDataList =
            //     EditTicketModel.fromJson(json.decode(response.body));
            TicketCategory.text = jsonDecode(response.body)["result"][0]
                    ["Category"]
                .toString();
            TicketNo.text =
                jsonDecode(response.body)["result"][0]["TicketNo"].toString();
            RequiredDate.text = jsonDecode(response.body)["result"][0]
                    ["RequiredDate"]
                .toString();
            Description.text = jsonDecode(response.body)["result"][0]
                    ["Description"]
                .toString();
            createdEmployee.text =
                jsonDecode(response.body)["result"][0]["EmpName"].toString();
            alterempname =
                jsonDecode(response.body)["result"][0]["EmpName"].toString();
            alteremail = jsonDecode(response.body)["result"][0]["EmpContactNo"]
                .toString();
            altercontactno = jsonDecode(response.body)["result"][0]
                    ["EmpContactNo"]
                .toString();
            print('cusempname' + alterempname);
          });
          print("DataSize" + editTicketDataList.result!.length.toString());
        });
      }
      print("DataSize" + editTicketDataList.result!.length.toString());
    } else {
      print('Response error!!');
    }
  }

  Future<http.Response> updateTicketStatus(int formID) async {
    print("updateTicketStatus(int formID) was called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": formID,
      "Solution": rejectionController.text,
      "TicketNo": alterTicketNo,
      "CustName": "",
      "UpdateLocation": "",
      "Docno":0,
    };
    print(body);
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.parse(AppConstants.LIVE_URL + 'updateClosedTickets'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    print(response.body);
    print(response.statusCode);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Something went Wrong!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          formid == 3
              ? Fluttertoast.showToast(
                  msg: "Ticket Closed Successfully!!",
                  backgroundColor: Colors.green)
              : formid == 5
                  ? Fluttertoast.showToast(
                      msg: "Ticket Deleted Successfully!!",
                      backgroundColor: Colors.green)
                  : Fluttertoast.showToast(
                      msg: "Ticket Reopen successfully!!",
                      backgroundColor: Colors.green);

          Navigator.pop(context);
          if (formid == 4) {
            rejectionController.text = "";
          }
          cutTicketStatusData();

          /*    Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ReportList(
                ticketName: widget.ticketName,
                ticketType: widget.ticketType,
              ),
            ),
          );*/
        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        // firstDate: DateTime(2020 - 01 - 01),
        firstDate: DateTime.now().subtract(Duration(days: 0)),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selecteddate = new DateFormat("dd-MM-yyyy").format(picked);
        RequiredDate.text = selecteddate.toString();
        print("Slectdate: " + RequiredDate.text);
      });
    }
  }



  void showalert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                            enabled: false,
                            minLines: 1,
                            maxLines: 2,
                            controller: TicketCategory,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.cyan)),
                              labelText: 'Ticket Category',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )),

                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                  enabled: false,
                                  minLines: 1,
                                  maxLines: 2,
                                  controller: TicketNo,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.cyan)),
                                    labelText: 'TicketNo',
                                    labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  )),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectDate(context);
                                    //   myFocusNode.unfocus();
                                  });
                                },
                                child: TextField(
                                    enabled: false,
                                    minLines: 1,
                                    controller: RequiredDate,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.cyan)),
                                      labelText: 'RequiredDate',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                            enabled: true,
                            minLines: 1,
                            maxLines: 15,
                            controller: Description,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.cyan)),
                              labelText: 'Description',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )),

                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: TextButton.icon(
                                onPressed: () {
                                  UpdateCustomerDetails();
                                  print('Save Test');
                                },
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future UpdateCustomerDetails() async {
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": "3",
      "CompanyName": TicketNo.text,
      "CompanyAddress": Description.text,
      "Country": RequiredDate.text,
      "State": branchID,
      "City": "",
      "ZipCode": "",
      "Landmark": "",
      "MobileNo": "",
      "EMail": "",
      "UserName": ""
    };
    var Header = {"Content-Type": "application/json"};
    var response = await http.post(
        Uri.parse(AppConstants.LIVE_URL+ 'UpdateMaster'),
        body: json.encode(body),
        headers: Header);
    print(json.encode(body));

    if (response.statusCode == 200) {
      final decode = jsonDecode(response.body);
      if (decode["status"].toString() == "1") {
        Fluttertoast.showToast(msg: "successfully!!");
        Navigator.pop(context);
        cutTicketStatusData();
      } else {
        Fluttertoast.showToast(msg: "Not Inserted!!");
      }
    } else {
      loading = false;
      print("Somthing Worng Kindly Check Network...");
    }
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ReportsDashBoard()));
    return Future.value(true);
  }
}

/*class BackendService {
  static Future<List> getEmployee(String query) async {
    List<String> s = [];
    print(ReportListState.empDataList.result.length);
    for (int i = 0; i < ReportListState.empDataList.result.length; i++) {
      if (ReportListState.empDataList.result[i].empName
          .toLowerCase()
          .contains(query.toLowerCase())) {
        print("data");
        s.add(ReportListState.empDataList.result[i].empName);
      }
    }
    return s;
    // }
  }
}*/

class empModel {
  String cusEmpName;

  empModel(
    this.cusEmpName,
  );
}
