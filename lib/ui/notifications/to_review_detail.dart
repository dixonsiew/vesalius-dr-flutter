import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/row_data.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/notifications/to_review_detail_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/review.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

class ToReviewDetail extends StatefulWidget {

  static const String routeName = 'ToReviewDetail';

  final Review data;
  final List<Review> list;

  const ToReviewDetail({
    super.key,
    required this.data,
    required this.list,
  });

  @override
  State<ToReviewDetail> createState() => _ToReviewDetailState();
}

class _ToReviewDetailState extends State<ToReviewDetail> {

  late final TextEditingController txtremark;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final ToReviewDetailCtrl ctrl = Get.put(ToReviewDetailCtrl());

  @override
  void initState() {
    super.initState();
    txtremark = TextEditingController();
    ctrl.setList(widget.list);
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
      final o = await getPatientData(widget.data.prn);
      ctrl.setPatientInfo(PatientInfo(
        prn: o.prn,
        name: o.name,
        sexCode: o.sexCode,
        sexDesc: o.sexDesc,
      ));
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

  void removeFromList(String accessionNo) {
    ctrl.removeFromList(accessionNo);
    if (ctrl.list.isEmpty) {
      Get.back();
      Get.back(result: true);
    }

    else {
      Get.back();
    }
  }

  void submitAck(String a, String p) async {
    try {
      var o = {
        'accessionNo': a,
        'prn': p,
        'reviewDoctor': AuthManager.instance.mcr,
        'reviewDate': formatCurrentDate(),
        'reviewTime': formatCurrentTime(),
      };
      await submitReviewAck(o);
      await showSuccess();
      if (ctrl.list.length < 2) {
        Get.back();
        Get.back(result: true);
      }

      else {
        removeFromList(a);
      }
    }

    on DioException catch (error) {
      if (error.type == DioExceptionType.badResponse) {
        DioException e = error;
        if (e.response?.statusCode == 400) {
          showCustomDialog('Review has been Submitted in VESALIUS.', AlertType.info);
          return;
        }
      }

      handleError(error, () => submitAck(a, p));
    }

    catch (error) {
      showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Future<void> showSuccess() async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 51.0, bottom: 41.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
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
      ),
    ));
  }

  void showAcknowledge(Review review) async {
    String im = 'images/microscope.png';
    String i = review.investigationType.toUpperCase();
    if (i == 'DI') {

    }

    else if (i == 'LABS') {
      im = 'images/x-ray-1.png';
    }

    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.only(top: 8.0, bottom: 35.0),
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
                    im,
                    width: 16.0,
                    height: 16.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 7.0),
                  Expanded(
                    child: Text(
                      review.serviceDesc,
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
            const SizedBox(height: 38.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AppElevatedButton(
                text: 'Acknowledge',
                onPressed: () {
                  //String s = txtremark.text;
                  submitAck(review.accessionNo, review.prn);
                },
              ),
            ),
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
            ReviewDetailItem(
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
      title: 'Report Details',
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

class ReviewDetailItem extends StatefulWidget {
  
  final Review data;
  final void Function(Review) showAcknowledge;

  const ReviewDetailItem({
    super.key,
    required this.data,
    required this.showAcknowledge,
  });

  @override
  State<ReviewDetailItem> createState() => _ReviewDetailItemState();
}

class _ReviewDetailItemState extends State<ReviewDetailItem> {

  bool isDownloading = false;
  double? percent;

  @override
  Widget build(BuildContext context) {
    final review = widget.data;
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 17.0, vertical: 5.0),
            decoration: BoxDecoration(
              color: kTextColor1,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: Text(
              review.investigationType.capitalize ?? review.investigationType,
              style: kTextStyle1.copyWith(
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          RowData(label: 'Description', text: review.serviceDesc,),
          const SizedBox(height: 15.0),
          RowData(label: 'Order Date', text: review.orderDate,),
          const SizedBox(height: 15.0),
          RowData(label: 'Result Date', text: review.resultDate,),
          const SizedBox(height: 15.0),
          RowData(label: 'Report Type', text: review.reportType,),
          const SizedBox(height: 25.0),
          if (review.reportType != 'PDF') ...[
            ElevatedButton(
              onPressed: () {
                widget.showAcknowledge(review);
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
          else if (review.reportType == 'PDF') ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      setState(() {
                        isDownloading = true;
                        percent = 0;
                      });
                      final dir = await getApplicationDocumentsDirectory();
                      String fp = '${dir.path}/${review.accessionNo}-${review.prn}.pdf';
                      File file = await getInvestigationReportPdf(review.accessionNo, fp, (received, total) {
                        if (total != -1) {
                          double pct = (received / total * 100);
                          setState(() {
                            percent = pct;
                          });
                          
                          //print((received / total * 100).toStringAsFixed(0) + "%");
                        }
                      });
                      setState(() {
                        isDownloading = false;
                      });
                      //print(file.path);
                      await OpenFilex.open(file.path);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kPrimaryColor,
                      backgroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                      side: const BorderSide(
                        color: kPrimaryColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/docs.png',
                          width: 16.0,
                          height: 16.0,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 5.91),
                        Text(
                          'View Report',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.showAcknowledge.call(widget.data);
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
                        const SizedBox(width: 4.0),
                        Text(
                          'Acknowledge',
                          style: kTextStyle1.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isDownloading) ...[
              LinearPercentIndicator(
                lineHeight: 14.0,
                percent: (percent ?? 0) / 100.0,
                center: Text(
                  '${percent == null ? 0 : percent!.toStringAsFixed(0)} %',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
                barRadius: const Radius.circular(8.0),
                backgroundColor: Colors.black26,
                progressColor: kPrimaryColor,
              ),
            ],
          ],
        ],
      ),
    );
  }
}