class jasperTicketInsertResponseModel {
  int? status;
  List<Result>? result;

  jasperTicketInsertResponseModel({this.status, this.result});

  jasperTicketInsertResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? docNo;
  int? maxDocno;
  String? msg;

  Result({this.docNo, this.maxDocno, this.msg});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    maxDocno = json['MaxDocno'];
    msg = json['Msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['MaxDocno'] = this.maxDocno;
    data['Msg'] = this.msg;
    return data;
  }
}
