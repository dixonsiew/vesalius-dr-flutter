import 'package:flutter/material.dart';

const kServerUrl = 'https://202.55.80.99:43902/mobile_central_dr-1.0.0';

enum PatientType {
  outpatient,
  inpatient,
}

enum AlertType {
  info,
  success,
  error,
}

const kAppToolbarHeight = 45.0;

const kAlertTextColor = Color(0xFF203B8C);
const kAlertBgColor = Color(0xFFE0FCFB);
const kAlertIconInfoColor = Color(0xFF063D8B);
const kAlertIconSuccessColor = Color(0xFF04C789);
const kAlertIconErrorColor = Color(0xFFE00202);
const kAlertBtnInfoColor = Color(0xFF0070C0);
const kAlertBtnSuccessColor = Color(0xFF00B04F);
const kAlertBtnErrorColor = Color(0xFFFF0000);

const kLoginInputColor = Color(0xFFD4AF37);
const kTextColor = Color(0xFf203B8C);

const kAppBarTitleTextStyle = TextStyle(
  color: Color(0xFF203B8C),
  fontFamily: 'texgyreadventor',
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const kAppBarIconColor = Color(0xFF203B8C);

const kTabTitleTextStyle = TextStyle(
  color: Color(0xFF203B8C),
  fontFamily: 'texgyreadventor',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

const kOutpatientCardColor = Color(0xFF8FD3FF);
const kOutpatientCardShadowColor = Color(0xFF1F3B8C);
const kOutpatientDecoration = BoxDecoration(
  color: kOutpatientCardColor,
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: kOutpatientCardShadowColor,
      offset: Offset(0, 2),
      blurRadius: 5.0,
      spreadRadius: 0,
    ),
  ],
);
const kOutpatientCardTextColor = Colors.black;
const kOutpatientCardTextStyle = TextStyle(
  color: kOutpatientCardTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 20.0,
);

const kInpatientCardColor = Color(0xFFE0FCFB);
const kInpatientDecoration = BoxDecoration(
  color: kInpatientCardColor,
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
  boxShadow: <BoxShadow>[
    BoxShadow(
      color: kOutpatientCardShadowColor,
      offset: Offset(0, 2),
      blurRadius: 5.0,
      spreadRadius: 0,
    ),
  ],
);
const kInpatientCardTextStyle = TextStyle(
  color: kOutpatientCardTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 14.0,
);

const kAllergiesCardHeaderColor = Color(0xFF203B8C);
const kAllergiesCardTextStyle = TextStyle(
  color: kOutpatientCardTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 16.0,
);

const kDrawerTextColor = Color(0xFF203B8C);
const kDrawerHeaderTextStyle = TextStyle(
  color: kDrawerTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 24.0,
);
const kDrawerTextStyle = TextStyle(
  color: kDrawerTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 18.0,
);

const kLabelTextStyle = TextStyle(
  color: kTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);
const kNoteTextStyle = TextStyle(
  color: kTextColor,
  fontFamily: 'texgyreadventor',
  fontSize: 14.0,
);