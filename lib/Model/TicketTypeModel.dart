class TicketTypeModel {
  int? status;
  List<Result>? result;

  TicketTypeModel({this.status, this.result});

  TicketTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? type;
  String? typeCode;
  String? status;

  Result({this.docNo, this.type, this.typeCode, this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    type = json['Type'];
    typeCode = json['TypeCode'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['Type'] = this.type;
    data['TypeCode'] = this.typeCode;
    data['Status'] = this.status;
    return data;
  }
}
