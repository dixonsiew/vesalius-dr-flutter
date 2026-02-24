import 'package:flutter/material.dart';

class PatientCountModel extends ChangeNotifier {

  int _outpatientCount = 0;
  int _inpatientCount = 0;

  void setOutpatientCount(int n) {
    _outpatientCount = n;
    notifyListeners();
  }

  void setInpatientCount(int n) {
    _inpatientCount = n;
    notifyListeners();
  }

  int get outpatientCount => _outpatientCount;

  int get inpatientCount => _inpatientCount;
}