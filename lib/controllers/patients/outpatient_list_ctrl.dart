import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';

class OutpatientListCtrl extends GetxController {

  final _isLoading = false.obs;
  final _lastUpdateDate = ''.obs;
  final _keyword = ''.obs;
  final _list = <OutpatientQueueDetail>[].obs;
  final _mlist = <OutpatientQueueDetail>[].obs;

  void init() {
    _list.clear();
  }

  void initMList() {
    _mlist.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setLastUpdateDate(String s) {
    _lastUpdateDate.value = s;
  }

  void setKeyword(String s) {
    _keyword.value = s;
  }

  void setList(List<OutpatientQueueDetail> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setMList(List<OutpatientQueueDetail> lx) {
    _mlist.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _mlist.clear();
    }
  }

  void resetList() {
    init();
    setList(mlist);
  }

  bool get isLoading => _isLoading.value;
  String get lastUpdateDate => _lastUpdateDate.value;
  String get keyword => _keyword.value;
  List<OutpatientQueueDetail> get list => [..._list];
  List<OutpatientQueueDetail> get mlist => [..._mlist];
}