import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';

class PatientProfileInfo extends StatelessWidget {

  final PatientInfo? patientInfo;

  const PatientProfileInfo({
    super.key, 
    required this.patientInfo,
  });

  String get name {
    String s = '';
    List<String> ls = [];

    if (patientInfo?.name != null) {
      Name sname = patientInfo!.name;
      if (sname.title.isNotEmpty) {
        ls.add(sname.title);
      }

      if (sname.firstName.isNotEmpty) {
        ls.add(sname.firstName);
      }

      if (sname.middleName.isNotEmpty) {
        ls.add(sname.middleName);
      }

      if (sname.lastName.isNotEmpty) {
        ls.add(sname.lastName);
      }
    }

    s = ls.join(' ');
    return s;
  }

  @override
  Widget build(BuildContext context) {
    if (patientInfo == null) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                child: FaIcon(
                  patientInfo?.sexCode == 'm' || patientInfo?.sexCode == 'M' ? FontAwesomeIcons.mars : FontAwesomeIcons.venus,
                  size: 30.0,
                  color: const Color(0xFF203B8C),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientInfo?.prn ?? '',
                      style: const TextStyle(
                        color: Color(0xFF203B8C),
                        fontFamily: 'texgyreadventor',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF203B8C),
                        fontFamily: 'texgyreadventor',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1.0,
        ),
      ],
    );
  }
}