import 'package:get/get.dart';

class ChartAllCtrl extends GetxController {

  final _isLoading = false.obs;
  final _opt = 0.obs;
  final _fall = false.obs;
  final _fcurr = [false.obs, false.obs, false.obs, false.obs, false.obs];

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setOpt(int i) {
    _opt.value = i;
  }

  void setFAll(bool b) {
    _fall.value = b;
    if (b) {
      _fcurr[0].value = b;
      _fcurr[1].value = b;
      _fcurr[2].value = b;
      _fcurr[3].value = b;
      _fcurr[4].value = b;
    }
  }

  void setFCurr(bool b, int i) {
    _fcurr[i].value = b;
    if (_fcurr.every((o) => o.value == true)) {
      _fall.value = true;
    }

    if (_fcurr.any((o) => o.value == false)) {
      _fall.value = false;
    }
  }

  void resetFCurr() {
    setFAll(false);
    _fcurr[0].value = false;
    _fcurr[1].value = false;
    _fcurr[2].value = false;
    _fcurr[3].value = false;
    _fcurr[4].value = false;
  }

  bool getFCurr(int i) {
    return _fcurr[i].value;
  }

  bool get isLoading => _isLoading.value;
  int get opt => _opt.value;
  bool get fall => _fall.value;
  List<bool> get fcurr => [_fcurr[0].value, _fcurr[1].value, _fcurr[2].value, _fcurr[3].value, _fcurr[4].value];
}