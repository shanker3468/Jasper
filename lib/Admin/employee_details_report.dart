import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ADMIN Models/UserDataModel.dart';
import '../AppConstants.dart';
import '../ServiceStation/TicketCreation.dart';
import 'package:flutter_switch/flutter_switch.dart';


class EmployeeDetailsReport extends StatefulWidget {
  EmployeeDetailsReport({Key? key,}) : super(key: key);


  @override
  EmployeeDetailsReportState createState() => EmployeeDetailsReportState();
}

class EmployeeDetailsReportState extends State<EmployeeDetailsReport> {
  bool loading = false;
  var UserName = "";
  var UserID = "";
  var branchID = "";
  var BranchName = "";
  var DepartmentCode = "";
  var DepartmentName = "";
  var Location = "";

  late String Count;

  List<itemsearch> li8 = [];

  late UserDataModel li6;

  late String empstatus;
  bool empStatus = false;



  int formID = 0;

  TextEditingController Email = new TextEditingController();
  TextEditingController Country = new TextEditingController();
  TextEditingController EmpID = new TextEditingController();
  TextEditingController ZipCode = new TextEditingController();
  TextEditingController LandMark = new TextEditingController();
  TextEditingController MobileNumber = new TextEditingController();
  TextEditingController MobilePassword = new TextEditingController();
  TextEditingController firstName = new TextEditingController();
  TextEditingController designation = new TextEditingController();
  TextEditingController department = new TextEditingController();

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

