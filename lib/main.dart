import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'models/data_manager.dart';
import 'models/notification_count_model.dart';
import 'models/notifications_search_model.dart';
import 'models/patient_count_model.dart';
import 'models/patient_search_model.dart';
import 'ui/main_layout.dart';
import 'ui/splash.dart';

late LazyBox box;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: ".env");
  box = await DataManager.instance.initHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ));
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PatientCountModel()),
        ChangeNotifierProvider(create: (context) => NotificationCountModel()),
        ChangeNotifierProvider(create: (context) => PatientSearchModel()),
        ChangeNotifierProvider(create: (context) => NotificationsSearchModel()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VESALIUS.dr',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('en', 'AU'),
        ],
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
          fontFamily: kBodyFont,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: Theme.of(context).appBarTheme.copyWith(shadowColor: Colors.black),
        ),
        initialRoute: Splash.routeName,
        getPages: [
          GetPage(name: Splash.routeName, page: () => const Splash(), transition: Transition.fadeIn),
          GetPage(name: MainLayout.routeName, page: () => const MainLayout()),
        ],
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: scale),
            child: child!,
          );
        },
      ),
    );
  }
}