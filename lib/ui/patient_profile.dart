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
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'main_layout.dart';

class PatientProfile extends StatefulWidget {
  static const String routeName = 'Patient_Profile';

  final String prn;
  final PatientType patientType;

  const PatientProfile({
    super.key,
    required this.prn,
    required this.patientType,
  });

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  PatientInfo? patientInfo;
  PatientData? patientData;
  int branchId = 1;
  bool isLoading = false;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final dlg = CustomDialog.of(context);
    try {
      setState(() {
        isLoading = true;
      });
      var o = await getPatientData(widget.prn);
      setState(() {
        patientInfo = PatientInfo(
          prn: o.prn,
          name: o.name,
          sexCode: o.sexCode,
          sexDesc: o.sexDesc,
        );
        patientData = o;
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

  Widget buildContent() {
    if (patientData == null) {
      return Container();
    }

    return SafeArea(
      child: ListView(
        children: [
          PatientProfileInfo(patientInfo: patientInfo),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
            child: Material(
              elevation: 5.0,
              color: widget.patientType == PatientType.inpatient
                  ? kInpatientCardColor
                  : kOutpatientCardColor,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: widget.patientType == PatientType.inpatient
                    ? kInpatientDecoration
                    : kOutpatientDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                      child: RowData(
                        label: 'Born',
                        text: patientData!.dob,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Gender',
                        text: patientData!.sexDesc,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Nationality',
                        text: patientData!.nationalityDescription,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Document No.',
                        text: patientData!.documentNo,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Contact No.',
                        text: patientData!.contactNumber.home,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Address',
                        text: patientData!.homeAddress.address1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: '',
                        text: patientData!.homeAddress.address2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: '',
                        text: patientData!.homeAddress.address3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Postcode',
                        text: patientData!.homeAddress.postalCode,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'State',
                        text: patientData!.homeAddress.cityState,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: RowData(
                        label: 'Email',
                        text: patientData!.contactNumber.email,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black,
        ),
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(
          color: kAppBarIconColor, //change your color here
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              drawerKey.currentState?.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: kAppBarIconColor,
            ),
          ),
        ],
        title: const Text(
          'Patient Profile',
          style: kAppBarTitleTextStyle,
        ),
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
        index: 0,
        onTap: (int i) {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainLayout(index: i)), (route) => false);
        },
      ),
      endDrawer: const AppDrawer(),
    );
  }
}
