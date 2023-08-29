import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

import '../Admin/WipAssignTickets.dart';
import '../AppConstants.dart';

import '../Model/UtilityItemDetailsModel.dart';
import '../ServiceStation/TicketCreation.dart';

import 'WipAssignTickets.dart';



class UtilityReportDetailsView extends StatefulWidget {
  final int draftno;
  final String TicketType;
  String Branch1;

  final int id;






  // Function callback;
  UtilityReportDetailsView({Key? key, required this.draftno ,required this.TicketType,required this.id,required this.Branch1/*, this.callback*/})
      : super(key: key);

  /* final String text;
  PurchaseOrderApprovalItem({Key?key, required this.text}) : super(key: key);*/
  @override
  _UtilityReportDetailsViewState createState() =>
      _UtilityReportDetailsViewState();
}

class _UtilityReportDetailsViewState extends State<UtilityReportDetailsView> {
  //EmployeeDataSource employeeDataSource;

  TextEditingController searchcontroller = new TextEditingController();
  TextEditingController textFieldController = new TextEditingController();


  late UtilityItemDetailsModel  li4 =UtilityItemDetailsModel(result: []);


  String _searchResult = '';
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  int selectedIndex = 0;
  bool loading = false;


  late  String UserName,UserID,branchID,BranchName,DepartmentCode,DepartmentName,Location,EmpGroup;
  late bool sessionLoggedIn;

  TextEditingController Edt_PoNo = new TextEditingController();
  TextEditingController Edt_PoDate = new TextEditingController();
  TextEditingController Edt_SupplierName = new TextEditingController();
  TextEditingController ItemCategory = new TextEditingController();
  TextEditingController Edt_ShipFrom = new TextEditingController();
  TextEditingController AssetName = new TextEditingController();
  TextEditingController AssetCode = new TextEditingController();

  TextEditingController ItemName = new TextEditingController();
  TextEditingController BranchName1 = new TextEditingController();
  TextEditingController Priority = new TextEditingController();
  TextEditingController Edt_TotAmount = new TextEditingController();
  TextEditingController Edt_Remarks = new TextEditingController();

  TextEditingController EmpName = new TextEditingController();
  TextEditingController EmpContactNo = new TextEditingController();
  TextEditingController Edt_DelDate = new TextEditingController();
  TextEditingController Edt_PaymentTerms = new TextEditingController();
  TextEditingController Remarks = new TextEditingController();
  TextEditingController RejectReason = new TextEditingController();
  TextEditingController IssueCategory = new TextEditingController();
  TextEditingController Category = new TextEditingController();
  TextEditingController AgeingDays = new TextEditingController();
  TextEditingController AssignEmpName = new TextEditingController();
  TextEditingController AssignEmpContactNo = new TextEditingController();
  TextEditingController TicketStatus = new TextEditingController();
  TextEditingController Quotation = new TextEditingController();

  var format = NumberFormat.currency(
    locale: 'HI',
    symbol: "",
  );


