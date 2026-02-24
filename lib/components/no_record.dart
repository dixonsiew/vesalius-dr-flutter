import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class NoRecord extends StatelessWidget {
  
  final String text;

  const NoRecord({
    super.key, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/medical-record.png',
            width: 96.0,
            height: 96.0,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 15.0),
          Text(
            'No Record Found',
            style: kTextStyle1.copyWith(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: kTextColor5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              text,
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}