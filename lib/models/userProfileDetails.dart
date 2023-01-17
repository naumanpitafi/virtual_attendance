class EmployeProfileModel {
  double? employeId;
  String? employeCode;
  String? employeMenagerCode;
  String? employeName;
  String? employeFatherName;
  String? employeDOJ;
  String? employeDOB;
  String? employeManagerId;
  String? employeAttendanceDate;
  String? employeAttendanceStatus;
  String? employeInTime;
  String? employeOutTime;
  double? employeDEPTID;
  String? employeDepartment;
  String? employeNIC;
  double? employeSubDepartmentID;
  String? employeSubDepartment;
  double? employeTypeId;
  String? employeTNmae;
  double? employeBranchId;
  String? employeBranchName;
  String? employeUserName;
  String? employeUserExpiryDate;
  String? employePassword;
  String? employeSuperVisorId;
  String? employeHOD;
  String? employeMArkAttendance;
  String? employeAuthTokenNumber;
  String? employeFreeZone;
  String? employeMobileNumber;
  String? employeDesignation;

  EmployeProfileModel({
    this.employeId,
    this.employeCode,
    this.employeMenagerCode,
    this.employeName,
    this.employeFatherName,
    this.employeDOJ,
    this.employeDOB,
    this.employeManagerId,
    this.employeAttendanceDate,
    this.employeAttendanceStatus,
    this.employeInTime,
    this.employeOutTime,
    this.employeDEPTID,
    this.employeDepartment,
    this.employeNIC,
    this.employeSubDepartmentID,
    this.employeSubDepartment,
    this.employeTypeId,
    this.employeTNmae,
    this.employeBranchId,
    this.employeBranchName,
    this.employeUserName,
    this.employeUserExpiryDate,
    this.employePassword,
    this.employeSuperVisorId,
    this.employeHOD,
    this.employeMArkAttendance,
    this.employeAuthTokenNumber,
    this.employeFreeZone,
    this.employeMobileNumber,
    this.employeDesignation
  });

  factory EmployeProfileModel.fromJson(Map<String, dynamic> json) =>
      EmployeProfileModel(
        employeId: json['EMP_ID'] ?? 0.0,
        employeCode:
            json['EMPLOYEECODE'] == null ? '' : json['EMPLOYEECODE'].toString(),
        employeMenagerCode: json['EMP_MANAGER_CODE'] == null
            ? ''
            : json['EMP_MANAGER_CODE'].toString(),
        employeName:
            json['NAME'] == null ? '' : json['NAME'].toString(),
        employeFatherName: json['FATHERNAME'] == null
            ? ''
            : json['FATHERNAME'].toString(),
        employeDOJ: json['JOININGDATE'] == null ? '' : json['JOININGDATE'].toString(),
        employeDOB: json['DOB'] == null ? '' : json['DOB'].toString(),
        employeManagerId: json['EMP_MANAGER_ID'] == null
            ? ''
            : json['EMP_MANAGER_ID'].toString(),
        employeAttendanceDate: json['ATTENDANCE_DATE'] == null
            ? ''
            : json['ATTENDANCE_DATE'].toString(),
        employeAttendanceStatus: json['ATTENDANCE_STATUS'] == null
            ? ''
            : json['ATTENDANCE_STATUS'].toString(),
        employeInTime: json['INTIME'] == null ? '' : json['INTIME'].toString(),
        employeOutTime:
            json['OUTTIME'] == null ? '' : json['OUTTIME'].toString(),
        employeDEPTID: json['EMP_ID'] ?? 0.0,
        employeDepartment:
            json['DEPARTMENT'] == null ? '' : json['DEPARTMENT'].toString(),
        employeNIC: json['NIC'] == null ? '' : json['NIC'].toString(),
        employeSubDepartmentID: json['SUB_DEPT_ID'] ?? 0.0,
        employeSubDepartment: json['SUB_DEPARTMENT'] == null
            ? ''
            : json['SUB_DEPARTMENT'].toString(),
        employeTypeId: json['EMP_TYPE_ID'] ?? 0.0,
        employeTNmae:
            json['EMP_T_NAME'] == null ? '' : json['EMP_T_NAME'].toString(),
        employeBranchId: json['BRANCH_ID'] ?? 0.0,
        employeBranchName:
            json['BRANCH'] == null ? '' : json['BRANCH'].toString(),
        employeUserName:
            json['USER_NAME'] == null ? '' : json['USER_NAME'].toString(),
        employeUserExpiryDate:
            json['USER_EXPIRY'] == null ? '' : json['USER_EXPIRY'].toString(),
        employePassword:
            json['PASSWORD'] == null ? '' : json['PASSWORD'].toString(),
        employeSuperVisorId: json['SUPERVISOR_ID'] == null
            ? ''
            : json['SUPERVISOR_ID'].toString(),
        employeHOD: json['HOD'] == null ? '' : json['HOD'].toString(),
        employeMArkAttendance: json['ATTENDANCE_ALLOWED'] == null
            ? 'N'
            : json['ATTENDANCE_ALLOWED'].toString(),
        employeAuthTokenNumber: json['AUTH_TOKEN_NUMBER'] == null
            ? ''
            : json['AUTH_TOKEN_NUMBER'].toString(),
        employeFreeZone:
            json['FREE_ZONE'] == null ? '' : json['FREE_ZONE'].toString(),
            employeDesignation:  json['DESIGNATION'] == null ? '' : json['DESIGNATION'].toString(),
            employeMobileNumber:  json['PHONE'] == null ? '' : json['PHONE'].toString(),
      );
}
