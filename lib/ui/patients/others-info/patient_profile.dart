import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/patients/patient_header.dart';
import 'package:vesalius_dr_flutter/components/row_data.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/patients/others-info/patient_profile_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

class PatientProfile extends StatefulWidget {

  static const String routeName = '/PatientProfile';

  final PatientHeader patientHeader;

  const PatientProfile({
    super.key,
    required this.patientHeader,
  });

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final PatientProfileCtrl ctrl = Get.put(PatientProfileCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      var o = await getPatientData(widget.patientHeader.prn);
      ctrl.setPatientData(o);
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

  PatientHeader get patientHeader {
    return PatientHeader(
      prn: widget.patientHeader.prn,
      name: '${ctrl.patientData!.name.title} ${ctrl.patientData!.name.firstName} ${ctrl.patientData!.name.middleName} ${ctrl.patientData!.name.lastName}'.trim(),
      sexCode: ctrl.patientData!.sexCode,
      type: widget.patientHeader.type,
    );
  }

  Widget buildContent() {
    return Obx(() => ctrl.patientData == null ? Container() :
    Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: patientHeader,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFECEEFF),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RowData(label: 'Born', text: ctrl.patientData!.dob,),
                const SizedBox(height: 15.0),
                RowData(label: 'Gender', text: ctrl.patientData!.sexDesc,),
                const SizedBox(height: 15.0),
                RowData(label: 'Nationality', text: ctrl.patientData!.nationalityDescription,),
                const SizedBox(height: 15.0),
                RowData(label: 'Document No.', text: ctrl.patientData!.documentNo,),
                const SizedBox(height: 15.0),
                RowData(label: 'Contact Number', text: ctrl.patientData!.contactNumber.home,),
                const SizedBox(height: 15.0),
                RowData(label: 'Address', text: ctrl.patientData!.homeAddress.address1,),
                RowData(label: '', text: ctrl.patientData!.homeAddress.address2,),
                RowData(label: '', text: ctrl.patientData!.homeAddress.address3,),
                const SizedBox(height: 15.0),
                RowData(label: 'Postcode', text: ctrl.patientData!.homeAddress.postalCode,),
                const SizedBox(height: 15.0),
                RowData(label: 'State', text: ctrl.patientData!.homeAddress.cityState,),
                const SizedBox(height: 15.0),
                RowData(label: 'Email', text: ctrl.patientData!.contactNumber.email,),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Patient Profile',
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