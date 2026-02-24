import 'package:flutter/material.dart';
import 'package:vesalius_dr_flutter/constants.dart';

class ReviewSubmit extends StatelessWidget {
  
  final void Function(String, String) submitReview;
  final String accessionNo;
  final String prn;
  final String serviceDesc;

  const ReviewSubmit({
    super.key, 
    required this.submitReview,
    required this.accessionNo,
    required this.prn,
    required this.serviceDesc,
  });

  List<Widget> buildInput(BuildContext context) {
    List<Widget>lx = [
      Text(
        serviceDesc,
        style: const TextStyle(
          color: kTextColor,
          fontFamily: 'texgyreadventor',
          fontWeight: FontWeight.bold,
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFA6A6A6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    color: Color(0xFF203B8C),
                    width: 1.0,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ),
          const SizedBox(
            width:  10.0,
          ),
          Expanded(
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kTextColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: const BorderSide(
                    color: Color(0xFF203B8C),
                    width: 1.0,
                  ),
                ),
              ),
              onPressed: () {
                submitReview(accessionNo, serviceDesc);
              },
              child: const Text('Review'),
            ),
          ),
        ],
      ),
    ];

    return lx;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: kOutpatientCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buildInput(context),
        ),
      ),
    );
  }
}