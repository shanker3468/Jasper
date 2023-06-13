class LoginModel {
  int? status;
  List<Result>? result;

  LoginModel({this.status, this.result});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
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
  String? empGroupID;


  Result(
      {this.docNo,
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
        this.empGroup,
        this.empGroupID
      });

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    empID = json['EmpID'];
    branchName = json['BranchName'];
    branchCode = json['BranchCode'];
    empCategory = json['EmpCategory'];
    mobUserID = json['MobUserID'];
    mobUserPassword = json['MobUserPassword'];
    mobileNo = json['MobileNo'];
    email = json['Email'];
    department = json['Department'];
    deptCode = json['DeptCode'];
    createdDate = json['CreatedDate'];
    adminUser = json['AdminUser'];
    location = json['Location'];
    empStatus = json['EmpStatus'];
    deviceID = json['DeviceID'];
    empGroup = json['EmpGroup'];
    empGroupID = json['EmpGroupID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['EmpID'] = this.empID;
    data['BranchName'] = this.branchName;
    data['BranchCode'] = this.branchCode;
    data['EmpCategory'] = this.empCategory;
    data['MobUserID'] = this.mobUserID;
    data['MobUserPassword'] = this.mobUserPassword;
    data['MobileNo'] = this.mobileNo;
    data['Email'] = this.email;
    data['Department'] = this.department;
    data['DeptCode'] = this.deptCode;
    data['CreatedDate'] = this.createdDate;
    data['AdminUser'] = this.adminUser;
    data['Location'] = this.location;
    data['EmpStatus'] = this.empStatus;
    data['DeviceID'] = this.deviceID;
    data['EmpGroup'] = this.empGroup;
    data['EmpGroupID'] = this.empGroupID;
    return data;
  }
}
