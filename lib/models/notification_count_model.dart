import 'package:flutter/material.dart';

class NotificationCountModel extends ChangeNotifier {

  int _reviewCount = 0;
  int _todoCount = 0;

  void setReviewCount(int n) {
    _reviewCount = n;
    notifyListeners();
  }

  void setTodoCount(int n) {
    _todoCount = n;
    notifyListeners();
  }

  int get todoCount => _todoCount;

  int get reviewCount => _reviewCount;
}