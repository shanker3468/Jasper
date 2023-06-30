class AssetMasterModel {
  int? status;
  List<Result>? result;

  AssetMasterModel({this.status, this.result});

  AssetMasterModel.fromJson(Map<String, dynamic> json) {
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
  String? assetName;
  String? assetCode;
  String? assetGroup;
  String? yearOfManufacturing;
  String? status;
  String? branchName;
  String? branchCode;

  Result(
      {this.docNo,
        this.assetName,
        this.assetCode,
        this.assetGroup,
        this.yearOfManufacturing,
        this.status,
        this.branchName,
        this.branchCode});

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    assetName = json['AssetName'];
    assetCode = json['AssetCode'];
    assetGroup = json['AssetGroup'];
    yearOfManufacturing = json['YearOfManufacturing'];
    status = json['Status'];
    branchName = json['BranchName'];
    branchCode = json['BranchCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['AssetName'] = this.assetName;
    data['AssetCode'] = this.assetCode;
    data['AssetGroup'] = this.assetGroup;
    data['YearOfManufacturing'] = this.yearOfManufacturing;
    data['Status'] = this.status;
    data['BranchName'] = this.branchName;
    data['BranchCode'] = this.branchCode;
    return data;
  }
}
