import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/notifications_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:vesalius_dr_flutter/ui/notifications/to_do.dart';

import 'notifications/to_review.dart';

class Notifications extends StatefulWidget {
  
  static const String routeName = '/Notifications';

  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> with SingleTickerProviderStateMixin {

  int tabIndex = 0;
  late TabController tabController;

  final NotificationsCtrl ctrl = Get.put(NotificationsCtrl());

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {
        tabIndex = tabController.index;
      });
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
      if (!mounted) {
        return;
      }

      var lx = await getTodoNotificationList();
      var ls = TodoNotification.getUniqueList(lx);
      ctrl.setTodoCount(ls.length);
    }

    on DioException catch (error) {
      handleError(error, load);
    }

    catch (error) {
      if (mounted) {}
      await showCustomDialog(error.toString(), AlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  'Notifications',
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
                controller: tabController,
                onTap: (int i) {
                  setState(() {
                    tabIndex = i;
                  });
                },
                tabs: [
                  Tab(
                    child: Obx(() =>
                      Text(
                        'To Review (${ctrl.reviewCount})',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: tabIndex == 0 ? kPrimaryColor : kTextColor2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Tab(
                    child: Obx(() =>
                      Text(
                        'To-Do (${ctrl.todoCount})',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: tabIndex == 1 ? kPrimaryColor : kTextColor2,
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
                  ToReview(),
                  ToDo(),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}