import 'package:get/get.dart';

class NotificationsCtrl extends GetxController {

  final _reviewCount = 0.obs;
  final _todoCount = 0.obs;

  void setReviewCount(int n) {
    _reviewCount.value = n;
  }

  void setTodoCount(int n) {
    _todoCount.value = n;
  }

  int get reviewCount => _reviewCount.value;
  int get todoCount => _todoCount.value;
}