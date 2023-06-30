import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jasper/Admin/WipAssignTickets_DetailsView.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../ADMIN Models/AssignEmpDepartmentModel.dart';
import '../ADMIN Models/AssignEmpListBasedOnDepartmentModel.dart';
import '../ADMIN Models/BranchMasterModel.dart';
import '../ADMIN Models/CustomerTicketsModel.dart';
import '../ADMIN Models/TicketStatusFilterModel.dart';
import '../ADMIN Models/TicketStatusModel.dart';
import '../AppConstants.dart';
import '../Model/TicketTypeModel.dart';
import 'BranchAdminWipAssignTickets_DetailsView.dart';



class BranchAdminWIP_Assign_Tickets extends StatefulWidget {
   BranchAdminWIP_Assign_Tickets({ Key? key, required  String this.status,required String this.Tickettype,required String this.BranchName}) : super(key: key);

  String status;
  String BranchName;
   String Tickettype;

  @override
  BranchAdminWIP_Assign_TicketsState createState() => BranchAdminWIP_Assign_TicketsState();
}

class BranchAdminWIP_Assign_TicketsState extends State<BranchAdminWIP_Assign_Tickets> {
 // ApprovalPendingModel li2;

   TicketTypeModel li4=TicketTypeModel(result: []);
   CustomerTicketsModel li2 =CustomerTicketsModel(result: []);

   TicketStatusModel li10 =TicketStatusModel(result :[]);
   AssignEmpDepartmentModel li11=AssignEmpDepartmentModel(result :[]);
   TicketStatusFilterModel li13 =TicketStatusFilterModel(result :[]);
   AssignEmpListBasedOnDepartmentModel li12=AssignEmpListBasedOnDepartmentModel(result :[]);
  List<FilterList4> li3 = [];
  TextEditingController searchcontroller = new TextEditingController();
  TextEditingController RemarksController =new TextEditingController();
  String _searchResult = '';
   List<selectedListModel> selectedDatalist = [];


   bool ItemVisible =false;

  late  String UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location,EmpGroup;
  late bool sessionLoggedIn;

  var dropdownValue2 = "Select Ticket Type";
  var stringlist2 = ["Select Ticket Type"];

  String TicketType="";

   String Ticketcode="";

  var dropdownValue5 = "Select Branch";
  var stringlist5 = ["Select Branch"];


   var dropdownValue6 = "Select Ticket Type";
   var stringlist6 = ["Select Ticket Type"];


   var dropdownValue7 = "Select Ticket Status";
   var stringlist7 = ["Select Ticket Status"];

   var dropdownValue8 = "Select Department";
   var stringlist8 = ["Select Department"];

   var dropdownValue9 = "Select Employee";
   var stringlist9 = ["Select Employee"];

   var dropdownValue10 = "Select Ticket Status";
   var stringlist10 = ["Select Ticket Status"];


   String BranchName1="";

   String BranchCode="";



   String TicketStatusCode="";
   String TicketStatus="";


   String FilterStatusCode="";
   String FilterStatusName="";

   String AssignDepartment="";
   String AssignDepartmentCode="";

   String AssignEmpName="";
   String AssignEmpNameCode="";


  int _currentSortColumn = 0;
  bool _isAscending = true;

  int selectedIndex = 0;
   bool loading = false;

   int SumQty=0;






   var userid = "";
  var uSERID = "";
  var password = "";
  var uSERCODE = "";
  var uNAME = "";
  var gROUPS = "";
  var eMail = "";
  var locked = "";
  var department = "";
  var branch = "";
  var mobileUser = "";
  var portNum = "";
  var uLocation = "";
  var uUserType = "";
  var uMobileMacID = "";

