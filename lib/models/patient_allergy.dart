import 'package:vesalius_dr_flutter/helpers.dart';

class PatientAllergy {

  num alertRefNo;
  String prn;
  String alertType;
  String allergyType;
  String description;
  String? system;
  String? route;
  String? probability;
  String? reaction;
  String createdBy;
  String creationDate;
  String? inactiveUser;
  String? inactiveDateTime;
  String? inactiveReason;
  String? syncDate;
  String? transferFlag;
  String? transferDateTime;
  String? transferSystem;

  PatientAllergy({
    required this.alertRefNo,
    required this.prn,
    required this.alertType,
    required this.allergyType,
    required this.description,
    required this.system,
    required this.route,
    required this.probability,
    required this.reaction,
    required this.createdBy,
    required this.creationDate,
    required this.inactiveUser,
    required this.inactiveDateTime,
    required this.inactiveReason,
    required this.syncDate,
    required this.transferFlag,
    required this.transferDateTime,
    required this.transferSystem,
  });

  factory PatientAllergy.fromJson(Map<String, dynamic> json) {
    return PatientAllergy(
      alertRefNo: json['alertRefNo'],
      prn: json['prn'],
      alertType: json['alertType'],
      allergyType: json['allergyType'],
      description: json['description'],
      system: json['system'],
      route: json['route'],
      probability: json['probability'],
      reaction: json['reaction'],
      createdBy: json['createdBy'],
      creationDate: formatDateTime(json['creationDate']),
      inactiveUser: json['inactiveUser'],
      inactiveDateTime: json['inactiveDateTime'],
      inactiveReason: json['inactiveReason'],
      syncDate: json['syncDate'],
      transferFlag: json['transferFlag'],
      transferDateTime: json['transferDateTime'],
      transferSystem: json['transferSystem'],
    );
  }
}