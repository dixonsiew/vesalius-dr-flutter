import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/components/bottom_bar.dart';
import 'package:vesalius_dr_flutter/components/patient_profile_info.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/patient_allergy.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'main_layout.dart';

class Allergies extends StatefulWidget {

  static const String routeName = 'Allergies';

  final String prn;
  final PatientType patientType;

  const Allergies({
    super.key, 
    required this.prn,
    required this.patientType,
  });

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {

  PatientInfo? patientInfo;
  List<PatientAllergy> list = [];
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
      var lx = await getPatientAllergyList(widget.prn);
      setState(() {
        patientInfo = PatientInfo(
          prn: o.prn,
          name: o.name,
          sexCode: o.sexCode,
          sexDesc: o.sexDesc,
        );
        list = lx;
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
    if (patientInfo == null) {
      return Container();
    }
    
    return SafeArea(
      child: Scrollbar(
        child: ListView(
          children: [
            PatientProfileInfo(patientInfo: patientInfo),
            ProblemsCard(
              list: list,
              patientType: widget.patientType,
            ),
            DrugAllergieCard(
              list: list,
              patientType: widget.patientType,
            ),
            GeneralAlertCard(
              list: list,
              patientType: widget.patientType,
            ),
          ],
        ),
      ),
    );

    // return ModalProgressHUD(
    //   inAsyncCall: isLoading,
    //   child: RefreshIndicator(
    //     key: refreshIndicatorKey,
    //     child: SafeArea(
    //       child: ListView(
    //         children: [
    //           SizedBox(
    //             height: 5.0,
    //           ),
              
    //         ],
    //       ),
    //     ),
    //     onRefresh: onRefresh,
    //   ),
    // );
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
        title: const Text(
          'Allergies and Alerts',
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

class CardHeader extends StatelessWidget {
  
  final String title;

  const CardHeader({
    super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kAllergiesCardHeaderColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'texgyreadventor',
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class ProblemsCard extends StatelessWidget {
  
  final List<PatientAllergy> list;
  final PatientType patientType;

  const ProblemsCard({
    super.key, 
    required this.list,
    required this.patientType,
  });

  List<Widget> buildList() {
    List<Widget> lx = <Widget>[
      const CardHeader(title: 'Problems',)
    ];

    for (var o in list) {
      if (o.alertType == 'CLINICAL ALERT') {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              '${String.fromCharCode(0x2022)} ${o.description} from ${o.creationDate}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }
    }

    if (lx.length < 2) {
      lx.add(
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            'No Problem is captured',
            style: kAllergiesCardTextStyle,
          ),
        )
      );
    }

    return lx;
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildList(),
          ),
        ),
      ),
    );
  }
}

class DrugAllergieCard extends StatelessWidget {

  final List<PatientAllergy> list;
  final PatientType patientType;

  const DrugAllergieCard({
    super.key, 
    required this.list,
    required this.patientType,
  });

  List<Widget> buildList() {
    List<Widget> lx = <Widget>[
      const CardHeader(title: 'Drug Allergies',)
    ];

    for (var o in list) {
      if (o.alertType == 'CLINICAL ALLERGY') {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              '${String.fromCharCode(0x2022)} ${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }

      if (o.system != null) {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              'Cause: ${o.system}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }

      if (o.route != null) {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              'Route: ${o.route}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }

      if (o.probability != null) {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              'Probability: ${o.probability}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }

      if (o.reaction != null) {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              'Reaction: ${o.reaction}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }
    }

    if (lx.length < 2) {
      lx.add(
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            'No Drug Allergies is captured',
            style: kAllergiesCardTextStyle,
          ),
        )
      );
    }

    return lx;
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildList(),
          ),
        ),
      ),
    );
  }
}

class GeneralAlertCard extends StatelessWidget {

  final List<PatientAllergy> list;
  final PatientType patientType;

  const GeneralAlertCard({
    super.key, 
    required this.list,
    required this.patientType,
  });

  List<Widget> buildList() {
    List<Widget> lx = <Widget>[
      const CardHeader(title: 'General Alert / General Allergies',)
    ];

    lx.add(
      Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Text(
          'General Alert:',
          style: kAllergiesCardTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );

    for (var o in list) {
      if (o.alertType == 'GENERAL ALERT') {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              '${String.fromCharCode(0x2022)} ${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }
    }

    if (lx.length < 3) {
      lx.add(
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            'No General Alert is captured',
            style: kAllergiesCardTextStyle,
          ),
        )
      );
    }

    lx.add(
      Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: Text(
          'General Allergies:',
          style: kAllergiesCardTextStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    );

    for (var o in list) {
      if (o.alertType == 'GENERAL ALLERGY') {
        lx.add(
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10.0),
            child: Text(
              '${String.fromCharCode(0x2022)} ${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
              style: kAllergiesCardTextStyle,
            ),
          )
        );
      }
    }

    if (lx.length < 5) {
      lx.add(
        const Padding(
          padding: EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text(
            'No General Allergies is captured',
            style: kAllergiesCardTextStyle,
          ),
        )
      );
    }

    return lx;
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildList(),
          ),
        ),
      ),
    );
  }
}