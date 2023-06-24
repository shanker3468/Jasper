import 'dart:developer';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../ADMIN Models/BranchMasterModel.dart';
import '../ADMIN Models/CustomerTicketsModel.dart';
import '../ADMIN Models/WeekUpdateAdminModel.dart';
import '../AppConstants.dart';
import '../Model/TicketTypeModel.dart';
import 'AdminDashBoard.dart';
import 'AssignTickets_DetailsView.dart';


class MuliselectList {
  final String? type;
  String? typeCode;

  MuliselectList({
    this.type,
    this.typeCode,
  });
}

class AllAssign_Tickets extends StatefulWidget {
   AllAssign_Tickets({ Key? key, required  String this.status,required String this.Tickettype,required String this.BranchName}) : super(key: key);

  String status;
  String BranchName;
   String Tickettype;

  @override
  AllAssign_TicketsState createState() => AllAssign_TicketsState();
}

class AllAssign_TicketsState extends State<AllAssign_Tickets> {
 // ApprovalPendingModel li2;

   TicketTypeModel li4=TicketTypeModel(result: []);
   WeekUpdateAdminModel li2 =WeekUpdateAdminModel(result: []);
  BranchMasterModel li5=BranchMasterModel(result: []);
  List<FilterList> li3 = [];
  TextEditingController searchcontroller = new TextEditingController();
  TextEditingController RemarksController =new TextEditingController();
  String _searchResult = '';
   List<selectedListModel> selectedDatalist = [];


  String dropdownbranch='';





  late  String UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location,EmpGroup;
  late bool sessionLoggedIn;

  var dropdownValue2 = "Select Ticket Type";
  var stringlist2 = ["Select Ticket Type"];

  String TicketType="";

   String Ticketcode="";

  var dropdownValue5 = "Select Branch";
  var stringlist5 = ["Select Branch"];


   String BranchName1="";

   String BranchCode="";


  int _currentSortColumn = 0;
  bool _isAscending = true;

  int selectedIndex = 0;
  bool loading = false;





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

