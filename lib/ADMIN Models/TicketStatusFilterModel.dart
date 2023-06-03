class TicketStatusFilterModel {
  int? status;
  List<Result>? result;

  TicketStatusFilterModel({this.status, this.result});

  TicketStatusFilterModel.fromJson(Map<String, dynamic> json) {
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
  String? statusName;
  String? statusCode;
  String? status;

  Result({this.docNo, this.statusName, this.statusCode, this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    statusName = json['StatusName'];
    statusCode = json['StatusCode'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['StatusName'] = this.statusName;
    data['StatusCode'] = this.statusCode;
    data['Status'] = this.status;
    return data;
  }
}
