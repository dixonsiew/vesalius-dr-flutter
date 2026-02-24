import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'main_layout.dart';
import 'patient_detail.dart';

class OutpatientList extends StatefulWidget {

  static const String routeName = 'Outpatient_List';

  final String queueCriteria;
  final String title;

  const OutpatientList({
    super.key, 
    required this.queueCriteria,
    required this.title,
  });

  @override
  State<OutpatientList> createState() => _OutpatientListState();
}

class _OutpatientListState extends State<OutpatientList> {

  List<OutpatientQueueDetail> list = [];
  List<OutpatientQueueDetail> _list = [];
  String lastUpdateDate = '';
  bool isLoading = false;
  bool isSearch = false;
  final searchController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void load() async {
    final dlg = CustomDialog.of(context);
    try {
      setState(() {
        isLoading = true;
      });
      var lx = await getOutpatientQueueDetailList(widget.queueCriteria);
      lx.sort((a, b) {
        int? x = int.tryParse(a.queueNumber ?? '0');
        int? y = int.tryParse(b.queueNumber ?? '0');
        if (x == null && y == null) {
          return 0;
        } else if (x == null && y != null) {
          return -1;
        } else if (x != null && y == null) {
          return 1;
        }
        return x!.compareTo(y!);
      });
      String s = _getLastUpdateDate(lx);

      setState(() {
        list = lx;
        _list = lx;
        lastUpdateDate = s;
        isLoading = false;
      });
    }
    
    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.handleError(error, load);
    }

    catch (error) {
      setState(() {
        isLoading = false;
      });
      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  String _getLastUpdateDate(List<OutpatientQueueDetail> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      OutpatientQueueDetail o = lx[0];
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  void filterOutpatient(String s) {
    if (s.isEmpty) {
      setState(() {
        list = _list;
      });
    }

    else {
      String r = s.toLowerCase();
      var q = _list.where((o) {
        return o.firstName.toLowerCase().contains(r) ||
        o.middleName.toLowerCase().contains(r) ||
        o.lastName.toLowerCase().contains(r) ||
        o.title.toLowerCase().contains(r);
      });
      setState(() {
        list = q.toList();
      });
    }
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

  List<Widget> buildActions() {
    List<Widget> lx = [];
    if (!isSearch) {
      lx.add(
        IconButton(
          icon: const Icon(
            Icons.search,
            color: kAppBarIconColor,
          ),
          onPressed: () {
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
      return Text(
        widget.title,
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
        onChanged: filterOutpatient,
      ),
    );
  }

  Widget buildContent() {
    if (list.isEmpty && !isLoading) {
      return SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
          child: Material(
            elevation: 5.0,
            child: Container(
              padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
              decoration: kOutpatientDecoration,
              child: Text(
                'No patient found.',
                style: kOutpatientCardTextStyle.copyWith(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scrollbar(
        child: ListView.builder(
          itemCount: list.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return const SizedBox(
                height: 15.0,
              );
            }

            else {
              OutpatientQueueDetail o = list[i - 1];
              return OutpatientDetailCard(
                outpatientQueueDetail: o,
                queueCriteria: widget.queueCriteria,
              );
            }
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black),
        automaticallyImplyLeading: !isSearch,
        leading: buildLeading(),
        iconTheme: const IconThemeData(
          color: kAppBarIconColor, //change your color here
        ),
        actions: buildActions(),
        title: buildTitle(),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const CupertinoActivityIndicator(radius: 15.0),
        child: RefreshIndicator(
          key: refreshIndicatorKey,
          onRefresh: onRefresh,
          child: buildContent(),
        ),
      ),
      bottomNavigationBar: lastUpdateDate.isEmpty ? BottomBar(
        index: 0,
        onTap: (int i) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainLayout(index: i)), (route) => false);
        },
        ) : Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LastUpdateBar(lastUpdateDate: lastUpdateDate),
          BottomBar(
            index: 0,
            onTap: (int i) {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainLayout(index: i)), (route) => false);
            },
          ),
        ],
      ),
      endDrawer: const AppDrawer(),
    );
  }
}

class OutpatientDetailCard extends StatelessWidget {

  final OutpatientQueueDetail outpatientQueueDetail;
  final String queueCriteria;

  const OutpatientDetailCard({
    super.key, 
    required this.outpatientQueueDetail,
    required this.queueCriteria,
  });

  String get image {
    String s = 'M-icon';

    if (outpatientQueueDetail.sexCode.toLowerCase() == 'm') {
      return s;
    }

    else if (outpatientQueueDetail.sexCode.toLowerCase() == 'f') {
      s = 'W-icon';
    }

    else if (outpatientQueueDetail.sexCode.toLowerCase() == 'u') {
      s = 'U-icon';
    }

    return s;
  }

  Widget get vipImage {
    if (outpatientQueueDetail.vipFlag?.toLowerCase() == 'yes') {
      return Container(
        width: 20.0,
        height: 20.0,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: AssetImage('images/red-corner.png'),
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          decoration: kOutpatientDecoration,
          child: Stack(
            children: [
              vipImage,
              Container(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => PatientDetail(
                          prn: outpatientQueueDetail.prn,
                          patientType: PatientType.outpatient,
                        )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('images/$image.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            '${outpatientQueueDetail.queueNumber}',
                            style: kOutpatientCardTextStyle.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                outpatientQueueDetail.prn,
                                style: kOutpatientCardTextStyle.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                '${outpatientQueueDetail.title} ${outpatientQueueDetail.firstName} ${outpatientQueueDetail.middleName} ${outpatientQueueDetail.lastName}'.trimLeft(),
                                style: kOutpatientCardTextStyle.copyWith(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                              ),
                              Text(
                                '${outpatientQueueDetail.sexDesc}    ${outpatientQueueDetail.age}',
                                style: kOutpatientCardTextStyle.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              Text(
                                outpatientQueueDetail.nationality,
                                style: kOutpatientCardTextStyle.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    queueCriteria == 'Appointment' ? '${outpatientQueueDetail.appointmentTime}' : outpatientQueueDetail.registrationTime,
                                    style: kOutpatientCardTextStyle.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20.0,
                                  ),
                                  Text(
                                    outpatientQueueDetail.patientStatus,
                                    style: kOutpatientCardTextStyle.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              
                              
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}