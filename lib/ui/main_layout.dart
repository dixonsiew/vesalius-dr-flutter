import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/patients_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/notification_manager.dart';
import 'package:vesalius_dr_flutter/ui/appointment.dart';
import 'package:vesalius_dr_flutter/ui/notifications.dart';
import 'package:vesalius_dr_flutter/ui/patients.dart';

import 'home.dart';

class MainLayout extends StatefulWidget {

  static const String routeName = '/MainLayout';

  final int index;

  const MainLayout({
    super.key,
    this.index = 0,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  late List<Widget> pages;
  late PageController pageController;

  final MainLayoutCtrl ctrl = Get.put(MainLayoutCtrl());
  final PatientsCtrl patientsCtrl = Get.put(PatientsCtrl());

  @override
  void initState() {
    super.initState();
    pages = [Home(onPatient: onPatient), const Patients(), const Appointment(), const Notifications()];
    ctrl.setIndex(widget.index);
    pageController = PageController(initialPage: ctrl.index);
    initPlatformState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void initPlatformState() async {
    OneSignal.Notifications.addForegroundWillDisplayListener(NotificationManager.instance.foregroundWillDisplayListener);

    await OneSignal.Notifications.requestPermission(true);

    if (AuthManager.instance.isLogin) {
      //OneSignal.shared.sendTag('user', DataManager.userDetails!.userId!);
      String playerId = AuthManager.instance.getPlayerId();

      if (playerId.isNotEmpty) {
        //await updatePlayerId(playerId);
      }
    }
  }

  void onPatient(int i) {
    ctrl.setIndex(1);
    patientsCtrl.setTabIndex(i);
    pageController.jumpToPage(1);
    patientsCtrl.tabController?.animateTo(i);
  }

  Widget get buildContent => PageView(
    controller: pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: pages,
  );

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    bool b = await showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: kBgColor1,
        body: SafeArea(
          child: buildContent,
        ),
        bottomNavigationBar: Obx(() =>
          BottomBar(
            index: ctrl.index,
            onTap: (int i) {
              ctrl.setIndex(i);
              pageController.jumpToPage(i);
            },
          ),
        ),
      ),
    );
  }
}