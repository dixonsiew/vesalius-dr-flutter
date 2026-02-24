import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/models/notification_count_model.dart';
import 'package:vesalius_dr_flutter/models/notifications_search_model.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'to_review_notifications.dart';
import 'todo_notifications.dart';

class Notifications extends StatefulWidget {

  static const String routeName = 'Notifications';

  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> with AutomaticKeepAliveClientMixin<Notifications>, SingleTickerProviderStateMixin {

  int tabIndex = 0;
  bool isSearch0 = false;
  bool isSearch1 = false;
  late TabController tabController;
  late final TextEditingController searchController;
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      
    });
    tabController.index = 0;
    load();
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.removeListener(() { });
    tabController.dispose();
    super.dispose();
  }

  void load() async {
    final dlg = CustomDialog.of(context);
    try {
      NotificationCountModel cm = Provider.of<NotificationCountModel>(context, listen: false);
      var lx = await getTodoNotificationList();
      var ls = TodoNotification.getUniqueList(lx);
      cm.setReviewCount(0);
      cm.setTodoCount(ls.length);
    }

    on DioException catch (error) {
      dlg.handleError(error, load);
    }

    catch (error) {
      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  void filterList(String s) {
    if (tabIndex == 0) {
      Provider.of<NotificationsSearchModel>(context, listen: false).searchReview(s);
    }

    else {
      Provider.of<NotificationsSearchModel>(context, listen: false).searchTodo(s);
    }
  }

  Widget? buildLeading() {
    if (tabIndex == 0 && isSearch0) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kAppBarIconColor,
        ),
        onPressed: () {
          setState(() {
            isSearch0 = false;
          });
        },
      );
    }

    else if (tabIndex == 1 && isSearch1) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kAppBarIconColor,
        ),
        onPressed: () {
          setState(() {
            isSearch1 = false;
          });
        },
      );
    }

    return null;
  }

  List<Widget> buildActions(BuildContext context) {
    List<Widget> lx = [];
    if (tabIndex == 0 && !isSearch0) {
      lx.add(
        IconButton(
          icon: const Icon(
            Icons.search,
            color: kAppBarIconColor,
          ),
          onPressed: () {
            //showSearch(context: context, delegate: HomeSearch());
            setState(() {
              isSearch0 = true;
            });
          },
        )
      );
    }

    else if (tabIndex == 1 && !isSearch1) {
      lx.add(
        IconButton(
          icon: const Icon(
            Icons.search,
            color: kAppBarIconColor,
          ),
          onPressed: () {
            //showSearch(context: context, delegate: HomeSearch());
            setState(() {
              isSearch1 = true;
            });
          },
        )
      );
    }

    lx.add(
      IconButton(
        onPressed: () {
          drawerKey.currentState?.openEndDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: kAppBarIconColor,
        ),
      )
    );

    return lx;
  }

  Widget buildTitle() {
    if ((!isSearch0 && !isSearch1) || 
    (tabIndex == 0 && !isSearch0) || 
    (tabIndex == 1 && !isSearch1)) {
      return const Text(
        'MY NOTIFICATIONS',
        style: kAppBarTitleTextStyle,
      );
    }

    return Material(
      elevation: 20.0,
      borderRadius: BorderRadius.circular(5.0),
      shadowColor: Colors.black,
        child: TextField(
        controller: searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        cursorColor: kTextColor,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: const Icon(
            Icons.search,
            color: kAppBarIconColor,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 3.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        onChanged: filterList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: drawerKey,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 2.0,
          leading: buildLeading(),
          actions: buildActions(context),
          title: buildTitle(),
          bottom: TabBar(
            controller: tabController,
            onTap: (int i) {
              setState(() {
                tabIndex = i;
              });
            },
            tabs: [
              Tab(
                child: Text(
                  'To Review (${Provider.of<NotificationCountModel>(context).reviewCount})',
                  style: kTabTitleTextStyle,
                ),
              ),
              Tab(
                child: Text(
                  'To-Do (${Provider.of<NotificationCountModel>(context).todoCount})',
                  style: kTabTitleTextStyle,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: TabBarView(
            controller: tabController,
            children: const [
              ToReviewNotifications(),
              TodoNotifications(),
            ],
          ),
        ),
        endDrawer: const AppDrawer(),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}