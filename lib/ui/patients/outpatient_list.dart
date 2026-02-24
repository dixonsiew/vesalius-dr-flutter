import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/no_record.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/patients/outpatient_list_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'outpatient_detail.dart';

class OutpatientList extends StatefulWidget {

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

  late final TextEditingController txtsearch;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final OutpatientListCtrl ctrl = Get.put(OutpatientListCtrl());

  @override
  void initState() {
    super.initState();
    txtsearch = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtsearch.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final lx = await getOutpatientQueueDetailList(widget.queueCriteria);
      lx.sort((a, b) {
        int x = int.tryParse(a.queueNumber ?? '0') ?? 0;
        int y = int.tryParse(b.queueNumber ?? '0') ?? 0;
        return x.compareTo(y);
      });
      String s = _getLastUpdateDate(lx);
      ctrl.init();
      ctrl.initMList();
      ctrl.setList(lx);
      ctrl.setMList(lx);
      ctrl.setLastUpdateDate(s);
      ctrl.setIsLoading(false);
    }
    
    on DioException catch (error) {
      ctrl.setIsLoading(false);
      handleError(error, load);
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> onRefresh() async {
    load();
  }

  String _getLastUpdateDate(List<OutpatientQueueDetail> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      OutpatientQueueDetail o = lx.first;
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  void onSearchPatient(String s) {
    if (s.isEmpty) {
      ctrl.resetList();
    }

    else {
      String r = s.toLowerCase();
      var q = ctrl.mlist.where((o) {
        return o.firstName.toLowerCase().contains(r) ||
        o.middleName.toLowerCase().contains(r) ||
        o.lastName.toLowerCase().contains(r) ||
        o.title.toLowerCase().contains(r);
      });
      ctrl.init();
      ctrl.setList(q.toList());
    }
  }

  Widget buildSearch() {
    return Container(
      margin: const EdgeInsets.only(top: 25.0, bottom: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEAEAEA).withValues(alpha: 0.21),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: TextField(
        controller: txtsearch,
        autofocus: false,
        cursorColor: kPrimaryColor,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontFamily: kBodyFont,
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: kTextColor1,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search patient’s name',
          hintStyle: kTextStyle1.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: kTextColor2,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 15.0),
            child: Icon(
              Icons.search,
              color: kPrimaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        onSubmitted: onSearchPatient,
      ),
    );
  }

  Widget buildList() {
    return Obx(() => ctrl.list.isEmpty ? const NoRecord(text: 'You have no patients at the moment.') :
    Scrollbar(
      child: ListView.builder(
        itemCount: ctrl.list.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return buildSearch();
          }

          return OutpatientItem(
            data: ctrl.list[index - 1],
            queueCriteria: widget.queueCriteria,
          );
        },
      ),
    ));
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() : buildList());
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: widget.title,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            onPressed: () {
              
            },
            icon: Image.asset(
              'images/filter.png',
              width: 24.0,
              height: 24.0,
            ),
          ),
        ),
      ],
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class OutpatientItem extends StatelessWidget {
  
  final OutpatientQueueDetail data;
  final String queueCriteria;

  const OutpatientItem({
    super.key,
    required this.data,
    required this.queueCriteria,
  });

  String get timeLabel {
    String s = 'Seen';
    if (queueCriteria == 'Appointment') {
      s = 'Appointment';
    }

    return s;
  }

  String? get time {
    String? s = queueCriteria == 'Appointment' ? data.appointmentTime : data.registrationTime;
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.30),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () => Get.to(() => OutpatientDetail(data: data)),
          borderRadius: BorderRadius.circular(5.0),
          child: Stack(
            children: [
              if (data.vipFlag?.toLowerCase() == 'yes') ...[
                Image.asset('images/red-corner.png'),
              ],
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD4D4),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/avatar.png',
                          width: 17.9,
                          height: 21.12,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${data.title} ${data.firstName} ${data.middleName} ${data.lastName}'.trim(),
                            style: kTextStyle1.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF2E2E2E),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '${data.sexDesc}     ${data.age}',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            data.nationality,
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          if (queueCriteria != 'Registered') ...[
                            Text(
                              '$timeLabel time : $time',
                              style: kTextStyle1.copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: kTextColor5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      data.prn,
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}