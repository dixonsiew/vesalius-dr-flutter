import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/components/patient_profile_info.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'allergies.dart';
import 'main_layout.dart';
import 'patient_profile.dart';

class PatientDetail extends StatefulWidget {

  static const String routeName = 'Patient_Info';

  final String prn;
  final PatientType patientType;

  const PatientDetail({
    super.key, 
    required this.prn,
    required this.patientType,
  });

  @override
  State<PatientDetail> createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetail> {

  PatientInfo? patientInfo;
  bool isLoading = false;
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
        isLoading = false;
      });
      var o = await getPatientData(widget.prn);
      setState(() {
        patientInfo = PatientInfo(
          prn: o.prn,
          name: o.name,
          sexCode: o.sexCode,
          sexDesc: o.sexDesc,
        );
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

  Widget buildContent() {
    if (patientInfo == null) {
      return Container();
    }

    return SafeArea(
      child: ListView(
        children: [
          PatientProfileInfo(patientInfo: patientInfo),
          PatientDetailCard(
            image: 'profile', 
            text: 'Patient Profile',
            patientType: widget.patientType,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => PatientProfile(
                    prn: widget.prn,
                    patientType: widget.patientType,
                  )));
            },
          ),
          PatientDetailCard(
            image: 'allergies', 
            text: 'Allergies and Alerts',
            patientType: widget.patientType,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Allergies(
                    prn: widget.prn,
                    patientType: widget.patientType,
                  )));
            },
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
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black),
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
        title: Text(
          '${widget.patientType == PatientType.outpatient ? "Outpatient" : "Inpatient"} Details',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const CupertinoActivityIndicator(radius: 15.0),
        child: buildContent(),
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

class PatientDetailCard extends StatelessWidget {

  final String image;
  final String text;
  final PatientType patientType;
  final void Function() onTap;

  const PatientDetailCard({
    super.key, 
    required this.image,
    required this.text,
    required this.patientType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: Material(
        elevation: 5.0,
        color: patientType == PatientType.inpatient ? kInpatientCardColor : kOutpatientCardColor,
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: patientType == PatientType.inpatient ? kInpatientDecoration : kOutpatientDecoration,
          child: InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/$image.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    text,
                    style: kOutpatientCardTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}