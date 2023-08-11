import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
import '../String_Values.dart';



class SuperAdminAllTicketReports extends StatefulWidget {
   SuperAdminAllTicketReports({ Key? key, required  String this.getScreenName,required String this.getTicketType}) : super(key: key);

  String getScreenName;
  String getTicketType;


  @override
  SuperAdminAllTicketReportsState createState() => SuperAdminAllTicketReportsState();
}

class SuperAdminAllTicketReportsState extends State<SuperAdminAllTicketReports> {
 // ApprovalPendingModel li2;

   TicketTypeModel li4=TicketTypeModel(result: []);
   CustomerTicketsModel li2 =CustomerTicketsModel(result: []);
  BranchMasterModel li5=BranchMasterModel(result: []);
   TicketStatusModel li10 =TicketStatusModel(result :[]);
   AssignEmpDepartmentModel li11=AssignEmpDepartmentModel(result :[]);
   TicketStatusFilterModel li13 =TicketStatusFilterModel(result :[]);
   AssignEmpListBasedOnDepartmentModel li12=AssignEmpListBasedOnDepartmentModel(result :[]);
  List<FilterList2> li3 = [];
  TextEditingController searchcontroller = new TextEditingController();
  TextEditingController RemarksController =new TextEditingController();
  String _searchResult = '';
   List<selectedListModel> selectedDatalist = [];


   bool ItemVisible =false;

  late  String UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location,EmpGroup;
  late bool sessionLoggedIn;

  var dropdownValue2 = "Select Ticket Type";
  var stringlist2 = ["Select Ticket Type"];

  String TicketType="ALL";

   String Ticketcode="ALL";

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


   String BranchName1="ALL";

   String BranchCode="Brnch-00";



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

   var selectdate = DateFormat("dd-MM-yyyy").format(DateTime.now());

   var excel = Excel.createExcel();

   late Directory tempDir;

   late Directory path;



   Future<void> attendanceReport() async {
     CellStyle headercellStyle = CellStyle(
       backgroundColorHex: "#bec4c0",
       bold: true,
       italic: false,
       fontSize: 12,
       textWrapping: TextWrapping.WrapText,
       fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
       rotation: 0,
     );

     var currentDaySheet = excel['Sheet1'];
     // var monthlySheet = excel['MonthlySheet'];

     List<String> dataList = [
       'S.No',
       'Date',
       'EmpName',
       'TicketNo',
       'TicketType',
       'Description',
       'priority',
       'Status',
       'Branch'
     ];

     int colIndex = 0;
     dataList.forEach((colValue) {
       currentDaySheet.cell(
         CellIndex.indexByColumnRow(
           rowIndex: colIndex,
           columnIndex: currentDaySheet.maxCols,
         ),
       )
         ..value = colValue
         ..cellStyle = headercellStyle;
     });

     //todo:detail insert datas IN ROW
     //TODO:S.No DATA

     int colIndex1 = 0;
     int sno = 1;
     li2.result!.forEach((colValue) {
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: currentDaySheet.maxRows,
         columnIndex: colIndex1,
       ))
         ..value = sno;


       sno++;
     });

