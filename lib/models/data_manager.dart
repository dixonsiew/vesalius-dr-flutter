import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/main.dart';

class DataManager {

  DataManager._privateConstructor();

  static final DataManager instance = DataManager._privateConstructor();

  final _storage = const FlutterSecureStorage(aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  Future<LazyBox> initHive() async{
    await Hive.initFlutter();
    return await openHiveBox();
  }

  Future<LazyBox> openHiveBox() async {
    return await Hive.openLazyBox(kHiveBoxName);
  }

  Future<String?> read(String key) async {
    String? s = await _storage.read(key: key);
    return s;
  }

  Future<void> write(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
    await box.deleteFromDisk();
    box = await openHiveBox();
  }

  Future<void> setItem(String key, dynamic o) async {
    await box.put(key, o);
  }

  Future<dynamic> getItem(String key) async {
    return await box.get(key);
  }

  Future<void> removeItem(String key) async {
    await box.delete(key);
  }
}