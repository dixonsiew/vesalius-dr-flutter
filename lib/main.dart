import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_dr_flutter/models/patient_count_model.dart';
import 'package:vesalius_dr_flutter/models/notification_count_model.dart';
import 'package:vesalius_dr_flutter/models/patient_search_model.dart';
import 'package:vesalius_dr_flutter/models/notifications_search_model.dart';
import 'package:vesalius_dr_flutter/ui/login.dart';
import 'package:vesalius_dr_flutter/ui/change_password.dart';
import 'package:vesalius_dr_flutter/ui/splash.dart';

import 'ui/main_layout.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.black));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PatientCountModel()),
        ChangeNotifierProvider(create: (context) => NotificationCountModel()),
        ChangeNotifierProvider(create: (context) => PatientSearchModel()),
        ChangeNotifierProvider(create: (context) => NotificationsSearchModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VESALIUS.dr',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: Theme.of(context).appBarTheme.copyWith(shadowColor: Colors.black),
        ),
        initialRoute: Splash.routeName,
        routes: {
          Splash.routeName: (context) => const Splash(),
          Login.routeName: (context) => const Login(),
          MainLayout.routeName: (context) => const MainLayout(),
          ChangePassword.routeName: (context) => const ChangePassword(),
        },
      ),
    );
  }
}
