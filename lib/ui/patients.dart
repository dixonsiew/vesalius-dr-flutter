import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/patients_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'patients/inpatient.dart';
import 'patients/outpatient.dart';

class Patients extends StatefulWidget {

  static const String routeName = '/Patients';

  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> with AutomaticKeepAliveClientMixin<Patients>, SingleTickerProviderStateMixin {

  late TabController tabController;

  final PatientsCtrl ctrl = Get.put(PatientsCtrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      ctrl.setTabIndex(tabController.index);
    });
    tabController.index = ctrl.tabIndex;
    ctrl.tabController = tabController;
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
      final lx = await getOutpatientQueueSummaryList();
      final ly = await getInpatientDetailList();
      mainLayoutCtrl.setOutpatientCount(getOutpatientCount(lx));
      mainLayoutCtrl.setInpatientCount(ly.length);
    }

    on DioException catch (error) {
      handleError(error, load);
    }

    catch (error) {
      showCustomDialog(error.toString(), AlertType.error);
    }
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
              toolbarHeight: kAppToolbarHeight,
              automaticallyImplyLeading: false,
              backgroundColor: kBgColor1,
              centerTitle: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text(
                  'My Patients',
                  style: kTextStyle1.copyWith(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
              ),
              elevation: 2.0,
              bottom: TabBar(
                indicatorColor: kPrimaryColor,
                controller: ctrl.tabController,
                onTap: (int i) {
                  ctrl.setTabIndex(i);
                },
                tabs: [
                  Obx(() =>
                    Tab(
                      child: Text(
                        'Outpatient (${mainLayoutCtrl.outpatientCount})',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: ctrl.tabIndex == 0 ? kPrimaryColor : kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Obx(() =>
                    Tab(
                      child: Text(
                        'Inpatient (${mainLayoutCtrl.inpatientCount})',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: ctrl.tabIndex == 1 ? kPrimaryColor : kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: kBgColor1,
            body: SafeArea(
              child: TabBarView(
                controller: tabController,
                children: const [
                  Outpatient(),
                  Inpatient(),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}