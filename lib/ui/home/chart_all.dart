import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/home/chart_all_ctrl.dart';
import 'package:vesalius_dr_flutter/ui/home/chart1_1w.dart';
import 'package:vesalius_dr_flutter/ui/home/chart2_1w.dart';
import 'package:vesalius_dr_flutter/ui/home/chart3_1w.dart';

import 'chart0_1w.dart';

class ChartAll extends StatefulWidget {
  
  static const String routeName = '/ChartAll';

  const ChartAll({super.key});

  @override
  State<ChartAll> createState() => _ChartAllState();
}

class _ChartAllState extends State<ChartAll> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final ChartAllCtrl ctrl = Get.put(ChartAllCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {

  }

  Future<void> onRefresh() async {
    load();
  }

  Widget tick() {
    return Image.asset(
      'images/tick.png',
      width: 16.0,
      height: 16.0,
      fit: BoxFit.cover,
    );
  }

  Widget round() {
    return Image.asset(
      'images/round.png',
      width: 16.0,
      height: 16.0,
      fit: BoxFit.cover,
    );
  }

  void onApplyFilter() {
    
  }

  void showFilter() async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 8.0, bottom: 35.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 22.0,
                  iconSize: 28.0,
                  icon: const Icon(
                    Icons.close,
                    color: kTextColor2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Dashboard Selection',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF01274A),
                ),
              ),
            ),
            const SizedBox(height: 11.0),
            InkWell(
              onTap: () {
                ctrl.setFAll(!ctrl.fall);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'All',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Obx(() => ctrl.fall == false ? round() : tick()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ctrl.setFCurr(!ctrl.getFCurr(0), 0);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Weekly Upcoming Appointments',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Obx(() => ctrl.getFCurr(0) == false ? round() : tick()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ctrl.setFCurr(!ctrl.getFCurr(1), 1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Past Weekly Outpatient Visits',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Obx(() => ctrl.getFCurr(1) == false ? round() : tick()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ctrl.setFCurr(!ctrl.getFCurr(2), 2);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Past Weekly Inpatient Visits',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Obx(() => ctrl.getFCurr(2) == false ? round() : tick()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ctrl.setFCurr(!ctrl.getFCurr(3), 3);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total Past Weekly Professional Fees',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Obx(() => ctrl.getFCurr(3) == false ? round() : tick()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ctrl.setFCurr(!ctrl.getFCurr(4), 4);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Internal Referral Statistics',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF01274A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Obx(() => ctrl.getFCurr(4) == false ? round() : tick()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 23.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => ctrl.resetFCurr(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 40.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                        side: const BorderSide(
                          color: kPrimaryColor,
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 17.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onApplyFilter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 40.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      ),
                      child: Text(
                        'Apply',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    ctrl.setOpt(0);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: ctrl.opt == 0 ? kPrimaryColor : Colors.transparent,
                      ),
                      child: Text(
                        '1W',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: ctrl.opt == 0 ? Colors.white : kTextColor2,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ctrl.setOpt(1);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: ctrl.opt == 1 ? const Color(0xFFA41D2B) : Colors.transparent,
                      ),
                      child: Text(
                        '2W',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: ctrl.opt == 1 ? Colors.white : const Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ctrl.setOpt(2);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: ctrl.opt == 2 ? const Color(0xFFA41D2B) : Colors.transparent,
                      ),
                      child: Text(
                        '1M',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: ctrl.opt == 2 ? Colors.white : const Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ctrl.setOpt(3);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: ctrl.opt == 3 ? const Color(0xFFA41D2B) : Colors.transparent,
                      ),
                      child: Text(
                        '3M',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: ctrl.opt == 3 ? Colors.white : const Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ctrl.setOpt(4);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: ctrl.opt == 4 ? const Color(0xFFA41D2B) : Colors.transparent,
                      ),
                      child: Text(
                        '6M',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: ctrl.opt == 4 ? Colors.white : const Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ctrl.setOpt(5);
                  },
                  borderRadius: BorderRadius.circular(50.0),
                  child: Obx(() =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: ctrl.opt == 5 ? const Color(0xFFA41D2B) : Colors.transparent,
                      ),
                      child: Text(
                        '12M',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w800,
                          color: ctrl.opt == 5 ? Colors.white : const Color(0xFFB1B1B1),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Chart01w(),
          ),
          const SizedBox(height: 35.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Chart11w(),
          ),
          const SizedBox(height: 35.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Chart21w(),
          ),
          const SizedBox(height: 35.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Chart31w(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Dashboard',
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            onPressed: showFilter,
            icon: Image.asset(
              'images/filter.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: Obx(() => 
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const CupertinoActivityIndicator(radius: 15.0),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}