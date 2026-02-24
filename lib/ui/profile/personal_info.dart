import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/profile/personal_info_ctrl.dart';
import 'package:vesalius_dr_flutter/models/user.dart';

class PersonalInfo extends StatefulWidget {

  static const String routeName = '/PersonalInfo';

  final User user;

  const PersonalInfo({
    super.key,
    required this.user,
  });

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final PersonalInfoCtrl ctrl = Get.put(PersonalInfoCtrl());

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
    final user = widget.user;
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 30.0),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'images/doc-1.png',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 35.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Name',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          InfoBox(data: '${user.title} ${user.firstName} ${user.middleName} ${user.lastName ?? ''}'.trim()),
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'MCR Number',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          InfoBox(data: user.mcr),
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Nationality',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          InfoBox(data: user.nationality),
          const SizedBox(height: 25.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Gender',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor1,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          InfoBox(data: user.sex.capitalize ?? user.sex),
          const SizedBox(height: 25.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Personal Info',
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

class InfoBox extends StatelessWidget {

  final String data;

  const InfoBox({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: const Color(0xFFDBDBDB).withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: kBgColor2.withValues(alpha: 0.1),
            blurRadius: 8.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
      child: Text(
        data,
        style: kTextStyle1.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.w600,
          color: kTextColor1,
        ),
      ),
    );
  }
}