class AssignEmpDepartmentModel {
  int? status;
  List<Result>? result;

  AssignEmpDepartmentModel({this.status, this.result});

  AssignEmpDepartmentModel.fromJson(Map<String, dynamic> json) {
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
  String? departmentName;
  String? departmentCode;
  String? empStatus;

  Result(
      {this.docNo, this.departmentName, this.departmentCode, this.empStatus});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    departmentName = json['DepartmentName'];
    departmentCode = json['DepartmentCode'];
    empStatus = json['EmpStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['DepartmentName'] = this.departmentName;
    data['DepartmentCode'] = this.departmentCode;
    data['EmpStatus'] = this.empStatus;
    return data;
  }
}
