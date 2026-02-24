import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/row_data.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/notifications/to_do_detail_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

class ToDoDetail extends StatefulWidget {
  
  static const String routeName = 'ToDoDetail';

  final String prn;

  const ToDoDetail({
    super.key,
    required this.prn,
  });

  @override
  State<ToDoDetail> createState() => _ToDoDetailState();
}

class _ToDoDetailState extends State<ToDoDetail> {

  late final TextEditingController txtremark;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final ToDoDetailCtrl ctrl = Get.put(ToDoDetailCtrl());

  @override
  void initState() {
    super.initState();
    txtremark = TextEditingController();
    load();
  }

  @override
  void dispose() {
    txtremark.dispose();
    super.dispose();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final o = await getPatientData(widget.prn);
      final lx = await getTodoNotificationDetailList(widget.prn);
      lx.sort((a, b) {
        String x = a.itemDesc ?? '';
        String y = b.itemDesc ?? '';
        return x.toLowerCase().compareTo(y.toLowerCase());
      });
      ctrl.init();
      ctrl.setPatientInfo(
        PatientInfo(
          prn: o.prn,
          name: o.name,
          sexCode: o.sexCode,
          sexDesc: o.sexDesc,
        )
      );
      ctrl.setList(lx);
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

  void submitAck(String s, String a, String t) async {
    try {
      var o = {
        'accessionNo': a,
        'notificationType': t == 'Drug Discontinue' ? 'DISCONTINUE-ACK' : 'VOA',
        'remark': s
      };
      await submitDrugVerificationAck(o);
      await showSuccess('Thank you. Acknowledge request has been submitted to VESALIUS.');
      if (ctrl.list.length < 2) {
        Get.back();
        Get.back(result: true);
      }

      else {
        Get.back();
        load();
      }
    }
    
    on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode == 400) {
          showCustomDialog('Drug Order is already Acknowledged in VESALIUS.', AlertType.info);
          return;
        }
      }