  var page = 1;
  late int totalpages;
  List<String> selectedlist = [];
  var format = NumberFormat.currency(
    locale: 'HI',
    symbol: "",
  );
  @override
  void initState() {
    getStringValuesSF();
    super.initState();
    // if(widget.status=="2"){
    //   getTicketList1();
    // }
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      //  backgroundColor: Colors.indigo,
        appBar: AppBar(

          title: Text('Tickets'),
          actions: [

                        IconButton(
                        icon: const Icon(Icons.save),
                        tooltip: 'Approve All',
                        onPressed: () {
                          if (selectedlist.length == 0 || selectedlist.length == null) {
                            showDialogbox(context, "Select Atleast one Ticket!!");
                          } else {


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
                                                  Text("Do You Want to Proceed ?"),
                                                  SizedBox(height: 5,),
                                                  Text("TicketStatus="+FilterStatusName.toString(),style: TextStyle(fontWeight:FontWeight.bold),),

                                                  Padding(
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

                                                  Visibility(
                                                    visible: ItemVisible,
                                                    child: Column(
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
                                                    ),




                                                  ),

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
                                                            TicketStatusCode="";
                                                            TicketStatus="";

                                                            AssignDepartment="";
                                                            AssignDepartmentCode="";

                                                            AssignEmpName="";
                                                            AssignEmpNameCode="";
                                                            ItemVisible=false;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                "Assign Cancelled!!",
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


                                                            if(TicketStatus=="Assign"){

                                                              if (TicketStatus.isEmpty) {
                                                                Fluttertoast.showToast(
                                                                    msg: "TicketStatus should not left Empty!!",
                                                                    toastLength: Toast.LENGTH_LONG,
                                                                    gravity: ToastGravity.SNACKBAR,
                                                                    timeInSecForIosWeb: 1,
                                                                    textColor: Colors.white,
                                                                    backgroundColor: Colors.red,
                                                                    fontSize: 16.0);
                                                              }else  if (AssignDepartment.isEmpty) {
                                                                Fluttertoast.showToast(
                                                                    msg: "AssignDepartment should not left Empty!!",
                                                                    toastLength: Toast.LENGTH_LONG,
                                                                    gravity: ToastGravity.SNACKBAR,
                                                                    timeInSecForIosWeb: 1,
                                                                    textColor: Colors.white,
                                                                    backgroundColor: Colors.red,
                                                                    fontSize: 16.0);
                                                              }else  if (AssignEmpName.isEmpty) {
                                                                Fluttertoast.showToast(
                                                                    msg: "AssignEmpName should not left Empty!!",
                                                                    toastLength: Toast.LENGTH_LONG,
                                                                    gravity: ToastGravity.SNACKBAR,
                                                                    timeInSecForIosWeb: 1,
                                                                    textColor: Colors.white,
                                                                    backgroundColor: Colors.red,
                                                                    fontSize: 16.0);
                                                              }else{

                                                                print("Empty true");


                                                                selectedDatalist.clear();

                                                                for (int k = 0; k < li2.result!.length; k++) {
                                                                  for (int j = 0; j < selectedlist.length; j++) {
                                                                    if (selectedlist[j] ==
                                                                        li2.result![k].docNo.toString()) {


                                                                      selectedDatalist.add(selectedListModel(
                                                                          li2.result![k].docNo,
                                                                          li2.result![k].ticketNo,
                                                                          li2.result![k].brachName,
                                                                          TicketStatusCode,
                                                                          AssignEmpName,
                                                                          AssignEmpNameCode,
                                                                          AssignDepartment,
                                                                          '',
                                                                          UserID.toString()
                                                                      ));

                                                                    }
                                                                  }
                                                                }


                                                                BulkinsertStatusTickets();
                                                                Navigator.pop(context);


                                                              }



                                                            }else{



                                                              if (TicketStatus.isEmpty) {
                                                                Fluttertoast.showToast(
                                                                    msg: "TicketStatus should not left Empty!!",
                                                                    toastLength: Toast.LENGTH_LONG,
                                                                    gravity: ToastGravity.SNACKBAR,
                                                                    timeInSecForIosWeb: 1,
                                                                    textColor: Colors.white,
                                                                    backgroundColor: Colors.red,
                                                                    fontSize: 16.0);
                                                              }else{

                                                                print("Empty false");
                                                                selectedDatalist.clear();

                                                                for (int k = 0; k < li2.result!.length; k++) {
                                                                  for (int j = 0; j < selectedlist.length; j++) {
                                                                    if (selectedlist[j] ==
                                                                        li2.result![k].docNo.toString()) {


                                                                      selectedDatalist.add(selectedListModel(
                                                                          li2.result![k].docNo,
                                                                          li2.result![k].ticketNo,
                                                                          li2.result![k].brachName,
                                                                          TicketStatusCode,
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          '',
                                                                          UserID.toString()
                                                                      ));

                                                                    }
                                                                  }
                                                                }


                                                                BulkinsertStatusTickets();
                                                                Navigator.pop(context);


                                                              }

                                                            }

                                                            // selectState =
                                                            // 1;
                                                            // print(
                                                            //     selectState);
                                                            //
                                                            // insertData();
                                                            // Navigator.pop(
                                                            //     context);
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
                                                            'Submit',
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



                          }

                        }),
                    IconButton(
                        icon: const Icon(Icons.cancel),
                        tooltip: 'Reject All',
                        onPressed: () {

                          if (selectedlist.length == 0 || selectedlist.length == null) {
                            showDialogbox(context, "Select Atleast one Ticket!!");
                          } else {
                             RejectAll(context);
                          }

                        }),


            /*TextButton(

              style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20,color:Colors.green),),
              onPressed: () {
                if (li2.result!.length == 0 || li2.result!.length == null) {
                  showDialogbox(context, "Row Should not Empty");
                } else {

               //   ApproveAll(context);

                }
              },
              child: Text("Approve All"),

            ),
            TextButton(
              style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20,color:Colors.redAccent,decorationColor:Colors.cyan),),
              onPressed: () {
                if (li2.result!.length == 0 || li2.result!.length == null) {
                  showDialogbox(context, "Row Should not Empty");
                } else {
                 // RejectAll(context);
                }
              },
              child: Text("Reject All"),
            ),*/
          ],
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Container(
            child: Column(
              children: [


                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Select Ticket Type", style: TextStyle(fontWeight:FontWeight.bold)),
                    ],
                  ),
                ),


                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  // showClearButton: true,

                  // label: "Select Screen",
                  items: stringlist2,
                  onChanged: (val) {
                    print(val);
                    for (int kk = 0; kk < li4.result!.length; kk++) {
                      if (li4.result![kk].type == val) {
                        TicketType = li4.result![kk].type.toString();
                        Ticketcode = li4.result![kk].typeCode.toString();
                        setState(() {
                          print(TicketType);
                          print(Ticketcode);

                          //GetMyTablRecord();
                        });
                      }
                    }

                    setState(() {
                     if (TicketType.isNotEmpty&&FilterStatusName.isEmpty){
                       print("TicketType.isNotEmpty && FilterStatusName.isEmpty");
                       getTicketListBasedOnTicketCategory();
                      } else if(TicketType.isEmpty&&FilterStatusName.isNotEmpty){
                       print("TicketType.isEmpty&&FilterStatusName.isNotEmpty");
                       getTicketList1(FilterStatusCode);

                     }else {

                       print("TicketType.isNotEmpty&&FilterStatusName.isNotEmpty");
                       getTicketList(FilterStatusCode);


                      }
                    });



                  },
                  selectedItem: TicketType,
                ),




                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Ticket Status", style: TextStyle(fontWeight:FontWeight.bold)),
                      Text("Count", style: TextStyle(fontWeight:FontWeight.bold)),
                    ],
                  ),
                ),



                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: DropdownSearch<String>(
                        mode: Mode.DIALOG,
                        showSearchBox: true,
                        // showClearButton: true,

                        // label: "Select Screen",
                        items: stringlist10,
                        onChanged: (val) {
                          print(val);

                          for (int kk = 0; kk < li13.result!.length; kk++) {
                            if (li13.result![kk].statusName == val) {
                              FilterStatusName = li13.result![kk].statusName.toString();
                              FilterStatusCode = li13.result![kk].statusCode.toString();
                              setState(() {
                                print(FilterStatusName);
                                //GetMyTablRecord();
                              });
                            }
                          }

                          setState(() {
                            if (TicketType.isNotEmpty&&FilterStatusName.isEmpty){
                              print("TicketType.isNotEmpty && FilterStatusName.isEmpty");
                              getTicketListBasedOnTicketCategory();
                            } else if(TicketType.isEmpty&&FilterStatusName.isNotEmpty){
                              print("TicketType.isEmpty&&FilterStatusName.isNotEmpty");
                              getTicketList1(FilterStatusCode);

                            }else {

                              print("TicketType.isNotEmpty&&FilterStatusName.isNotEmpty");
                              getTicketList(FilterStatusCode);


                            }
                          });



                         /* setState(() {

                            selectedlist.clear();
                            if (TicketType.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "TicketType should not left Empty!!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  fontSize: 16.0);
                            } else  if (BranchName1.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "BranchName should not left Empty!!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.SNACKBAR,
                                  timeInSecForIosWeb: 1,
                                  textColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  fontSize: 16.0);
                            } else {

                              getTicketList(FilterStatusCode);

                            }
                          });*/
                        },
                        selectedItem: FilterStatusName,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: height/16,
                              color:Colors.black12,
                              child: Center(child: Text(SumQty.toString(), style: TextStyle(fontWeight:FontWeight.bold,color:Colors.red)))),
                        )),
                  ],
                ),

                SizedBox(height: 5,),



                Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: searchcontroller,
                      decoration: new InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          _searchResult = value;
                          if (li2 != null) {
                            li3.clear();
                            for (int k = 0; k < li2.result!.length; k++)
                              if (li2.result![k].docNo
                                  .toString()
                                  .toLowerCase()
                                  .contains(value) ||
                                  li2.result![k].ticketNo
                                      .toString()
                                      .toLowerCase()
                                      .contains(value) ||
                                  li2.result![k].empName
                                      .toString()
                                      .toLowerCase()
                                      .contains(value) ||
                                  li2.result![k].category
                                      .toString()
                                      .toLowerCase()
                                      .contains(value) ||
                                  li2.result![k].issueCatrgory
                                      .toString()
                                      .toLowerCase()
                                      .contains(value)||
                                  li2.result![k].priority
                                      .toString()
                                      .toLowerCase()
                                      .contains(value)||
                                  li2.result![k].category
                                      .toString()
                                      .toLowerCase()
                                      .contains(value)||
                                  li2.result![k].brachName
                                      .toString()
                                      .toLowerCase()
                                      .contains(value)

                              )
                                li3.add(FilterList4(

                                    li2.result![k].createdDate,
                                    li2.result![k].docNo,
                                    li2.result![k].brachName,
                                    li2.result![k].branchCode,
                                    li2.result![k].issueCatrgory,
                                    li2.result![k].issueCategoryId,
                                    li2.result![k].itemName,
                                    li2.result![k].itemCode,
                                    li2.result![k].issueType,
                                    li2.result![k].requiredDate,
                                    li2.result![k].description,
                                    li2.result![k].attachFilePath,
                                    li2.result![k].attachFileName,
                                    li2.result![k].status,
                                    li2.result![k].closedDate,
                                    li2.result![k].empName,
                                    li2.result![k].empContactNo,
                                    li2.result![k].empMailid,
                                    li2.result![k].rejectRemarks,
                                    li2.result![k].createdAt,
                                    li2.result![k].updatedAt,
                                    li2.result![k].priority,
                                    li2.result![k].category,
                                    li2.result![k].modifiedDate,
                                    li2.result![k].assignStatus,
                                    li2.result![k].ticketNo,
                                    li2.result![k].assignEmpName,
                                    li2.result![k].assignEmpId,
                                    li2.result![k].assignEmpDept,
                                    li2.result![k].solutionProvided,
                                    li2.result![k].endDate,
                                    li2.result![k].startDate,
                                    li2.result![k].assignEmpcontactNo,
                                    li2.result![k].assetName,
                                    li2.result![k].assetCode

                                ));
                          }
                        });
                      },
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          _searchResult = "";
                          searchcontroller.text = "";

                          if (li2 != null) {
                            li3.clear();
                            for (int k = 0; k < li2.result!.length; k++)
                              li3.add(FilterList4(
                                  li2.result![k].createdDate,
                                  li2.result![k].docNo,
                                  li2.result![k].brachName,
                                  li2.result![k].branchCode,
                                  li2.result![k].issueCatrgory,
                                  li2.result![k].issueCategoryId,
                                  li2.result![k].itemName,
                                  li2.result![k].itemCode,
                                  li2.result![k].issueType,
                                  li2.result![k].requiredDate,
                                  li2.result![k].description,
                                  li2.result![k].attachFilePath,
                                  li2.result![k].attachFileName,
                                  li2.result![k].status,
                                  li2.result![k].closedDate,
                                  li2.result![k].empName,
                                  li2.result![k].empContactNo,
                                  li2.result![k].empMailid,
                                  li2.result![k].rejectRemarks,
                                  li2.result![k].createdAt,
                                  li2.result![k].updatedAt,
                                  li2.result![k].priority,
                                  li2.result![k].category,
                                  li2.result![k].modifiedDate,
                                  li2.result![k].assignStatus,
                                  li2.result![k].ticketNo,
                                  li2.result![k].assignEmpName,
                                  li2.result![k].assignEmpId,
                                  li2.result![k].assignEmpDept,
                                  li2.result![k].solutionProvided,
                                  li2.result![k].endDate,
                                  li2.result![k].startDate,
                                  li2.result![k].assignEmpcontactNo,
                                  li2.result![k].assetName,
                                  li2.result![k].assetCode
                              ));
                          }
                        });
                      },
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(5.0),
                  scrollDirection: Axis.horizontal,
                  child: li2.result!.length>0
                      ? DataTable(
                    columnSpacing: 20.0,
                    headingRowColor:
                    MaterialStateProperty.all(Colors.blue),
                    sortColumnIndex: _currentSortColumn,
                    sortAscending: _isAscending,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'View',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if(FilterStatusName=="")DataColumn(
                        label: Text(
                          'TicketType',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Ticket No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Branch Name',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Priority',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Issuetype',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if(FilterStatusName=="Work IN Progress")DataColumn(
                        label: Text(
                          'AssignEmpName',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if(FilterStatusName=="Work IN Progress")DataColumn(
                        label: Text(
                          'AssignEmpContactNo',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),


                      if(TicketType=="Tools")DataColumn(
                        label: Text(
                          'ItemCategory',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if(TicketType=="Tools")DataColumn(
                        label: Text(
                          'ItemName',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      if(TicketType=="Assets")DataColumn(
                        label: Text(
                          'AssetCode',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if(TicketType=="Assets")DataColumn(
                        label: Text(
                          'AssetName',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'RequiredDate',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Discription',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Attachment',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'CreatedBy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),


                      DataColumn(
                        label: Text(
                          'Action',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Reject',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: li3
                        .map(
                          (list) => DataRow(
                          selected: selectedlist.contains(
                              list.docNo.toString()),
                          onSelectChanged: (value) {
                            if (value == true) {
                              setState(() {
                                selectedlist.add(
                                    list.docNo.toString());

                              });
                            } else {
                              setState(() {
                                selectedlist.remove(
                                    list.docNo.toString());
                              });
                            }
                          },
                          cells: [
                            DataCell(
                              Center(
                                child: Center(
                                  child: Wrap(
                                      direction: Axis
                                          .vertical, //default
                                      alignment:
                                      WrapAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              print(list.docNo);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          BranchAdminWipAssignTicketsDetailsView(
                                                            draftno:
                                                            int.parse(list.docNo.toString()),TicketType:list.category.toString(),list2: li3,id:li3.indexOf(list), Branch1:BranchName1
                                                            /*callback:
                                                                              getpendingapprovallist*/
                                                          )));
                                            },
                                            icon: Icon(Icons
                                                .remove_red_eye_outlined))
                                      ]),
                                ),
                              ),
                            ),
                            if(FilterStatusName=="")DataCell(Text(
                                list.category.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.ticketNo.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.brachName.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                style: TextStyle(fontWeight:FontWeight.bold,color:list.priority.toString()=="High"?Colors.red:list.priority.toString()=="Medium"?Colors.orangeAccent:Colors.green,),
                                list.priority.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.issueType.toString(),
                                textAlign: TextAlign.center)),
                            if(FilterStatusName=="Work IN Progress")DataCell(Text(
                                list.assignEmpName.toString(),
                                textAlign: TextAlign.center)),
                            if(FilterStatusName=="Work IN Progress")DataCell(Row(
                              children: [
                                Text(
                                    list.assignEmpcontactNo.toString(),
                                    textAlign: TextAlign.center),
                                list.assignEmpcontactNo.toString()!=null
                                    &&
                                    list.assignEmpcontactNo.toString().length>9?
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
                                              var url = 'tel:${list.assignEmpcontactNo.toString()}';

                                              await launch(url);
                                            },
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.green,
                                            )))
                                ):Container()
                              ],
                            )),
                            if(TicketType=="Tools")DataCell(Text(
                                list.itemName.toString(),
                                textAlign: TextAlign.center)),
                            if(TicketType=="Tools")DataCell(Text(
                                list.itemName.toString(),
                                textAlign: TextAlign.center)),
                            if(TicketType=="Assets")DataCell(Text(
                                list.assetCode.toString(),
                                textAlign: TextAlign.center)),
                            if(TicketType=="Assets")DataCell(Text(
                                list.assetName.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.requiredDate.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Wrap(
                                direction:
                                Axis.vertical, //default
                                alignment: WrapAlignment.center,
                                children: [
                                  Text(
                                      (list.description.toString()),
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight:
                                          FontWeight.bold),
                                      textAlign:
                                      TextAlign.center)
                                ])),
                            DataCell(list.attachFileName.toString()!=null
                                &&
                                list.attachFileName.toString().isNotEmpty?Column(
                              children: [
                                new TextButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (BuildContext context) {
                                        return Center(
                                          child: Container(
                                            padding:
                                            EdgeInsets.all(8),
                                            color: Colors
                                                .transparent,
                                            child:
                                            SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Image
                                                      .network(
                                                    AppConstants.LIVE_URL+
                                                        list.attachFileName.toString(),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical:
                                                        8.0,
                                                        horizontal:
                                                        15),
                                                    child:
                                                    TextButton
                                                        .icon(
                                                      onPressed:
                                                          () {
                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .cancel_presentation,
                                                        color: Colors
                                                            .white,
                                                      ),
                                                      label: Text(
                                                        'Close',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontSize:
                                                            12),
                                                      ),
                                                      style: TextButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        Colors
                                                            .red,
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(8.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                    print("attachement viewed");
                                  },
                                  icon: Icon(
                                    Icons.attach_file,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Attachment',
                                    style: TextStyle(color: Colors.white, fontSize: 10),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ],
                            ):Container()),


                            DataCell(Row(
                              children: [
                                Text(
                                    list.empName.toString(),
                                    textAlign: TextAlign.center),
                                list.empContactNo.toString()!=null
                                    &&
                                    list.empContactNo.toString().length>9?
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
                                              var url = 'tel:${list.empContactNo.toString()}';

                                              await launch(url);
                                            },
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.green,
                                            )))
                                ):Container()
                              ],
                            )),

                            // DataCell(Wrap(
                            //     direction:
                            //         Axis.vertical, //default
                            //     alignment: WrapAlignment.center,
                            //     children: [
                            //       Text(list.Location.toString(),
                            //           textAlign:
                            //               TextAlign.center)
                            //     ])),
                            DataCell(
                              Center(
                                child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.work_history_rounded),
                                      color: Colors.green,
                                      onPressed: () {

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
                                                              Text("Do You Want to Proceed ?"),
                                                              SizedBox(height: 5,),
                                                              FilterStatusName.isNotEmpty?Text("TicketStatus="+FilterStatusName.toString(),style: TextStyle(fontWeight:FontWeight.bold),):Text(list.status!.toLowerCase().toString()=='o'?"TicketStatus=Open".toString():list.status!.toLowerCase().toString()=='p'?"TicketStatus=Work IN Progress":"TicketStatus=Work IN Progress"),



                                                              Padding(
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

                                                              Visibility(
                                                                visible: ItemVisible,
                                                                child: Column(
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
                                                                ),




                                                              ),

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
                                                                             TicketStatusCode="";
                                                                             TicketStatus="";

                                                                             AssignDepartment="";
                                                                             AssignDepartmentCode="";

                                                                             AssignEmpName="";
                                                                             AssignEmpNameCode="";
                                                                             ItemVisible=false;
                                                                        Fluttertoast.showToast(
                                                                            msg:
                                                                            "Assign Cancelled!!",
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


                                                                            if(TicketStatus=="Assign"){

                                                                              if (TicketStatus.isEmpty) {
                                                                                Fluttertoast.showToast(
                                                                                    msg: "TicketStatus should not left Empty!!",
                                                                                    toastLength: Toast.LENGTH_LONG,
                                                                                    gravity: ToastGravity.SNACKBAR,
                                                                                    timeInSecForIosWeb: 1,
                                                                                    textColor: Colors.white,
                                                                                    backgroundColor: Colors.red,
                                                                                    fontSize: 16.0);
                                                                              }else  if (AssignDepartment.isEmpty) {
                                                                                Fluttertoast.showToast(
                                                                                    msg: "AssignDepartment should not left Empty!!",
                                                                                    toastLength: Toast.LENGTH_LONG,
                                                                                    gravity: ToastGravity.SNACKBAR,
                                                                                    timeInSecForIosWeb: 1,
                                                                                    textColor: Colors.white,
                                                                                    backgroundColor: Colors.red,
                                                                                    fontSize: 16.0);
                                                                              }else  if (AssignEmpName.isEmpty) {
                                                                                Fluttertoast.showToast(
                                                                                    msg: "AssignEmpName should not left Empty!!",
                                                                                    toastLength: Toast.LENGTH_LONG,
                                                                                    gravity: ToastGravity.SNACKBAR,
                                                                                    timeInSecForIosWeb: 1,
                                                                                    textColor: Colors.white,
                                                                                    backgroundColor: Colors.red,
                                                                                    fontSize: 16.0);
                                                                              }else{

                                                                                print("Empty true");


                                                                                selectedDatalist.clear();


                                                                                      selectedDatalist.add(selectedListModel(
                                                                                          int.tryParse(list.docNo.toString()),
                                                                                          list.ticketNo,
                                                                                          list.brachName,
                                                                                          TicketStatusCode,
                                                                                          AssignEmpName,
                                                                                          AssignEmpNameCode,
                                                                                          AssignDepartment,
                                                                                          '',
                                                                                          UserID.toString()
                                                                                      ));


                                                                                BulkinsertStatusTickets();
                                                                                Navigator.pop(context);


                                                                              }



                                                                            }else{



                                                                              if (TicketStatus.isEmpty) {
                                                                                Fluttertoast.showToast(
                                                                                    msg: "TicketStatus should not left Empty!!",
                                                                                    toastLength: Toast.LENGTH_LONG,
                                                                                    gravity: ToastGravity.SNACKBAR,
                                                                                    timeInSecForIosWeb: 1,
                                                                                    textColor: Colors.white,
                                                                                    backgroundColor: Colors.red,
                                                                                    fontSize: 16.0);
                                                                              }else{

                                                                                print("Empty false");
                                                                                selectedDatalist.clear();


                                                                                selectedDatalist.add(selectedListModel(
                                                                                    int.tryParse(list.docNo.toString()),
                                                                                    list.ticketNo,
                                                                                    list.brachName,
                                                                                    TicketStatusCode,
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    '',
                                                                                    UserID.toString()
                                                                                ));


                                                                                BulkinsertStatusTickets();
                                                                                Navigator.pop(context);


                                                                              }

                                                                            }

                                                                        // selectState =
                                                                        // 1;
                                                                        // print(
                                                                        //     selectState);
                                                                        //
                                                                        // insertData();
                                                                        // Navigator.pop(
                                                                        //     context);
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
                                                                        'Submit',
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

                                        /*showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  Text("Do You Want to Approve ?"),

                                                  Padding(
                                                    //TextEditingController RemarksController =new TextEditingController();
                                                    padding: EdgeInsets.all(15),
                                                    // child: TextField(
                                                    //   controller: RemarksController,
                                                    //   decoration: InputDecoration(
                                                    //     focusedBorder: OutlineInputBorder(
                                                    //       borderSide:
                                                    //       BorderSide(color: Colors.green, width: 2.0),
                                                    //     ),
                                                    //     enabledBorder: OutlineInputBorder(
                                                    //       borderSide:
                                                    //       BorderSide(color: Colors.red, width: 2.0),
                                                    //     ),
                                                    //     labelText: 'Remarks',
                                                    //     prefixIcon: Icon(Icons.receipt_long_outlined),
                                                    //     hintText: 'Enter Your Remarks',
                                                    //   ),
                                                    // ),
                                                  ),
                                                ],
                                              ),

                                              actions: <Widget>[

                                                TextButton(
                                                  onPressed: () {

                                                    updateTicketStatus(8,int.parse(list.docNo.toString()),list.brachName.toString());

                                                    Navigator.pop(context);

                                                   /* if (RemarksController.text!=""){

                                                      print(uSERID);
                                                    /*  updateindentlist(
                                                          int.parse(list.docNo.toString()),
                                                          "A",
                                                          RemarksController.text,
                                                          int.parse(
                                                              uSERID));*/
                                                    }else{
                                                      Fluttertoast.showToast(msg: "Remarks should not be empty");
                                                    }*/
                                                  },

                                                  child: const Text('Approve'),
                                                ),

                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                )
                                              ],
                                            );
                                          },
                                        );*/

                                      },
                                    )),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Center(
                                    child: IconButton(
                                      icon: Icon(Icons.cancel),
                                      color: Colors.red,
                                      onPressed: () {
                                        RemarksController.text ="";
                                        print("Pressed");
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          // user must tap button!
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Column(
                                                children: [
                                                  Text("Do You Want to Reject ?"),
                                                  Text("Ticket No ="+list.ticketNo.toString()),
                                                  SizedBox(height: 5,),
                                                  Text("TicketStatus="+FilterStatusName.toString(),style: TextStyle(fontWeight:FontWeight.bold),),

                                                  Padding(

                                                    padding: EdgeInsets.all(15),
                                                    child: TextField(
                                                      controller: RemarksController,
                                                      decoration: InputDecoration(
                                                        focusedBorder: OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(color: Colors.green, width: 2.0),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderSide:
                                                          BorderSide(color: Colors.red, width: 2.0),
                                                        ),
                                                        labelText: 'Enter Your Remarks',
                                                        prefixIcon: Icon(Icons.receipt_long_outlined),
                                                        hintText: 'Enter Your Remarks',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              actions: <Widget>[

                                                TextButton(
                                                  onPressed: () {




                                                     if (RemarksController.text!=""){

                                                       updateTicketStatus(7,int.parse(list.docNo.toString()),list.brachName.toString());

                                                       Navigator.pop(context);

                                                   /* updateindentlist(
                                                        int.parse(list.docNo.toString()),
                                                        "R",
                                                        RemarksController.text,
                                                        int.parse(
                                                            uSERID));*/
                                                    }else{
                                                       Fluttertoast.showToast(msg: "Remarks should not be empty");
                                                     }
                                                  },

                                                  child: const Text('Reject'),
                                                ),

                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                )
                                              ],
                                            );
                                          },
                                        );

                                      },
                                    )),
                              ),
                            ),
                          ]),
                    )
                        .toList(),
                  )
                      : Container(
                    child: Center(
                      child: Text('No Data'),
                    ),
                  ),
                ),
                Container(
                  color: Colors.blueAccent.withOpacity(0.2),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Page : ${page}"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: page > 0
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              if (page > 1)
                                setState(() {
                                  page--;
                                  li3.removeRange(0, li3.length);
                                  for (int i = (page * 20) - 19;
                                  i < page * 20;
                                  i++) {
                                    li3.add(FilterList4(

                                        li2.result![i].createdDate,
                                        li2.result![i].docNo,
                                        li2.result![i].brachName,
                                        li2.result![i].branchCode,
                                        li2.result![i].issueCatrgory,
                                        li2.result![i].issueCategoryId,
                                        li2.result![i].itemName,
                                        li2.result![i].itemCode,
                                        li2.result![i].issueType,
                                        li2.result![i].requiredDate,
                                        li2.result![i].description,
                                        li2.result![i].attachFilePath,
                                        li2.result![i].attachFileName,
                                        li2.result![i].status,
                                        li2.result![i].closedDate,
                                        li2.result![i].empName,
                                        li2.result![i].empContactNo,
                                        li2.result![i].empMailid,
                                        li2.result![i].rejectRemarks,
                                        li2.result![i].createdAt,
                                        li2.result![i].updatedAt,
                                        li2.result![i].priority,
                                        li2.result![i].category,
                                        li2.result![i].modifiedDate,
                                        li2.result![i].assignStatus,
                                        li2.result![i].ticketNo,
                                        li2.result![i].assignEmpName,
                                        li2.result![i].assignEmpId,
                                        li2.result![i].assignEmpDept,
                                        li2.result![i].solutionProvided,
                                        li2.result![i].endDate,
                                        li2.result![i].startDate,
                                        li2.result![i].assignEmpcontactNo,
                                      li2.result![i].assetName,
                                      li2.result![i].assetCode

                                    ));
                                  }
                                });
                            },
                          ),
                          int.parse(li3.length.toString()) == 0
                              ? Text("0 to 0 of 0")
                              : int.parse(li2.result!.length.toString()) >
                              (page * 20)
                              ? Text(
                              "${(page * 20) - 19} to ${(page * 20)} of ${li2.result!.length}")
                              : Text(
                              "${(page * 20) - 19} to ${li2.result!.length} of ${li2.result!.length}"),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              color: int.parse(li2 != null
                                  ? li2.result!.length.toString()
                                  : 0.toString()) >
                                  (page * 20)
                                  ? Colors.blueAccent
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                if (int.parse(
                                    li2.result!.length.toString()) >
                                    (page * 20)) {
                                  page++;
                                  li3.removeRange(0, li3.length);
                                  for (int i = (page * 20) - 19;
                                  i < page * 20;
                                  i++) {
                                    li3.add(FilterList4(


                                        li2.result![i].createdDate,
                                        li2.result![i].docNo,
                                        li2.result![i].brachName,
                                        li2.result![i].branchCode,
                                        li2.result![i].issueCatrgory,
                                        li2.result![i].issueCategoryId,
                                        li2.result![i].itemName,
                                        li2.result![i].itemCode,
                                        li2.result![i].issueType,
                                        li2.result![i].requiredDate,
                                        li2.result![i].description,
                                        li2.result![i].attachFilePath,
                                        li2.result![i].attachFileName,
                                        li2.result![i].status,
                                        li2.result![i].closedDate,
                                        li2.result![i].empName,
                                        li2.result![i].empContactNo,
                                        li2.result![i].empMailid,
                                        li2.result![i].rejectRemarks,
                                        li2.result![i].createdAt,
                                        li2.result![i].updatedAt,
                                        li2.result![i].priority,
                                        li2.result![i].category,
                                        li2.result![i].modifiedDate,
                                        li2.result![i].assignStatus,
                                        li2.result![i].ticketNo,
                                        li2.result![i].assignEmpName,
                                        li2.result![i].assignEmpId,
                                        li2.result![i].assignEmpDept,
                                        li2.result![i].solutionProvided,
                                        li2.result![i].endDate,
                                        li2.result![i].startDate,
                                        li2.result![i].assignEmpcontactNo,
                                        li2.result![i].assetName,
                                        li2.result![i].assetCode

                                    ));
                                  }
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  }

 /* Future<http.Response> getpendingapprovallist() async {

    print('getpendingapprovallist');

    var headers = {"Content-Type": "application/json"};

    // var body = {"UserID": "6"};

    var body = {"UserID": uSERID.toString()};


    print(body);

    setState(() {
      loading = true;
    });

    final response = await http.post(
        Uri.parse(Appconstants.LIVE_URL + '/getPOPendingList'),
        body: jsonEncode(body),
        headers: headers);

    setState(() {
      loading = false;
    });

    print(Appconstants.LIVE_URL + '/getPOPendingList');
    print(response.body);


    if (response.statusCode == 200) {
      var nodata = jsonDecode(response.body)['status'] == 0;

      if (nodata == true) {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {

        print(Appconstants.LIVE_URL + '/getPOPendingList');
        print(body);
        print(response.body);

        li2 = ApprovalPendingModel.fromJson(jsonDecode(response.body));

        if (li2.result.length % 20 == 0)
          totalpages = (li2.result.length / 20).floor();
        else
          totalpages = (li2.result.length / 20).floor() + 1;
        print(totalpages);

        li3.removeRange(0, li3.length);

        for (int k = 0; k < li2.result.length; k++) {
          li3.add(FilterList(
            li2.result[k].ownerCode.toString(),
            "Purchase",
            li2.result[k].firstName,
            li2.result[k].docnum,
            li2.result[k].docEntry,
            li2.result[k].docdate,
            li2.result[k].location,
            li2.result[k].cardName,
            li2.result[k].doctotal.toString(),
            li2.result[k].currency.toString(),
            li2.result[k].branch.toString(),
          ));
        }


        // print(li2.result.length);
        setState(() {});

      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }*/

 /* Future<http.Response> updateindentlist(
      int docentry, String Status,String Remarks, int UserID) async {
    print("updateindentlist was called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "DocEntry": docentry,
      "UserID": UserID,
      "Remarks": Remarks,
      "Type": Status,
      "PostingObject":"22"

    };
    setState(() {
      loading = true;
    });
    print(body);

    print(Appconstants.LIVE_URL + '/updatePO');
    final response = await http.post(
        Uri.parse(Appconstants.LIVE_URL + '/updatePO'),
        body: jsonEncode(body),
        headers: headers);
    setState(() {
      loading = false;
    });

    print(response.body);

    if (response.statusCode == 200) {
      print(jsonDecode(response.body)["status"]);
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Updated",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Updated Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        //Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Assign_Tickets()));
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }*/

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

      getOpenTickets();

      gettickettype().then((value) => getTicketStatusList()).then((value) => getTicketStatusfilterList());
    });
  }


  Future<http.Response> gettickettype() async {

    print("gettickettype is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 20,
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

          li4 = TicketTypeModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li4.result!.length;i++);
          print(li4.result!.length.toString());

          setState(() {
            stringlist2.clear();
            stringlist2.add("Select Ticket Type");
            for (int i = 0; i < li4.result!.length; i++)
              stringlist2.add(li4.result![i].type.toString());
          });

          setState(() {
            loading = false;
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




   Future<http.Response> getTicketStatusList() async {

     print("getTicketStatusList is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "FormID": 11,
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

           li10 = TicketStatusModel.fromJson(jsonDecode(response.body));

           for(int i=0;i<li10.result!.length;i++);
           print(li10.result!.length.toString());

           setState(() {
             stringlist7.clear();
             stringlist7.add("Select Ticket Status");
             for (int i = 0; i < li10.result!.length; i++)
               stringlist7.add(li10.result![i].statusName.toString());
           });

           setState(() {
             loading = false;
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

   Future<http.Response> getTicketStatusfilterList() async {

     print("getTicketStatusfilterList is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "FormID": 14,
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

           li13 = TicketStatusFilterModel .fromJson(jsonDecode(response.body));

           for(int i=0;i<li13.result!.length;i++);
           print(li13.result!.length.toString());

           setState(() {
             stringlist10.clear();
             stringlist10.add("Select Ticket Status");
             for (int i = 0; i < li13.result!.length; i++)
               stringlist10.add(li13.result![i].statusName.toString());
           });

           setState(() {
             loading = false;
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

   Future<http.Response> getAssignEmployeeDepartment() async {

     print("getAssignEmployeeDepartment is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "FormID": 13,
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

           li11 = AssignEmpDepartmentModel.fromJson(jsonDecode(response.body));

           for(int i=0;i<li11.result!.length;i++);
           print(li11.result!.length.toString());

           setState(() {
             stringlist8.clear();
             stringlist8.add("Select Department");
             for (int i = 0; i < li11.result!.length; i++)
               stringlist8.add(li11.result![i].departmentName.toString());
           });

           setState(() {
             loading = false;
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

   Future<http.Response> getAssignEmployeeListBasedOnDepartment(AssignDepartment) async {

     print("getAssignEmployeeListBasedOnDepartment is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "FormID": 12,
       "UserID": AssignDepartment.toString(),
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

           li12 = AssignEmpListBasedOnDepartmentModel.fromJson(jsonDecode(response.body));

           for(int i=0;i<li12.result!.length;i++);
           print(li12.result!.length.toString());

           setState(() {
             stringlist9.clear();
             stringlist9.add("Select Employee");
             for (int i = 0; i < li12.result!.length; i++)
               stringlist9.add(li12.result![i].firstName.toString());
           });

           setState(() {
             loading = false;
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

  Future<http.Response> getTicketList(FilterStatusCode) async {

    print("getTicketList is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "TicketCategory": TicketType.toString(),
      "BranchCode": branchID.toString(),
      "Status":FilterStatusCode.toString()
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
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

          SumQty =0;

          li2.result!.clear();

        } else {

          print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
          print(body);
          print(response.body);

          li2 = CustomerTicketsModel.fromJson(jsonDecode(response.body));

          if (li2.result!.length % 20 == 0)
            totalpages = (li2.result!.length / 20).floor();
          else
            totalpages = (li2.result!.length / 20).floor() + 1;
          print(totalpages);

          li3.removeRange(0, li3.length);

          for (int k = 0; k < li2.result!.length; k++) {
            li3.add(FilterList4(

                li2.result![k].createdDate,
                li2.result![k].docNo,
                li2.result![k].brachName,
                li2.result![k].branchCode,
                li2.result![k].issueCatrgory,
                li2.result![k].issueCategoryId,
                li2.result![k].itemName,
                li2.result![k].itemCode,
                li2.result![k].issueType,
                li2.result![k].requiredDate,
                li2.result![k].description,
                li2.result![k].attachFilePath,
                li2.result![k].attachFileName,
                li2.result![k].status,
                li2.result![k].closedDate,
                li2.result![k].empName,
                li2.result![k].empContactNo,
                li2.result![k].empMailid,
                li2.result![k].rejectRemarks,
                li2.result![k].createdAt,
                li2.result![k].updatedAt,
                li2.result![k].priority,
                li2.result![k].category,
                li2.result![k].modifiedDate,
                li2.result![k].assignStatus,
                li2.result![k].ticketNo,
                li2.result![k].assignEmpName,
                li2.result![k].assignEmpId,
                li2.result![k].assignEmpDept,
                li2.result![k].solutionProvided,
                li2.result![k].endDate,
                li2.result![k].startDate,
                li2.result![k].assignEmpcontactNo,
                li2.result![k].assetName,
                li2.result![k].assetCode

            ));

           li3.length==""?  SumQty =0:  SumQty =li3.length.toInt();

          }


           print("SumQty"+SumQty.toString());
          setState(() {



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


   Future<http.Response> getTicketList1(FilterStatusCode) async {

     print("getTicketList is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "BranchCode": branchID.toString(),
       "Status":FilterStatusCode.toString()
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew1'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew1');
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

           SumQty =0;

           li2.result!.clear();

         } else {

           print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
           print(body);
           print(response.body);

           li2 = CustomerTicketsModel.fromJson(jsonDecode(response.body));

           if (li2.result!.length % 20 == 0)
             totalpages = (li2.result!.length / 20).floor();
           else
             totalpages = (li2.result!.length / 20).floor() + 1;
           print(totalpages);

           li3.removeRange(0, li3.length);

           for (int k = 0; k < li2.result!.length; k++) {
             li3.add(FilterList4(

                 li2.result![k].createdDate,
                 li2.result![k].docNo,
                 li2.result![k].brachName,
                 li2.result![k].branchCode,
                 li2.result![k].issueCatrgory,
                 li2.result![k].issueCategoryId,
                 li2.result![k].itemName,
                 li2.result![k].itemCode,
                 li2.result![k].issueType,
                 li2.result![k].requiredDate,
                 li2.result![k].description,
                 li2.result![k].attachFilePath,
                 li2.result![k].attachFileName,
                 li2.result![k].status,
                 li2.result![k].closedDate,
                 li2.result![k].empName,
                 li2.result![k].empContactNo,
                 li2.result![k].empMailid,
                 li2.result![k].rejectRemarks,
                 li2.result![k].createdAt,
                 li2.result![k].updatedAt,
                 li2.result![k].priority,
                 li2.result![k].category,
                 li2.result![k].modifiedDate,
                 li2.result![k].assignStatus,
                 li2.result![k].ticketNo,
                 li2.result![k].assignEmpName,
                 li2.result![k].assignEmpId,
                 li2.result![k].assignEmpDept,
                 li2.result![k].solutionProvided,
                 li2.result![k].endDate,
                 li2.result![k].startDate,
                 li2.result![k].assignEmpcontactNo,
                 li2.result![k].assetName,
                 li2.result![k].assetCode

             ));

             li3.length==""?  SumQty =0:  SumQty =li3.length.toInt();

           }


           print("SumQty"+SumQty.toString());
           setState(() {



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


   Future<http.Response> getTicketListBasedOnTicketCategory() async {

     print("getTicketListBasedOnTicketCategory is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "TicketCategory": TicketType.toString(),
       "BranchCode":branchID.toString()
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getBranchAdminOpenTicketsBasedOnCategory'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getBranchAdminOpenTicketsBasedOnCategory');
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

           SumQty =0;

           li2.result!.clear();

         } else {

           print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
           print(body);
           print(response.body);

           li2 = CustomerTicketsModel.fromJson(jsonDecode(response.body));

           if (li2.result!.length % 20 == 0)
             totalpages = (li2.result!.length / 20).floor();
           else
             totalpages = (li2.result!.length / 20).floor() + 1;
           print(totalpages);

           li3.removeRange(0, li3.length);

           for (int k = 0; k < li2.result!.length; k++) {
             li3.add(FilterList4(

                 li2.result![k].createdDate,
                 li2.result![k].docNo,
                 li2.result![k].brachName,
                 li2.result![k].branchCode,
                 li2.result![k].issueCatrgory,
                 li2.result![k].issueCategoryId,
                 li2.result![k].itemName,
                 li2.result![k].itemCode,
                 li2.result![k].issueType,
                 li2.result![k].requiredDate,
                 li2.result![k].description,
                 li2.result![k].attachFilePath,
                 li2.result![k].attachFileName,
                 li2.result![k].status,
                 li2.result![k].closedDate,
                 li2.result![k].empName,
                 li2.result![k].empContactNo,
                 li2.result![k].empMailid,
                 li2.result![k].rejectRemarks,
                 li2.result![k].createdAt,
                 li2.result![k].updatedAt,
                 li2.result![k].priority,
                 li2.result![k].category,
                 li2.result![k].modifiedDate,
                 li2.result![k].assignStatus,
                 li2.result![k].ticketNo,
                 li2.result![k].assignEmpName,
                 li2.result![k].assignEmpId,
                 li2.result![k].assignEmpDept,
                 li2.result![k].solutionProvided,
                 li2.result![k].endDate,
                 li2.result![k].startDate,
                 li2.result![k].assignEmpcontactNo,
                 li2.result![k].assetName,
                 li2.result![k].assetCode

             ));

             li3.length==""?  SumQty =0:  SumQty =li3.length.toInt();

           }


           print("SumQty"+SumQty.toString());
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


   Future<http.Response> getTicketListBasedOnTicketCategoryandBranch() async {

     print("getTicketListBasedOnTicketCategoryandBranch is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "TicketCategory": TicketType.toString(),
       "BrachName": branch.toString(),
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryandBranch'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryandBranch');
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

           SumQty =0;

           li2.result!.clear();

         } else {

           print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
           print(body);
           print(response.body);

           li2 = CustomerTicketsModel.fromJson(jsonDecode(response.body));

           if (li2.result!.length % 20 == 0)
             totalpages = (li2.result!.length / 20).floor();
           else
             totalpages = (li2.result!.length / 20).floor() + 1;
           print(totalpages);

           li3.removeRange(0, li3.length);

           for (int k = 0; k < li2.result!.length; k++) {
             li3.add(FilterList4(

                 li2.result![k].createdDate,
                 li2.result![k].docNo,
                 li2.result![k].brachName,
                 li2.result![k].branchCode,
                 li2.result![k].issueCatrgory,
                 li2.result![k].issueCategoryId,
                 li2.result![k].itemName,
                 li2.result![k].itemCode,
                 li2.result![k].issueType,
                 li2.result![k].requiredDate,
                 li2.result![k].description,
                 li2.result![k].attachFilePath,
                 li2.result![k].attachFileName,
                 li2.result![k].status,
                 li2.result![k].closedDate,
                 li2.result![k].empName,
                 li2.result![k].empContactNo,
                 li2.result![k].empMailid,
                 li2.result![k].rejectRemarks,
                 li2.result![k].createdAt,
                 li2.result![k].updatedAt,
                 li2.result![k].priority,
                 li2.result![k].category,
                 li2.result![k].modifiedDate,
                 li2.result![k].assignStatus,
                 li2.result![k].ticketNo,
                 li2.result![k].assignEmpName,
                 li2.result![k].assignEmpId,
                 li2.result![k].assignEmpDept,
                 li2.result![k].solutionProvided,
                 li2.result![k].endDate,
                 li2.result![k].startDate,
                 li2.result![k].assignEmpcontactNo,
                 li2.result![k].assetName,
                 li2.result![k].assetCode

             ));

             li3.length==""?  SumQty =0:  SumQty =li3.length.toInt();

           }


           print("SumQty"+SumQty.toString());
           setState(() {

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


   Future<http.Response> getOpenTickets() async {

     print("getOpenTickets is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "TicketCategory": TicketType.toString(),
       "BranchCode": branchID.toString(),
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getOpenTicketsforbranchAdmin'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getOpenTicketsforbranchAdmin');
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

           SumQty =0;

           li2.result!.clear();

         } else {

           print(AppConstants.LIVE_URL + 'getWipcustTckttoAsignnew');
           print(body);
           print(response.body);

           li2 = CustomerTicketsModel.fromJson(jsonDecode(response.body));

           if (li2.result!.length % 20 == 0)
             totalpages = (li2.result!.length / 20).floor();
           else
             totalpages = (li2.result!.length / 20).floor() + 1;
           print(totalpages);

           li3.removeRange(0, li3.length);

           for (int k = 0; k < li2.result!.length; k++) {
             li3.add(FilterList4(

                 li2.result![k].createdDate,
                 li2.result![k].docNo,
                 li2.result![k].brachName,
                 li2.result![k].branchCode,
                 li2.result![k].issueCatrgory,
                 li2.result![k].issueCategoryId,
                 li2.result![k].itemName,
                 li2.result![k].itemCode,
                 li2.result![k].issueType,
                 li2.result![k].requiredDate,
                 li2.result![k].description,
                 li2.result![k].attachFilePath,
                 li2.result![k].attachFileName,
                 li2.result![k].status,
                 li2.result![k].closedDate,
                 li2.result![k].empName,
                 li2.result![k].empContactNo,
                 li2.result![k].empMailid,
                 li2.result![k].rejectRemarks,
                 li2.result![k].createdAt,
                 li2.result![k].updatedAt,
                 li2.result![k].priority,
                 li2.result![k].category,
                 li2.result![k].modifiedDate,
                 li2.result![k].assignStatus,
                 li2.result![k].ticketNo,
                 li2.result![k].assignEmpName,
                 li2.result![k].assignEmpId,
                 li2.result![k].assignEmpDept,
                 li2.result![k].solutionProvided,
                 li2.result![k].endDate,
                 li2.result![k].startDate,
                 li2.result![k].assignEmpcontactNo,
                 li2.result![k].assetName,
                 li2.result![k].assetCode

             ));

             li3.length==""?  SumQty =0:  SumQty =li3.length.toInt();

           }


           print("SumQty"+SumQty.toString());
           setState(() {

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


   Future<http.Response> updateTicketStatus(int formID,int DocNo,String BranchName) async {
     print("updateTicketStatus(int formID) was called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "FormID": formID,
       "Solution": RemarksController.text.toString(),
       "TicketNo": "",
       "CustName": BranchName.toString(),
       "UpdateLocation": "",
       "Docno":DocNo
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


           showDialog<void>(
               context: this.context,
               barrierDismissible: true,
               builder: (BuildContext context) {
                 return AlertDialog(
                   backgroundColor: Colors.white.withOpacity(0),
                   title: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(50),
                           bottomRight: Radius.circular(50),
                           topLeft: Radius.circular(50),
                           topRight: Radius.circular(50)),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Container(
                           padding: const EdgeInsets.all(16.0),
                           child: Image.asset(
                             'assets/images/Jasperlogo.png',height:  MediaQuery.of(context).size.height/8,
                           ),
                         ),
                         SizedBox(
                           height: 5,
                         ),

                         Text(
                           formID==7?"Ticket Reject Successfully!":"Ticket Approved Successfully!",
                           style: TextStyle(color: Colors.green,fontSize: 16),
                         ),
                         SizedBox(
                           height: 30,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: TextButton(
                                 child: Text('OK',style: TextStyle(color: Colors.blue),textAlign: TextAlign.end,),
                                 onPressed: () {
                                   Navigator.of(context).pop();
                                   getTicketList(FilterStatusCode);

                                 },
                               ),
                             ),
                           ],
                         ),
                       ],

                     ),
                   ),

                   // actions: <Widget>[
                   //   TextButton(
                   //     child: Text('OK'),
                   //     onPressed: () {
                   //       Navigator.of(context).pop();
                   //     },
                   //   ),
                   // ],
                 );

               });



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





  void onSearchTextChanged(String value) async {
    print(value);
    if (li2.result!.length > 0) {
      setState(() {
        for (int kk = 0; kk < li2.result!.length; kk++) {
          print(li2.result![kk].docNo);
        }
      });
    } else {}
  }

  //  bool onWillPop() {
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (BuildContext context) => AdminDashBoard()),
  //           (route) => false);
  // }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        li3.sort((a, b) => a.docNo!.compareTo(int.parse(b.docNo.toString())));
      } else {
        li3.sort((a, b) => b.docNo!.compareTo(int.parse(a.docNo.toString())));
      }
    }
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

  Future ApproveAll(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
          new TextEditingController();
          _textFieldController.text = UserID.toString();
          return AlertDialog(
            title: Text('Do You Want to Approve'),
            // content: TextField(
            //   /*onChanged: (value) {
            //     setState(() {
            //       valuetext = value;
            //     });
            //   },*/
            //   controller: _textFieldController,
            //   decoration: InputDecoration(hintText: "Enter The Remarks"),
            // ),
            actions: <Widget>[
              TextButton(
                style:  ElevatedButton.styleFrom(backgroundColor:Colors.red ),
                child: Text('CANCEL',style: TextStyle(color:Colors.white)),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style:  ElevatedButton.styleFrom(backgroundColor:Colors.green ),

                child: Text('OK',style: TextStyle(color:Colors.white)),
                onPressed: () {
                  setState(() {
                    //Navigator.pop(context);

                    if(_textFieldController.text!="") {

                      selectedDatalist.clear();

                      print(uSERID);
                      for (int k = 0; k < li2.result!.length; k++) {
                        for (int j = 0; j < selectedlist.length; j++) {
                          if (selectedlist[j] ==
                              li2.result![k].docNo.toString()) {


                            selectedDatalist.add(selectedListModel(
                                li2.result![k].docNo,
                              li2.result![k].ticketNo,
                              li2.result![k].brachName,
                              'A',
                              '',
                              '',
                              '',
                              '',
                                UserID.toString()
                            ));

                          }
                        }
                      }

                      BulkinsertStatusTickets();
                      Navigator.pop(context);

                    }else{
                      Fluttertoast.showToast(msg: "Remarks should not be left empty");
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  Future RejectAll(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";
          TextEditingController _textFieldController =
          new TextEditingController();
          _textFieldController.text = '';
          return AlertDialog(
            title: Text('Enter Rejection Reason'),

            content: TextField(
              /*onChanged: (value) {
                setState(() {
                  valuetext = value;
                });
              },*/
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter The Remarks"),
            ),
            actions: <Widget>[
              TextButton(
                style:  ElevatedButton.styleFrom(backgroundColor:Colors.red ),
                child: Text('CANCEL',style: TextStyle(color:Colors.white)),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style:  ElevatedButton.styleFrom(backgroundColor:Colors.green ),

                child: Text('OK',style: TextStyle(color:Colors.white)),
                onPressed: () {
                  setState(() {
                    // Navigator.pop(context);
                     if(_textFieldController.text!="") {
                    for (int k = 0; k < li2.result!.length; k++) {
                      for (int j = 0; j < selectedlist.length; j++) {
                        if (selectedlist[j] ==
                            li2.result![k].docNo.toString()) {

                          selectedDatalist.add(selectedListModel(
                              li2.result![k].docNo,
                              li2.result![k].ticketNo,
                              li2.result![k].brachName,
                              'R',
                              '',
                              '',
                              '',
                              _textFieldController.text.toString(),
                              UserID.toString()
                          ));

                        }
                      }
                    }


                    BulkinsertStatusTickets();
                    Navigator.pop(context);

                    }else{
                      Fluttertoast.showToast(msg: "Remarks should not be left empty");
                    }


                  });
                },
              ),
            ],
          );
        });
  }


   Future<http.Response>  BulkinsertStatusTickets() async {
     print("BulkinsertStatusTickets was called");
     var headers = {"Content-Type": "application/json"};
     setState(() {
       loading = true;
     });

     final response = await http.post(
       Uri.parse(AppConstants.LIVE_URL + 'BulkUpdateTicketstatus'),
       headers: headers,
       body: (jsonEncode(selectedDatalist)),
     );
     print(response.body);
     print(AppConstants.LIVE_URL + 'BulkUpdateTicketstatus');
     print((jsonEncode(selectedDatalist)));
     print(response.statusCode);

     setState(() {
       loading = false;
     });

     if (response.statusCode == 200) {
       if (jsonDecode(response.body)["status"] == 0) {
         Fluttertoast.showToast(
             msg: "Not Insert",
             toastLength: Toast.LENGTH_LONG,
             gravity: ToastGravity.SNACKBAR,
             timeInSecForIosWeb: 1,
             textColor: Colors.white,
             fontSize: 16.0);
       } else {
         setState(() {



           showDialog<void>(
               context: this.context,
               barrierDismissible: true,
               builder: (BuildContext context) {
                 return AlertDialog(
                   backgroundColor: Colors.white.withOpacity(0),
                   title: Container(
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.only(
                           bottomLeft: Radius.circular(50),
                           bottomRight: Radius.circular(50),
                           topLeft: Radius.circular(50),
                           topRight: Radius.circular(50)),
                     ),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         Container(
                           padding: const EdgeInsets.all(16.0),
                           child: Image.asset(
                             'assets/images/Jasperlogo.png',height:  MediaQuery.of(context).size.height/8,
                           ),
                         ),
                         SizedBox(
                           height: 5,
                         ),

                         Text(
                           "Ticket Updated Successfully!",
                           style: TextStyle(color: Colors.green,fontSize: 16),
                         ),
                         SizedBox(
                           height: 30,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: TextButton(
                                 child: Text('OK',style: TextStyle(color: Colors.blue),textAlign: TextAlign.end,),
                                 onPressed: () {
                                   Navigator.of(context).pop();
                                   TicketStatusCode="";
                                   TicketStatus="";

                                   AssignDepartment="";
                                   AssignDepartmentCode="";

                                   AssignEmpName="";
                                   AssignEmpNameCode="";
                                   ItemVisible=false;
                                   getTicketList(FilterStatusCode);
                                 },
                               ),
                             ),
                           ],
                         ),
                       ],

                     ),
                   ),

                   // actions: <Widget>[
                   //   TextButton(
                   //     child: Text('OK'),
                   //     onPressed: () {
                   //       Navigator.of(context).pop();
                   //     },
                   //   ),
                   // ],
                 );

               });


           selectedDatalist.clear();


           setState(() {

           });

         });
       }
       return response;
     } else {
       throw Exception('Something went wrong??!!');
     }
   }
}
/*Future<http.Response> getpendingapprovallist() async {
    setState(() {
      loading = true;
    });
    var envelope = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <IN_MOB_APPR_PURCHASELIST xmlns="http://tempuri.org/">
      <UserID>1</UserID>
      <BranchID>1</BranchID>
    </IN_MOB_APPR_PURCHASELIST>
  </soap:Body>
</soap:Envelope>''';

    var url = "";
    url = Appconstants.LIVE_URL + 'service.asmx?op=IN_MOB_APPR_PURCHASELIST';

    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "text/xml; charset=utf-8",
        },
        body: envelope);
    print("URL" + url);

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);

      print('okokoko $parsedXml.text');
      if (parsedXml.text != "[]") {
        final decoded = json.decode(parsedXml.text);
        li2 = ApprovalPendingList.fromJson(jsonDecode(parsedXml.text));
        print(li2.details[0].DraftNo);
      }
    } else {
      setState(() {
        loading = false;
      });
      print('RESPONSE:${response.statusCode}');
      print('RESPONSE:${response.body}');
    }
    return response;
  }*/

class User {
  String name;
  int age;
  String role;

  User({required this.name, required this.age, required this.role});
}

class FilterList {
  String? createdDate;
  int? docNo;
  String? brachName;
  String? branchCode;
  String? issueCatrgory;
  String? issueCategoryId;
  String? itemName;
  String? itemCode;
  String? issueType;
  String? requiredDate;
  String? description;
  String? attachFilePath;
  String? attachFileName;
  String? status;
  String? closedDate;
  String? empName;
  String? empContactNo;
  String? empMailid;
  String? rejectRemarks;
  String? createdAt;
  String? updatedAt;
  String? priority;
  String? category;
  String? modifiedDate;
  String? assignStatus;
  String? ticketNo;
  String? assignEmpName;
  String? assignEmpId;
  String? assignEmpDept;
  String? solutionProvided;
  String? endDate;
  String? startDate;
  String? assignEmpcontactNo;
  FilterList(
      this.createdDate,
      this.docNo,
      this.brachName,
      this.branchCode,
      this.issueCatrgory,
      this.issueCategoryId,
      this.itemName,
      this.itemCode,
      this.issueType,
      this.requiredDate,
      this.description,
      this.attachFilePath,
      this.attachFileName,
      this.status,
      this.closedDate,
      this.empName,
      this.empContactNo,
      this.empMailid,
      this.rejectRemarks,
      this.createdAt,
      this.updatedAt,
      this.priority,
      this.category,
      this.modifiedDate,
      this.assignStatus,
      this.ticketNo,
      this.assignEmpName,
      this.assignEmpId,
      this.assignEmpDept,
      this.solutionProvided,
      this.endDate,
      this.startDate,
      this.assignEmpcontactNo
      );
}

class selectedListModel {
  int? Docno;
  String? TicketNo;
  String? BranchName;
  String? status;
  String? AssignEmpName;
  String? AssignEmpId;
  String? AssignEmpDept;
  String? Extra1;
  String? Extra2;

  selectedListModel(
      this.Docno,
        this.TicketNo,
        this.BranchName,
        this.status,
        this.AssignEmpName,
        this.AssignEmpId,
        this.AssignEmpDept,
        this.Extra1,
        this.Extra2
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Docno'] = this.Docno;
    data['TicketNo'] = this.TicketNo;
    data['BranchName'] = this.BranchName;
    data['status'] = this.status;
    data['AssignEmpName'] = this.AssignEmpName;
    data['AssignEmpId'] = this.AssignEmpId;
    data['AssignEmpDept'] = this.AssignEmpDept;
    data['Extra1'] = this.Extra1;
    data['Extra2'] = this.Extra2;
    return data;
  }
}

class FilterList4 {
  String? createdDate;
  int? docNo;
  String? brachName;
  String? branchCode;
  String? issueCatrgory;
  String? issueCategoryId;
  String? itemName;
  String? itemCode;
  String? issueType;
  String? requiredDate;
  String? description;
  String? attachFilePath;
  String? attachFileName;
  String? status;
  String? closedDate;
  String? empName;
  String? empContactNo;
  String? empMailid;
  String? rejectRemarks;
  String? createdAt;
  String? updatedAt;
  String? priority;
  String? category;
  String? modifiedDate;
  String? assignStatus;
  String? ticketNo;
  String? assignEmpName;
  String? assignEmpId;
  String? assignEmpDept;
  String? solutionProvided;
  String? endDate;
  String? startDate;
  String? assignEmpcontactNo;
  String? assetName;
  String? assetCode;
  FilterList4(
      this.createdDate,
      this.docNo,
      this.brachName,
      this.branchCode,
      this.issueCatrgory,
      this.issueCategoryId,
      this.itemName,
      this.itemCode,
      this.issueType,
      this.requiredDate,
      this.description,
      this.attachFilePath,
      this.attachFileName,
      this.status,
      this.closedDate,
      this.empName,
      this.empContactNo,
      this.empMailid,
      this.rejectRemarks,
      this.createdAt,
      this.updatedAt,
      this.priority,
      this.category,
      this.modifiedDate,
      this.assignStatus,
      this.ticketNo,
      this.assignEmpName,
      this.assignEmpId,
      this.assignEmpDept,
      this.solutionProvided,
      this.endDate,
      this.startDate,
      this.assignEmpcontactNo,
      this.assetName,
      this.assetCode
      );
}


