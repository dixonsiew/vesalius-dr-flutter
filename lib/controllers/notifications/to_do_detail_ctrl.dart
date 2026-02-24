import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';

class ToDoDetailCtrl extends GetxController {

  final _isLoading = false.obs;
  final _patientInfo = Rx<PatientInfo?>(null);
  final _list = <TodoNotification>[].obs;

  void init() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setPatientInfo(PatientInfo? o) {
    _patientInfo.value = o;
  }

  void setList(List<TodoNotification> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  PatientInfo? get patientInfo => _patientInfo.value;
  List<TodoNotification> get list => [..._list];
}