import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

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

String getLastUpdateDate(String s) {
  return s;
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

Color _getAlertBtnColor(AlertType alertType) {
  if (alertType == AlertType.success) {
    return kAlertBtnSuccessColor;
  }

  else if (alertType == AlertType.error) {
    return kAlertBtnErrorColor;
  }

  return kAlertBtnInfoColor;
}

class CustomDialog {

  final BuildContext context;

  CustomDialog._(this.context);

  static CustomDialog of(BuildContext context) {
    return CustomDialog._(context);
  }

  void handleError(DioException error, void Function() onYes) async {
    String msg = error.message ?? 'Unknown';
    if (error.type == DioExceptionType.connectionTimeout) {
      msg = 'Connection Timeout';
    }

    else if (error.type == DioExceptionType.receiveTimeout) {
      msg = 'Receive Timeout';
    }

    else if (error.type == DioExceptionType.badResponse) {
      msg = 'Error occurred - ${error.response?.statusCode}';
    }

    bool b = await showConfirmDialog('$msg. Do you want to retry ?');
    if (b) {
      onYes();
    }
  }

  Future<void> showCustomDialog(String text, AlertType alertType) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: const Color(0xFFE0FCFB),
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    _getAlertIcon(alertType),
                    size: 80.0,
                    color: _getAlertIconColor(alertType),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    text,
                    style: const TextStyle(
                      color: kAlertTextColor,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: _getAlertBtnColor(alertType),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: const BorderSide(
                            width: 1.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> showConfirmDialog(String text) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          backgroundColor: const Color(0xFFE0FCFB),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.report_problem,
                  size: 80.0,
                  color: Color(0xFFFFCC00),
                ),
                const SizedBox(height: 8.0),
                Text(
                  text,
                  style: const TextStyle(
                    color: kAlertTextColor,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
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
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('NO'),
                      ),
                    ),
                    const SizedBox(width:  10.0),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFFFBF00),
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
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('YES'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    ) ?? false;
  }
}