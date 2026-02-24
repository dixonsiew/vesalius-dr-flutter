import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';

class TodoCtrl extends GetxController {

  final _isLoading = false.obs;
  final _lastUpdateDate = ''.obs;
  final _list = <TodoNotification>[].obs;

  void init() {
    _list.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setLastUpdateDate(String s) {
    _lastUpdateDate.value = s;
  }

  void setList(List<TodoNotification> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  String get lastUpdateDate => _lastUpdateDate.value;
  List<TodoNotification> get list => [..._list];
}