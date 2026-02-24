import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/patients/patient_header.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class Diagnosis extends StatefulWidget {
  
  static const String routeName = '/Diagnosis';

  final PatientHeader patientHeader;

  const Diagnosis({
    super.key,
    required this.patientHeader,
  });

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {

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

  Widget buildContent() {
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: widget.patientHeader,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '18.06.2021',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  'Diagnosis',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Content',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: kTextColor1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Diagnosis',
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