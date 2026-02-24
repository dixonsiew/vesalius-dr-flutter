import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/notification_manager.dart';
import 'dart:developer' as developer;

import 'main_layout.dart';
import 'sign_in.dart';

class Splash extends StatefulWidget {

  static const String routeName = '/Splash';

  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    await AuthManager.instance.load();
    initPlatformState();
  }

  void initPlatformState() async {
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.Debug.setLogLevel(OSLogLevel.info);

    OneSignal.consentRequired(false);

    OneSignal.initialize(kOneSignalAppID);
    await OneSignal.Notifications.clearAll();

    OneSignal.User.pushSubscription.addObserver((state) {
      final s = OneSignal.User.pushSubscription.id ?? '';
      if (s.isNotEmpty) {
        AuthManager.playerId = s;
        developer.log("==== splash playerid ${AuthManager.playerId} ====");
      }
    });

    OneSignal.Notifications.addForegroundWillDisplayListener(NotificationManager.instance.foregroundWillDisplayListener);

    OneSignal.Notifications.addClickListener((OSNotificationClickEvent ev) {
      NotificationManager.instance.clickListener(ev);
    });

    startNavigate();
  }

  void startNavigate() async {
    Duration duration = const Duration(seconds: 5);
    await Future.delayed(duration, navigationPage);
  }

  void navigationPage() {
    if (AuthManager.isLogin) {
      Get.off(() => const MainLayout());
    }

    else {
      Get.off(() => const SignIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light, statusBarColor: kPrimaryColor),
        toolbarHeight: 0.0,
        backgroundColor: kPrimaryColor,
        elevation: 0.0,
      ),
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Image.asset(
          'images/splash.png',
          width: 300.0,
          height: 141.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}