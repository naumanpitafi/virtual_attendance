class GetEmployeAttendanceSummeryModel {
  double? employeId;
  String? employeCode;
  String? employeName;
  String? employeCnic;
  String? employeEmail;
  double? employeDesignId;
  String? employeDesignation;
  double? employeBranchId;
  String? employeBranchName;
  double? employeDeptId;
  String? employeDepartment;
  double? employeSubDepartmentId;
  String? employeSubDepartment;
  String? employeAttendanceStatus;
  String? employedecription;
  double? employeTotal;

  GetEmployeAttendanceSummeryModel({
    this.employeId,
    this.employeCode,
    this.employeName,
    this.employeCnic,
    this.employeEmail,
    this.employeDesignId,
    this.employeDesignation,
    this.employeBranchId,
    this.employeBranchName,
    this.employeDeptId,
    this.employeDepartment,
    this.employeSubDepartmentId,
    this.employeSubDepartment,
    this.employeAttendanceStatus,
    this.employedecription,
    this.employeTotal,
  });

  factory GetEmployeAttendanceSummeryModel.fromJson(
          Map<String, dynamic> json) =>
      GetEmployeAttendanceSummeryModel(
        employeId: json['EMP_ID'] ?? 0.0,
        employeCode:
            json['EMPLOYEECODE'] == null ? '' : json['EMPLOYEECODE'].toString(),
        employeName:
            json['EMP_NAME'] == null ? '' : json['EMP_NAME'].toString(),
        employeCnic: json['NIC'] == null ? '' : json['NIC'].toString(),
        employeEmail: json['EMAIL'] == null ? '' : json['EMAIL'].toString(),
        employeDesignId: json['DESIGN_ID'] ?? 0.0,
        employeDesignation:
            json['DESIGNATION'] == null ? '' : json['DESIGNATION'].toString(),
        employeBranchId: json['BRANCH_ID'] ?? 0.0,
        employeBranchName:
            json['BRANCH_NAME'] == null ? '' : json['BRANCH_NAME'].toString(),
        employeDeptId: json['DEPT_ID'] ?? 0.0,
        employeDepartment:
            json['DEPARTMENT'] == null ? '' : json['DEPARTMENT'].toString(),
        employeSubDepartmentId: json['SUB_DEPT_ID'] ?? 0.0,
        employeSubDepartment:
            json['SUB_DEPARTMENT'] == null ? '' : json['SUB_DEPARTMENT'].toString(),
        employeAttendanceStatus:
            json['ATTENDANCE_STATUS'] == null ? '' : json['ATTENDANCE_STATUS'].toString(),
        employedecription:
            json['DESCRIPTION'] == null ? '' : json['DESCRIPTION'].toString(),
        employeTotal: json['TOTAL'] ?? 0.0,
      );
}
