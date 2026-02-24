import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/components/patients/patient_header.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/patients/others-info/allergies_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/patient_allergy.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

class Allergies extends StatefulWidget {

  static const String routeName = '/Allergies';

  final PatientHeader patientHeader;

  const Allergies({
    super.key,
    required this.patientHeader,
  });

  @override
  State<Allergies> createState() => _AllergiesState();
}

class _AllergiesState extends State<Allergies> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final AllergiesCtrl ctrl = Get.put(AllergiesCtrl());

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      ctrl.setIsLoading(true);
      final lx = await getPatientAllergyList(widget.patientHeader.prn);
      ctrl.init();
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

  Widget buildContent() {
    return Obx(() => ctrl.isLoading ? Container() :
    Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: widget.patientHeader,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Problems(list: ctrl.list),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: DrugAllergy(list: ctrl.list),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GeneralAlert(list: ctrl.list),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: GeneralAllergy(list: ctrl.list),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Allergies & Alerts',
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

class Problems extends StatelessWidget {

  final List<PatientAllergy> list;

  const Problems({
    super.key, 
    required this.list,
  });

  List<Widget> buildList() {
    final la = list.where((o) => o.alertType == 'CLINICAL ALERT').toList();
    int n = la.length;
    String s = n == 0 ? 'Problems' : 'Problems ($n)';
    List<Widget> lx = [
      Text(
        s,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kPrimaryColor,
        ),
      ),
    ];
    lx.add(const SizedBox(height: 17.0));

    if (n == 0) {
      lx.add(
        Container(
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
          child: Text(
            'No data available.',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < la.length; i++) {
      final o = la[i];
      lx.addAll([
        Container(
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
          child: Text(
            '${o.description} from ${o.creationDate}',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ]);
    }

    lx.add(const SizedBox(height: 10.0));
    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildList(),
    );
  }
}

class DrugAllergy extends StatelessWidget {

  final List<PatientAllergy> list;

  const DrugAllergy({
    super.key, 
    required this.list,
  });

  List<Widget> buildList() {
    final la = list.where((o) => o.alertType == 'CLINICAL ALLERGY').toList();
    int n = la.length;
    String s = n == 0 ? 'Drug Allergies' : 'Drug Allergies ($n)';
    List<Widget> lx = [
      Text(
        s,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kPrimaryColor,
        ),
      ),
    ];
    lx.add(const SizedBox(height: 15.0));

    if (n == 0) {
      lx.add(
        Container(
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
          child: Text(
            'No data available.',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < la.length; i++) {
      final o = la[i];
      String x = '';
      if (o.system != null) {
        x = 'Cause : ${o.system}';
      }

      if (o.route != null) {
        x = 'Route : ${o.route}';
      }

      if (o.probability != null) {
        x = 'Probability : ${o.probability}';
      }

      if (o.reaction != null) {
        x = 'Reaction : ${o.reaction}';
      }

      lx.addAll([
        Container(
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
          child: x.isEmpty ? 
            Text(
              '${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ) : 
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: kTextColor1,
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  x,
                  style: kTextStyle1.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF7C7C7C),
                  ),
                ),
              ],
            ),
        ),
        const SizedBox(height: 20.0),
      ]);
    }

    lx.add(const SizedBox(height: 10.0));
    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildList(),
    );
  }
}

class GeneralAlert extends StatelessWidget {
  
  final List<PatientAllergy> list;

  const GeneralAlert({
    super.key, 
    required this.list,
  });

  List<Widget> buildList() {
    final la = list.where((o) => o.alertType == 'GENERAL ALERT').toList();
    int n = la.length;
    String s = n == 0 ? 'General Alert' : 'General Alert ($n)';
    List<Widget> lx = [
      Text(
        s,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kPrimaryColor,
        ),
      ),
    ];
    lx.add(
      const SizedBox(height: 15.0),
    );

    if (n == 0) {
      lx.add(
        Container(
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
          child: Text(
            'No data available.',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < la.length; i++) {
      final o = la[i];
      lx.addAll([
        Container(
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
          child: Text(
            '${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ]);
    }

    lx.add(const SizedBox(height: 10.0));
    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buildList(),
    );
  }
}

class GeneralAllergy extends StatelessWidget {
  
  final List<PatientAllergy> list;

  const GeneralAllergy({
    super.key, 
    required this.list,
  });

  List<Widget> buildList() {
    var la = list.where((o) => o.alertType == 'GENERAL ALLERGY').toList();
    int n = la.length;
    String s = n == 0 ? 'General Allergy' : 'General Allergy ($n)';
    List<Widget> lx = [
      Text(
        s,
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: kPrimaryColor,
        ),
      ),
    ];
    lx.add(const SizedBox(height: 15.0));

    if (n == 0) {
      lx.add(
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                offset: const Offset(0, 4.0),
                blurRadius: 8.0,// changes position of shadow
              ),
            ],
          ),
          child: Text(
            'No data available.',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < la.length; i++) {
      final o = la[i];
      lx.addAll([
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDBDBDB).withValues(alpha: 0.3),
                offset: const Offset(0, 4.0),
                blurRadius: 8.0,// changes position of shadow
              ),
            ],
          ),
          child: Text(
            '${o.description} ( ${o.allergyType} ) from ${o.creationDate}',
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ]);
    }

    lx.add(const SizedBox(height: 10.0));
    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: buildList(),
    );
  }
}