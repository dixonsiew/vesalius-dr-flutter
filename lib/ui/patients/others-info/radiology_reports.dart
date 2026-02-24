import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/patients/patient_header.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class RadiologyReports extends StatefulWidget {
  
  static const String routeName = '/RadiologyReports';

  final PatientHeader patientHeader;

  const RadiologyReports({
    super.key,
    required this.patientHeader,
  });

  @override
  State<RadiologyReports> createState() => _RadiologyReportsState();
}

class _RadiologyReportsState extends State<RadiologyReports> {

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
            padding: const EdgeInsets.all(20.0),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '18.06.2021',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w800,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5590FC).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          'images/docs-1.png',
                          width: 24.0,
                          height: 24.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Text(
                      'Xray Report.pdf',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
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
      title: 'Radiology Report',
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