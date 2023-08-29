import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstants.dart';
import '../DashBoard.dart';
import '../Model/UtilityItemModel.dart';
import '../Model/jasperTicketInsertResponseModel.dart';

class UtilityItemChoose extends StatefulWidget {
  const UtilityItemChoose({Key? key}) : super(key: key);

  @override
  State<UtilityItemChoose> createState() => UtilityItemChooseState();
}

class UtilityItemChooseState extends State<UtilityItemChoose> {
  bool loading = false;

  var selectstate = "Select Priority";

  TextEditingController datecontroler = TextEditingController();
  TextEditingController myController = TextEditingController();
  TextEditingController searchController = new TextEditingController();
  TextEditingController descriptioncontroler = TextEditingController();

  late String selecteddate;

  late FocusNode myFocusNode;


  var stringlist = [
    "Select Priority",
    "Low",
    "Medium",
    "High"
  ];

  late UtilityItemModel li5;
  late jasperTicketInsertResponseModel   li55 =jasperTicketInsertResponseModel (result: []);

  int DocNo=0;
  String TicketNo='';



  static var cnt=[];

  var cnt1=0;

  static double total=0.0;

  static double Price=1;

  static List<TextEditingController> controllers = [];
  static List<double> itemtotal =[];

  List<FilterList> li2 = [];

  List<UpdatedItemList> li35 = [];

