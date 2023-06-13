

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
import '../Model/IssueCategoryModel.dart';
import '../Model/IssueTypeModel.dart';
import '../Model/ItemCategoryModel.dart';
import '../Model/ItemListModel.dart';
import '../Model/TicketTypeModel.dart';

class WeeklyUpdate extends StatefulWidget {
  const WeeklyUpdate({Key? key}) : super(key: key);

  @override
  State<WeeklyUpdate> createState() => WeeklyUpdateState();
}

class WeeklyUpdateState extends State<WeeklyUpdate> {

  bool loading = false;

  bool ItemVisible =false;

  bool ItemListVisible= false;

  late String SessionEmpID, SessionEmpName, SessionBranchId, SessionBranchName,SessionAdminUser,SessionDepartmentCode,SessionDepartmentName,SessionLocation,EmpGroup;

 //late String SessionEmpID, SessionEmpName, SessionBranchId, SessionBranchName,SessionAdminUser,SessionDepartmentCode,SessionDepartmentName,SessionLocation;

  late IssueCategoryModel li3;

  late IssueTypeModel li4;

  late TicketTypeModel li2;

  late ItemCategoryModel li5;

  late ItemListModel li6;


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

    getStringValuesSF();






    super.initState();
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


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

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
      "EmployeeCategory": "",
      "BranchName": SessionBranchName,
      "BranchCode": SessionBranchId,
      "Description": descriptioncontroler.text.toString(),
      "AttachFilePath": selectstate,
      "AttachFileName": files.length != 0 ? filepath : "",
      "Extra1":EmpGroup,
      "Extra2":"",
      "Extra3":""
    };
    print(jsonEncode(body));
    setState(() {
      loading = true;
    });

    final response = await http.post(

      Uri.parse(AppConstants.LIVE_URL+'insertWeeklyUpdationTickets'),
      headers: headers,
      body: (jsonEncode(body)),
    );
    print(AppConstants.LIVE_URL+'insertWeeklyUpdationTickets');
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
        title: Text('Weekly status Updation'),
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


                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Remarks", style: TextStyle(fontWeight:FontWeight.bold)),

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
                                            ListTile(
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
                                            ),
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

              if (descriptioncontroler.text.isEmpty ||
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


              }



              print(result);
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

