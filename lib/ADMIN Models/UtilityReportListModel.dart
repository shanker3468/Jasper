class UtilityReportListModel {
  int? status;
  List<Result>? result;

  UtilityReportListModel({this.status, this.result});

  UtilityReportListModel.fromJson(Map<String, dynamic> json) {
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
  String? branchCode;
  String? status;
  String? description;
  int? docNo;
  String? ticketNo;
  String? sno;
  String? itemCode;
  String? itemName;
  String? createdDate;
  String? uOM;
  String? qty;
  String? price;
  String? createdBy;

  Result(
      {this.brachName,
        this.branchCode,
        this.status,
        this.description,
        this.docNo,
        this.ticketNo,
        this.sno,
        this.itemCode,
        this.itemName,
        this.createdDate,
        this.uOM,
        this.qty,
        this.price,
        this.createdBy});

  Result.fromJson(Map<String, dynamic> json) {
    brachName = json['BrachName'];
    branchCode = json['BranchCode'];
    status = json['Status'];
    description = json['Description'];
    docNo = json['DocNo'];
    ticketNo = json['TicketNo'];
    sno = json['Sno'];
    itemCode = json['ItemCode'];
    itemName = json['ItemName'];
    createdDate = json['CreatedDate'];
    uOM = json['UOM'];
    qty = json['Qty'];
    price = json['Price'];
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrachName'] = this.brachName;
    data['BranchCode'] = this.branchCode;
    data['Status'] = this.status;
    data['Description'] = this.description;
    data['DocNo'] = this.docNo;
    data['TicketNo'] = this.ticketNo;
    data['Sno'] = this.sno;
    data['ItemCode'] = this.itemCode;
    data['ItemName'] = this.itemName;
    data['CreatedDate'] = this.createdDate;
    data['UOM'] = this.uOM;
    data['Qty'] = this.qty;
    data['Price'] = this.price;
    data['createdBy'] = this.createdBy;
    return data;
  }
}
