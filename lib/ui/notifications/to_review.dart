import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/components/no_record.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/notifications/to_review_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/notifications_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/review.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:vesalius_dr_flutter/ui/notifications/to_review_detail.dart';

class ToReview extends StatefulWidget {

  const ToReview({super.key});

  @override
  State<ToReview> createState() => _ToReviewState();
}

class _ToReviewState extends State<ToReview> with AutomaticKeepAliveClientMixin<ToReview> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final ToReviewCtrl ctrl = Get.put(ToReviewCtrl());
  final NotificationsCtrl notificationsCtrl = Get.put(NotificationsCtrl());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final lx = await getReviewList(formatCurrentDate());
      String s = _getLastUpdateDate(lx);
      final ls = Review.getUniqueList(lx);
      notificationsCtrl.setReviewCount(ls.length);
      ctrl.init();
      ctrl.setList(ls);
      ctrl.setAllList(lx);
      ctrl.setLastUpdateDate(s);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      await showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  String _getLastUpdateDate(List<Review> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      Review o = lx[0];
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  Widget buildList() {
    return Obx(() => ctrl.list.isEmpty ? const NoRecord(text: 'You have no document to review at the moment.') :
    Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ctrl.lastUpdateDate.isNotEmpty ? 44.0 : 0),
          child: Scrollbar(
            child: ListView.builder(
              itemCount: ctrl.list.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 25.0);
                }

                Review o = ctrl.list[index - 1];
                return ToReviewItem(
                  reload: load,
                  data: o,
                  list: ctrl.alllist.where((x) => x.patientName == o.patientName).toList(),
                );
              },
            ),
          ),
        ),
        if (ctrl.lastUpdateDate.isNotEmpty) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: LastUpdateBar(ctrl.lastUpdateDate),
          ),
        ],
      ],
    ));
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() : buildList());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
      ModalProgressHUD(
        inAsyncCall: ctrl.isLoading,
        blur: kBlur,
        progressIndicator: const AppActivityIndicator(),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          color: kPrimaryColor,
          child: buildContent(),
        ),
      ),
    );
  }
}

class ToReviewItem extends StatelessWidget {

  final void Function() reload;
  final Review data;
  final List<Review> list;
  
  const ToReviewItem({
    super.key, 
    required this.reload,
    required this.data,
    required this.list,
  });

  List<Widget> buildList() {
    List<Widget> lx = [
      Text(
        data.patientName,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2E2E2E),
        ),
      ),
      const SizedBox(height: 12.0),
    ];
    for (String i in data.investigationTypes!.keys) {
      List<String> li = data.investigationTypes![i]!;
      String im = 'images/microscope.png';
      if (i == 'DI') {

      }

      else if (i == 'LABS') {
        im = 'images/x-ray-1.png';
      }

      for (int i = 0; i < li.length; i++) {
        String x = li[i];
        final row = Row(
          children: [
            Image.asset(
              im,
              width: 14.0,
              height: 14.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 11.0),
            Expanded(
              child: Text(
                x,
                style: kTextStyle1.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: kTextColor5,
                ),
              ),
            ),
          ],
        );
        lx.addAll([
          row,
          const SizedBox(height: 10.0),
        ]);
      }

      lx.removeLast();
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.30),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () async {
            bool b = await Get.to(() => ToReviewDetail(data: data, list: list)) ?? false;
            if (b == true) {
              reload();
            }
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD4D4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/avatar.png',
                      width: 18.65,
                      height: 22.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}