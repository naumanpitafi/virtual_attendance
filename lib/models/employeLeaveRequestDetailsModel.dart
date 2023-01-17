class EmployeLeavesRequestDetailsemodel {
  double? employeId;
  String? employeName;
  String? employefatherName;
  String? employeDOJ;
  String? employeDOB;
  double? employeBranchId;
  String? employeBranchName;
  double? employeDepartmentID;
  String? employeDepartment;
  double? employeSubDepartmentID;
  String? employeSubDepartment;
  double? employeDesigId;
  String? employeDesignation;
  double? employeTypeId;
  String? employeTName;
  String? employeAuthTokenNumber;
  double? employeLeavrGerID;
  double? employeLeaveId;
  String? employeDESCR;
  String? employeDescription;
  String? employeLeaveDateFrom;
  String? employeLeaveDateTo;
  double? employeTotalLeave;
  String? employeCreatedBy;
  String? employecreatedDate;
  String? employeApproved;
  String? employeApprovedBy;
  String? employeApprovedDate;
  String? employeRejected;
  String? employeRejectedBy;
  String? employeRejectedDate;
  String? employeRemarks;
  String? employeRequestedDate;

  EmployeLeavesRequestDetailsemodel(
      {this.employeId,
      this.employeName,
      this.employefatherName,
      this.employeDOB,
      this.employeDOJ,
      this.employeBranchId,
      this.employeBranchName,
      this.employeDepartmentID,
      this.employeDepartment,
      this.employeSubDepartmentID,
      this.employeSubDepartment,
      this.employeDesigId,
      this.employeDesignation,
      this.employeTypeId,

      this.employeTName,
      this.employeAuthTokenNumber,
      this.employeLeavrGerID,
      this.employeLeaveId,
      this.employeDESCR,
      this.employeDescription,
      this.employeLeaveDateFrom,
      this.employeLeaveDateTo,
      this.employeTotalLeave,
      this.employeCreatedBy,
      this.employecreatedDate,
      this.employeRejected,
      this.employeApproved,
      this.employeApprovedBy,
      this.employeApprovedDate,
      this.employeRemarks,
      this.employeRequestedDate,
      this.employeRejectedBy,
      this.employeRejectedDate});
  factory EmployeLeavesRequestDetailsemodel.fromJson(
          Map<String, dynamic> json) =>
      EmployeLeavesRequestDetailsemodel(
        employeId: json['EMP_ID'] ?? 0.0,
        employeName:
            json['EMP_NAME'] == null ? '' : json['EMP_NAME'].toString(),
        employefatherName: json['EMP_FATHER_NAME'] == null
            ? ''
            : json['EMP_FATHER_NAME'].toString(),
        employeDOJ: json['DOJ'] == null ? '' : json['DOJ'].toString(),
        employeDOB: json['DOB'] == null ? '' : json['DOB'].toString(),
        employeBranchId: json['BRANCH_ID'] ?? 0.0,
        employeBranchName:
            json['BRANCH_NAME'] == null ? '' : json['BRANCH_NAME'].toString(),
        employeDepartmentID: json['DEPT_ID'] ?? 0.0,
        employeDepartment:
            json['DEPARTMENT'] == null ? '' : json['DEPARTMENT'].toString(),
        employeSubDepartmentID: json['SUB_DEPT_ID'] ?? 0.0,
        employeSubDepartment: json['SUB_DEPARTMENT'] == null
            ? ''
            : json['SUB_DEPARTMENT'].toString(),
        employeDesigId: json['DESIGN_ID'] ?? 0.0,
        employeDesignation:
            json['DESIGNATION'] == null ? '' : json['DESIGNATION'].toString(),
        employeTypeId: json['EMP_TYPE_ID'] ?? 0.0,
        employeTName:
            json['EMP_T_NAME'] == null ? '' : json['EMP_T_NAME'].toString(),
        employeAuthTokenNumber: json['AUTH_TOKEN_NUMBER'] == null
            ? ''
            : json['AUTH_TOKEN_NUMBER'].toString(),
        employeLeavrGerID: json['LEAVRGTR_ID'] ?? 0.0,
        employeLeaveId: json['LEAVE_ID'] ?? 0.0,
        employeDESCR: json['DESCR'] == null
            ? ''
            : json['DESCR'].toString(),
        employeDescription:
            json['MOBILE_DESCRIPTION'] == null ? '' : json['MOBILE_DESCRIPTION'].toString(),
        employeLeaveDateFrom: json['LEAVE_DATE_FROM'] == null
            ? ''
            : json['LEAVE_DATE_FROM'].toString(),
        employeLeaveDateTo: json['LEAVE_DATE_TO'] == null
            ? ''
            : json['LEAVE_DATE_TO'].toString(),
        employeTotalLeave: json['TOTALLEAV'] ?? 0.0,
        employeCreatedBy:
            json['CREATED_BY'] == null ? '' : json['CREATED_BY'].toString(),
        employecreatedDate:
            json['CREATED_DATE'] == null ? '' : json['CREATED_DATE'].toString(),
        employeRejected:
            json['REJECTED'] == null ? '' : json['REJECTED'].toString(),
        employeApproved:
            json['APPROVED'] == null ? '' : json['APPROVED'].toString(),
        employeApprovedBy:
            json['APPROVED_BY'] == null ? '' : json['APPROVED_BY'].toString(),
        employeApprovedDate: json['APPROVED_DATE'] == null
            ? ''
            : json['APPROVED_DATE'].toString(),
        employeRemarks:
            json['REMARKS'] == null ? '' : json['REMARKS'].toString(),
        employeRequestedDate:
            json['REQUEST_DATE'] == null ? '' : json['REQUEST_DATE'].toString(),
        employeRejectedBy:
            json['REJECTED_BY'] == null ? '' : json['REJECTED_BY'].toString(),
        employeRejectedDate: json['REJECTED_DATE'] == null
            ? ''
            : json['REJECTED_DATE'].toString(),
      );
}
