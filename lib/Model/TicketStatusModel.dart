class TicketStatusModel {
  int? status;
  List<Result>? result;

  TicketStatusModel({this.status, this.result});

  TicketStatusModel.fromJson(Map<String, dynamic> json) {
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
  String? brachName;
  String? branchCode;
  String? issueCatrgory;
  String? issueCategoryId;
  String? itemName;
  String? itemCode;
  String? issueType;
  String? requiredDate;
  String? description;
  String? attachFilePath;
  String? attachFileName;
  String? createdDate;
  String? status;
  String? closedDate;
  String? empName;
  String? empContactNo;
  String? empMailid;
  String? rejectRemarks;
  String? createdAt;
  String? updatedAt;
  String? priority;
  String? category;
  String? modifiedDate;
  String? assignStatus;
  String? ticketNo;
  String? assignEmpName;
  String? assignEmpId;
  String? assignEmpDept;
  String? solutionProvided;
  String? endDate;
  String? startDate;
  String? assignEmpcontactNo;
  String? empGroup;
  String? empID;
  String? assetName;
  String? assetCode;

  Result(
      {this.docNo,
        this.brachName,
        this.branchCode,
        this.issueCatrgory,
        this.issueCategoryId,
        this.itemName,
        this.itemCode,
        this.issueType,
        this.requiredDate,
        this.description,
        this.attachFilePath,
        this.attachFileName,
        this.createdDate,
        this.status,
        this.closedDate,
        this.empName,
        this.empContactNo,
        this.empMailid,
        this.rejectRemarks,
        this.createdAt,
        this.updatedAt,
        this.priority,
        this.category,
        this.modifiedDate,
        this.assignStatus,
        this.ticketNo,
        this.assignEmpName,
        this.assignEmpId,
        this.assignEmpDept,
        this.solutionProvided,
        this.endDate,
        this.startDate,
        this.assignEmpcontactNo,
        this.empGroup,
        this.empID,
        this.assetName,
        this.assetCode
      });

  Result.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    brachName = json['BrachName'];
    branchCode = json['BranchCode'];
    issueCatrgory = json['IssueCatrgory'];
    issueCategoryId = json['IssueCategoryId'];
    itemName = json['ItemName'];
    itemCode = json['ItemCode'];
    issueType = json['IssueType'];
    requiredDate = json['RequiredDate'];
    description = json['Description'];
    attachFilePath = json['AttachFilePath'];
    attachFileName = json['AttachFileName'];
    createdDate = json['CreatedDate'];
    status = json['Status'];
    closedDate = json['ClosedDate'];
    empName = json['EmpName'];
    empContactNo = json['EmpContactNo'];
    empMailid = json['EmpMailid'];
    rejectRemarks = json['RejectRemarks'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    priority = json['Priority'];
    category = json['Category'];
    modifiedDate = json['ModifiedDate'];
    assignStatus = json['AssignStatus'];
    ticketNo = json['TicketNo'];
    assignEmpName = json['AssignEmpName'];
    assignEmpId = json['AssignEmpId'];
    assignEmpDept = json['AssignEmpDept'];
    solutionProvided = json['SolutionProvided'];
    endDate = json['EndDate'];
    startDate = json['StartDate'];
    assignEmpcontactNo = json['AssignEmpcontactNo'];
    empGroup = json['EmpGroup'];
    empID = json['EmpID'];
    assetName = json['AssetName'];
    assetCode = json['AssetCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocNo'] = this.docNo;
    data['BrachName'] = this.brachName;
    data['BranchCode'] = this.branchCode;
    data['IssueCatrgory'] = this.issueCatrgory;
    data['IssueCategoryId'] = this.issueCategoryId;
    data['ItemName'] = this.itemName;
    data['ItemCode'] = this.itemCode;
    data['IssueType'] = this.issueType;
    data['RequiredDate'] = this.requiredDate;
    data['Description'] = this.description;
    data['AttachFilePath'] = this.attachFilePath;
    data['AttachFileName'] = this.attachFileName;
    data['CreatedDate'] = this.createdDate;
    data['Status'] = this.status;
    data['ClosedDate'] = this.closedDate;
    data['EmpName'] = this.empName;
    data['EmpContactNo'] = this.empContactNo;
    data['EmpMailid'] = this.empMailid;
    data['RejectRemarks'] = this.rejectRemarks;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['Priority'] = this.priority;
    data['Category'] = this.category;
    data['ModifiedDate'] = this.modifiedDate;
    data['AssignStatus'] = this.assignStatus;
    data['TicketNo'] = this.ticketNo;
    data['AssignEmpName'] = this.assignEmpName;
    data['AssignEmpId'] = this.assignEmpId;
    data['AssignEmpDept'] = this.assignEmpDept;
    data['SolutionProvided'] = this.solutionProvided;
    data['EndDate'] = this.endDate;
    data['StartDate'] = this.startDate;
    data['AssignEmpcontactNo'] = this.assignEmpcontactNo;
    data['EmpGroup'] = this.empGroup;
    data['EmpID'] = this.empID;
    data['AssetName'] = this.assetName;
    data['AssetCode'] = this.assetCode;
    return data;
  }
}
