import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/review.dart';

class ToReviewDetailCtrl extends GetxController {

  final _isLoading = false.obs;
  final _patientInfo = Rx<PatientInfo?>(null);
  final _list = <Review>[].obs;

  void init() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setPatientInfo(PatientInfo? o) {
    _patientInfo.value = o;
  }

  void setList(List<Review> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void removeFromList(String accessionNo) {
    _list.retainWhere((o) => o.accessionNo != accessionNo);
  }

  bool get isLoading => _isLoading.value;
  PatientInfo? get patientInfo => _patientInfo.value;
  List<Review> get list => [..._list];
}