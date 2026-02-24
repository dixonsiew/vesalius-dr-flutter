import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_dr_flutter/models/data_manager.dart';

class AuthManager {

  static String? token;
  static String? role;
  static String? mcr;
  static String? branch;
  static String? username;
  static String playerId = '';
  static bool isLogin = false;

  AuthManager._privateConstructor();

  static final AuthManager instance = AuthManager._privateConstructor();

  Future<void> set(String mtoken, String role, String? mmcr, String? mbranch, String musername, bool misLogin) async {
    token = mtoken;
    username = musername;
    isLogin = misLogin;
    mcr = mmcr;
    branch = mbranch;
    await DataManager.instance.write('GmsTokenDr', token);
    await DataManager.instance.write('role', role);
    await DataManager.instance.write('mcr', mcr);
    await DataManager.instance.write('branch', branch);
    await DataManager.instance.write('username', username!);
    await DataManager.instance.write('isLogin', '1');
  }

  Future<void> load() async {
    token = await DataManager.instance.read('GmsTokenDr');
    role = await DataManager.instance.read('role');
    username = await DataManager.instance.read('username');
    isLogin = (await DataManager.instance.read('isLogin') ?? '') == '1' ? true : false;
    mcr = await DataManager.instance.read('mcr');
    branch = await DataManager.instance.read('branch');
  }

  Future<void> signOut() async {
    String username = await DataManager.instance.read('__biometric-username__') ?? '';
    Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
    await DataManager.instance.clear();
    if (m != null) {
      await DataManager.instance.setItem('biometric', m);
    }

    if (username.isNotEmpty) {
      await DataManager.instance.write('__biometric-username__', username);
    }

    isLogin = false;
  }

  String getPlayerId() {
    String playerId = '';
    String? subId = OneSignal.User.pushSubscription.id;
    playerId = subId ?? '';

    AuthManager.playerId = playerId;
    return playerId;
  }

  Future<void> waitPlayerId() async {
    await Future.doWhile(() {
      String playerId = getPlayerId();
      if (playerId.isNotEmpty) {
        return false;
      }

      return true;
    });
  }
}