class EmployePlacesModel {
  double? employeId;
  double? aLMLCODE;
  String? aLMLPLACENAME;
  double? aLMLLAT;
  double? aLMLLANG;
  String? colorCode;


  EmployePlacesModel({
    this.employeId,
    this.aLMLCODE,
    this.aLMLPLACENAME,
    this.aLMLLAT,
    this.aLMLLANG,
    this.colorCode
  });

  factory EmployePlacesModel.fromJson(Map<String, dynamic> json) =>
      EmployePlacesModel(
        employeId: json['EMP_ID'] ?? 0.0,
        aLMLCODE: json['ALML_CODE'] ?? 0.0,
        aLMLPLACENAME: json['ALML_PLACE_NAME'] == null
            ? ''
            : json['ALML_PLACE_NAME'].toString(),
        aLMLLAT: json['ALML_LAT'] ?? 31.5522869,
        aLMLLANG: json['ALML_LANG'] ?? 74.3470055,
        colorCode: json['COLOR_CODE'] == null
            ? '#ea8181'
            : json['COLOR_CODE'].toString(),
      );
}
