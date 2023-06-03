class EmployeeListModel {
  int? status;
  List<Result>? result;

  EmployeeListModel({this.status, this.result});

  EmployeeListModel.fromJson(Map<String, dynamic> json) {
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
  String? fullName;
  String? lastName;
  String? firstName;
  String? empID;
  String? mobileNo;
  String? email;

  Result(
      {this.fullName,
        this.lastName,
        this.firstName,
        this.empID,
        this.mobileNo,
        this.email});

  Result.fromJson(Map<String, dynamic> json) {
    fullName = json['FullName'];
    lastName = json['LastName'];
    firstName = json['FirstName'];
    empID = json['EmpID'];
    mobileNo = json['MobileNo'];
    email = json['Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FullName'] = this.fullName;
    data['LastName'] = this.lastName;
    data['FirstName'] = this.firstName;
    data['EmpID'] = this.empID;
    data['MobileNo'] = this.mobileNo;
    data['Email'] = this.email;
    return data;
  }
}
