import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/ui/home.dart';
import 'package:vesalius_dr_flutter/ui/notifications.dart';

import 'login.dart';

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

  @override
  void initState() {
    super.initState();
    pages = [const Home(), const Notifications()];
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    final nav = Navigator.of(context);
    bool b = await CustomDialog.of(context).showConfirmDialog('Are you sure you want to logout ?');
    if (b) {
      nav.pushReplacementNamed(Login.routeName);
    }

    return;
  }

  Widget get buildContent => PageView(
    controller: pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: pages,
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black),
          toolbarHeight: 0.0,
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: buildContent,
        ),
        bottomNavigationBar: BottomBar(
          index: 0,
          onTap: (int i) {
            pageController.jumpToPage(i);
          },
        ),
      ),
    );
  }
}