          title: Text('weekly Updation'),

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
                      Text("Select Branch", style: TextStyle(fontWeight:FontWeight.bold)),
                    ],
                  ),
                ),



                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  // showClearButton: true,

                  // label: "Select Screen",
                  items: stringlist5,
                  onChanged: (val) {
                    print(val);
                    for (int kk = 0; kk < li5.result!.length; kk++) {
                      if (li5.result![kk].branchName == val) {
                        BranchName1 = li5.result![kk].branchName.toString();
                        BranchCode = li5.result![kk].branchCode.toString();
                        setState(() {
                          print(BranchName1);
                          //GetMyTablRecord();
                        });
                      }
                    }

                    setState(() {
                      if (BranchName1.isEmpty) {
                        Fluttertoast.showToast(
                            msg: "BranchName should not left Empty!!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            fontSize: 16.0);
                      }  else {

                        getTicketList();

                      }
                    });
                  },
                  selectedItem: BranchName1,
                ),

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
                                  li2.result![k].description
                                      .toString()
                                      .toLowerCase()
                                      .contains(value) ||
                                  li2.result![k].empName
                                      .toString()
                                      .toLowerCase()
                                      .contains(value) ||
                                  li2.result![k].docNo
                                      .toString()
                                      .toLowerCase()
                                      .contains(value)

                              )
                                li3.add(FilterList(

                                    li2.result![k].createdDate,
                                    li2.result![k].docNo,
                                    li2.result![k].brachName,
                                    li2.result![k].branchCode,
                                    li2.result![k].description,
                                    li2.result![k].attachFilePath,
                                    li2.result![k].attachFileName,
                                    li2.result![k].empName,
                                    li2.result![k].empContactNo,
                                    li2.result![k].empMailid,
                                    li2.result![k].modifiedDate,
                                    li2.result![k].empGroup,
                                    li2.result![k].empID


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
                              li3.add(FilterList(
                                  li2.result![k].createdDate,
                                  li2.result![k].docNo,
                                  li2.result![k].brachName,
                                  li2.result![k].branchCode,
                                  li2.result![k].description,
                                  li2.result![k].attachFilePath,
                                  li2.result![k].attachFileName,
                                  li2.result![k].empName,
                                  li2.result![k].empContactNo,
                                  li2.result![k].empMailid,
                                  li2.result![k].modifiedDate,
                                  li2.result![k].empGroup,
                                  li2.result![k].empID
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
                          'BranchName',
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
                          'Emp Contact Number',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    rows: li3
                        .map(
                          (list) => DataRow(
                          selected: selectedlist.contains(
                              list.docNo.toString()),
                          // onSelectChanged: (value) {
                          //   // if (value == true) {
                          //   //   setState(() {
                          //   //     selectedlist.add(
                          //   //         list.docNo.toString());
                          //   //
                          //   //   });
                          //   // } else {
                          //   //   setState(() {
                          //   //     selectedlist.remove(
                          //   //         list.docNo.toString());
                          //   //   });
                          //   // }
                          // },
                          cells: [
                            DataCell(Text(
                                list.brachName.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(list.attachFileName.toString()!=null
                                &&
                                list.attachFileName.toString().isNotEmpty?Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () {

                                    List<String> imglist =
                                    list.attachFileName!.split(',');
                                    print("sizeimglist" + imglist.length.toString());

                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (int i = 0; i < imglist.length; i++)
                                                InkWell(
                                                  onTap: () {
                                                    imglist[i].endsWith(".jpg")
                                                        ? showDialog(
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
                                                                  imglist[i].endsWith(
                                                                      ".jpg")
                                                                      ? InteractiveViewer(
                                                                    boundaryMargin:
                                                                    const EdgeInsets.all(20.0),
                                                                    minScale:
                                                                    0.1,
                                                                    maxScale:
                                                                    2.5,
                                                                    child: Image
                                                                        .network(
                                                                      AppConstants.LIVE_URL + imglist[i],
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      // loadingBuilder: (BuildContext context,
                                                                      //     Widget child,
                                                                      //     ImageChunkEvent loadingProgress) {
                                                                      //   if (loadingProgress ==
                                                                      //       null)
                                                                      //     return child;
                                                                      //   return Center(
                                                                      //     child: CircularProgressIndicator(
                                                                      //       value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes : null,
                                                                      //     ),
                                                                      //   );
                                                                      // },
                                                                    ),
                                                                  )
                                                                      : imglist[i].endsWith(
                                                                      ".pdf")
                                                                      ? Image
                                                                      .asset(
                                                                    "assets/images/pdf.png",
                                                                    width:
                                                                    24,
                                                                    height:
                                                                    24,
                                                                  )
                                                                      : Image
                                                                      .asset(
                                                                    "assets/images/docs.png",
                                                                    width:
                                                                    24,
                                                                    height:
                                                                    24,
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
                                                    )
                                                        : Container();
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(16),
                                                    height: 100,
                                                    width: 100,
                                                    child: imglist[i].endsWith(".jpg")
                                                        ? Image.network(
                                                      AppConstants.LIVE_URL +

                                                          imglist[i],
                                                      // loadingBuilder: (BuildContext
                                                      // context,
                                                      //     Widget child,
                                                      //     ImageChunkEvent
                                                      //     loadingProgress) {
                                                      //   if (loadingProgress ==
                                                      //       null) return child;
                                                      //   return Center(
                                                      //     child:
                                                      //     CircularProgressIndicator(
                                                      //       value: loadingProgress
                                                      //           .expectedTotalBytes !=
                                                      //           null
                                                      //           ? loadingProgress
                                                      //           .cumulativeBytesLoaded /
                                                      //           loadingProgress
                                                      //               .expectedTotalBytes
                                                      //           : null,
                                                      //     ),
                                                      //   );
                                                      // },
                                                    ):
                                                      Icon(
                                                          Icons.list_alt),
                                                    ),
                                                  ),

                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    print("attachement viewed");



                                    /*Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8, top: 2, bottom: 2),
                                        child: TextButton.icon(
                                          onPressed: () {
                                            List<String> imglist =
                                            list.attachFileName!.split(',');
                                            print("sizeimglist" + imglist.length.toString());

                                            showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      for (int i = 0; i < imglist.length; i++)
                                                        InkWell(
                                                          onTap: () {
                                                            imglist[i].endsWith(".jpg")
                                                                ? showDialog(
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
                                                                          imglist[i].endsWith(
                                                                              ".jpg")
                                                                              ? InteractiveViewer(
                                                                            boundaryMargin:
                                                                            const EdgeInsets.all(20.0),
                                                                            minScale:
                                                                            0.1,
                                                                            maxScale:
                                                                            2.5,
                                                                            child: Image
                                                                                .network(
                                                                              AppConstants.LIVE_URL +
                                                                                  '/' +
                                                                                  imglist[i],
                                                                              fit: BoxFit
                                                                                  .fill,

                                                                            ),
                                                                          )
                                                                              : imglist[i].endsWith(
                                                                              ".pdf")
                                                                              ? Image
                                                                              .asset(
                                                                            "assets/images/pdf.png",
                                                                            width:
                                                                            24,
                                                                            height:
                                                                            24,
                                                                          )
                                                                              : Image
                                                                              .asset(
                                                                            "assets/images/docs.png",
                                                                            width:
                                                                            24,
                                                                            height:
                                                                            24,
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
                                                            )
                                                                : Container();
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.all(16),
                                                            height: 100,
                                                            width: 100,
                                                            child: imglist[i].endsWith(".jpg")
                                                                ? Image.network(
                                                              AppConstants.LIVE_URL+
                                                                  '/' +
                                                                  imglist[i],
                                                              // loadingBuilder: (BuildContext
                                                              // context,
                                                              //     Widget child,
                                                              //     ImageChunkEvent
                                                              //     loadingProgress) {
                                                              //   if (loadingProgress ==
                                                              //       null) return child;
                                                              //   return Center(
                                                              //     child:
                                                              //     CircularProgressIndicator(
                                                              //       value: loadingProgress
                                                              //           .expectedTotalBytes !=
                                                              //           null
                                                              //           ? loadingProgress
                                                              //           .cumulativeBytesLoaded /
                                                              //           loadingProgress
                                                              //               .expectedTotalBytes
                                                              //           : null,
                                                              //     ),
                                                              //   );
                                                              // },
                                                            )
                                                                : InkWell(
                                                              onTap: () async {
                                                                launch(AppConstants.LIVE_URL+
                                                                    '/' +
                                                                    imglist[i]);
                                                              },
                                                              child: Icon(
                                                                  Icons.list_alt),
                                                            ),
                                                          ),
                                                        )
                                                    ],
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
                                            'View Attachment',
                                            style: TextStyle(color: Colors.white, fontSize: 10),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );*/
                                   /*showDialog(

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
                                              imglist[i].endsWith(".jpg")
                                                  ? Image.network(
                                                AppConstants.LIVE_URL+
                                                    '/' +
                                                    imglist[i],
                                                // loadingBuilder: (BuildContext
                                                // context,
                                                //     Widget child,
                                                //     ImageChunkEvent
                                                //     loadingProgress) {
                                                //   if (loadingProgress ==
                                                //       null) return child;
                                                //   return Center(
                                                //     child:
                                                //     CircularProgressIndicator(
                                                //       value: loadingProgress
                                                //           .expectedTotalBytes !=
                                                //           null
                                                //           ? loadingProgress
                                                //           .cumulativeBytesLoaded /
                                                //           loadingProgress
                                                //               .expectedTotalBytes
                                                //           : null,
                                                //     ),
                                                //   );
                                                // },
                                              )
                                                  : InkWell(
                                                onTap: () async {
                                                  launch(AppConstants.LIVE_URL+
                                                      '/' +
                                                      imglist[i]);
                                                },
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
                                    );*/
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
                            DataCell(Text(
                                list.empName.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Row(
                              children: [
                                Text(
                                    list.empContactNo.toString(),
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
                                    li3.add(FilterList(

                                        li2.result![i].createdDate,
                                        li2.result![i].docNo,
                                        li2.result![i].brachName,
                                        li2.result![i].branchCode,
                                        li2.result![i].description,
                                        li2.result![i].attachFilePath,
                                        li2.result![i].attachFileName,
                                        li2.result![i].empName,
                                        li2.result![i].empContactNo,
                                        li2.result![i].empMailid,
                                        li2.result![i].modifiedDate,
                                        li2.result![i].empGroup,
                                        li2.result![i].empID


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
                                    li3.add(FilterList(

                                        li2.result![i].createdDate,
                                        li2.result![i].docNo,
                                        li2.result![i].brachName,
                                        li2.result![i].branchCode,
                                        li2.result![i].description,
                                        li2.result![i].attachFilePath,
                                        li2.result![i].attachFileName,
                                        li2.result![i].empName,
                                        li2.result![i].empContactNo,
                                        li2.result![i].empMailid,
                                        li2.result![i].modifiedDate,
                                        li2.result![i].empGroup,
                                        li2.result![i].empID


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

      getTicketListforAllBranch();

      gettickettype().then((value) => getBranchList());
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

  Future<http.Response> getBranchList() async {

    print("getBranchList is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 10,
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

          li5 = BranchMasterModel.fromJson(jsonDecode(response.body));



          setState(() {
            stringlist5.clear();
            stringlist5.add("Select Branch");
            for (int i = 0; i < li5.result!.length; i++)
              stringlist5.add(li5.result![i].branchName.toString());
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

           li5 = BranchMasterModel.fromJson(jsonDecode(response.body));



           setState(() {
             stringlist5.clear();
             stringlist5.add("Select Branch");
             for (int i = 0; i < li5.result!.length; i++)
               stringlist5.add(li5.result![i].branchName.toString());
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

  Future<http.Response> getTicketList() async {

    print("getTicketList is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "BrachName": BranchName1.toString(),
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getcustTckttoAsignnewone'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getcustTckttoAsignnewone');
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

          li2.result!.clear();

        } else {

          print(AppConstants.LIVE_URL + 'getcustTckttoAsignnew');
          print(body);
          print(response.body);

          li2 = WeekUpdateAdminModel.fromJson(jsonDecode(response.body));

          if (li2.result!.length % 20 == 0)
            totalpages = (li2.result!.length / 20).floor();
          else
            totalpages = (li2.result!.length / 20).floor() + 1;
          print(totalpages);

          li3.removeRange(0, li3.length);

          for (int k = 0; k < li2.result!.length; k++) {
            li3.add(FilterList(

                li2.result![k].createdDate,
                li2.result![k].docNo,
                li2.result![k].brachName,
                li2.result![k].branchCode,
                li2.result![k].description,
                li2.result![k].attachFilePath,
                li2.result![k].attachFileName,
                li2.result![k].empName,
                li2.result![k].empContactNo,
                li2.result![k].empMailid,
                li2.result![k].modifiedDate,
                li2.result![k].empGroup,
                li2.result![k].empID


            ));
          }


          // print(li2.result.length);
          setState(() {});

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

   Future<http.Response> getTicketListforAllBranch() async {

     print("getTicketListforAllBranch is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
     //  "BrachName": BranchName1.toString(),
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getcustTckttoAsignnewoneall'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getcustTckttoAsignnewoneall');
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

           li2.result!.clear();

         } else {

           print(AppConstants.LIVE_URL + 'getcustTckttoAsignnew');
           print(body);
           print(response.body);

           li2 = WeekUpdateAdminModel.fromJson(jsonDecode(response.body));

           if (li2.result!.length % 20 == 0)
             totalpages = (li2.result!.length / 20).floor();
           else
             totalpages = (li2.result!.length / 20).floor() + 1;
           print(totalpages);

           li3.removeRange(0, li3.length);

           for (int k = 0; k < li2.result!.length; k++) {
             li3.add(FilterList(

                 li2.result![k].createdDate,
                 li2.result![k].docNo,
                 li2.result![k].brachName,
                 li2.result![k].branchCode,
                 li2.result![k].description,
                 li2.result![k].attachFilePath,
                 li2.result![k].attachFileName,
                 li2.result![k].empName,
                 li2.result![k].empContactNo,
                 li2.result![k].empMailid,
                 li2.result![k].modifiedDate,
                 li2.result![k].empGroup,
                 li2.result![k].empID


             ));
           }


           // print(li2.result.length);
           setState(() {});

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
                                   getTicketList();

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



}


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
  String? description;
  String? attachFilePath;
  String? attachFileName;
  String? empName;
  String? empContactNo;
  String? empMailid;
  String? modifiedDate;
  String? empGroup;
  String? empID;
  FilterList(
      this.createdDate,
      this.docNo,
      this.brachName,
      this.branchCode,
      this.description,
      this.attachFilePath,
      this.attachFileName,
      this.empName,
      this.empContactNo,
      this.empMailid,
      this.modifiedDate,
      this.empGroup,
      this.empID
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


class Animal {
  final int? id;
  final String? name;

  Animal(this.id, this.name);


}
