import 'package:get/get.dart';

class MainLayoutCtrl extends GetxController {

  final _index = 0.obs;
  final _outpatientCount = 0.obs;
  final _inpatientCount = 0.obs;

  void setIndex(int i) {
    _index.value = i;
  }

  void setOutpatientCount(int n) {
    _outpatientCount.value = n;
  }

  void setInpatientCount(int n) {
    _inpatientCount.value = n;
  }

  int get index => _index.value;
  int get outpatientCount => _outpatientCount.value;
  int get inpatientCount => _inpatientCount.value;
}