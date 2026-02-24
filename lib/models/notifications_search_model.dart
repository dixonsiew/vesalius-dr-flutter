import 'dart:collection';
import 'package:flutter/material.dart';
import 'review.dart';
import 'todo_notification.dart';

class NotificationsSearchModel extends ChangeNotifier {

  List<Review> _reviewList = [];
  List<Review> _xreviewList = [];
  List<Review> _allreviewList = [];
  List<TodoNotification> _todoList = [];
  List<TodoNotification> _xtodoList = [];

  UnmodifiableListView<Review> get reviewList => UnmodifiableListView(_reviewList);
  UnmodifiableListView<Review> get allreviewList => UnmodifiableListView(_allreviewList);
  UnmodifiableListView<TodoNotification> get todoList => UnmodifiableListView(_todoList);

  void setReviewList(List<Review> ls, List<Review> lx) {
    _reviewList = ls;
    _xreviewList = ls;
    _allreviewList = lx;
    notifyListeners();
  }

  void searchReview(String s) {
    if (s.isEmpty) {
      _reviewList = _xreviewList;
    }

    else {
      String r = s.toLowerCase();
      var q = _reviewList.where((o) {
        return o.patientName.toLowerCase().contains(r);
      });
      _reviewList = q.toList();
    }

    notifyListeners();
  }

  void setTodoList(List<TodoNotification> ls, List<TodoNotification> lx) {
    _todoList = ls;
    _xtodoList = lx;
    notifyListeners();
  }

  void searchTodo(String s) {
    if (s.isEmpty) {
      _todoList = _xtodoList;
    }

    else {
      String r = s.toLowerCase();
      var q = _todoList.where((o) {
        return o.patientName.toLowerCase().contains(r);
      });
      _todoList = q.toList();
    }

    notifyListeners();
  }
}