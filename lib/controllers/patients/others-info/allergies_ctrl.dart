import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/patient_allergy.dart';

class AllergiesCtrl extends GetxController {

  final _isLoading = false.obs;
  final _list = <PatientAllergy>[].obs;

  void init() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setList(List<PatientAllergy> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  List<PatientAllergy> get list => [..._list];
}