
class GetSupervisorStatusModel {
  String? employeHOD;
  String? employeATTENDANCEALLOWED;
  double? employeId;
  String? userNAME;
  String? employePASSWORD;
  String? employeExpiry;
  String? employeCode;
  String? employeNAME;
  String? employeFatherNAME;
  String? employeCurrentAddres;
  String? employePermanentAddress;
  String? employenic;
  String? employephone;
  String? employeemail;
  String? employeJoiningDate;
  String? employeDEPARTMENTCODE;
  String? employeDEPARTMENT;
  String? employeSUBDEPTCODE;
  String? employeSUBDEPARTMENT;

  GetSupervisorStatusModel({
    this.employeHOD,
    this.employeATTENDANCEALLOWED,
    this.employeId,
    this.userNAME,
    this.employePASSWORD,
    this.employeExpiry,
    this.employeCode,
    this.employeNAME,
    this.employeFatherNAME,
    this.employeCurrentAddres,
    this.employePermanentAddress,
    this.employenic,
    this.employephone,
    this.employeemail,
    this.employeJoiningDate,
    this.employeDEPARTMENTCODE,
    this.employeDEPARTMENT,
    this.employeSUBDEPARTMENT,
    this.employeSUBDEPTCODE,
  });

  factory GetSupervisorStatusModel.fromJson(Map<String, dynamic> json) =>
      GetSupervisorStatusModel(
        employeHOD: json['HOD'] == null ? '' : json['HOD'].toString(),
        employeATTENDANCEALLOWED: json['ATTENDANCE_ALLOWED'] == null ? '' : json['ATTENDANCE_ALLOWED'].toString(),
        employeId: json['EMP_ID'] ?? 0.0,
        userNAME: json['USER_NAME'] == null ? '' : json['USER_NAME'].toString(),
        employePASSWORD:
            json['PASSWORD'] == null ? '' : json['PASSWORD'].toString(),
        employeExpiry:
            json['USER_EXPIRY'] == null ? '' : json['USER_EXPIRY'].toString(),
        employeCode:
            json['EMPLOYEECODE'] == null ? '' : json['EMPLOYEECODE'].toString(),
        employeNAME: json['NAME'] == null ? '' : json['NAME'].toString(),
        employeFatherNAME:
            json['FATHERNAME'] == null ? '' : json['FATHERNAME'].toString(),
        employeCurrentAddres: json['CURRENTADDRESS'] == null
            ? ''
            : json['CURRENTADDRESS'].toString(),
        employePermanentAddress: json['PERMANENTADDRESS'] == null
            ? ''
            : json['PERMANENTADDRESS'].toString(),
        employenic: json['NIC'] == null ? '' : json['NIC'].toString(),
        employephone: json['PHONE'] == null ? '' : json['PHONE'].toString(),
        employeemail: json['EMAIL'] == null ? '' : json['EMAIL'].toString(),
        employeJoiningDate:
            json['JOININGDATE'] == null ? '' : json['JOININGDATE'].toString(),
        employeDEPARTMENTCODE: json['DEPARTMENTCODE'] == null
            ? ''
            : json['DEPARTMENTCODE'].toString(),
        employeDEPARTMENT:
            json['DEPARTMENT'] == null ? '' : json['DEPARTMENT'].toString(),
        employeSUBDEPARTMENT:
            json['SUB_DEPTCODE'] == null ? '' : json['SUB_DEPTCODE'].toString(),
        employeSUBDEPTCODE: json['SUB_DEPARTMENT'] == null
            ? ''
            : json['SUB_DEPARTMENT'].toString(),
      );
}
