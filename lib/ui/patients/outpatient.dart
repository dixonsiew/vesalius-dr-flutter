import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/patients/outpatient_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'outpatient_list.dart';

class Outpatient extends StatefulWidget {

  const Outpatient({super.key});

  @override
  State<Outpatient> createState() => _OutpatientState();
}

class _OutpatientState extends State<Outpatient> with AutomaticKeepAliveClientMixin<Outpatient> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final OutpatientCtrl ctrl = Get.put(OutpatientCtrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());

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
      final lx = await getOutpatientQueueSummaryList();
      mainLayoutCtrl.setOutpatientCount(getOutpatientCount(lx));
      final regd = lx.firstWhere((x) => x.queueCriteria == 'Registered', orElse: () => OutpatientQueueSummary(imageName: 'arrived.png', linkName: 'arrived', queueCount: 0, queueCriteria: 'Registered'));
      final seen = lx.firstWhere((x) => x.queueCriteria == 'Seen', orElse: () => OutpatientQueueSummary(imageName: 'seen.png', linkName: 'seen', queueCount: 0, queueCriteria: 'Seen'));
      final appt = lx.firstWhere((x) => x.queueCriteria == 'Appointment', orElse: () => OutpatientQueueSummary(imageName: 'appointment-1.png', linkName: 'appt', queueCount: 0, queueCriteria: 'Appointment'));
      final kiv = lx.firstWhere((x) => x.queueCriteria == 'KIV', orElse: () => OutpatientQueueSummary(imageName: 'kiv.png', linkName: 'kiv', queueCount: 0, queueCriteria: 'KIV'));

      String s = await _getLastUpdateDate(lx);
      ctrl.init();

      if (lx.isEmpty) {
        ctrl.setList([
          OutpatientQueueSummary(imageName: 'arrived.png', linkName: 'arrived', queueCount: 0, queueCriteria: 'Registered'),
          OutpatientQueueSummary(imageName: 'seen.png', linkName: 'seen', queueCount: 0, queueCriteria: 'Seen'),
          OutpatientQueueSummary(imageName: 'appointment-1.png', linkName: 'appt', queueCount: 0, queueCriteria: 'Appointment'),
          OutpatientQueueSummary(imageName: 'kiv.png', linkName: 'kiv', queueCount: 0, queueCriteria: 'KIV')
        ]);
      }

      else {
        ctrl.setList([regd, seen, appt, kiv]);
      }

      ctrl.setLastUpdateDate(s);
      ctrl.setIsLoading(false);
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  int getOutpatientCount(List<OutpatientQueueSummary> lx) {
    int n = 0;
    for (OutpatientQueueSummary o in lx) {
      if (o.queueCriteria != 'KIV') {
        n += o.queueCount;
      }
    }

    return n;
  }

  Future<String> _getLastUpdateDate(List<OutpatientQueueSummary> lx) async {
    String s = '';
    if (lx.isNotEmpty) {
      try {
        final x = lx.firstWhereOrNull((o) => o.queueCount > 0);
        final ls = await getOutpatientQueueDetailList(x?.queueCriteria ?? '');
        if (ls.isNotEmpty) {
          OutpatientQueueDetail o = ls[0];
          s = getLastUpdateDate(o.lastUpdateDate);
        }
      }

      catch (_) {}
    }

    return s;
  }

  Widget buildContent() {
    return Stack(
      children: [
        Obx(() =>
          Padding(
            padding: EdgeInsets.only(bottom: ctrl.lastUpdateDate.isNotEmpty ? 44.0 : 0),
            child: Scrollbar(
              child: ListView.builder(
                itemCount: ctrl.list.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(height: 25.0);
                  }
        
                  return OutpatientItem(data: ctrl.list[index - 1]);
                },
              ),
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
    );
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

class OutpatientItem extends StatelessWidget {

  final OutpatientQueueSummary data;

  const OutpatientItem({
    super.key,
    required this.data,
  });

  String get image {
    String s = 'arrived.png';
    if (data.queueCriteria == 'Seen') {
      s = 'seen.png';
    }

    else if (data.queueCriteria == 'Appointment') {
      s = 'appointment-1.png';
    }
    
    else if (data.queueCriteria == 'KIV') {
      s = 'kiv.png';
    }

    return s;
  }

  String get title {
    String s = 'Arrived / In Progress';
    if (data.queueCriteria == 'Seen') {
      s = 'Seen';
    }
    
    else if (data.queueCriteria == 'Appointment') {
      s = 'Appointment';
    }
    
    else if (data.queueCriteria == 'KIV') {
      s = 'KIV';
    }

    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.35),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            String s = title;
            if (s == 'Seen') {
              s = 'Seen List';
            }

            Get.to(() => OutpatientList(queueCriteria: data.queueCriteria, title: s));
          },
          borderRadius: BorderRadius.circular(5.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Row(
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD4D4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/$image',
                      width: 24.0,
                      height: 24.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Text(
                    title,
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Text(
                  data.queueCount.toString(),
                  style: kTextStyle1.copyWith(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700,
                    color: kPrimaryColor,
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