  @override
  void initState() {
    print(widget.draftno);
    print(widget.TicketType);
    getStringValuesSF();

    Edt_PoNo.text=widget.draftno.toString();
    Edt_SupplierName.text=widget.TicketType.toString();
    Edt_ShipFrom.text=widget.Branch1.toString();



      getUtilityItemDetails();









    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(

        title: Text('Utility Item Details'),
        backgroundColor: Colors.blue,
        /* actions: [
            IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Approve',
                onPressed: () {

\


                  _displayTextInputDialog1(
                      context, widget.draftno.toString(), "A");

                }),
            IconButton(
                icon: const Icon(Icons.cancel),
                tooltip: 'Reject',
                onPressed: () {
                  _displayTextInputDialog(
                      context, widget.draftno.toString(), "R");
                }),
          ],*/
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 10,
                child: Row(
                  children: [
                    //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          controller: Edt_PoNo,
                          enabled: false,
                          onSubmitted: (value) {},
                          decoration: InputDecoration(
                            labelText: "Ticket No",
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    new Expanded(
                      flex: 5,
                      child: Container(

                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                //Use of SizedBox
                height: 5,
              ),
              Container(
                height: height / 12,
                child: Row(
                  children: [
                    //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          controller: Edt_SupplierName,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Ticket Type",
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    new Expanded(
                      flex: 5,
                      child: Container(
                        color: Colors.white,
                        child: new TextField(
                          controller: Edt_ShipFrom,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Branch",
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(0))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              li4.result!.isNotEmpty?Material(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(5.0),
                    scrollDirection: Axis.horizontal,
                    child: li4.result!.isNotEmpty
                        ? DataTable(
                      columnSpacing: 5.0,
                      headingRowColor:
                      MaterialStateProperty.all(Colors.blue.shade900),

                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'Sno',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ItemCode',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'ItemName',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'UOM',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Qty',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'createdBy',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),



                      ],
                      rows: li4.result!
                          .map(
                            (list) => DataRow(

                            color:MaterialStateColor.resolveWith((states) => Colors.white24),

                            cells: [
                              DataCell(Wrap(
                                  direction: Axis.vertical, //default
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Text((li4.result!.indexOf(list)+
                                        1)
                                        .toString(),
                                        textAlign: TextAlign.start)
                                  ])),
                              DataCell(Text(

                                  list.itemCode.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(Text(

                                  list.itemName.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(Text(
                                  list.uOM.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(Text(
                                  list.qty.toString(),
                                  textAlign: TextAlign.center)),
                              DataCell(Text(
                                  list.createdBy.toString(),
                                  textAlign: TextAlign.center)),

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
                ),
              ):Container(),

              /*SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: li4 != null
                      ? SfDataGridTheme(
                          data: SfDataGridThemeData(headerColor: Colors.redAccent),
                          child: SfDataGrid(
                            //frozenColumnsCount: 1,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            source: employeeDataSource,
                            columnWidthMode: ColumnWidthMode.auto,
                            columns: <GridColumn>[
                              GridColumn(
                                  columnName: 'ItemCode',
                                  label: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'ItemCode',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'ItemName',
                                  label: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 20),
                                      child: Text(
                                        'ItemName',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'UOM',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'UOM',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'Req Quantity',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Req Quantity',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'On Hand Stock',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text(
                                          'On Hand Stock',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ))),
                              GridColumn(
                                  columnName: 'Price',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Price',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'Last Purchase Price',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Last Purchase Price',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'LineTotal',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'LineTotal',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'Tax Code',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Tax Code',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              GridColumn(
                                  columnName: 'Tax Amount',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Tax Amount',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                              /*
                              GridColumn(
                                  columnName: 'PriceBeforeDisc',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'PriceBeforeDisc',
                                        style: TextStyle(color: Colors.white),
                                      ))),*/
                              GridColumn(
                                  columnName: 'Total',
                                  label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Total',
                                        style: TextStyle(color: Colors.white),
                                      ))),
                            ],
                            //selectionMode: SelectionMode.multiple,
                          ),
                        )
                      : Container(
                          child: Center(
                            child: Text('No Data Found!'),
                          ),
                        ),
                ),*/
            ],
          ),
        ),
      ),
    );

  }

  /* Future<http.Response> getgridItemsheader() async {

    print("getgridItemsheader was called");
    var headers = {"Content-Type": "application/json"};
    var body = {"DocEntry": "${widget.draftno}"};
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(Appconstants.LIVE_URL + '/singleheaderPoPendingList'),
        body: jsonEncode(body),
        headers: headers);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == "0") {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        headerlist = PoHeaderModel.fromJson(jsonDecode(response.body));
        print(headerlist);
        Edt_SupplierName.text = headerlist.result[0].cardName;
        Edt_PoNo.text = headerlist.result[0].pONum.toString();
        Edt_PoDate.text = headerlist.result[0].pODate.toString();
        Edt_PlaceOfsupply.text = headerlist.result[0].placeofSupply.toString();
        Edt_ShipFrom.text = headerlist.result[0].shipToCode.toString();
        Edt_TotBefDiscount.text =
            format.format(headerlist.result[0].totBefDisc);
        Edt_DiscPercent.text = format.format(headerlist.result[0].discPrcnt);
        Edt_TaxAmount.text = format.format(headerlist.result[0].taxAmount);
        Edt_TotAmount.text = format.format(headerlist.result[0].docTotal);
        Edt_Remarks.text = headerlist.result[0].comments.toString();
        Edt_PaymentTerms.text = headerlist.result[0].PymntGroup.toString();
        Edt_DelDate.text = headerlist.result[0].delDate.toString();
        Edt_Cur.text = headerlist.result[0].docCur.toString();
        Edt_Freight.text = format.format(headerlist.result[0].docTotalFC);
        Remarks.text = headerlist.result[0].comments.toString();
      }
     // getgridItems();
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Login API');
    }
  }

  Future<http.Response> getgridItems() async {
    var headers = {"Content-Type": "application/json"};
    var body = {"DocEntry": "${widget.draftno}"};
    setState(() {
      loading = true;
    });
    final response = await http.post(
        Uri.parse(Appconstants.LIVE_URL + '/singlePOPendingList'),
        body: jsonEncode(body),
        headers: headers);
    setState(() {
      loading = false;
    });
    if (response.statusCode == 200) {
      getgridlist = PoDetailModel.fromJson(jsonDecode(response.body));
      print(response.body);
      if (jsonDecode(response.body)["status"] == "0") {
        Fluttertoast.showToast(
            msg: "No Data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        li4 = PoDetailModel.fromJson(jsonDecode(response.body));
        employeeDataSource = EmployeeDataSource(li4: li4);
      }
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
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


    });
  }

  Future<http.Response> getUtilityItemDetails() async {

    print("getUtilityItemDetails is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 27,
      "UserID": widget.draftno.toString(),
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
          li4.result!.clear();

        }else if (json.decode(response.body)["status"] == "0" &&
            jsonDecode(response.body)["result"].toString() == []) {
          li4.result!.clear();

        } else if (json.decode(response.body)["status"] == 1 &&
            jsonDecode(response.body)["result"].toString() == "[]") {
          li4.result!.clear();


        }else{

          li4 = UtilityItemDetailsModel  .fromJson(jsonDecode(response.body));


          setState(() {

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







/* Future<http.Response> updateindentlist(
      int docentry, int UserID, String Remarks, String Status) async {
    print("updateindentlist was called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "DocEntry": docentry,
      "UserID": UserID,
      "Remarks": Remarks,
      "Type": Status,
      "PostingObject":"22".toString()
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
        print("fgfdg");
        // widget.callback();
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PurchaseApprovalList()),
            (route) => false);
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }*/


}

/*class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({PoDetailModel li4}) {
    var format = NumberFormat.currency(
      locale: 'HI',
      symbol: "",
    );
    _employeeData = li4.result
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'ItemCode',
                value:
                    e.itemCode.toString() == '' ? 'NA' : e.itemCode.toString(),
              ),
              DataGridCell<String>(
                  columnName: 'ItemName', value: e.itemName.toString()),
              DataGridCell<String>(columnName: 'UOM', value: e.uOM.toString()),
              DataGridCell<String>(
                  columnName: 'Quantity',
                  value: e.quantity.toString() == "0"
                      ? 'NA'
                      : format.format(e.quantity)),
              DataGridCell<String>(
                  columnName: 'On Hand Stock',
                  value: e.OnHand.toString() == "0"
                      ? "0"
                      : format.format(e.OnHand)),
              DataGridCell<String>(
                  columnName: 'Price', value: e.price.toStringAsFixed(2)),
              DataGridCell<String>(
                  columnName: 'Last Purchase Price',
                  value: e.LastPrice.toString() == "0"
                      ? 'NA'
                      : format.format(e.LastPrice)),
              DataGridCell<String>(
                  columnName: 'Line Total',
                  //value: double.parse(e.lineTotal).toStringAsFixed(2)),
                  value: format.format(e.lineTotal)),
              DataGridCell<String>(
                  columnName: 'Tax Code', value: e.taxCode.toString()),
              DataGridCell<String>(
                  columnName: 'Tax Amount', value: format.format(e.taxAmount)),
              /*DataGridCell<String>(
                  columnName: 'PriceBeforeDisc',
                  value: e.priceBeforeDisc.toStringAsFixed(2)),*/
              DataGridCell<String>(
                  columnName: 'Total', value: format.format(e.priceAfterDisc)),
            ]))
        .toList();

    print(_employeeData);
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          textAlign: TextAlign.left,
        ),
      );
    }).toList());
  }
}*/

class FilterList2 {
  String? createdDate;
  String? createdDate1;
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
  String? quotaion;
  String? vechileType;
  String? branchCategory;
  String? branchCategoryID;
  String? issueTypeSortName;
  String? branchCategorySortName;
  FilterList2(
      this.createdDate,
      this.createdDate1,
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
      this.assetCode,
      this.quotaion,
      this.vechileType,
      this.branchCategory,
      this.branchCategoryID,
      this.issueTypeSortName,
      this.branchCategorySortName
      );
}
