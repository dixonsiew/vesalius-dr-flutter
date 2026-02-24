import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/home_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/models/user.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'home/chart0_1w.dart';
import 'home/chart1_1w.dart';
import 'home/chart2_1w.dart';
import 'home/chart3_1w.dart';
import 'home/chart_all.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  
  static const String routeName = '/Home';

  final void Function(int) onPatient;

  const Home({
    super.key,
    required this.onPatient,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>, SingleTickerProviderStateMixin {

  late TabController tabController;
  final CarouselController carController = CarouselController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final HomeCtrl ctrl = Get.put(HomeCtrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      ctrl.setCurrent(tabController.index);
    });
    load();
  }

  @override
  void dispose() {
    tabController.removeListener(() { });
    tabController.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      await AuthManager.instance.load();
      User o = await getUser();
      ctrl.setUser(o);
      final lx = await getOutpatientQueueSummaryList();
      final ly = await getInpatientDetailList();
      mainLayoutCtrl.setOutpatientCount(getOutpatientCount(lx));
      mainLayoutCtrl.setInpatientCount(ly.length);
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

  int getOutpatientCount(List<OutpatientQueueSummary> lx) {
    int n = 0;
    for (var o in lx) {
      if (o.queueCriteria != 'KIV') {
        n += o.queueCount;
      }
    }

    return n;
  }

  String formatDateTime(DateTime dt) {
    return formatDate(dt, [DD, ', ', d, ' ', M, ' ', yyyy]);
  }

  String get name {
    User? o = ctrl.user;
    String s = '${o?.title} ${o?.firstName} ${o?.middleName} ${o?.lastName ?? ''}'.trim();
    return s;
  }

  String get greetings {
    var h = DateTime.now().hour;
    String s = 'Good';
    String b = 'Night';
    if (h < 12) {
      b = 'Morning';
    }

    else if (h >= 12 && h < 17) {
      b = 'Afternoon';
    }

    else if (h >= 17 && h <= 19) {
      b = 'Evening';
    }

    return '$s $b';
  }

  Widget buildContent() {
    return ctrl.isLoading ? Container() :
    Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 17.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$greetings,',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor4,
                        ),
                      ),
                      Text(
                        name,
                        style: kTextStyle1.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                      Text(
                        formatDateTime(DateTime.now()),
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor2,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Get.to(() => Profile(user: ctrl.user!)),
                  splashRadius: 24.0,
                  icon: Image.asset(
                    'images/doc.png',
                    width: 48.0,
                    height: 48.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 25.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                        blurRadius: 8.0,// changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: const Color(0xFFEF6060),
                    borderRadius: BorderRadius.circular(5.0),
                    child: InkWell(
                      onTap: () => widget.onPatient.call(0),
                      borderRadius: BorderRadius.circular(5.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'images/patient-1.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                                Obx(() =>
                                  Text(
                                    mainLayoutCtrl.outpatientCount.toString(),
                                    style: kTextStyle1.copyWith(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13.0),
                            Text(
                              'Today’s Outpatients',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 25.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                        blurRadius: 8.0,// changes position of shadow
                      ),
                    ],
                  ),
                  child: Material(
                    color: const Color(0xFF5590FC),
                    borderRadius: BorderRadius.circular(5.0),
                    child: InkWell(
                      onTap: () => widget.onPatient.call(1),
                      borderRadius: BorderRadius.circular(5.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'images/bed.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                                Obx(() =>
                                  Text(
                                    mainLayoutCtrl.inpatientCount.toString(),
                                    style: kTextStyle1.copyWith(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 13.0),
                            Text(
                              'Today’s Inpatients',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17.0),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 17.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Dashboard Overview',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        '*Data last updated on 23 Nov 2022',
                        style: kTextStyle1.copyWith(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor2,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ChartAll()),
                  style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                  ),
                  child: Text(
                    'View All',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              height: 440.0,
              child: DefaultTabController(
                length: 4,
                child: Builder(
                  builder: (context) => TabBarView(
                    controller: tabController,
                    physics: const BouncingScrollPhysics(),
                    children: const [
                      Chart01w(),
                      Chart11w(),
                      Chart21w(),
                      Chart31w(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() =>
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [0, 1, 2, 3].map((i) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    tabController.animateTo(i);
                  },
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 6.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ctrl.current == i ? kPrimaryColor : const Color(0xFFDADADA),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
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
        child: buildContent(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}