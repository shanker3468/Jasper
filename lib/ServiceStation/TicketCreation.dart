

import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart'as http;

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AppConstants.dart';
import '../DashBoard.dart';
import '../Model/AssetMasterModel.dart';
import '../Model/IssueCategoryModel.dart';
import '../Model/IssueTypeModel.dart';
import '../Model/ItemCategoryModel.dart';
import '../Model/ItemListModel.dart';
import '../Model/TicketTypeModel.dart';

class TicketCreation extends StatefulWidget {
  const TicketCreation({Key? key}) : super(key: key);

  @override
  State<TicketCreation> createState() => TicketCreationState();
}

class TicketCreationState extends State<TicketCreation> {

  bool loading = false;

  bool ItemVisible =false;

  bool IssueCategory= false;

  bool AssetVisible =false;

  bool ItemListVisible= false;

  late String SessionEmpID, SessionEmpName, SessionBranchId, SessionBranchName,SessionAdminUser,SessionDepartmentCode,SessionDepartmentName,SessionLocation,EmpGroup;

 //late String SessionEmpID, SessionEmpName, SessionBranchId, SessionBranchName,SessionAdminUser,SessionDepartmentCode,SessionDepartmentName,SessionLocation;

  late IssueCategoryModel li3;

  late IssueTypeModel li4;

  late TicketTypeModel li2;

  late ItemCategoryModel li5;

  late ItemListModel li6;

  late AssetMasterModel li7;


  final picker = ImagePicker();


  var selectstate = "Select Priority";

  var issueCategory="";
  var issueCategoryCode="";

  var ItemCategory="";
  var ItemCategoryCode="";

  var ItemName="";
  var ItemCode="";

  var TicketType="";

  var Ticketcode="";

  var issuetype="";

  var issuetypeCode="";

  var assetCode="";
  var assetName="";


  var stringlist = [
    "Select Priority",
    "Low",
    "Medium",
    "High"
  ];

  var dropdownValue3 = "Select Issue Category";
  var stringlist3 = ["Select Issue Category"];
  var dropdownValue4 = "Select Issue Type";
  var stringlist4 = ["Select Issue Type"];
  var dropdownValue2 = "Select Ticket Type";
  var stringlist2 = ["Select Ticket Type"];


  var dropdownValue5 = "Select Item Category";
  var stringlist5 = ["Select Item Category"];

  var dropdownValue7 = "Select Item";
  var stringlist7 = ["Select Item"];

  var stringlist8 = ["Select Asset"];

  TextEditingController datecontroler = TextEditingController();
  TextEditingController myController = TextEditingController();
  TextEditingController descriptioncontroler = TextEditingController();
  late String selecteddate;

   File? file;
  var pickedFile;
  List<String> files = [];
  late FilePickerResult result;
  late FocusNode myFocusNode;



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




  @override
  void initState() {
    // TODO: implement initState
    selecteddate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    datecontroler.text = selecteddate.toString();

    selectstate="Medium";

    getStringValuesSF();

    getAssetCategory();

    getticketNo().then((value) => gettickettype().then((value) => getIssueCategory()).then((value) => getIssuetype()));




    super.initState();
  }


