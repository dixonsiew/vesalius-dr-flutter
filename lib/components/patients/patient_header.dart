import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class PatientHeader extends StatelessWidget {

  final String prn;
  final String name;
  final String sexCode;
  final String type;

  const PatientHeader({
    super.key,
    required this.prn,
    required this.name,
    required this.sexCode,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: type == 'out' ? const Color(0xFFFFD4D4) : const Color(0xFFDDE8FC),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  type == 'out' ? 'images/avatar.png' : 'images/avatar-1.png',
                  width: 17.9,
                  height: 21.12,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 19.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    name,
                    style: kTextStyle1.copyWith(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    'PRN: $prn    Gender: $sexCode',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: kTextColor5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 13.0),
        Container(
          width: double.infinity,
          height: 1.0,
          color: const Color(0xFFDADADA),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}