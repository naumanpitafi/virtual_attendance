class SingleUserAttendanceModel {
  double? employeId;
  String? employeCode;
  String? employeMenagerCode;
  String? employeName;
  String? employefatherName;
  String? employeDOJ;
  String? employeBOB;
  double? employeMenagerId;
  String? attendanceDate;
  String? attendanceStatus;
  String? inTime;
  String? outTime;
  double? employeDepartmentID;
  String? employeDepartment;
  String? employeCnic;
  double? employeSubDepartmentID;
  String? employeSubDepartment;
  double? employeTypeId;
  String? employeTName;
  double? employeBranchId;
  String? employeBranchName;
  String? employeUserName;
  String? employeUserExpiry;
  String? employePassword;
  double? employeSupervisorId;
  String? employeHOD;
  String? employeMarkAttendance;
  String? employeAuthTokenNumber;
  String? employeFreeZone;
  String? employeDESCR;

  SingleUserAttendanceModel({
    this.employeId,
    this.employeCode,
    this.employeMenagerCode,
    this.employeName,
    this.employefatherName,
    this.employeDOJ,
    this.employeBOB,
    this.employeMenagerId,
    this.attendanceDate,
    this.attendanceStatus,
    this.inTime,
    this.outTime,
    this.employeDepartmentID,
    this.employeDepartment,
    this.employeCnic,
    this.employeSubDepartmentID,
    this.employeSubDepartment,
    this.employeTypeId,
    this.employeTName,
    this.employeBranchId,
    this.employeBranchName,
    this.employeUserName,
    this.employeUserExpiry,
    this.employePassword,
    this.employeSupervisorId,
    this.employeHOD,
    this.employeMarkAttendance,
    this.employeAuthTokenNumber,
    this.employeFreeZone,
    this.employeDESCR
  });
  factory SingleUserAttendanceModel.fromJson(Map<String, dynamic> json) =>
      SingleUserAttendanceModel(
        employeId: json['EMP_ID'] ?? 0.0,
        employeCode:
            json['EMPLOYEECODE'] == null ? '' : json['EMPLOYEECODE'].toString(),
        employeMenagerCode: json['EMP_MANAGER_CODE'] == null
            ? ''
            : json['EMP_MANAGER_CODE'].toString(),
        employeName:
            json['EMP_NAME'] == null ? '' : json['EMP_NAME'].toString(),
        employefatherName: json['EMP_FATHER_NAME'] == null
            ? ''
            : json['EMP_FATHER_NAME'].toString(),
        employeDOJ: json['DOJ'] == null ? '' : json['DOJ'].toString(),
        employeBOB: json['DOB'] == null ? '' : json['DOB'].toString(),
        employeMenagerId: json['EMP_MANAGER_ID'] ?? 0.0,
        attendanceDate: json['ATTENDANCE_DATE'] == null
            ? ''
            : json['ATTENDANCE_DATE'].toString(),
        attendanceStatus: json['ATTENDANCE_STATUS'] == null
            ? ''
            : json['ATTENDANCE_STATUS'].toString(),
        inTime: json['INTIME'] == null ? '' : json['INTIME'].toString(),
        outTime: json['OUTTIME'] == null ? '' : json['OUTTIME'].toString(),
        employeDepartmentID: json['DEPT_ID'] ?? 0.0,
        employeDepartment:
            json['DEPARTMENT'] == null ? '' : json['DEPARTMENT'].toString(),
        employeCnic: json['NIC'] == null ? '' : json['NIC'].toString(),
        employeSubDepartmentID: json['SUB_DEPT_ID'] ?? 0.0,
        employeSubDepartment: json['SUBDEPARTMENT'] == null
            ? ''
            : json['SUBDEPARTMENT'].toString(),
        employeTypeId: json['EMP_TYPE_ID'] ?? 0.0,
        employeTName:
            json['EMP_T_NAME'] == null ? '' : json['EMP_T_NAME'].toString(),
        employeBranchId: json['BRANCH_ID'] ?? 0.0,
        employeBranchName:
            json['BRANCH_NAME'] == null ? '' : json['BRANCH_NAME'].toString(),
        employeUserName:
            json['USER_NAME'] == null ? '' : json['USER_NAME'].toString(),
        employeUserExpiry:
            json['USER_EXPIRY'] == null ? '' : json['USER_EXPIRY'].toString(),
        employePassword:
            json['PASSWORD'] == null ? '' : json['PASSWORD'].toString(),
        employeSupervisorId: json['SUPERVISOR_ID'] ?? 0.0,
        employeHOD: json['HOD'] == null ? '' : json['HOD'].toString(),
        employeMarkAttendance: json['MARK_ATTENDANCE'] == null
            ? ''
            : json['MARK_ATTENDANCE'].toString(),
        employeAuthTokenNumber: json['AUTH_TOKEN_NUMBER'] == null
            ? ''
            : json['AUTH_TOKEN_NUMBER'].toString(),
        employeFreeZone:
            json['FREE_ZONE'] == null ? '' : json['FREE_ZONE'].toString(),
            employeDESCR:  json['DESCR'] == null ? '' : json['DESCR'].toString(),
      );
}
