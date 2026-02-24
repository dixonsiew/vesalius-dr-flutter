import 'package:vesalius_dr_flutter/constants.dart';
import 'api_helper.dart';

Future<Map<String, dynamic>> authenticate(o) async {
  Map<String, dynamic> m = {};

  try {
    final res = await ApiHelper.dio.post('$kServerUrl/login', data: o);
    String? token = res.headers.value('Authorization');
    m['token'] = token;
    m['data'] = res.data;
  }

  catch (error) {
    rethrow;
  }

  return m;
}