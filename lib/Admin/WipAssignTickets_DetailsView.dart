import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';

import '../AppConstants.dart';
import 'AssignTickets.dart';
import 'WipAssignTickets.dart';



class WipAssignTicketsDetailsView extends StatefulWidget {
  final int draftno;
  final String TicketType;
  String Branch1;

 final int id;


  List<FilterList3> list2;


  // Function callback;
  WipAssignTicketsDetailsView({Key? key, required this.draftno ,required this.TicketType,required this.list2,required this.id,required this.Branch1/*, this.callback*/})
      : super(key: key);

  /* final String text;
  PurchaseOrderApprovalItem({Key?key, required this.text}) : super(key: key);*/
  @override
  _WipAssignTicketsDetailsViewState createState() =>
      _WipAssignTicketsDetailsViewState();
}

class _WipAssignTicketsDetailsViewState extends State<WipAssignTicketsDetailsView> {
  //EmployeeDataSource employeeDataSource;

  TextEditingController searchcontroller = new TextEditingController();
  TextEditingController textFieldController = new TextEditingController();


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
  TextEditingController IssueCategory = new TextEditingController();
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

    Edt_PoNo.text=widget.list2[widget.id].ticketNo.toString();
    Edt_PoDate.text=widget.list2[widget.id].requiredDate.toString();
    Edt_SupplierName.text=widget.list2[widget.id].category.toString();
    Edt_ShipFrom.text=widget.list2[widget.id].issueType.toString();
    ItemCategory.text=widget.list2[widget.id].itemCode.toString();
    ItemName.text=widget.list2[widget.id].itemName.toString();
    AssetName.text=widget.list2[widget.id].assetName.toString();
    AssetCode.text=widget.list2[widget.id].assetCode.toString();
    BranchName1.text=widget.list2[widget.id].brachName.toString();
    Priority.text=widget.list2[widget.id].priority.toString();
    Remarks.text=widget.list2[widget.id].description.toString();
    EmpName.text=widget.list2[widget.id].empName.toString();
    EmpContactNo.text=widget.list2[widget.id].empContactNo.toString();
    AssignEmpName.text=widget.list2[widget.id].assignEmpName.toString();
    AssignEmpContactNo.text=widget.list2[widget.id].assignEmpcontactNo.toString();
    IssueCategory.text=widget.list2[widget.id].issueType.toString();
    TicketStatus.text=widget.list2[widget.id].status.toString()=="T"?"ThirdParty":widget.list2[widget.id].status.toString()=="Q"?"Quotation":widget.list2[widget.id].status.toString()=="O"?"Open Tickets":widget.list2[widget.id].status.toString()=="P"?"Work IN Progress":widget.list2[widget.id].status.toString()=="S"?"Resolved":widget.list2[widget.id].status.toString()=="R"?"Reject":widget.list2[widget.id].status.toString()=="RO"?"Re-Open":"Approved";
    Quotation.text=widget.list2[widget.id].quotaion.toString();
    AgeingDays.text=    widget.list2[widget.id].status!=
        "C"
        ? '${DateTime.now().difference(DateFormat("yyyy-MM-dd").parse(widget.list2[widget.id].createdDate.toString())).inDays.toString()}'
        : '${DateFormat("yyyy-MM-dd").parse(widget.list2[widget.id].createdDate.toString()).difference(DateFormat("yyyy-MM-dd").parse(widget.list2[widget.id].createdDate.toString())).inDays.toString()}';





    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(

          title: Text('Ticket Details'),
          backgroundColor: Colors.blue,
         /* actions: [
            IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Approve',
                onPressed: () {


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
                          color: Colors.white,
                          child: new TextField(
                            controller: Edt_PoDate,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Required Date",
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
                              labelText: "Issue Type",
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
                            controller: IssueCategory,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Issue Type",
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
                            controller: AgeingDays,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Ageing Days",
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
                            controller: TicketStatus,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Ticket Status",
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
                      Quotation.text!="null"||Quotation.text!="null"?Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            controller: Quotation,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Quotation",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(0))),
                            ),
                          ),

                        ),


                      ):Container(),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5,
                ),

                if(widget.TicketType=="Tools")Container(
                  height: height / 12,
                  child: Row(
                    children: [
                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                      new Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            controller: ItemCategory,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Item Category",
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
                            controller: ItemName,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Item Name",
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
                if(widget.TicketType=="Tools")SizedBox(
                  height: 10,
                ),

                if(widget.TicketType=="Assets")Container(
                  height: height / 12,
                  child: Row(
                    children: [
                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                      new Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            controller: AssetName,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Assset Name",
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
                            controller: AssetCode,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Asset Code",
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
                if(widget.TicketType=="Assets")SizedBox(
                  height: 10,
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
                            controller: EmpName,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Emp Name",
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
                        flex: 6,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            controller: EmpContactNo,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Emp Contact No",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(0))),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      new Expanded(
                        flex: 3,
                        child:widget.list2[widget.id].empContactNo.toString()!=null
                            &&
                            widget.list2[widget.id].empContactNo.toString().length>9?
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
                                      var url = 'tel:${widget.list2[widget.id].empContactNo.toString()}';

                                      await launch(url);
                                    },
                                    child: Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    )))
                        ):Container()
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                if(AssignEmpName.text.isNotEmpty)SizedBox(
                  height: 10,
                ),
                if(AssignEmpName.text.isNotEmpty)Container(
                  height: height / 12,
                  child: Row(
                    children: [
                      //new Expanded(flex: 1, child: new Text("Scan Pallet")),
                      new Expanded(
                        flex: 5,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            controller: AssignEmpName,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Assign Emp Name",
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
                        flex: 6,
                        child: Container(
                          color: Colors.white,
                          child: new TextField(
                            controller: AssignEmpContactNo,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Assign Emp Contact No",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(0))),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      new Expanded(
                          flex: 3,
                          child:widget.list2[widget.id].assignEmpcontactNo.toString()!=null
                              &&
                              widget.list2[widget.id].assignEmpcontactNo.toString().length>9?
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
                                        var url = 'tel:${widget.list2[widget.id].assignEmpcontactNo.toString()}';

                                        await launch(url);
                                      },
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.green,
                                      )))
                          ):Container()
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                            controller: BranchName1,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Branch Name",
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
                            style: TextStyle(fontWeight:FontWeight.bold,color:Priority.text.trim().toString()=="High"?Colors.red:Priority.text.trim().toString()=="Medium"?Colors.orangeAccent:Colors.green,),
                            controller: Priority,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Priority",
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                            child: widget.list2[widget.id].attachFileName.toString()!=null
                                &&
                                widget.list2[widget.id].attachFileName.toString().isNotEmpty?Column(
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
                                                        widget.list2[widget.id].attachFileName.toString(),
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
                              ],
                            ):Container(child:Text("No Attachement"),),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
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
                            controller: Remarks,
                            enabled: false,
                            onSubmitted: (value) {},
                            decoration: InputDecoration(
                              labelText: "Discription",
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

  Future _displayTextInputDialog(
      BuildContext context, String DocEntry, String Status) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";

          textFieldController.text = '';
          return AlertDialog(
            title: Text('Enter Rejection Reason'),
            content: TextField(
              /*onChanged: (value) {
                setState(() {
                  valuetext = value;
                });
              },*/
              controller: textFieldController,
              decoration: InputDecoration(hintText: "Enter The Remarks"),
            ),
            actions: <Widget>[
              TextButton(
               // color: Colors.red,
               // textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
               // color: Colors.green,
               // textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {

                          if(textFieldController.text!="") {
                            updateTicketStatus(7, int.parse(widget.list2[widget.id].docNo
                                .toString()), widget.list2[widget.id].brachName.toString(),
                                textFieldController.text);
                            Navigator.pop(context);
                          }else{

                            Fluttertoast.showToast(msg: "Remarks should not be left empty");
                          }

                     /* updateindentlist(int.parse(DocEntry),
                          int.parse(userid), _textFieldController.text, Status);*/


                  });
                },
              ),
            ],
          );
        });
  }
  Future _displayTextInputDialog1(
      BuildContext context, String DocEntry, String Status) async {
    return showDialog(
        context: context,
        builder: (context) {
          //String valuetext = "";


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
              ElevatedButton(
                          style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20,color:Colors.red),),
                          onPressed: () {
                          setState(() {
                          Navigator.pop(context);
                          });
                          },
                          child: Text("CANCEL"),

                    ),

                    ElevatedButton(
                    style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20,color:Colors.green),),
                      onPressed: () {
                              setState(() {


                                updateTicketStatus(8,int.parse(widget.list2[widget.id].docNo.toString()),widget.list2[widget.id].brachName.toString(),textFieldController.text);
                                Navigator.pop(context);



                              });
                      },
                      child: Text("OK"),

          ),

            ],
          );
        });
  }

  Future<http.Response> updateTicketStatus(int formID,int DocNo,String BranchName,String Remarks) async {
    print("updateTicketStatus(int formID) was called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": formID,
      "Solution": Remarks.toString(),
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

                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (builder) => Assign_Tickets( status:"2",Tickettype:widget.TicketType,BranchName:widget.Branch1)),

                                   );
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
