import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';

class PatientProfileCtrl extends GetxController {
  
  final _isLoading = false.obs;
  final _patientData = Rx<PatientData?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setPatientData(PatientData? o) {
    _patientData.value = o;
  }

  bool get isLoading => _isLoading.value;
  PatientData? get patientData => _patientData.value;
}