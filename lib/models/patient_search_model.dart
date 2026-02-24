import 'dart:collection';
import 'package:flutter/material.dart';
import 'inpatient.dart';

class PatientSearchModel extends ChangeNotifier {

  List<InpatientQueueDetail> _inpatientList = [];
  List<InpatientQueueDetail> _xinpatientList = [];

  UnmodifiableListView<InpatientQueueDetail> get inpatientList => UnmodifiableListView(_inpatientList);

  void setInpatientList(List<InpatientQueueDetail> lx) {
    _inpatientList = lx;
    _xinpatientList = lx;
    notifyListeners();
  }

  void searchInpatient(String s) {
    if (s.isEmpty) {
      _inpatientList = _xinpatientList;
    }

    else {
      String r = s.toLowerCase();
      var q = _inpatientList.where((o) {
        return o.firstName.toLowerCase().contains(r) ||
        o.middleName.toLowerCase().contains(r) ||
        o.lastName.toLowerCase().contains(r) ||
        o.title.toLowerCase().contains(r) ||
        o.prn.toLowerCase().contains(r) ||
        o.ward.toLowerCase().contains(r);
      });
      _inpatientList = q.toList();
    }

    notifyListeners();
  }
}