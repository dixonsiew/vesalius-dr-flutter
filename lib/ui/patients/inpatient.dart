import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/last_update_bar.dart';
import 'package:vesalius_dr_flutter/components/no_record.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/main_layout_ctrl.dart';
import 'package:vesalius_dr_flutter/controllers/patients/inpatient_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/inpatient.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'inpatient_detail.dart';

class Inpatient extends StatefulWidget {

  const Inpatient({super.key});

  @override
  State<Inpatient> createState() => _InpatientState();
}

class _InpatientState extends State<Inpatient> with AutomaticKeepAliveClientMixin<Inpatient> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final InpatientCtrl ctrl = Get.put(InpatientCtrl());
  final MainLayoutCtrl mainLayoutCtrl = Get.put(MainLayoutCtrl());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final lx = await getInpatientDetailList();
      mainLayoutCtrl.setInpatientCount(lx.length);
      lx.sort((a, b) {
        int i = a.ward.toLowerCase().compareTo(b.ward.toLowerCase());
        if (i == 0) {
          String n1 = getPatientName(a);
          String n2 = getPatientName(b);
          return n1.compareTo(n2);
        }

        else {
          return i;
        }
      });
      //Provider.of<PatientSearchModel>(context, listen: false).setInpatientList(lx);
      String s = _getLastUpdateDate(lx);
      ctrl.init();
      ctrl.setList(lx);
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

  String getPatientName(InpatientQueueDetail o) {
    return '${o.title} ${o.firstName} ${o.middleName} ${o.lastName}'.trim().toLowerCase();
  }

  String _getLastUpdateDate(List<InpatientQueueDetail> lx) {
    String s = '';
    if (lx.isNotEmpty) {
      InpatientQueueDetail o = lx[0];
      s = getLastUpdateDate(o.lastUpdateDate);
    }

    return s;
  }

  Widget buildList() {
    return Obx(() => ctrl.list.isEmpty ? const NoRecord(text: 'You have no patients at the moment.') :
    Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: ctrl.lastUpdateDate.isNotEmpty ? 44.0 : 0),
          child: Scrollbar(
            child: ListView.builder(
              itemCount: ctrl.list.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 25.0);
                }
      
                return InpatientItem(data: ctrl.list[index - 1]);
              },
            ),
          ),
        ),
        if (ctrl.lastUpdateDate.isNotEmpty) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: LastUpdateBar(ctrl.lastUpdateDate),
          ),
        ],
      ],
    ));
  }

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() : buildList());
  }
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() =>
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
    );
  }
}

class InpatientItem extends StatelessWidget {

  final InpatientQueueDetail data;

  const InpatientItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 15.0),
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
          onTap: () => Get.to(() => InpatientDetail(data: data)),
          borderRadius: BorderRadius.circular(5.0),
          child: Stack(
            children: [
              if (data.vipFlag.toLowerCase() == 'yes') ...[
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
                        color: Color(0xFFDDE8FC),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/avatar-1.png',
                          width: 17.9,
                          height: 21.12,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 17.0),
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
                          Text(
                            '${data.ward} / ${data.bed}',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            '${data.admissionDate} ${data.admissionTime}',
                            style: kTextStyle1.copyWith(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: kTextColor5,
                            ),
                          ),
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