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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: kAllergiesCardTextStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text.trim(),
            style: kAllergiesCardTextStyle,
          ),
        ),
      ],
    );
  }
}