  Future<http.Response> getAssetCategory() async {

    print("getAssetCategory is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 23,
      "UserID": "",
      "Password": "",
      "Branch": SessionBranchId,
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

          li7 = AssetMasterModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li7.result!.length;i++);
          print(li7.result!.length.toString());

          setState(() {
            stringlist8.clear();
            stringlist8.add("Select Asset");
            for (int i = 0; i < li7.result!.length; i++)
              stringlist8.add(li7.result![i].assetName.toString());
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


      if(EmpGroup=="Tools"){
        getItemCategory();

        setState(() {
          ItemVisible=true;
          AssetVisible=false;

        });


      }else if(EmpGroup=="Assets"){

        getAssetCategory();

        setState(() {
          ItemVisible=false;
          AssetVisible=true;
        });



      }else{
        setState(() {
          ItemVisible=false;
          AssetVisible=false;
        });
      }





      print("shared" + SessionEmpID);

    });
  }


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,);


    setState(() {
      if (pickedFile != null) {
        files.clear();
        files.add(pickedFile.path);
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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



  Future<http.Response> getIssueCategory() async {

    print("getIssueCategory is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 2,
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

          li3 = IssueCategoryModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li3.result!.length;i++);
          print(li3.result!.length.toString());

          setState(() {
            stringlist3.clear();
            stringlist3.add("Select Issue Category");
            for (int i = 0; i < li3.result!.length; i++)
              stringlist3.add(li3.result![i].issue.toString());
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


  Future<http.Response> getIssuetype() async {

    print("getIssueCategory is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 3,
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

          li4 = IssueTypeModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li4.result!.length;i++);
          print(li4.result!.length.toString());

          setState(() {
            stringlist4.clear();
            stringlist4.add("Select Issue Type");
            for (int i = 0; i < li4.result!.length; i++)
              stringlist4.add(li4.result![i].issue.toString());
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

  Future<http.Response> gettickettype() async {

    print("gettickettype is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 4,
      "UserID": EmpGroup.toString(),
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

          li2 = TicketTypeModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li2.result!.length;i++);
          print(li2.result!.length.toString());

          setState(() {
            stringlist2.clear();
            stringlist2.add("Select Ticket Type");
            for (int i = 0; i < li2.result!.length; i++)
              stringlist2.add(li2.result![i].type.toString());
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


  Future<http.Response> getItemCategory() async {

    print("getItemCategory is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 6,
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

          li5 = ItemCategoryModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li5.result!.length;i++);
          print(li5.result!.length.toString());

          setState(() {
            stringlist5.clear();
            stringlist5.add("Select Item Category");
            for (int i = 0; i < li5.result!.length; i++)
              stringlist5.add(li5.result![i].categoryName.toString());
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


  Future<http.Response> getItemListCategory(ItemCategoryCode) async {

    print("getItemListCategory is called");
    var headers = {"Content-Type": "application/json"};
    var body = {
      "FormID": 7,
      "UserID": "",
      "Password": "",
      "Branch": "",
      "DataBase":ItemCategoryCode.toString()
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

          li6 = ItemListModel.fromJson(jsonDecode(response.body));

          for(int i=0;i<li6.result!.length;i++);
          print(li6.result!.length.toString());

          setState(() {
            stringlist7.clear();
            stringlist7.add("Select Item");
            for (int i = 0; i < li6.result!.length; i++)
              stringlist7.add(li6.result![i].itemName.toString());
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

  Future Photoupload() async {
    print("Photoupload");
    var url;
    url = Uri.parse(AppConstants.LIVE_URL +'upload');

    setState(() {
      loading = true;
    });
    // print(file.path);
    var request = http.MultipartRequest('POST', url);
    for (int i = 0; i < files.length; i++)
      request.files.add(await http.MultipartFile.fromPath('files', files[i]));

    print("files${request.files.length}");
    http.StreamedResponse response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      print(response.statusCode);
      print(value);
      if (response.statusCode == 200) {
        // Fluttertoast.showToast(
        //     msg: "Image upload successfully",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.SNACKBAR,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.green,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
      print(value);
    });

    setState(() {
      loading = false;
    });
  }

  Future<http.Response> insertticket() async {
    print("insertticket was called");

    String filepath = "";
    for (int i = 0; i < files.length; i++)
      if (i == 0 || files.length == 1)
        filepath = filepath + files[i].split('/').last;
      else
        filepath = filepath + ',' + files[i].split('/').last;
    print(filepath);

    var headers = {"Content-Type": "application/json"};
    var body = {
      "EmployeeName": SessionEmpName.toString(),
      "EmployeeCode": SessionEmpID,
      "EmployeeCategory": TicketType=="Assets"?assetName:"",
      "BranchName": SessionBranchName,
      "BranchCode": SessionBranchId,
      "TicketNo": myController.text.toString(),
      "RequiredDate": datecontroler.text.toString(),
      "Description": descriptioncontroler.text.toString(),
      "AttachFilePath": selectstate,
      "AttachFileName": files.length != 0 ? filepath : "",
      "TicketType": TicketType,
      "IssueCategory": issueCategory,
      "IssueCategoryID": issueCategoryCode,
      "IssueType": issuetype,
      "IssueTypeId": issuetypeCode,
      "ItemName":TicketType=="Tools"?ItemName:"",
      "ItemCode":TicketType=="Tools"?ItemCode:"",
      "Priority": selectstate,
      "Extra1":TicketType=="Tools"?ItemCategory:"",
      "Extra2":TicketType=="Tools"?ItemCategoryCode:"",
      "Extra3":TicketType=="Assets"?assetCode:""
    };
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });

    final response = await http.post(

      Uri.parse(AppConstants.LIVE_URL+'insertTickets'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    print(AppConstants.LIVE_URL+'insertTickets');
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
                          "Ticket Saved Successfully!",
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





        });
      }
      return response;
    } else {
      throw Exception('Failed to Login API');
    }
  }


  @override
  Widget build(BuildContext context) {
     var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Ticket'),
      ),
      body: loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SafeArea(
            child: SingleChildScrollView(
        child: Center(
            child: Column(
              children: [

                SizedBox(height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(8),
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
                                    //   myFocusNode.unfocus();
                                  });
                                },
                                child: TextField(
                                    controller: datecontroler,
                                    enabled: true,
                                    //  focusNode: myFocusNode,
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
                          for (int kk = 0; kk < li2.result!.length; kk++) {
                            if (li2.result![kk].type == val) {
                              TicketType = li2.result![kk].type.toString();
                              Ticketcode = li2.result![kk].typeCode.toString();
                              setState(() {
                                print(TicketType);
                                print(Ticketcode);

                                //GetMyTablRecord();
                              });
                            }
                          }

                          if(Ticketcode=="T03"){
                            getItemCategory();


                            setState(() {
                              ItemVisible=true;
                              IssueCategory=false;
                              AssetVisible=false;
                            });


                          }else if (Ticketcode=="T02"){

                            getAssetCategory();
                            setState(() {
                              ItemVisible=false;
                              IssueCategory=false;
                              AssetVisible=true;
                            });
                          }else{
                            setState(() {
                              ItemVisible=false;
                              IssueCategory=true;
                              AssetVisible=false;
                            });
                          }

                          setState(() {

                            selectstate="Medium";
                            descriptioncontroler.text="";
                             issueCategory="";
                             issueCategoryCode="";
                             ItemCategory="";
                             ItemCategoryCode="";
                             ItemName="";
                             ItemCode="";
                             issuetype="";
                             issuetypeCode="";
                             assetCode="";
                             assetName="";
                          });

                        },
                        selectedItem: TicketType,
                      ),

                      /* SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TypeAheadFormField(
                                  textFieldConfiguration:
                                  TextFieldConfiguration(
                                    textCapitalization:
                                    TextCapitalization.words,
                                    enabled: true,
                                    controller: this.EmpController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'Select Employee',
                                      hintStyle: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            5.0),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return BackendService.getEmployee(
                                        pattern);
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  transitionBuilder: (context,
                                      suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    print(suggestion);
                                    for (int i = 0;
                                    i < empDataList.result.length;
                                    i++) {
                                      if (empDataList
                                          .result[i].empName
                                          .toString() ==
                                          suggestion) {
                                        mobilenoController.text =
                                            empDataList
                                                .result[i].mobileNo
                                                .toString();
                                        emailController.text =
                                            empDataList
                                                .result[i].emailID
                                                .toString();
                                        print("EmpID: " +
                                            mobilenoController.text);
                                        print("EmpName: " +
                                            emailController.text);
                                        // CustomerEmployeeDataModel(EmpIDController.text);
                                      }
                                    }
                                    print(suggestion);

                                    this.EmpController.text =
                                        suggestion;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select Employee';
                                    } else
                                      return 'nothing';
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(
                                                8.0))),
                                    child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext
                                              context) =>
                                                  CustomerEmployeeCreation(
                                                    type: "0",
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.person_add,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        label: Text(
                                          "Add",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: height / 60),
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),*/

                      Visibility(
                        visible: AssetVisible,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Select Asset", style: TextStyle(fontWeight:FontWeight.bold)),
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
                                for (int kk = 0; kk < li7.result!.length; kk++) {
                                  if (li7.result![kk].assetName == val) {
                                    assetName = li7.result![kk].assetName.toString();
                                    assetCode = li7.result![kk].assetCode.toString();
                                    setState(() {
                                      print(assetCode);
                                      //GetMyTablRecord();
                                    });
                                  }
                                }

                                // setState(() {
                                //   getItemListCategory(ItemCategoryCode);
                                // });
                              },
                              selectedItem: assetName,
                            ),



                          ],
                        ),




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
                                  Text("Select Item Category", style: TextStyle(fontWeight:FontWeight.bold)),
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
                                  if (li5.result![kk].categoryName == val) {
                                    ItemCategory = li5.result![kk].categoryName.toString();
                                    ItemCategoryCode = li5.result![kk].categoryCode.toString();
                                    setState(() {
                                      print(ItemCategory);
                                      //GetMyTablRecord();
                                    });
                                  }
                                }

                                setState(() {
                                  getItemListCategory(ItemCategoryCode);
                                });
                              },
                              selectedItem: ItemCategory,
                            ),


                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Select Item", style: TextStyle(fontWeight:FontWeight.bold)),
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
                                for (int kk = 0; kk < li6.result!.length; kk++) {
                                  if (li6.result![kk].itemName == val) {
                                    ItemName = li6.result![kk].itemName.toString();
                                    ItemCode = li6.result![kk].itemCode.toString();
                                    setState(() {
                                      print(ItemName);
                                      //GetMyTablRecord();
                                    });
                                  }
                                }


                              },
                              selectedItem: ItemName,
                            ),
                          ],
                        ),




                      ),








                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Select Priority", style: TextStyle(fontWeight:FontWeight.bold)),
                          ],
                        ),
                      ),

                      Container(
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
                      ),

                      Visibility(
                        visible:IssueCategory ,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Select IssueCategory", style: TextStyle(fontWeight:FontWeight.bold)),
                                ],
                              ),
                            ),
                            DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              // showClearButton: true,

                              // label: "Select Screen",
                              items: stringlist3,
                              onChanged: (val) {
                                print(val);
                                for (int kk = 0; kk < li3.result!.length; kk++) {
                                  if (li3.result![kk].issue == val) {
                                    issueCategory = li3.result![kk].issue.toString();
                                    issueCategoryCode = li3.result![kk].issueCode.toString();
                                    setState(() {
                                      print(issueCategory);
                                      //GetMyTablRecord();
                                    });
                                  }
                                }
                              },
                              selectedItem: issueCategory,
                            ),
                          ],
                        ),
                      ),






                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Select IssueType", style: TextStyle(fontWeight:FontWeight.bold)),
                          ],
                        ),
                      ),


                      DropdownSearch<String>(
                        mode: Mode.DIALOG,
                        showSearchBox: true,
                        // showClearButton: true,

                        // label: "Select Screen",
                        items: stringlist4,
                        onChanged: (val) {
                          print(val);
                          for (int kk = 0; kk < li4.result!.length; kk++) {
                            if (li4.result![kk].issue == val) {
                              issuetype = li4.result![kk].issue.toString();
                              issuetypeCode = li4.result![kk].issueCode.toString();
                              setState(() {
                                print(issuetype);
                                //GetMyTablRecord();
                              });
                            }
                          }
                        },
                        selectedItem: issuetype,
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
                        maxLines: 3,
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

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Attached Files", style: TextStyle(fontWeight:FontWeight.bold)),

                          ],
                        ),
                      ),

                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap:() {
                                showModalBottomSheet(
                                    context: context,
                                    builder:
                                        (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            /*istTile(
                                              title:
                                              Text("Gallery"),
                                              onTap: () async {
                                                Navigator.pop(
                                                    context);
                                                pickedFile = await picker.getImage(source: ImageSource.gallery);
                                                setState(() {
                                                  if (pickedFile != null) {
                                                    files.clear();
                                                    files.add(pickedFile.path);
                                                    file = File(pickedFile.path);
                                                    print("filefile"+file!.path.toString());
                                                  } else {
                                                    print('No image selected.');
                                                  }
                                                });
                                                // result = (await FilePicker
                                                //     .platform
                                                //     .pickFiles(
                                                //     allowMultiple:
                                                //     true,
                                                //     type: FileType.custom,
                                                //     allowedExtensions: [
                                                //       'jpg',
                                                //       // 'pdf',
                                                //       // 'doc'
                                                //     ]))!;

                                                // if (result !=
                                                //     null) {
                                                //   files.clear();
                                                //   for (int u = 0;
                                                //   u <
                                                //       result
                                                //           .files
                                                //           .length;
                                                //   u++)
                                                //     files.add(result
                                                //         .files[u]
                                                //         .path!);
                                                  // files.addAll(result.files.);
                                                  // file = File(result
                                                  //     .files
                                                  //     .);
                                                  Fluttertoast.showToast(
                                                      msg:
                                                      "Image upload successfully",
                                                      toastLength: Toast
                                                          .LENGTH_SHORT,
                                                      gravity:
                                                      ToastGravity
                                                          .SNACKBAR,
                                                      timeInSecForIosWeb:
                                                      1,
                                                      backgroundColor:
                                                      Colors
                                                          .green,
                                                      textColor:
                                                      Colors
                                                          .white,
                                                      fontSize:
                                                      16.0);
                                                // } else {
                                                //   // User canceled the picker
                                                // }
                                                setState(() {});
                                              },
                                              leading:
                                              Icon(Icons.image),
                                            ),*/
                                            ListTile(
                                              leading: Icon(
                                                  Icons.camera_alt),
                                              title: Text("Camera"),
                                              onTap: () async {
                                                Navigator.pop(
                                                    context);
                                                // getImage();
                                                pickedFile = await picker.getImage(source: ImageSource.camera);


                                                setState(() {
                                                  if (pickedFile != null) {
                                                    files.clear();
                                                    files.add(pickedFile.path);
                                                    file = File(pickedFile.path);
                                                    print("filefile"+file!.path.toString());
                                                  } else {
                                                    print('No image selected.');
                                                  }
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                color: Colors.blueGrey,
                                child: Text(
                                  "Choose File",
                                  style:
                                  TextStyle(color: Colors.white),
                                ),

                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),

                            file!=null ? Image.file(File(file!.path),height:height/2, width: width/2,):Container(child: Text("No image selected."),),

                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
        ),
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

             /* if (TicketType.isEmpty) {
                Fluttertoast.showToast(
                    msg: "TicketType should not left Empty!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 16.0);
              } else if (selectstate == "Select Priority") {
                Fluttertoast.showToast(
                    msg: "Please select Priority!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 16.0);
              }else if (issueCategory.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Please select Issue Category!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 16.0);
              }else if (issuetype.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Please select Issue Type!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 16.0);
              }else if (descriptioncontroler.text.isEmpty ||
                  descriptioncontroler.text == "") {
                Fluttertoast.showToast(
                    msg: "Please Enter Description!!",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    textColor: Colors.white,
                    backgroundColor: Colors.red,
                    fontSize: 16.0);
              }else{



                if (files.length != 0) Photoupload();
                insertticket();


              }*/

              if(TicketType=="Admin") {
                if (selectstate == "Select Priority") {
                  Fluttertoast.showToast(
                      msg: "Please select Priority!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else if (issueCategory.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please select Issue Category!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else if (issuetype.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please select Issue Type!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else if (descriptioncontroler.text.isEmpty ||
                    descriptioncontroler.text == "") {
                  Fluttertoast.showToast(
                      msg: "Please Enter Description!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else {
                  if (files.length != 0) Photoupload();
                  insertticket();
                }
              }else if (TicketType=="Assets"){

                print("Group==Tools");

              if (assetName.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please select AssetName!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else if (selectstate == "Select Priority") {
                  Fluttertoast.showToast(
                      msg: "Please select Priority!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                }


             else   if (selectstate == "Select Priority") {
                  Fluttertoast.showToast(
                      msg: "Please select Priority!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                }

                else if (issuetype.isEmpty) {
                   Fluttertoast.showToast(
                       msg: "Please select issuetype!!",
                       toastLength: Toast.LENGTH_LONG,
                       gravity: ToastGravity.SNACKBAR,
                       timeInSecForIosWeb: 1,
                       textColor: Colors.white,
                       backgroundColor: Colors.red,
                       fontSize: 16.0);
                 }

                else if (descriptioncontroler.text.isEmpty ||
                    descriptioncontroler.text == "") {
                  Fluttertoast.showToast(
                      msg: "Please Enter Description!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else {
                  if (files.length != 0) Photoupload();
                  insertticket();
                }



              }else{

                print("Group==Tools");

                if (ItemCategory.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please select ItemCategory!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                }else if (ItemName.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please select ItemName!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else if (selectstate == "Select Priority") {
                  Fluttertoast.showToast(
                      msg: "Please select Priority!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else if (issuetype.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please select issuetype!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                 } else if (descriptioncontroler.text.isEmpty ||
                    descriptioncontroler.text == "") {
                  Fluttertoast.showToast(
                      msg: "Please Enter Description!!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      fontSize: 16.0);
                } else {
                  if (files.length != 0) Photoupload();
                  insertticket();
                }



              }



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