// TODO:DATE DATA IN LIST
     int colIndex2 = 1;
     currentDaySheet.cell(CellIndex.indexByString("B1"));
     int i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex2,
       ))
         ..value = DateFormat("dd-MM-yyyy").format(DateTime.parse(colValue.createdDate.toString()));
       i++;
     });

     // TODO:EMPLOYYEID DATA IN LIST
     int colIndex3 = 2;
     currentDaySheet.cell(CellIndex.indexByString("C1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex3,
       ))
         ..value = colValue.empName;
       i++;
     });

     // TODO:EMPLOYYENAME DATA IN LIST
     int colIndex4 = 3;
     currentDaySheet.cell(CellIndex.indexByString("D1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex4,
       ))
         ..value = colValue.ticketNo;
       i++;
     });

     // TODO:LOCATION TYPE DATA IN LIST
     int colIndex5 = 4;
     currentDaySheet.cell(CellIndex.indexByString("E1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex5,
       ))
         ..value = colValue.category;
       i++;
     });

     // TODO:LOCATION NAME DATA IN LIST
     int colIndex6 = 5;
     currentDaySheet.cell(CellIndex.indexByString("F1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex6,
       ))
         ..value = colValue.description;
       i++;
     });

     // TODO:FROM TIME DATA IN LIST
     int colIndex7 = 6;
     currentDaySheet.cell(CellIndex.indexByString("G1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex7,
       ))
         ..value = colValue.priority=='High'?"H":colValue.priority=='Medium'?"M":"L";
       i++;
     });

     // TODO:STATUS DATA IN LIST
     int colIndex8 = 7;
     currentDaySheet.cell(CellIndex.indexByString("H1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex8,
       ))
         ..value = colValue.status=='O'?"Open Tickets":colValue.status=='Q'?"Quotation":colValue.status=='T'?"ThirdParty":colValue.status=='P'?"Work IN Progress":colValue.status=='S'?"Resolved":colValue.status=='R'?"Reject":"Approved";
       i++;
     });

     // TODO:PLACE DATA IN LIST
     int colIndex9 = 8;
     currentDaySheet.cell(CellIndex.indexByString("H1"));
     i = 1;
     li2.result!.forEach((colValue) {
       print(colValue);
       currentDaySheet.cell(CellIndex.indexByColumnRow(
         rowIndex: i,
         columnIndex: colIndex9,
       ))
         ..value = colValue.brachName;
       i++;
     });

     // Saving the file
     if (li2.result!.isNotEmpty) {
       if (Platform.isAndroid) {
         path = (await getExternalStorageDirectory())!;
       } else if (Platform.isIOS) {
         path = await getApplicationDocumentsDirectory();
       }
// path=await getTemporaryDirectory()
       String outputFile = "${path.path}/TicketReport$selectdate.xlsx";
       print(outputFile);
       //stopwatch.reset();
       List<int>? fileBytes = excel.save();
       //print('saving executed in ${stopwatch.elapsed}');
       if (fileBytes != null) {
         File(join(outputFile))
           ..createSync(recursive: true)
           ..writeAsBytesSync(fileBytes);
         Fluttertoast.showToast(
             msg: "TicketReport$selectdate.xlsx is saved!!",
             gravity: ToastGravity.BOTTOM,
             backgroundColor: Colors.indigo,
             textColor: Colors.white);


         final File file = File('${path.path}/TicketReport$selectdate.xlsx');
         await file.writeAsBytes(fileBytes).then((value) async =>
         await OpenFile.open('${path.path}/TicketReport$selectdate.xlsx'));
       }
     } else {
       Fluttertoast.showToast(
           msg: "No Records Found!!!",
           gravity: ToastGravity.TOP,
           backgroundColor: Colors.red,
           textColor: Colors.white);
     }
   }


   Future<http.Response> AdminFilterAPI(int formID)  async {

     print("AdminFilterAPI is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "FormID": formID,
       "TicketType": TicketType.toString(),
       "Ticketcode": Ticketcode.toString(),
       "BranchCode": BranchCode.toString(),
       "BranchName1":BranchName1.toString() ,
       "TicketStatusCode":widget.getTicketType.toString(),
       "TicketStatusName":widget.getTicketType.toString(),
       "Extra1":"",
       "Extra2":"",
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'AdminFiltersCategory'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'AdminFiltersCategory');
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
             li3.add(FilterList2(



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
                 li2.result![k].quotation,
                 li2.result![k].issueTypeSortName,
                 li2.result![k].branchCategorySortName

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

          title: Text(widget.getScreenName.toString()+" Reports"),

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
                    if(val=="ALL"){
                      TicketType="ALL";
                      Ticketcode="ALL";


                    }else {
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
                    }

                    setState(() {


                      AdminFilterAPI(4);
                     // if (TicketType.isNotEmpty&&BranchName1.isEmpty&&FilterStatusName.isEmpty){
                     //   print("TicketType.isNotEmpty");
                     //   getTicketListBasedOnTicketCategory();
                     //  } else if(BranchName1.isNotEmpty&&TicketType.isNotEmpty&&FilterStatusName.isEmpty){
                     //   print("BranchName1.isNotEmpty&&FilterStatusName"
                     //       ".isNotEmpty");
                     //   getTicketListBasedOnTicketCategoryandBranch();
                     //
                     // }else {
                     //
                     //   print("Else");
                     //   getTicketList();
                     //
                     //
                     //  }
                    });



                  },
                  selectedItem: TicketType,
                ),


                /*Padding(
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

                      selectedlist.clear();


                      if (TicketType.isNotEmpty&&BranchName1.isNotEmpty) {
                        print("TicketType.isNotEmpty");
                        getTicketListBasedOnTicketCategoryandBranch();
                      } else {

                        getTicketList(FilterStatusCode);

                      }
                    });
                  },
                  selectedItem: BranchName1,
                ),*/

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Branch", style: TextStyle(fontWeight:FontWeight.bold)),
                      Text("Count", style: TextStyle(fontWeight:FontWeight.bold)),
                    ],
                  ),
                ),



                Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child:   DropdownSearch<String>(
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

                            AdminFilterAPI(4);
                            // if (TicketType.isNotEmpty&&BranchName1.isEmpty&&FilterStatusName.isEmpty){
                            //   print("TicketType.isNotEmpty");
                            //   getTicketListBasedOnTicketCategory();
                            // } else if(BranchName1.isNotEmpty&&TicketType.isNotEmpty&&FilterStatusName.isEmpty){
                            //   print("BranchName1.isNotEmpty&&FilterStatusName"
                            //       ".isNotEmpty");
                            //   getTicketListBasedOnTicketCategoryandBranch();
                            //
                            // }else {
                            //
                            //   print("Else");
                            //   getTicketList();
                            //
                            //
                            // }
                          });
                        },
                        selectedItem: BranchName1,
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
                                li3.add(FilterList2(

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
                                    li2.result![k].quotation,
                                    li2.result![k].issueTypeSortName,
                                    li2.result![k].branchCategorySortName

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
                              li3.add(FilterList2(
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
                                  li2.result![k].quotation,
                                  li2.result![k].issueTypeSortName,
                                  li2.result![k].branchCategorySortName
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

                      if(FilterStatusName=="")DataColumn(
                        label: Text(
                          'Type',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Branch',
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
                          'Category',
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
                          'EmpContactNo',
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
                      DataColumn(
                        label: Text(
                          'Req Date',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      DataColumn(
                        label: Text(
                          'Created',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Description',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),



                    ],
                    rows: li3
                        .map(
                          (list) => DataRow(
                          // selected: selectedlist.contains(
                          //     list.docNo.toString()),
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

                            if(FilterStatusName=="")DataCell(Text(
                                list.category.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.status!.toLowerCase().toString()=='t'?"ThirdParty".toString():list.status!.toLowerCase().toString()=='q'?"Quotation":list.status!.toLowerCase().toString()=='o'?"Open":list.status!.toLowerCase().toString()=='p'?"Work IN Progress":list.status!.toLowerCase().toString()=='r'?"Reject":list.status!.toLowerCase().toString()=='a'?"Approved":list.status!.toLowerCase().toString()=='c'?"Closed":"Re-Open",
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.ticketNo.toString(),
                                textAlign: TextAlign.center)),

                            DataCell(Text(
                                list.brachName.toString(),
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                style: TextStyle(fontWeight:FontWeight.bold,color:list.priority.toString()=="High"?Colors.red:list.priority.toString()=="Medium"?Colors.orangeAccent:Colors.green,),
                                list.priority.toString()=="High"?"H":list.priority.toString()=="Medium"?"M":"L",
                                textAlign: TextAlign.center)),
                            DataCell(Text(
                                list.issueCatrgory.toString(),
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
                            DataCell(Text(
                                list.requiredDate.toString(),
                                textAlign: TextAlign.center)),



                            DataCell(Text(
                                list.empName.toString(),
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

                            // DataCell(Wrap(
                            //     direction:
                            //         Axis.vertical, //default
                            //     alignment: WrapAlignment.center,
                            //     children: [
                            //       Text(list.Location.toString(),
                            //           textAlign:
                            //               TextAlign.center)
                            //     ])),

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
                                    li3.add(FilterList2(

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
                                        li2.result![i].quotation,
                                        li2.result![i].issueTypeSortName,
                                        li2.result![i].branchCategorySortName

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
                                    li3.add(FilterList2(


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
                                        li2.result![i].quotation,
                                        li2.result![i].issueTypeSortName,
                                        li2.result![i].branchCategorySortName

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
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {

              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext bc) {
                    return SafeArea(
                      child: Container(
                        child: Wrap(
                          children: <Widget>[
                            new ListTile(
                              // leading: new Icon(Icons.),
                                title: new Text('Excel'),
                                onTap: () {

                                  attendanceReport();


                                 // generateSalesReportExcel();
                                  Navigator.of(context).pop();
                                }),
                            // new ListTile(
                            //   // leading: new Icon(Icons.photo_camera),
                            //   title: new Text('Pdf'),
                            //   onTap: () {
                            //     generateSalesReport(context);
                            //     Navigator.of(context).pop();
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    );
                  }
              );



              //                Excel excel;
              //                 excel = Excel.createExcel();
              //                Sheet sheetObject = excel['Sales Report'];
              //                sheetObject.appendRow([""]);
              //                sheetObject.appendRow([""]);
              //                sheetObject.appendRow(["OrderNo","Name", "GST No","Bill Date","Bill Amount","Advance","Discount", "Balance Receivable"]);
              //                for(int i=0;i<li6.details.length;i++)
              //                 sheetObject.appendRow([li6.details[i].orderNo, li6.details[i].name, li6.details[i].invNo,"${DateFormat("hh:mm a, dd-MM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(int.parse(li6.details[i].docDate.toString().replaceAll("/Date(", "").replaceAll(")/", ""))))}",li6.details[i].orderPrice,li6.details[i].advanceAmount,li6.details[i].disAmount,"${li6.details[i].orderPrice-li6.details[i].advanceAmount-li6.details[i].disAmount}"]);
              //
              //                CellStyle cellStyle = CellStyle(backgroundColorHex: "#1AFF1A", fontFamily : getFontFamily(FontFamily.Calibri));
              //
              //                cellStyle.underline = Underline.Single; // or Underline.Double
              //
              //
              //                var cell = sheetObject.cell(CellIndex.indexByString("A3"));
              //                // cell.value = 8; // dynamic values support provided;
              //                cell.cellStyle = cellStyle;
              //                 cell = sheetObject.cell(CellIndex.indexByString("B3"));
              //                cell.cellStyle = cellStyle;
              //                cell = sheetObject.cell(CellIndex.indexByString("C3"));
              //                cell.cellStyle = cellStyle;
              //                cell = sheetObject.cell(CellIndex.indexByString("D3"));
              //                cell.cellStyle = cellStyle;
              //                cell = sheetObject.cell(CellIndex.indexByString("E3"));
              //                cell.cellStyle = cellStyle;
              //                cell = sheetObject.cell(CellIndex.indexByString("F3"));
              //                cell.cellStyle = cellStyle;
              //                cell = sheetObject.cell(CellIndex.indexByString("G3"));
              //                cell.cellStyle = cellStyle;
              //                cell = sheetObject.cell(CellIndex.indexByString("H3"));
              //                cell.cellStyle = cellStyle;
              // //                 var sheet = excel['mySheet'];
              // //
              // //                 var cell = sheet.cell(CellIndex.indexByString("A1"));
              // //                 cell.value = "Heya How are you I am fine ok goood night";
              // //                 cell.cellStyle = cellStyle;
              // //
              // //                 var cell2 = sheet.cell(CellIndex.indexByString("E5"));
              // //                 cell2.value = "Heya How night";
              // //                 cell2.cellStyle = cellStyle;
              // //                 /*
              // // * sheetObject.appendRow(list-iterables);
              // // * sheetObject created by calling - // Sheet sheetObject = excel['SheetName'];
              // // * list-iterables === list of iterables
              // // */
              // //
              // //
              // //
              // //
              // //                 /// printing cell-type
              // //                 print("CellType: " + cell.cellType.toString());
              //
              //                 ///
              //                 ///
              //                 /// Iterating and changing values to desired type
              //                 ///
              //                 ///
              //                 // for (int row = 0; row < sheet.maxRows; row++) {
              //                 //   sheet.row(row).forEach((cell1) {
              //                 //     if (cell1 != null) {
              //                 //       cell1.value = ' My custom Value ';
              //                 //     }
              //                 //   });
              //                 // }
              //
              //                 var fileBytes = excel.save();
              //                 var tempDir;
              //                 if (Platform.isAndroid) {
              //                   tempDir = await getTemporaryDirectory();
              //                   // Android-specific code
              //                 } else {
              //                   tempDir = await getApplicationDocumentsDirectory();
              //                   // iOS-specific code
              //                 }
              //                 String tempPath = tempDir.path;
              //                 print("$tempPath/text.xlsx");
              //                 File(join("$tempPath/text.xlsx"))
              //                   ..createSync(recursive: true)
              //                   ..writeAsBytesSync(fileBytes);
            },
            icon: Icon(Icons.download_outlined),
            backgroundColor: String_Values.primarycolor,
            label: Text("Download")));


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
    });data

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

      AdminFilterAPI(4);

      gettickettype().then((value) => getBranchList()).then((value) => getTicketStatusList()).then((value) => getTicketStatusfilterList());
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
            stringlist2.add("ALL");
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

  Future<http.Response> getTicketList() async {

    print("getTicketList is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "BrachName": BranchName1.toString(),
      "Status":widget.getTicketType.toString()
    };

    print(body);
    setState(() {
      loading = true;
    });
    try {
      final response = await http.post(
          Uri.parse(AppConstants.LIVE_URL + 'getTicketsBasedonBranch'),
          body: jsonEncode(body),
          headers: headers);
      print(AppConstants.LIVE_URL + 'getTicketsBasedonBranch');
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

          print(AppConstants.LIVE_URL + 'getTicketsBasedonBranch');
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
            li3.add(FilterList2(

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
                li2.result![k].quotation,
                li2.result![k].issueTypeSortName,
                li2.result![k].branchCategorySortName

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
       "Status":widget.getTicketType.toString()
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryforAdmin'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryforAdmin');
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

           print(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryforAdmin');
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
             li3.add(FilterList2(

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
                 li2.result![k].quotation,
                 li2.result![k].issueTypeSortName,
                 li2.result![k].branchCategorySortName

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


   Future<http.Response> getTicketListBasedOnTicketCategoryandBranch() async {

     print("getTicketListBasedOnTicketCategoryandBranch is called");
     var headers = {"Content-Type": "application/json"};
     var body = {
       "TicketCategory": TicketType.toString(),
       "BrachName": BranchName1.toString(),
       "Status":widget.getTicketType.toString()
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryandBranchforReport'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getOpenTicketsBasedOnCategoryandBranchforReport');
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
             li3.add(FilterList2(

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
                 li2.result![k].quotation,
                 li2.result![k].issueTypeSortName,
                 li2.result![k].branchCategorySortName

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
       "Status": widget.getTicketType.toString(),
     };

     print(body);
     setState(() {
       loading = true;
     });
     try {
       final response = await http.post(
           Uri.parse(AppConstants.LIVE_URL + 'getOpenTicketsforAdmin'),
           body: jsonEncode(body),
           headers: headers);
       print(AppConstants.LIVE_URL + 'getOpenTicketsforAdmin');
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

           print(AppConstants.LIVE_URL + 'getOpenTicketsforAdmin');
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
             li3.add(FilterList2(

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
                 li2.result![k].quotation,
                 li2.result![k].issueTypeSortName,
                 li2.result![k].branchCategorySortName

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
                              ''
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
                              ''
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

class FilterList2 {
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
  String? quotation;
  String? issueTypeSortName;
  String? branchCategorySortName;

  FilterList2(
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
      this.quotation,
  this.issueTypeSortName,
  this.branchCategorySortName
      );
}


