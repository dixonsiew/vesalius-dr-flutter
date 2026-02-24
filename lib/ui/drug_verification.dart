import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/components/patient_profile_info.dart';
import 'package:vesalius_dr_flutter/components/row_data.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'drug_ack.dart';
import 'main_layout.dart';

class DrugVerification extends StatefulWidget {

  static const String routeName = 'DrugVerification_list';

  final String prn;

  const DrugVerification({
    super.key, 
    required this.prn,
  });

  @override
  State<DrugVerification> createState() => _DrugVerificationState();
}

class _DrugVerificationState extends State<DrugVerification> {

  PatientInfo? patientInfo;
  List<TodoNotification> list = [];
  List<TodoNotification> _list = [];
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
      var o = await getPatientData(widget.prn);
      var lx = await getTodoNotificationDetailList(widget.prn);
      lx.sort((a, b) {
        String x = a.itemDesc ?? '';
        String y = b.itemDesc ?? '';
        return x.toLowerCase().compareTo(y.toLowerCase());
      });

      setState(() {
        patientInfo = PatientInfo(
          prn: o.prn,
          name: o.name,
          sexCode: o.sexCode,
          sexDesc: o.sexDesc,
        );
        list = lx;
        _list = lx;
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

  void filterList(String s) {
    if (s.isEmpty) {
      setState(() {
        list = _list;
      });
    }

    else {
      String r = s.toLowerCase();
      var q = _list.where((o) {
        String x = o.itemDesc ?? '';
        String y = o.instruction ?? '';
        return x.toLowerCase().contains(r) || y.toLowerCase().contains(r);
      });
      setState(() {
        list = q.toList();
      });
    }
  }

  void submitAck(String s, String a, String t) async {
    final dlg = CustomDialog.of(context);
    try {
      var o = {
        'accessionNo': a,
        'notificationType': t == 'Drug Discontinue' ? 'DISCONTINUE-ACK' : 'VOA',
        'remark': s
      };
      final nav = Navigator.of(context);
      await submitDrugVerificationAck(o);
      await dlg.showCustomDialog('Acknowledge request has been submitted to VESALIUS.', AlertType.info);
      if (list.length < 2) {
        nav.pop();
        nav.pop(true);
      }

      else {
        nav.pop();
        load();
      }
    }
    
    catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.badResponse) {
          DioException e = error;
          if (e.response?.statusCode == 400) {
            await dlg.showCustomDialog('Drug Order is already Acknowledged in VESALIUS.', AlertType.info);
            return;
          }
        }

        dlg.handleError(error, () => submitAck(s, a, t));
      }

      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  void submitAckDiscontinue(String s, String a, String t) async {
    final dlg = CustomDialog.of(context);
    try {
      var o = {
        'accessionNo': a,
        'notificationType': 'VOAD',
        'remark': s
      };
      final nav = Navigator.of(context);
      await submitDrugVerificationAck(o);
      await dlg.showCustomDialog('Acknowledge and Discontinue request has been submitted to VESALIUS', AlertType.info);
      if (list.length < 2) {
        nav.pop();
        nav.pop(true);
      }

      else {
        nav.pop();
        load();
      }
    }

    catch (error) {
      if (error is DioException) {
        if (error.type == DioExceptionType.badResponse) {
          DioException e = error;
          if (e.response?.statusCode == 400) {
            await dlg.showCustomDialog('Drug Order is already Acknowledged in VESALIUS.', AlertType.info);
            return;
          }
        }

        dlg.handleError(error, () => submitAckDiscontinue(s, a, t));
      }

      dlg.showCustomDialog(error.toString(), AlertType.error);
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
      return const Text(
        'Drug Verification List',
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
        onChanged: filterList,
      ),
    );
  }

  Widget buildContent() {
    if (patientInfo == null) {
      return Container();
    }

    if (list.isEmpty && !isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
        child: Material(
          elevation: 5.0,
          child: Container(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 15.0),
            decoration: kOutpatientDecoration,
            child: Text(
              'No record found.',
              style: kOutpatientCardTextStyle.copyWith(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      );
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: list.length + 2,
        itemBuilder: (context, i) {
          if (i == 0) {
            return PatientProfileInfo(patientInfo: patientInfo);
          }

          else if (i == 1) {
            return const SizedBox(
              height: 10.0,
            );
          }

          else {
            TodoNotification o = list[i - 2];
            return DrugVerificationCard(
              todoNotification: o,
              submitAck: submitAck,
              submitAckDiscontinue: submitAckDiscontinue,
            );
          }
        }
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
      bottomNavigationBar: BottomBar(
        index: 1,
        onTap: (int i) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainLayout(index: i)), (route) => false);
        },
      ),
      endDrawer: const AppDrawer(),
    );
  }
}

class DrugVerificationCard extends StatelessWidget {

  final TodoNotification todoNotification;
  final void Function(String, String, String) submitAck;
  final void Function(String, String, String) submitAckDiscontinue;

  const DrugVerificationCard({
    super.key, 
    required this.todoNotification,
    required this.submitAck,
    required this.submitAckDiscontinue,
  });

  String replaceEmpty(String? s) {
    String x = s ?? '-';
    return x.isEmpty ? '-' : x;
  }

  List<Widget> buildRows() {
    List<Widget> lx = [
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(label: 'Description', text: todoNotification.itemDesc ?? '',),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(label: 'Quantity', text: '${todoNotification.itemQuantity} ${todoNotification.uom}',),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(label: 'Instruction', text: todoNotification.instruction ?? '',),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(label: 'Order Date / Time', text: '${todoNotification.orderDate} ${todoNotification.orderTime}',),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: RowData(label: 'Ordered By', text: todoNotification.orderBy ?? '',),
      ),
    ];

    if (todoNotification.notificationType == 'Drug Discontinue') {
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Discontinue Date / Time', text: '${replaceEmpty(todoNotification.discontinueDate)} ${todoNotification.discontinueTime ?? ""}',),
        )
      );
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Discontinued By', text: replaceEmpty(todoNotification.discontinueBy),),
        )
      );
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Discontinue Reason', text: replaceEmpty(todoNotification.discontinueReason),),
        )
      );
    }

    else if (todoNotification.notificationType == 'Verbal Order') {
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Dispensed Quantity', text: replaceEmpty(todoNotification.dispenseQuantity),),
        )
      );
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Last Dispensed Time', text: replaceEmpty(todoNotification.lastDispenseTime),),
        )
      );
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Served Quantity', text: replaceEmpty(todoNotification.servedQuantity),),
        )
      );
      lx.add(
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: RowData(label: 'Last Served Time', text: replaceEmpty(todoNotification.lastServedTime),),
        )
      );
    }

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: kInpatientDecoration,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: DrugAck(
                      submitAck: submitAck,
                      submitAckDiscontinue: submitAckDiscontinue,
                      accessionNo: todoNotification.accessionNo ?? '',
                      notificationType: todoNotification.notificationType,
                      itemDesc: todoNotification.itemDesc ?? '',
                    ),
                  ),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildRows(),
            ),
          ),
        ),
      ),
    );
  }
}