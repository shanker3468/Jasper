class AsignUserDataModel {
  int? status;
  List<Result>? result;

  AsignUserDataModel({this.status, this.result});

  AsignUserDataModel.fromJson(Map<String, dynamic> json) {
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
  String? mobileNo;
  String? email;
  String? department;
  int? deptCode;
  String? createdDate;
  String? empStatus;
  String? departmentCode;

  Result(
      {this.docNo,
        this.firstName,
        this.lastName,
        this.empID,
        this.branchName,
        this.branchCode,
        this.empCategory,
        this.mobileNo,
        this.email,
        this.department,
        this.deptCode,
        this.createdDate,
        this.empStatus,
        this.departmentCode});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    empID = json['EmpID'];
    branchName = json['BranchName'];
    branchCode = json['BranchCode'];
    empCategory = json['EmpCategory'];
    mobileNo = json['MobileNo'];
    email = json['Email'];
    department = json['Department'];
    deptCode = json['DeptCode'];
    createdDate = json['CreatedDate'];
    empStatus = json['EmpStatus'];
    departmentCode = json['DepartmentCode'];
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
    data['MobileNo'] = this.mobileNo;
    data['Email'] = this.email;
    data['Department'] = this.department;
    data['DeptCode'] = this.deptCode;
    data['CreatedDate'] = this.createdDate;
    data['EmpStatus'] = this.empStatus;
    data['DepartmentCode'] = this.departmentCode;
    return data;
  }
}