  late String SessionEmpID, SessionEmpName, SessionBranchId, SessionBranchName,SessionAdminUser,SessionDepartmentCode,SessionDepartmentName,SessionLocation,EmpGroup;



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
        datecontroler.text = selecteddate.toString();
        print("Slectdate: " + datecontroler.text);
      });
    }
  }

  void getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {



      SessionEmpID = prefs.getString('UserID').toString();
      SessionEmpName = prefs.getString('UserName').toString();
      SessionBranchId = prefs.getString('BranchID').toString();
      SessionBranchName = prefs.getString('BranchName').toString();
      SessionAdminUser = prefs.getString('AdminUser').toString();
      SessionDepartmentCode = prefs.getString('DepartmentCode').toString();
      SessionDepartmentName = prefs.getString('DepartmentName').toString();
      SessionLocation = prefs.getString('Location').toString();
      EmpGroup=prefs.getString('EmpGroup').toString();


      print(EmpGroup+EmpGroup.toString());

      print("shared" + SessionEmpID);

    });
  }

  Future<http.Response> getticketNo() async {

    print("getticketNo is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 5,
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

          String gettotticks =
          jsonDecode(response.body)["result"][0]["TotDocs"].toString();
          print("totdocs: " + gettotticks);
          setState(() {
            myController = TextEditingController()..text = gettotticks;
            print("set" + myController.text);
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

  Future<http.Response> getUtilityItems() async {

    print("getticketNo is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 26,
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


          li5 = UtilityItemModel.fromJson(jsonDecode(response.body));

          if(cnt.length==0) {
            print("call");
            total = 0;
            cnt.clear();
            stringlist.clear();

            for (int i = 0; i < li5.result!.length; i++) {
              cnt.add(0);
              itemtotal.add(0);

              controllers.add(new TextEditingController());
              controllers[i].text = "0";
              // checkvalue.add(CheckList(false,""));
              // li2.add(
              //     FilterList(li5.details[i].itemCode,li5.details[i].itemName,li5.details[i].price,li5.details[i].uOM,li5.details[i].qty));

            }




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

  Future<http.Response> insertticket() async {
    print("insertticket was called");



    var headers = {"Content-Type": "application/json"};
    var body = {
      "EmployeeName": SessionEmpName.toString(),
      "EmployeeCode": SessionEmpID,
      "EmployeeCategory": "",
      "BranchName": SessionBranchName,
      "BranchCode": SessionBranchId,
      "TicketNo": myController.text.toString(),
      "RequiredDate": datecontroler.text.toString(),
      "Description": descriptioncontroler.text.toString(),
      "AttachFilePath": selectstate,
      "AttachFileName": "",
      "TicketType": "Utility",
      "IssueCategory": "Utility",
      "IssueCategoryID": "Utility",
      "IssueType": "New Request",
      "IssueTypeId": "NR",
      "ItemName":"",
      "ItemCode":"",
      "Priority": "Medium",
      "Extra1":"",
      "Extra2":"",
      "Extra3":""
    };
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });

    final response = await http.post(

      Uri.parse(AppConstants.LIVE_URL+'insertTicketsforutilities'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    print(AppConstants.LIVE_URL+'insertTicketsforutilities');
    print(body);
    print(response.body);
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
            backgroundColor: Colors.green,
            fontSize: 16.0);
      } else {
        setState(() {

          li55 = jasperTicketInsertResponseModel .fromJson(jsonDecode(response.body));

          print(li55.result![0].docNo.toString());
          print(li55.result![0].maxDocno.toString());
          DocNo=int.parse(li55.result![0].maxDocno.toString());
          TicketNo=li55.result![0].docNo.toString();

         if (DocNo!=0){InsertUtility_Details(DocNo,TicketNo);}








        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }


  Future<http.Response> InsertUtility_Details(DocNo,TicketNo) async {

    print("InsertUtility_Details was called");

    var headers = {"Content-Type": "application/json"};
    setState(() {
      loading = true;
    });

    li35.clear();


    print(li5.result!.length);
    for (int i = 0; i < li5.result!.length; i++){

      if (int.parse(UtilityItemChooseState.cnt[i].toString()) != 0){
        print("inside");

        li35.add(UpdatedItemList
          (
            DocNo,
            TicketNo.toString(),
            i+1,
            li5.result![i].itemCode,
            li5.result![i].itemName!.replaceAll('&', "&amp;").trim(),
            li5.result![i].uom,
            double.parse(double.parse(UtilityItemChooseState.cnt[i].toString()).toStringAsFixed(2)).toString(),
            double.parse(double.parse(UtilityItemChooseState.itemtotal[i].toString()).toStringAsFixed(2)).toString(),
            SessionEmpID.toString(),
          "",
          "",
          ""
        ));

      }
    }

    print("jsonencode:");

    log(jsonEncode(li35));
    final response = await http.post(
        Uri.parse(AppConstants.LIVE_URL + 'InsertUtilityDetails'),
        headers: headers,
        body: jsonEncode(li35));

    print(AppConstants.LIVE_URL + 'InsertUtilityDetails');
    setState(() {
      loading = false;
    });
    print(response.body);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["status"] == 0) {
        Fluttertoast.showToast(
            msg: "Not Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        setState(() {
          //  Fluttertoast.showToast(msg: '${jsonDecode(response.body)["result"]}',gravity: ToastGravity.CENTER);
          Fluttertoast.showToast(
            // msg: jsonDecode(response.body)["result"],
              msg: '${jsonDecode(response.body)["result"]}',
              backgroundColor: Colors.green,
              textColor: Colors.white,
              gravity: ToastGravity.CENTER);


          showDialog<void>(
              context: context,
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
                          '${jsonDecode(response.body)["result"]}',
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
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (builder) => DashBoard()),
                                        (route) => false,
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

          // Navigator.push(
          //   this.context,
          //   MaterialPageRoute(
          //     builder: (context) => collections(),
          //   ),
          // );

        });
      }
      return response;
    } else {
      print(response.body);
      throw Exception('Failed to Login API');
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    selecteddate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    datecontroler.text = selecteddate.toString();


    selectstate="Medium";

    getStringValuesSF();



    getticketNo().then((value) => getUtilityItems());

    total = 0;
    cnt.clear();
    stringlist.clear();

    itemtotal =[];


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return  Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text('Add Utility'),
      ),
      body: loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(

          child: Column(
            children: [

              SizedBox(height: 10,
              ),
              Container(
                height: height/4.5,
                child: Column(
                  children: [
                    Container(
                      width: width,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                                controller: myController,
                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.cyan)),
                                  labelText: 'Ticket No',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                )),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectDate(context);
                                  myFocusNode.unfocus();
                                });
                              },
                              child: TextField(
                                  focusNode: FocusScopeNode(),
                                  controller: datecontroler,
                                  enabled: false,
                                  // focusNode: myFocusNode,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.cyan)),
                                    labelText: 'Required Date',
                                    labelStyle: TextStyle(
                                        fontWeight:
                                        FontWeight.bold,
                                        color: Colors.grey),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Problem Description", style: TextStyle(fontWeight:FontWeight.bold)),

                        ],
                      ),
                    ),
                    TextField(
                      controller: descriptioncontroler,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.cyan),
                        ),
                        //  labelText: 'Problem Description',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ),


                   /* Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Select Priority", style: TextStyle(fontWeight:FontWeight.bold)),
                        ],
                      ),
                    ),*/

                    /* Container(
                      width: width,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 60,
                              width: width / 2.2,
                              margin: const EdgeInsets.only(
                                  left: 0, right: 0.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white30,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                  border:
                                  new Border.all(color: Colors.black38)),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectstate,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectstate = newValue!;
                                    //print(newValue.toString());
                                  });
                                },
                                items: stringlist
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                              ),


                            ),
                          ),

                        ],
                      ),
                    ),*/


                  ],
                ),
              ),
              Container(
                  height: 60,
                  child: Row(children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 24.0, right: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Colors.white,
                        ),
                        child: TextField(
                          autofocus: false,
                          onChanged: (value) {
                            setState(() {
                              li2.clear();
                            });
                            for (int i = 0; i < li5.result!.length; i++)
                              if (li5.result![i].itemName.toString()
                                  .toLowerCase()
                                  .contains(searchController.text
                                  .toLowerCase())) {
                                setState(() {

                                  li2.add(
                                      FilterList(li5.result![i].itemName.toString(),li5.result![i].itemName.toString(),double.parse("1"),li5.result![i].uom.toString(),double.parse("1")));

                                });
                              }
                          },
                          controller: searchController,
                          onTap: (){
                            searchController.text="";
                          },
                          style: TextStyle(color: Colors.black54),
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap:(){
                                setState(() {
                                  searchController.text="";
                                });
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                color: Colors.redAccent,
                              ),
                            ),
                            hintText: 'Search item here.....',
                            hintStyle: TextStyle(
                              color: Colors.teal,
                              fontSize: 16.0,
                            ),
                            prefix: Text("    "),
                            suffix: Text("    "),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),

              SizedBox(height: 5,),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      for(int i=0;i<li5.result!.length;i++)
                        if (li5.result![i].itemName.toString()
                            .toLowerCase()
                            .contains(searchController.text
                            .toLowerCase()) ||
                            li5.result![i].itemCategory.toString()
                                .toLowerCase()
                                .contains(searchController.text
                                .toLowerCase()))
                        Card(
                          elevation: 30.5,
                          child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Expanded(flex: 2, child: Image.asset("logo.png")),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(li5.result![i].itemName.toString(),style: TextStyle(fontWeight: FontWeight.w500),),


                                        Text(
                                          /*  "\u{20B9} "*/
                                          li5.result![i].uom.toString(),
                                            style: TextStyle(
                                                color: Color.fromRGBO(160, 27, 37, 1)))
                                      ],
                                    ),
                                  ),

                                  //* start no of count design *//
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          Card(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [

                                                // minus item count design
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton( icon: Icon(Icons.remove,color: Colors.red,),onPressed: ()
                                                  {

                                                    setState(() {
                                                      print(cnt[i]);
                                                      if(cnt[i]!=0)
                                                        cnt[i]--;
                                                        itemtotal[i]=(double.parse(Price.toString()))*cnt[i];
                                                      controllers[i].text=cnt[i].toString();
                                                      print(cnt[i]);
                                                      total=0;
                                                      for(int j=0;j<li5.result!.length;j++)
                                                        total=total+(itemtotal[j]);
                                                    });
                                                  },),
                                                ),
                                                // minus item count design
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    height: 40,
                                                    child: TextField(
                                                      // enableInteractiveSelection:false,
                                                      decoration: InputDecoration
                                                        (
                                                        contentPadding: EdgeInsets.only(left:10,right: 10,),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5.0),
                                                        ),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(fontWeight: FontWeight.w800,fontSize: 14),
                                                      keyboardType: TextInputType.number,
                                                      onChanged: (value)
                                                      {
                                                        setState(() {
                                                          cnt[i]=int.parse(controllers[i].text);

                                                            itemtotal[i]=(double.parse(Price.toString()))*cnt[i];
                                                          total=0;
                                                          for(int j=0;j<li5.result!.length;j++)
                                                            total=total+(itemtotal[j]);
                                                        });
                                                      },
                                                      enabled:true,
                                                      controller: controllers[i],
                                                    ),
                                                  ),
                                                ),
                                                // plus item count design
                                                Expanded(
                                                  flex: 1,
                                                  child: IconButton( icon: Icon(Icons.add,color: Colors.teal,),onPressed: ()
                                                  {
                                                    setState(() {
                                                      print(cnt[i]);
                                                      cnt[i]++;
                                                      controllers[i].text=cnt[i].toString();
                                                      print(cnt[i]);

                                                        itemtotal[i]=(double.parse(Price.toString()))*cnt[i];
                                                      total=0;
                                                      for(int j=0;j<li5.result!.length;j++)
                                                        total=total+(itemtotal[j]);


                                                    });

                                                  },),
                                                ),

                                              ],
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  Expanded(flex: 3, child: Column(
                                    children: [
                                      Text("Qty",style: TextStyle(fontWeight: FontWeight.w500),),
                                      Text( itemtotal[i].toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.w800,color: Colors.teal),
                                        textAlign: TextAlign.right,),
                                    ],
                                  )),

                                ],
                              )),
                        )



                    ],


                  ),
                ),
              )
            ],
          ),

      ),


      persistentFooterButtons: [
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.red),
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              print('Cancel button clicked');
            },
            icon: Icon(
              Icons.cancel_outlined,
              color: Colors.white,
            ),
            label: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green),
          child: TextButton.icon(
            onPressed: () {
              DocNo=0;

              insertticket();

             // InsertUtility_Details();




              // print(result);
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],

    );
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
class FilterList {

