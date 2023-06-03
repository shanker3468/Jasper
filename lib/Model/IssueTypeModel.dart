class IssueTypeModel {
  int? status;
  List<Result>? result;

  IssueTypeModel({this.status, this.result});

  IssueTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? issue;
  String? issueCode;
  String? status;

  Result({this.docNo, this.issue, this.issueCode, this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    issue = json['Issue'];
    issueCode = json['IssueCode'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['Issue'] = this.issue;
    data['IssueCode'] = this.issueCode;
    data['Status'] = this.status;
    return data;
  }
}
