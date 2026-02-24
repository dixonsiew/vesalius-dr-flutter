import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final kServerUrl = dotenv.env['SERVERURL'] ?? '';
// const SERVER = 'http://202.73.42.183:43902/mobile_central_dr-1.0.0';
// const SERVER0 = 'http://192.168.5.173:8060/mobile_central_dr-1.0.0';

final kOneSignalAppID = dotenv.env['ONESIGNALAPPID'] ?? ''; // testing

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

const kPrimaryColor = Color(0xFFA41D2B);

const kBgColor1 = Color(0xFFF8F8F8);
const kBgColor2 = Color(0xFFE5E5E5);

const kTextColor1 = Color(0xFF002E50);
const kTextColor2 = Color(0xFFB1B1B1);
const kTextColor3 = Color(0xFFFD5E53);
const kTextColor4 = Color(0xFF757F8C);
const kTextColor5 = Color(0xFF4E4E4E);

const kTitleFont = 'Lato';
const kBodyFont = 'Lato';
const kMiscFont = 'Mulish';

const kAlertIconInfoColor = Color(0xFF063D8B);
const kAlertIconSuccessColor = Color(0xFF04C789);
const kAlertIconErrorColor = Color(0xFFE00202);

const kTextStyle1 = TextStyle(
  letterSpacing: 0.05,
);

const kBlur = 2.0;
const kHiveBoxName = 'vesaliudrBox';

const kError = 'An unexpected error occurred while processing your request. Please verify your internet connection or contact support for assistance.';