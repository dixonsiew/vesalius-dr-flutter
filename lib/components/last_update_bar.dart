import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class LastUpdateBar extends StatelessWidget {
  
  final String lastUpdateDate;

  const LastUpdateBar(this.lastUpdateDate, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Text(
        'Last Update: $lastUpdateDate',
        style: kTextStyle1.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF8D8D8D),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}