  String itemCode;
  String itemName;
  double price;
  String uOM;
  double qty;

  FilterList(

      this.itemCode,
      this.itemName,
      this.price,
      this.uOM,
      this.qty,);

}

class UpdatedItemList {

  int? DocNo;
  String? TicketNo;
  var Sno;
  String? ItemCode;
  String? ItemName;
  String? UOM;
  var Qty;
  var Price;
  String? createdBy;
  String? Extra1;
  String? Extra2;
  String? Extra3;

  UpdatedItemList(

      this.DocNo,
      this.TicketNo,
      this.Sno,
      this.ItemCode,
      this.ItemName,
      this.UOM,
      this.Qty,
      this.Price,
      this.createdBy,
      this.Extra1,
      this.Extra2,
      this.Extra3,
      );

  UpdatedItemList.fromJson(Map<String, dynamic> json) {
    DocNo = json['DocNo'];
    TicketNo = json['TicketNo'];
    Sno = json['Sno'];
    ItemCode = json['ItemCode'];
    ItemName = json['ItemName'];
    UOM = json['UOM'];
    Qty = json['Qty'];
    Price = json['Price'];
    createdBy = json['createdBy'];
    Extra1 = json['Extra1'];
    Extra2 = json['Extra2'];
    Extra3 = json['Extra3'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.DocNo;
    data['TicketNo'] = this.TicketNo;
    data['Sno'] = this.Sno;
    data['ItemCode'] = this.ItemCode;
    data['ItemName'] = this.ItemName;
    data['UOM'] = this.UOM;
    data['Qty'] = this.Qty;
    data['Price'] = this.Price;
    data['createdBy'] = this.createdBy;
    data['Extra1'] = this.Extra1;
    data['Extra2'] = this.Extra2;
    data['Extra3'] = this.Extra3;
    return data;
  }


}


