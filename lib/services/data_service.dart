import 'dart:io';
import 'package:dio/dio.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/outpatient.dart';
import 'package:vesalius_dr_flutter/models/inpatient.dart';
import 'package:vesalius_dr_flutter/models/patient_data.dart';
import 'package:vesalius_dr_flutter/models/patient_allergy.dart';
import 'package:vesalius_dr_flutter/models/review.dart';
import 'package:vesalius_dr_flutter/models/todo_notification.dart';
import 'package:vesalius_dr_flutter/models/user.dart';
import 'api_helper.dart';

Future<void> submitBiometricLogin(String deviceId) async {
  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/add-machine-id', data: { 'machineId': deviceId });
  }

  catch (error) {
    rethrow;
  }
}

Future<User> getUser() async {
  User o;

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/user');
    o = User.fromJson(res.data);
  }

  catch (error) {
    rethrow;
  }

  return o;
}

Future<List<OutpatientQueueSummary>> getOutpatientQueueSummaryList() async {
  List<OutpatientQueueSummary> lx = [];
  
  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/getOutpatientQueueSumarryList/${AuthManager.branch}/${AuthManager.mcr}');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map<OutpatientQueueSummary>((x) => OutpatientQueueSummary.fromJson(x)).toList();
    }
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<OutpatientQueueDetail>> getOutpatientQueueDetailList(String queueCriteria) async {
  List<OutpatientQueueDetail> lx = [];

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/getOutpatientQueueDetailList/${AuthManager.branch}/$queueCriteria/${AuthManager.mcr}');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map((x) => OutpatientQueueDetail.fromJson(x)).toList();
    }
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<InpatientQueueDetail>> getInpatientDetailList() async {
  List<InpatientQueueDetail> lx = [];

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/getInpatientQueueDetailList/${AuthManager.branch}/${AuthManager.mcr}');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map((x) => InpatientQueueDetail.fromJson(x)).toList();
    }
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<PatientData> getPatientData(String prn) async {
  PatientData o;

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-data/${AuthManager.branch}/$prn');
    o = PatientData.fromJson(res.data);
  }

  catch (error) {
    rethrow;
  }

  return o;
}

Future<List<PatientAllergy>> getPatientAllergyList(String prn) async {
  List<PatientAllergy> lx = [];

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-allergy/${AuthManager.branch}/$prn');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map((x) => PatientAllergy.fromJson(x)).toList();
    }
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<Review>> getReviewList(String dt) async {
  List<Review> lx = [];

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-investigation-report/${AuthManager.branch}/${AuthManager.mcr}/$dt');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map((x) => Review.fromJson(x)).toList();
    }
  }

  on DioException catch (error) {
    if (error.response?.statusCode != 502) {
      rethrow;
    }
  }

  return lx;
}

Future<String> submitReviewAck(o) async {
  String s = '';

  try {
    final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/process-doctor-review-investigation/${AuthManager.branch}/${AuthManager.mcr}', data: o);
    if (res.statusCode == 200) {
      s = '200';
    }

    else {
      s = '${res.statusCode}';
    }
  }

  catch (error) {
    rethrow;
  }

  return s;
}

Future<File> getInvestigationReportPdf(String accessionNo, String fp, void Function(int, int) onReceiveProgress) async {
  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-pdf-investigation-report/${AuthManager.branch}/${AuthManager.mcr}/$accessionNo',
      onReceiveProgress: onReceiveProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      )
    );
    File file = File(fp);
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(res.data);
    await raf.close();
    return file;
  }

  catch (error) {
    rethrow;
  }
}

Future<List<TodoNotification>> getTodoNotificationList() async {
  List<TodoNotification> lx = [];

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-doctor-todo-notification/${AuthManager.branch}/${AuthManager.mcr}');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map((x) => TodoNotification.fromJson(x)).toList();
    }
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<TodoNotification>> getTodoNotificationDetailList(String prn) async {
  List<TodoNotification> lx = [];

  try {
    final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-doctor-todo-notification-details/${AuthManager.branch}/${AuthManager.mcr}/$prn');
    final data = res.data;
    if (res.statusCode == 200) {
      final ls = data as List? ?? [];
      lx = ls.map((x) => TodoNotification.fromJson(x)).toList();
    }
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<String> submitDrugVerificationAck(o) async {
  String s = '';

  try {
    final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/process-doctor-todo-ack/${AuthManager.branch}/${AuthManager.mcr}', data: o);
    if (res.statusCode == 200) {
      s = '200';
    }

    else {
      s = '${res.statusCode}';
    }
  }

  catch (error) {
    rethrow;
  }

  return s;
}

Future<String> submitChangePassword(o) async {
  String s = '';

  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/change-password', data: o);
    s = '200';
  }
  catch (error) {
    rethrow;
  }

  return s;
}