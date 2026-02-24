import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/user.dart';

class HomeCtrl extends GetxController {

  final _isLoading = false.obs;
  final _current = 0.obs;
  final _user = Rx<User?>(null);

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setCurrent(int i) {
    _current.value = i;
  }

  void setUser(User? o) {
    _user.value = o;
  }

  bool get isLoading => _isLoading.value;
  int get current => _current.value;
  User? get user => _user.value;
}