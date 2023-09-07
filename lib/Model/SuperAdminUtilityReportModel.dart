class SuperAdminUtilityReportModel {
  int? status;
  List<Result>? result;

  SuperAdminUtilityReportModel({this.status, this.result});

  SuperAdminUtilityReportModel.fromJson(Map<String, dynamic> json) {
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
  String? brachName;
  String? itemname;
  int? reqqty;
  int? approvedQty;
  String? itemCategory;

  Result({this.brachName, this.itemname, this.reqqty, this.approvedQty, this.itemCategory});

  Result.fromJson(Map<String, dynamic> json) {
    brachName = json['BrachName'];
    itemname = json['itemname'];
    reqqty = json['Reqqty'];
    approvedQty = json['ApprovedQty'];
    itemCategory = json['ItemCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrachName'] = this.brachName;
    data['itemname'] = this.itemname;
    data['Reqqty'] = this.reqqty;
    data['ApprovedQty'] = this.approvedQty;
    data['ItemCategory'] = this.itemCategory;
    return data;
  }
}
