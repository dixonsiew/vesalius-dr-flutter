import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'constants.dart';
import 'models/auth_manager.dart';
import 'ui/sign_in.dart';

extension StringExtension on String {
  
  String titleCase() {
    var a = split(' ');
    List<String> ls = [];
    for (int i = 0; i < a.length; i++) {
      ls.add(a[i].capitalize!);
    }

    return ls.join(' ');
  }

  String replaceWhitespacesUsingRegex(String replace) {
    // This pattern means "at least one space, or more"
    // \\s : space
    // +   : one or more 
    final pattern = RegExp('\\s+');
    return replaceAll(pattern, replace);
  }
}

void handleError(DioException error, void Function()? onYes) async {
  String msg = error.message ?? kError;
  if (error.type == DioExceptionType.connectionTimeout) {
    msg = 'Connection Timeout';
  }

  else if (error.type == DioExceptionType.receiveTimeout) {
    msg = 'Receive Timeout';
  }

  else if (error.type == DioExceptionType.badResponse) {
    msg = 'Error occurred - ${error.response?.statusCode}';
    if (error.response?.statusCode == 401) {
      await AuthManager.instance.signOut();
      Get.offAll(() => const SignIn());
      return;
    }
  }

  if (msg == kError) {
    await showCustomDialog('Error: $kError', AlertType.error);
    return;
  }

  if (onYes != null) {
    bool b = await showConfirmDialog('$msg. Do you want to retry ?');
    if (b) {
      onYes.call();
    }
  }
}

String formatDateTime(String ds) {
  String s = ds;
  DateTime? dt = DateTime.tryParse(ds);

  if (dt != null) {
    var fmt = DateFormat('dd MMM yyyy');
    s = fmt.format(dt);
  }

  return s;
}

String formatCurrentDate() {
  DateTime dt = DateTime.now();
  var fmt = DateFormat('dd-MMM-yyyy');
  String s = fmt.format(dt);
  return s;
}

String formatCurrentTime() {
  DateTime dt = DateTime.now();
  var fmt = DateFormat('HH:mm');
  String s = fmt.format(dt);
  return s;
}

// String getLastUpdateDate_(String s) {
//   if (s != null && s != '') {
//     var dt = s.split(' ');
//     var d1 = dt[0].split(r'/');
//     String r = '${d1[2]}-${d1[1]}-${d1[0]}T${dt[1]}';
//     DateTime dx = DateTime.tryParse(r);

//     if (dx != null) {
//       var fmt = DateFormat('dd MMM yyyy hh:mm a');
//       return fmt.format(dx);
//     }
//   }

//   return s;
// }

String getLastUpdateDate(String? s) {
  return s ?? '';
}

IconData _getAlertIcon(AlertType alertType) {
  if (alertType == AlertType.success) {
    return Icons.check_circle_outline;
  }

  else if (alertType == AlertType.error) {
    return Icons.highlight_off;
  }

  return Icons.info;
}

Color _getAlertIconColor(AlertType alertType) {
  if (alertType == AlertType.success) {
    return kAlertIconSuccessColor;
  }

  else if (alertType == AlertType.error) {
    return kAlertIconErrorColor;
  }

  return kAlertIconInfoColor;
}

Future<void> showCustomDialog(String text, AlertType alertType) async {
  await Get.dialog(AlertDialog(
    scrollable: true,
    contentPadding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 44.0, bottom: 35.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    backgroundColor: Colors.white,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            _getAlertIcon(alertType),
            size: 80.0,
            color: _getAlertIconColor(alertType),
          ),
          const SizedBox(height: 24.0),
          Text(
            text,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              color: kTextColor1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          AppElevatedButton(
            text: 'OK',
            onPressed: () => Get.back(),
          ),
        ],
      ),
    ),
  ));
}

Future<bool> showConfirmDialog(String text) async {
  return await Get.dialog(AlertDialog(
    scrollable: true,
    contentPadding: const EdgeInsets.all(20.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    backgroundColor: Colors.white,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: kTextStyle1.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w700,
              color: kTextColor2,
            ),
          ),
          const SizedBox(height: 38.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(result: false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                    side: const BorderSide(
                      color: kPrimaryColor,
                    ),
                  ),
                  child: Text(
                    'No',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 17.0),
              Expanded(
                child: AppElevatedButton(
                  text: 'Yes',
                  onPressed: () => Get.back(result: true),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  )) ?? false;
}