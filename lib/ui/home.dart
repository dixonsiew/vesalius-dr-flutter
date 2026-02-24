import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/models/patient_count_model.dart';
import 'package:vesalius_dr_flutter/models/patient_search_model.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'inpatient.dart';
import 'outpatient.dart';

class Home extends StatefulWidget {

  static const String routeName = 'Dashboard';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home>, SingleTickerProviderStateMixin {

  int tabIndex = 0;
  bool isSearch = false;
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
      PatientCountModel cm = Provider.of<PatientCountModel>(context, listen: false);
      PatientSearchModel csm = Provider.of<PatientSearchModel>(context, listen: false);
      var lx = await getOutpatientQueueSummaryList();
      var ly = await getInpatientDetailList();
      cm.setOutpatientCount(getOutpatientCount(lx));
      cm.setInpatientCount(ly.length);
      csm.setInpatientList(ly);
    }

    on DioException catch (error) {
      dlg.handleError(error, load);
    }

    catch (error) {
      dlg.showCustomDialog(error.toString(), AlertType.error);
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

  void filterInpatient(String s) {
    Provider.of<PatientSearchModel>(context, listen: false).searchInpatient(s);
  }

  Widget? buildLeading() {
    if (isSearch) {
      return IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: kAppBarIconColor,
        ),
        onPressed: () {
          setState(() {
            isSearch = false;
          });
        },
      );
    }

    return null;
  }

  List<Widget> buildActions(BuildContext context) {
    List<Widget> lx = [];
    if (tabIndex == 1 && !isSearch) {
      lx.add(
        IconButton(
          icon: const Icon(
            Icons.search,
            color: kAppBarIconColor,
          ),
          onPressed: () {
            //showSearch(context: context, delegate: HomeSearch());
            setState(() {
              isSearch = true;
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
    if (!isSearch) {
      return const Text(
        'MY PATIENTS',
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
        onChanged: filterInpatient,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
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
                      'Outpatient (${Provider.of<PatientCountModel>(context).outpatientCount})',
                      style: kTabTitleTextStyle,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Inpatient (${Provider.of<PatientCountModel>(context).inpatientCount})',
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
                  Outpatient(),
                  Inpatient(),
                ],
              ),
            ),
            endDrawer: const AppDrawer(),
          );
        },
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class HomeSearch extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear), 
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}