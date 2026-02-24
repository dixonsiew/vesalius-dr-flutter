import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientsCtrl extends GetxController {

  final _tabIndex = 0.obs;
  TabController? tabController;

  void setTabIndex(int i) {
    _tabIndex.value = i;
  }

  int get tabIndex => _tabIndex.value;
}