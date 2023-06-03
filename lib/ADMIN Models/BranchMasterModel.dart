class BranchMasterModel {
  int? status;
  List<Result>? result;

  BranchMasterModel({this.status, this.result});

  BranchMasterModel.fromJson(Map<String, dynamic> json) {
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
  String? branchName;
  String? branchCode;
  String? status;

  Result({this.docNo, this.branchName, this.branchCode, this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    branchName = json['BranchName'];
    branchCode = json['BranchCode'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['BranchName'] = this.branchName;
    data['BranchCode'] = this.branchCode;
    data['Status'] = this.status;
    return data;
  }
}