      handleError(error, () => submitAck(s, a, t));
    }

    catch (error) {
      showCustomDialog(error.toString(), AlertType.error);
    }
  }

  void submitAckDiscontinue(String s, String a, String t) async {
    try {
      var o = {
        'accessionNo': a,
        'notificationType': 'VOAD',
        'remark': s
      };
      await submitDrugVerificationAck(o);
      await showSuccess('Thank you. Acknowledge and Discontinue request has been submitted to VESALIUS.');
      if (ctrl.list.length < 2) {
        Get.back();
        Get.back(result: true);
      }

      else {
        Get.back();
        load();
      }
    }

    on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        if (error.response?.statusCode == 400) {
          showCustomDialog('Drug Order is already Acknowledged in VESALIUS.', AlertType.info);
          return;
        }
      }

      handleError(error, () => submitAckDiscontinue(s, a, t));
    }

    catch (error) {
      showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> showSuccess(String message) async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 51.0, bottom: 41.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'images/tick-1.png',
            width: 54.0,
            height: 54.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 24.0),
          Text(
            'Acknowledge Successfully',
            style: kTextStyle1.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: kTextColor1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            'Thank you. Acknowledge request has been submitted to VESALIUS.',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25.0),
          AppElevatedButton(
            text: 'Done',
            onPressed: () => Get.back(),
          ),
        ],
      ),
    ));
  }

  void showAcknowledge(TodoNotification todoNotification) async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 8.0, bottom: 38.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: IconButton(
                  onPressed: () => Get.back(),
                  splashRadius: 22.0,
                  iconSize: 28.0,
                  icon: const Icon(
                    Icons.close,
                    color: kTextColor2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/microscope.png',
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 6.41),
                  Expanded(
                    child: Text(
                      todoNotification.itemDesc ?? '',
                      style: kTextStyle1.copyWith(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: kBgColor2.withValues(alpha: 0.1),
                    offset: const Offset(0, 4.0),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: TextField(
                controller: txtremark,
                cursorColor: kTextColor1,
                minLines: 3,
                maxLines: 8,
                style: const TextStyle(
                  fontFamily: kBodyFont,
                  fontSize: 16.0,
                  color: kTextColor1,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Remark for acknowledgement',
                  hintStyle: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor2,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.7)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.7)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppElevatedButton(
                text: 'Acknowledge',
                onPressed: () {
                  String s = txtremark.text;
                  submitAck(s, todoNotification.accessionNo ?? '0', todoNotification.notificationType);
                },
              ),
            ),
            if (todoNotification.notificationType == 'Verbal Order') ...[
              const SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlinedButton(
                  onPressed: () {
                    String s = txtremark.text;
                    submitAckDiscontinue(s, todoNotification.accessionNo ?? '0', todoNotification.notificationType);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    side: const BorderSide(
                      color: kPrimaryColor,
                    ),
                  ),
                  child: Text(
                    'Acknowledge & Discontinue',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }

  Widget buildContent() {
    return Obx(() => ctrl.patientInfo == null ? Container() :
    Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD4D4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Image.asset(
                      'images/avatar-2.png',
                      width: 23.87,
                      height: 28.16,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${ctrl.patientInfo?.name.title} ${ctrl.patientInfo?.name.firstName} ${ctrl.patientInfo?.name.middleName} ${ctrl.patientInfo?.name.lastName}'.trim(),
                        style: kTextStyle1.copyWith(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'PRN: ${ctrl.patientInfo?.prn} Gender: ${ctrl.patientInfo?.sexCode}',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
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
          Container(
            height: 1.0,
            margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            color: const Color(0xFFDADADA),
          ),
          for (var o in ctrl.list) ...[
            DrugVerificationItem(
              data: o,
              showAcknowledge: showAcknowledge,
            ),
          ],
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Drug Verification List',
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

class DrugVerificationItem extends StatelessWidget {
  
  final TodoNotification data;
  final void Function(TodoNotification) showAcknowledge;

  const DrugVerificationItem({
    super.key,
    required this.data,
    required this.showAcknowledge,
  });

  String replaceEmpty(String? s) {
    String x = s ?? '-';
    return x.isEmpty ? '-' : x;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
            offset: const Offset(0, 4.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowData(label: 'Description', text: data.itemDesc ?? '',),
          const SizedBox(height: 15.0),
          RowData(label: 'Quantity', text: '${data.itemQuantity} ${data.uom}',),
          const SizedBox(height: 15.0),
          RowData(label: 'Instruction', text: data.instruction ?? '',),
          const SizedBox(height: 15.0),
          RowData(label: 'Order Date / Time', text: '${data.orderDate} ${data.orderTime}',),
          const SizedBox(height: 15.0),
          RowData(label: 'Ordered By', text: data.orderBy ?? '',),
          const SizedBox(height: 15.0),
          if (data.notificationType == 'Drug Discontinue') ...[
            RowData(label: 'Discontinue Date / Time', text: '${replaceEmpty(data.discontinueDate)} ${data.discontinueTime ?? ""}',),
            const SizedBox(height: 15.0),
            RowData(label: 'Discontinued By', text: replaceEmpty(data.discontinueBy),),
            const SizedBox(height: 15.0),
            RowData(label: 'Discontinue Reason', text: replaceEmpty(data.discontinueReason),),
            const SizedBox(height: 15.0),
          ]
          else if (data.notificationType == 'Verbal Order') ...[
            RowData(label: 'Dispensed Quantity', text: replaceEmpty(data.dispenseQuantity),),
            const SizedBox(height: 15.0),
            RowData(label: 'Last Dispensed Time', text: replaceEmpty(data.lastDispenseTime),),
            const SizedBox(height: 15.0),
            RowData(label: 'Served Quantity', text: replaceEmpty(data.servedQuantity),),
            const SizedBox(height: 15.0),
            RowData(label: 'Last Served Time', text: replaceEmpty(data.lastServedTime),),
            const SizedBox(height: 15.0),
          ],
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              showAcknowledge.call(data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40.0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/writing.png',
                  width: 16.0,
                  height: 16.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 5.58),
                Text(
                  'Acknowledge',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}