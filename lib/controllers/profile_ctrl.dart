import 'package:get/get.dart';

class ProfileCtrl extends GetxController {

  final _isLoading = false.obs;
  final _isBiometricEnabled = false.obs;
  final _isPushEnabled = false.obs;

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setIsBiometricEnabled(bool b) {
    _isBiometricEnabled.value = b;
  }

  void setIsPushEnabled(bool b) {
    _isPushEnabled.value = b;
  }

  bool get isLoading => _isLoading.value;
  bool get isBiometricEnabled => _isBiometricEnabled.value;
  bool get isPushEnabled => _isPushEnabled.value;
}