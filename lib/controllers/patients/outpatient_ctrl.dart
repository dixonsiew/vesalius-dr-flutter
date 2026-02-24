import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';

class OutpatientCtrl extends GetxController {

  final _isLoading = false.obs;
  final _lastUpdateDate = ''.obs;
  final _list = <OutpatientQueueSummary>[].obs;

  void init() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setLastUpdateDate(String s) {
    _lastUpdateDate.value = s;
  }

  void setList(List<OutpatientQueueSummary> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  String get lastUpdateDate => _lastUpdateDate.value;
  List<OutpatientQueueSummary> get list => [..._list];
}