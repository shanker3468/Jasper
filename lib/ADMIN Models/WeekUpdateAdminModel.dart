class WeekUpdateAdminModel {
  int? status;
  List<Result>? result;

  WeekUpdateAdminModel({this.status, this.result});

  WeekUpdateAdminModel.fromJson(Map<String, dynamic> json) {
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
  String? createdDate;
  int? docNo;
  String? brachName;
  String? branchCode;
  String? description;
  String? attachFilePath;
  String? attachFileName;
  String? empName;
  String? empContactNo;
  String? empMailid;
  String? modifiedDate;
  String? empGroup;
  String? empID;

  Result(
      {this.createdDate,
        this.docNo,
        this.brachName,
        this.branchCode,
        this.description,
        this.attachFilePath,
        this.attachFileName,
        this.empName,
        this.empContactNo,
        this.empMailid,
        this.modifiedDate,
        this.empGroup,
        this.empID});

  Result.fromJson(Map<String, dynamic> json) {
    createdDate = json['CreatedDate'];
    docNo = json['DocNo'];
    brachName = json['BrachName'];
    branchCode = json['BranchCode'];
    description = json['Description'];
    attachFilePath = json['AttachFilePath'];
    attachFileName = json['AttachFileName'];
    empName = json['EmpName'];
    empContactNo = json['EmpContactNo'];
    empMailid = json['EmpMailid'];
    modifiedDate = json['ModifiedDate'];
    empGroup = json['EmpGroup'];
    empID = json['EmpID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreatedDate'] = this.createdDate;
    data['DocNo'] = this.docNo;
    data['BrachName'] = this.brachName;
    data['BranchCode'] = this.branchCode;
    data['Description'] = this.description;
    data['AttachFilePath'] = this.attachFilePath;
    data['AttachFileName'] = this.attachFileName;
    data['EmpName'] = this.empName;
    data['EmpContactNo'] = this.empContactNo;
    data['EmpMailid'] = this.empMailid;
    data['ModifiedDate'] = this.modifiedDate;
    data['EmpGroup'] = this.empGroup;
    data['EmpID'] = this.empID;
    return data;
  }
}
