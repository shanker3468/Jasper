class UtilityItemModel {
  int? status;
  List<Result>? result;

  UtilityItemModel({this.status, this.result});

  UtilityItemModel.fromJson(Map<String, dynamic> json) {
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
  String? itemName;
  String? itemCode;
  String? itemCategory;
  String? itemCategoryCode;
  String? uom;
  String? status;
  String? branchName;
  String? branchCode;

  Result(
      {this.docNo,
        this.itemName,
        this.itemCode,
        this.itemCategory,
        this.itemCategoryCode,
        this.uom,
        this.status,
        this.branchName,
        this.branchCode});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    itemName = json['ItemName'];
    itemCode = json['ItemCode'];
    itemCategory = json['ItemCategory'];
    itemCategoryCode = json['ItemCategoryCode'];
    uom = json['Uom'];
    status = json['Status'];
    branchName = json['BranchName'];
    branchCode = json['BranchCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['ItemName'] = this.itemName;
    data['ItemCode'] = this.itemCode;
    data['ItemCategory'] = this.itemCategory;
    data['ItemCategoryCode'] = this.itemCategoryCode;
    data['Uom'] = this.uom;
    data['Status'] = this.status;
    data['BranchName'] = this.branchName;
    data['BranchCode'] = this.branchCode;
    return data;
  }
}