      EmployeeDatas(formID);
    });
  }

  @override
  void initState() {


    li8.clear();
    getStringValuesSF();



    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(

          title: Text('Employee Details'),
          actions: [

            /*Center(
              child: Column(
                children: [
                  IconButton(
                      icon: const Icon(Icons.add_circle_outlined),
                      tooltip: 'Add New',
                      onPressed: () {

                      }),
                ],
              ),
            ),*/

          ],

        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8),
                      Container(
                        height: height / 15,
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 0, left: 10, right: 10),
                        child: TextField(
                            // controller: Searchcontroller,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.search),
                              hintText: 'Search Here',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blueAccent, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.0),
                              ),
                            ),
                            onChanged: (vvv) {
                              print("hgj");
                              li8.clear();
                              // li8.details.clear();
                              for (int i = 0; i < li6.result!.length; i++)
                                if ((li6.result![i].empStatus
                                        .toString()
                                        .toLowerCase()
                                        .contains(vvv)) ||
                                    (li6.result![i].empID
                                        .toString()
                                        .toLowerCase()
                                        .contains(vvv)) ||
                                    (li6.result![i].firstName
                                        .toString()
                                        .toLowerCase()
                                        .contains(vvv)) ||
                                    (li6.result![i].department
                                        .toString()
                                        .toLowerCase()
                                        .contains(vvv)))
                                  li8.add(
                                    itemsearch(
                                        li6.result![i].docNo,
                                        li6.result![i].firstName,
                                        li6.result![i].lastName,
                                        li6.result![i].empID,
                                        li6.result![i].branchName,
                                        li6.result![i].branchCode,
                                        li6.result![i].empCategory,
                                        li6.result![i].mobUserID,
                                        li6.result![i].mobUserPassword,
                                        li6.result![i].mobileNo,
                                        li6.result![i].email,
                                        li6.result![i].department,
                                        li6.result![i].deptCode,
                                        li6.result![i].createdDate,
                                        li6.result![i].adminUser,
                                        li6.result![i].location,
                                        li6.result![i].empStatus,
                                        li6.result![i].deviceID,
                                        li6.result![i].empGroup
                                      ),
                                  );

                              print(li8.length);
                              setState(() {});
                            }),
                      ),
                      li8 != null
                          ? SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 0, left: 5, right: 5),
                                  child: DataTable(
                                    // onSelectAll: n,
                                    headingRowColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => Colors.blue.shade400),

                                    showCheckboxColumn: false,
                                    columnSpacing: 15,
                                    columns: [
                                      DataColumn(
                                        label: Center(
                                            child: Wrap(
                                          direction: Axis.vertical, //default
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Text(
                                              "S.No",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                            child: Wrap(
                                          direction: Axis.vertical, //default
                                          alignment: WrapAlignment.center,
                                          children: [
                                            Text(
                                              "Edit",
                                              softWrap: true,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        )),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text(
                                                "EmpID",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text("Emp Name",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text("Emp Status",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text(
                                                "Mob UserName",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text(
                                                "Password",
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),

                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text("EmpGroup",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text("Location",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                      DataColumn(
                                        label: Center(
                                          child: Wrap(
                                            direction: Axis.vertical, //default
                                            alignment: WrapAlignment.center,
                                            children: [
                                              Text("Contact No",
                                                  softWrap: true,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                        numeric: false,
                                      ),
                                    ],

                                    rows: li8
                                        .map(
                                          (list) => DataRow(cells: [
                                            DataCell(Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction:Axis.vertical, //default
                                                      alignment:WrapAlignment.center,
                                                      children: [
                                                        Text((li8.indexOf(list) +1).toString(),
                                                            textAlign:TextAlign.center)
                                                      ]),
                                                ))),
                                            DataCell(
                                                Center(
                                                  child: Center(
                                                    child: Wrap(
                                                        direction: Axis
                                                            .vertical, //default
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            color: Colors.indigo
                                                                .withOpacity(
                                                                    0.8),
                                                          )
                                                        ]),
                                                  ),
                                                ), onTap: () {
                                              print(list.empID);

                                              empStatus = list.empStatus == "A" ? true : false;
                                              EmpID.text= list.empID.toString();
                                              MobileNumber.text=list.mobileNo.toString();
                                              MobilePassword.text=list.mobUserPassword.toString();

                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return Padding(
                                                      padding:
                                                      const EdgeInsets.all(1.0),
                                                      child: AlertDialog(
                                                        content: StatefulBuilder(
                                                          builder: (BuildContext
                                                          context,
                                                              void Function(
                                                                  void Function())
                                                              setState) {
                                                            return Container(
                                                              child:
                                                              SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                  MainAxisSize
                                                                      .min, // To make the card compact
                                                                  children: <Widget>[
                                                                    Text("Do You Want to Update ?"),
                                                                    SizedBox(height: 5,),
                                                                    Text("UserName="+list.firstName.toString(),style: TextStyle(fontWeight:FontWeight.bold),),

                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Container(
                                                                            height: height / 15,
                                                                            width: width,
                                                                            child: TextField(
                                                                                enabled: false,
                                                                                controller: EmpID,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                      borderSide:
                                                                                      BorderSide(color: Colors.cyan)),
                                                                                  labelText: 'Emp ID',
                                                                                  labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.grey),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Padding(
                                                                            padding:
                                                                            const EdgeInsets.symmetric(horizontal: 15.0),
                                                                            child: FlutterSwitch(
                                                                              activeText: "Active",
                                                                              inactiveText: "InActive",
                                                                              width: width,
                                                                              height: 45.0,
                                                                              valueFontSize: 12.0,
                                                                              toggleSize: 25.0,
                                                                              value: empStatus,
                                                                              borderRadius: 30.0,
                                                                              showOnOff: true,
                                                                              onToggle: (val) {
                                                                                setState(() {
                                                                                  empStatus = val;
                                                                                  if (empStatus == false) {
                                                                                    empStatus == true;
                                                                                  } else {
                                                                                    empStatus == false;
                                                                                  }

                                                                                  print(empStatus);
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Container(
                                                                            height: height / 15,
                                                                            width: width,
                                                                            child: TextField(
                                                                                enabled: true,
                                                                                controller: MobilePassword,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                      borderSide:
                                                                                      BorderSide(color: Colors.cyan)),
                                                                                  labelText: 'Mob Password',
                                                                                  labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.grey),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: 2,
                                                                          child: Container(
                                                                            height: height / 15,
                                                                            width: width,
                                                                            child: TextField(
                                                                                enabled: true,
                                                                                controller: MobileNumber,
                                                                                keyboardType: TextInputType.number,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                      borderSide:
                                                                                      BorderSide(color: Colors.cyan)),
                                                                                  labelText: 'Mob Number',
                                                                                  labelStyle: TextStyle(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.grey),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),



                                                              /*      Padding(
                                                                      padding: const EdgeInsets.all(8),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Text("Select Status", style: TextStyle(fontWeight:FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                    ),



                                                                    DropdownSearch<String>(
                                                                      mode: Mode.DIALOG,
                                                                      showSearchBox: true,
                                                                      // showClearButton: true,

                                                                      // label: "Select Screen",
                                                                      items: stringlist7,
                                                                      onChanged: (val) {
                                                                        print(val);
                                                                        for (int kk = 0; kk < li10.result!.length; kk++) {
                                                                          if (li10.result![kk].statusName == val) {
                                                                            TicketStatus = li10.result![kk].statusName.toString();
                                                                            TicketStatusCode = li10.result![kk].statusCode.toString();
                                                                            setState(() {
                                                                              print(TicketStatus);
                                                                              //GetMyTablRecord();
                                                                            });
                                                                          }
                                                                        }

                                                                        if(TicketStatus=="Assign"){
                                                                          getAssignEmployeeDepartment();

                                                                          setState(() {
                                                                            ItemVisible=true;
                                                                          });


                                                                        }else{
                                                                          setState(() {
                                                                            ItemVisible=false;
                                                                          });
                                                                        }

                                                                        setState(() {

                                                                        });
                                                                      },
                                                                      selectedItem: TicketStatus,
                                                                    ),

                                                                    Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text("Select Assign Department", style: TextStyle(fontWeight:FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        DropdownSearch<String>(
                                                                          mode: Mode.DIALOG,
                                                                          showSearchBox: true,
                                                                          // showClearButton: true,

                                                                          // label: "Select Screen",
                                                                          items: stringlist8,
                                                                          onChanged: (val) {
                                                                            print(val);
                                                                            for (int kk = 0; kk < li11.result!.length; kk++) {
                                                                              if (li11.result![kk].departmentName == val) {
                                                                                AssignDepartment = li11.result![kk].departmentName.toString();
                                                                                AssignDepartmentCode = li11.result![kk].departmentCode.toString();
                                                                                setState(() {
                                                                                  print(AssignDepartment);
                                                                                  //GetMyTablRecord();
                                                                                });
                                                                              }
                                                                            }

                                                                            setState(() {

                                                                              getAssignEmployeeListBasedOnDepartment(AssignDepartment);

                                                                            });
                                                                          },
                                                                          selectedItem: AssignDepartment,
                                                                        ),


                                                                        Padding(
                                                                          padding: const EdgeInsets.all(8),
                                                                          child: Row(
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text("Select Assign EmpName", style: TextStyle(fontWeight:FontWeight.bold)),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        DropdownSearch<String>(
                                                                          mode: Mode.DIALOG,
                                                                          showSearchBox: true,
                                                                          // showClearButton: true,

                                                                          // label: "Select Screen",
                                                                          items: stringlist9,
                                                                          onChanged: (val) {
                                                                            print(val);
                                                                            for (int kk = 0; kk < li12.result!.length; kk++) {
                                                                              if (li12.result![kk].firstName == val) {
                                                                                AssignEmpName = li12.result![kk].firstName.toString();
                                                                                AssignEmpNameCode = li12.result![kk].empID.toString();
                                                                                setState(() {
                                                                                  print(AssignEmpName);
                                                                                  //GetMyTablRecord();
                                                                                });
                                                                              }
                                                                            }


                                                                          },
                                                                          selectedItem: AssignEmpName,
                                                                        ),
                                                                      ],
                                                                    ),*/

                                                                    SizedBox(
                                                                        height: 15.0),
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width: 8,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                          TextButton
                                                                              .icon(
                                                                            onPressed:
                                                                                () {
                                                                              // TicketStatusCode="";
                                                                              // TicketStatus="";
                                                                              //
                                                                              // AssignDepartment="";
                                                                              // AssignDepartmentCode="";
                                                                              //
                                                                              // AssignEmpName="";
                                                                              // AssignEmpNameCode="";

                                                                              Fluttertoast.showToast(
                                                                                  msg:
                                                                                  "Update Cancelled!!",
                                                                                  backgroundColor:
                                                                                  Colors.red);
                                                                              Navigator.pop(
                                                                                  context);
                                                                              // call();
                                                                            },
                                                                            icon:
                                                                            Icon(
                                                                              Icons
                                                                                  .cancel,
                                                                              color: Colors
                                                                                  .white,
                                                                            ),
                                                                            label:
                                                                            Text(
                                                                              'Cancel',
                                                                              style: TextStyle(
                                                                                  color:
                                                                                  Colors.white),
                                                                            ),
                                                                            style: TextButton
                                                                                .styleFrom(
                                                                              backgroundColor:
                                                                              Colors.red,
                                                                              shape:
                                                                              RoundedRectangleBorder(
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
                                                                          child:
                                                                          TextButton
                                                                              .icon(
                                                                            onPressed:
                                                                                () {


                                                                              // if(TicketStatus=="Assign"){
                                                                              //
                                                                              //   if (TicketStatus.isEmpty) {
                                                                              //     Fluttertoast.showToast(
                                                                              //         msg: "TicketStatus should not left Empty!!",
                                                                              //         toastLength: Toast.LENGTH_LONG,
                                                                              //         gravity: ToastGravity.SNACKBAR,
                                                                              //         timeInSecForIosWeb: 1,
                                                                              //         textColor: Colors.white,
                                                                              //         backgroundColor: Colors.red,
                                                                              //         fontSize: 16.0);
                                                                              //   }else  if (AssignDepartment.isEmpty) {
                                                                              //     Fluttertoast.showToast(
                                                                              //         msg: "AssignDepartment should not left Empty!!",
                                                                              //         toastLength: Toast.LENGTH_LONG,
                                                                              //         gravity: ToastGravity.SNACKBAR,
                                                                              //         timeInSecForIosWeb: 1,
                                                                              //         textColor: Colors.white,
                                                                              //         backgroundColor: Colors.red,
                                                                              //         fontSize: 16.0);
                                                                              //   }else  if (AssignEmpName.isEmpty) {
                                                                              //     Fluttertoast.showToast(
                                                                              //         msg: "AssignEmpName should not left Empty!!",
                                                                              //         toastLength: Toast.LENGTH_LONG,
                                                                              //         gravity: ToastGravity.SNACKBAR,
                                                                              //         timeInSecForIosWeb: 1,
                                                                              //         textColor: Colors.white,
                                                                              //         backgroundColor: Colors.red,
                                                                              //         fontSize: 16.0);
                                                                              //   }else{
                                                                              //
                                                                              //     print("Empty true");
                                                                              //
                                                                              //
                                                                              //     selectedDatalist.clear();
                                                                              //
                                                                              //
                                                                              //     selectedDatalist.add(selectedListModel(
                                                                              //         int.tryParse(list.docNo.toString()),
                                                                              //         list.ticketNo,
                                                                              //         list.brachName,
                                                                              //         TicketStatusCode,
                                                                              //         AssignEmpName,
                                                                              //         AssignEmpNameCode,
                                                                              //         AssignDepartment,
                                                                              //         '',
                                                                              //         ''
                                                                              //     ));
                                                                              //
                                                                              //
                                                                              //     BulkinsertStatusTickets();
                                                                              //     Navigator.pop(context);
                                                                              //
                                                                              //
                                                                              //   }
                                                                              //
                                                                              //
                                                                              //
                                                                              // }else{
                                                                              //
                                                                              //
                                                                              //
                                                                              //   if (TicketStatus.isEmpty) {
                                                                              //     Fluttertoast.showToast(
                                                                              //         msg: "TicketStatus should not left Empty!!",
                                                                              //         toastLength: Toast.LENGTH_LONG,
                                                                              //         gravity: ToastGravity.SNACKBAR,
                                                                              //         timeInSecForIosWeb: 1,
                                                                              //         textColor: Colors.white,
                                                                              //         backgroundColor: Colors.red,
                                                                              //         fontSize: 16.0);
                                                                              //   }else{
                                                                              //
                                                                              //     print("Empty false");
                                                                              //     selectedDatalist.clear();
                                                                              //
                                                                              //
                                                                              //     selectedDatalist.add(selectedListModel(
                                                                              //         int.tryParse(list.docNo.toString()),
                                                                              //         list.ticketNo,
                                                                              //         list.brachName,
                                                                              //         TicketStatusCode,
                                                                              //         '',
                                                                              //         '',
                                                                              //         '',
                                                                              //         '',
                                                                              //         ''
                                                                              //     ));
                                                                              //
                                                                              //
                                                                              //     BulkinsertStatusTickets();
                                                                              //     Navigator.pop(context);
                                                                              //
                                                                              //
                                                                              //   }
                                                                              //
                                                                              // }


                                                                            },
                                                                            icon:
                                                                            Icon(
                                                                              Icons
                                                                                  .assignment_turned_in_outlined,
                                                                              color: Colors
                                                                                  .white,
                                                                            ),
                                                                            label:
                                                                            Text(
                                                                              'Update',
                                                                              style: TextStyle(
                                                                                  color:
                                                                                  Colors.white,
                                                                                  fontSize: 12),
                                                                            ),
                                                                            style: TextButton
                                                                                .styleFrom(
                                                                              backgroundColor:
                                                                              Colors.lightGreen,
                                                                              shape:
                                                                              RoundedRectangleBorder(
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
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  });
                                              // if (widget.ScreenType == "IE") {
                                              // } else {
                                              //   setState(() {
                                              //     EmployeeDetails(list.empID);
                                              // //   });
                                              //   Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             UpdateEmpDetails(
                                              //                 empid:
                                              //                     list.empID.toString())),
                                              //   );
                                              //}
                                            }),
                                            DataCell(
                                                Center(
                                                    child: Center(
                                                  child: Wrap(
                                                      direction: Axis
                                                          .vertical, //default
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          list.empID.toString(),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      ]),
                                                )),
                                                onTap: () {}),
                                            DataCell(Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction:
                                                      Axis.vertical, //default
                                                      alignment:
                                                      WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          list.firstName.toString(),
                                                          textAlign:
                                                          TextAlign.center,
                                                        )
                                                      ]),
                                                ))),
                                            DataCell(Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction:
                                                      Axis.vertical, //default
                                                      alignment:
                                                      WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          list.empStatus=="A"?"Active":"InActive".toString(),
                                                          textAlign:
                                                          TextAlign.center,
                                                        )
                                                      ]),
                                                ))),
                                            DataCell(Center(
                                                child: Center(
                                                  child: Wrap(
                                                      direction:
                                                      Axis.vertical, //default
                                                      alignment:
                                                      WrapAlignment.center,
                                                      children: [
                                                        Text(
                                                          list.mobUserID.toString(),
                                                          textAlign:
                                                          TextAlign.center,
                                                        )
                                                      ]),
                                                ))),
                                            DataCell(Center(
                                                child: Center(
                                              child: Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.center,
                                                  children: [
                                                    Text(
                                                      list.mobUserPassword.toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  ]),
                                            ))),
                                            DataCell(
                                              Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Text(
                                                        list.empGroup
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.start)
                                                  ]),
                                            ),
                                            DataCell(
                                              Wrap(
                                                  direction:
                                                      Axis.vertical, //default
                                                  alignment:
                                                      WrapAlignment.start,
                                                  children: [
                                                    Text(
                                                        list.location.toString()
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.start)
                                                  ]),
                                            ),
                                            DataCell(Row(
                                              children: [
                                                Text(
                                                    list.mobileNo.toString(),
                                                    textAlign: TextAlign.center),
                                                list.mobileNo.toString()!=null
                                                    &&
                                                    list.mobileNo.toString().length>9?
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
                                                              var url = 'tel:${list.mobileNo.toString()}';

                                                              await launch(url);
                                                            },
                                                            child: Icon(
                                                              Icons.call,
                                                              color: Colors.green,
                                                            )))
                                                ):Container()
                                              ],
                                            )),

                                          ]),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Text("No Data"),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<http.Response> EmployeeDatas(int formid) async {

    print("getticketNo is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 15,
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

          li6 = UserDataModel.fromJson(jsonDecode(response.body));

          li8.clear();
          for (int i = 0; i < li6.result!.length; i++) {
            li8.add(
              itemsearch(
                  li6.result![i].docNo,
                  li6.result![i].firstName,
                  li6.result![i].lastName,
                  li6.result![i].empID,
                  li6.result![i].branchName,
                  li6.result![i].branchCode,
                  li6.result![i].empCategory,
                  li6.result![i].mobUserID,
                  li6.result![i].mobUserPassword,
                  li6.result![i].mobileNo,
                  li6.result![i].email,
                  li6.result![i].department,
                  li6.result![i].deptCode,
                  li6.result![i].createdDate,
                  li6.result![i].adminUser,
                  li6.result![i].location,
                  li6.result![i].empStatus,
                  li6.result![i].deviceID,
                  li6.result![i].empGroup),
            );

            li8.length != 0 ? Count = li8.length.toString() : Count = "0";
            // to taking all list count
          }



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

  /*Future<http.Response> EmployeeDatas(int formid) async {
    print("Employee data called");
    var body = {
      "FormID": formid,
      "Password": "",
      "UserName": "",
      "EmpID": sessionempID.toString(),
      "EmpName": "",
    };

    print(body);
    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });

    final response = await http.post(
      Uri.parse(IpAddressState.ipAddress + 'JasperLogin'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    print(response.body);
    print(response.statusCode);

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 1) {
        li6 = EmployeeMasterDataModel.fromJson(jsonDecode(response.body));

        li8.clear();
        for (int i = 0; i < li6.result.length; i++) {
          li8.add(
            itemsearch(
                li6.result[i].docNo,
                li6.result[i].firstName,
                li6.result[i].lastName,
                li6.result[i].empID,
                li6.result[i].mobUserID,
                li6.result[i].mobUserPassword,
                li6.result[i].mobileNo,
                li6.result[i].email,
                li6.result[i].department,
                li6.result[i].createdDate,
                li6.result[i].adminUser,
                li6.result[i].empIMIENo,
                li6.result[i].companyName,
                li6.result[i].designation,
                li6.result[i].location,
                li6.result[i].empStatus,
                li6.result[i].groupCode,
                li6.result[i].casualLeave,
                li6.result[i].deviceID,
                li6.result[i].createdDate,
                li6.result[i].empDOB,
                // li6.result[i].dateofJoin,
                li6.result[i].catrgory),
          );

          li8.length != 0 ? Count = li8.length.toString() : Count = "0";
          // to taking all list count
        }
      } else {
        setState(() {
          Fluttertoast.showToast(
              msg: "No Data!!!", backgroundColor: Colors.lightGreen);
        });
      }
      return response;
    } else {
      throw Exception('Something went wrong??!!');
    }
  }*/



  Future<http.Response> EmployeeDetails(String userName) async {
    print("inside");
    print("usernmae" + userName);
    setState(() {
      loading = true;
    });
    var body = {
      "FormID": 13,
      "Password": "",
      "UserName": userName,
      "EmpID": "",
      "EmpName": ""
    };
    var headers = {"Content-Type": "application/json"};

    final response = await http.post(
      Uri.parse('http://14.98.224.37:2121/updatePassword'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    setState(() {
      loading = false;
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not in Register!!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            fontSize: 16.0);
      } else {
        setState(() {
          firstName.text =
              jsonDecode(response.body)["result"][0]["FirstName"].toString();
          MobileNumber.text =
              jsonDecode(response.body)["result"][0]["MobileNo"].toString();
          department.text =
              jsonDecode(response.body)["result"][0]["Department"].toString();
          designation.text =
              jsonDecode(response.body)["result"][0]["Designation"].toString();
          Email.text =
              jsonDecode(response.body)["result"][0]["Email"].toString();

          // print(CompanyName.text);
        });
      }
      return response;
    } else {
      throw Exception('Something went wrong??!!');
    }
  }
}

class itemsearch {
  int? docNo;
  String? firstName;
  String? lastName;
  String? empID;
  String? branchName;
  String? branchCode;
  String? empCategory;
  String? mobUserID;
  String? mobUserPassword;
  String? mobileNo;
  String? email;
  String? department;
  int? deptCode;
  String? createdDate;
  String? adminUser;
  String? location;
  String? empStatus;
  String? deviceID;
  String? empGroup;

  itemsearch(
      this.docNo,
      this.firstName,
      this.lastName,
      this.empID,
      this.branchName,
      this.branchCode,
      this.empCategory,
      this.mobUserID,
      this.mobUserPassword,
      this.mobileNo,
      this.email,
      this.department,
      this.deptCode,
      this.createdDate,
      this.adminUser,
      this.location,
      this.empStatus,
      this.deviceID,
      this.empGroup
  );
}
