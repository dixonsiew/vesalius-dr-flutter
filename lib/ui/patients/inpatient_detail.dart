import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/models/inpatient.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/allergies.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/case_notes.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/diagnosis.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/lab_results.dart';
import 'package:vesalius_dr_flutter/components/patients/patient_header.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/patient_profile.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/prescription.dart';
import 'package:vesalius_dr_flutter/ui/patients/others-info/radiology_reports.dart';

class InpatientDetail extends StatefulWidget {
  
  static const String routeName = '/InpatientDetail';

  final InpatientQueueDetail data;

  const InpatientDetail({
    super.key,
    required this.data,
  });

  @override
  State<InpatientDetail> createState() => _InpatientDetailState();
}

class _InpatientDetailState extends State<InpatientDetail> {

  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {

  }

  Future<void> onRefresh() async {
    load();
  }

  PatientHeader get patientHeader => PatientHeader(
    prn: widget.data.prn,
    name: '${widget.data.title} ${widget.data.firstName} ${widget.data.middleName} ${widget.data.lastName}'.trim(),
    sexCode: widget.data.sexCode,
    type: 'in',
  );

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: patientHeader,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Past Medical History',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 25.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDBDBDB).withValues(alpha: 0.30),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '29.04.2021',
                  style: kTextStyle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Does not have any hospitalisation history.',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Reported problem included Blood Problems (Bleeding disorder), Diabetes.',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\u2022 ',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Sought treatment previouusly for ( Ears, Nose, sinuses, or tonsils)',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Active Medications',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 25.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDBDBDB).withValues(alpha: 0.30),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'PANTORprazole 20 mg Tablet (ZOVANTA)',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 62.0),
                    Text(
                      '1b 1d',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'COUMADIN 5 MG Oral Tablet',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 62.0),
                    Text(
                      '1 tablet',
                      style: kTextStyle1.copyWith(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Others Information',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kPrimaryColor,
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SizedBox(
              height: 170.0,
              child: GridView.count(
                crossAxisCount: 4,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0,
                children: [
                  LinkItem(
                    image: 'profile.png',
                    name: 'Patient\nProfile',
                    onTap: () => Get.to(() => PatientProfile(patientHeader: patientHeader)),
                  ),
                  LinkItem(
                    image: 'alert.png',
                    name: 'Allergies /\nAlerts',
                    onTap: () => Get.to(() => Allergies(patientHeader: patientHeader)),
                  ),
                  LinkItem(
                    image: 'case-notes.png',
                    name: 'Case\nNotes',
                    onTap: () => Get.to(() => CaseNotes(patientHeader: patientHeader)),
                  ),
                  LinkItem(
                    image: 'diagnosis.png',
                    name: 'Diagnosis',
                    onTap: () => Get.to(() => Diagnosis(patientHeader: patientHeader)),
                  ),
                  LinkItem(
                    image: 'prescription.png',
                    name: 'Prescription',
                    onTap: () => Get.to(() => Prescription(patientHeader: patientHeader)),
                  ),
                  LinkItem(
                    image: 'lab-result.png',
                    name: 'Laboratory\nResult/s',
                    onTap: () => Get.to(() => LabResults(patientHeader: patientHeader)),
                  ),
                  LinkItem(
                    image: 'radiology-report.png',
                    name: 'Radiology\nReport/s',
                    onTap: () => Get.to(() => RadiologyReports(patientHeader: patientHeader)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Inpatient',
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
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
    );
  }
}

class LinkItem extends StatelessWidget {

  final String image;
  final String name;
  final void Function() onTap;

  const LinkItem({
    super.key,
    required this.image,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFECEEFF).withValues(alpha: 0.8),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/$image',
                width: 15.14,
                height: 15.14,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 7.0),
              Flexible(
                child: Text(
                  name,
                  style: kTextStyle1.copyWith(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}