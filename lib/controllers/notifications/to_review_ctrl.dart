import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/models/review.dart';

class ToReviewCtrl extends GetxController {

  final _isLoading = false.obs;
  final _lastUpdateDate = ''.obs;
  final _list = <Review>[].obs;
  final _alllist = <Review>[].obs;

  void init() {
    _list.clear();
    _alllist.clear();
  }

  void setIsLoading(bool b) {
    _isLoading.value = b;
  }

  void setLastUpdateDate(String s) {
    _lastUpdateDate.value = s;
  }

  void setList(List<Review> lx) {
    _list.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  void setAllList(List<Review> lx) {
    _alllist.addAllIf(lx.isNotEmpty, lx);
    if (lx.isEmpty) {
      _list.clear();
    }
  }

  bool get isLoading => _isLoading.value;
  String get lastUpdateDate => _lastUpdateDate.value;
  List<Review> get list => [..._list];
  List<Review> get alllist => [..._alllist];
}