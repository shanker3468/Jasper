class ItemCategoryModel {
  int? status;
  List<Result>? result;

  ItemCategoryModel({this.status, this.result});

  ItemCategoryModel.fromJson(Map<String, dynamic> json) {
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
  String? categoryName;
  String? categoryCode;
  String? status;

  Result({this.docNo, this.categoryName, this.categoryCode, this.status});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    categoryName = json['CategoryName'];
    categoryCode = json['CategoryCode'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['CategoryName'] = this.categoryName;
    data['CategoryCode'] = this.categoryCode;
    data['Status'] = this.status;
    return data;
  }
}
