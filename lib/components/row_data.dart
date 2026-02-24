import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class RowData extends StatelessWidget {
  
  final String label;
  final String text;

  const RowData({
    super.key, 
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF7C7C7C),
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: kTextColor1,
            ),
          ),
        ),
      ],
    );
  }
}