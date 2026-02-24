import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/ui/change_password.dart';
import 'package:vesalius_dr_flutter/ui/login.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'dart:io';

class AppDrawer extends StatefulWidget {

  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  bool allowBiometricAuth = false;
  String deviceId = '';
  List<BiometricType> listBiometric = [];
  final LocalAuthentication auth = LocalAuthentication();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }

      listBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      listBiometric = [];
    }

    final SharedPreferences prefs = await _prefs;
    String username = prefs.getString('__biometric-username__') ?? '';
    setState(() {
      allowBiometricAuth = username.isEmpty ? false : true;
    });
  }

  void onBiometric() async {
    final dlg = CustomDialog.of(context);
    final SharedPreferences prefs = await _prefs;
    String s = 'fingerprint';
    if (listBiometric.contains(BiometricType.face)) {
      s = 'face';
    }

    bool a = await auth.authenticate(
      localizedReason: 'Please scan your $s to authenticate',
      persistAcrossBackgrounding: true,
    );
    if (a) {
      await submitBiometricLogin(deviceId);
      await prefs.setString('__biometric-username__', AuthManager.username!);
      await prefs.setString('__biometric-uuid__', deviceId);
      setState(() {
        allowBiometricAuth = true;
      });
      await dlg.showCustomDialog('Biometric Authentication Enabled', AlertType.success);
    }
  }

  void onToggleSwitch(bool value) async {
    if (value) {
      final dlg = CustomDialog.of(context);
      try {
        bool x = await auth.canCheckBiometrics;
        if (x) {
          bool b = await dlg.showConfirmDialog('Would you like to use biometric authentication ?');
          if (b) {
            onBiometric();
          }

          else {
            setState(() {
              allowBiometricAuth = false;
            });
          }
        }

        else {
          await dlg.showCustomDialog('Biometric not enrolled on this device', AlertType.info);
        }
      } on PlatformException catch (_) {}

      catch (error) {
        dlg.showCustomDialog(error.toString(), AlertType.error);
      }
    }

    else {
      try {
        final SharedPreferences prefs = await _prefs;
        await submitBiometricLogin('__disabled__');
        await prefs.remove('__biometric-username__');
        await prefs.remove('__biometric-uuid__');
        setState(() {
          allowBiometricAuth = false;
        });
      }

      catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 80.0, bottom: 20.0),
            child: Text(
              'Settings',
              style: kDrawerHeaderTextStyle,
            ),
          ),
          const Divider(
            color: Color(0xFFCCCCCC),
            height: 1.0,
            thickness: 1.0,
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.unlock,
              color: kAppBarIconColor,
              size: 22.0,
            ),
            title: const Text(
              'Change password',
              style: kDrawerTextStyle,
            ),
            onTap: () async {
              final nav = Navigator.of(context);
              nav.pop();
              nav.pushNamed(ChangePassword.routeName);
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 70.0),
            child: const Divider(),
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: kAppBarIconColor,
              size: 22.0,
            ),
            title: const Text(
              'Logout',
              style: kDrawerTextStyle,
            ),
            onTap: () async {
              final nav = Navigator.of(context);
              nav.pop();
              bool b = await CustomDialog.of(context).showConfirmDialog('Are you sure you want to logout ?');
              if (b) {
                nav.pushNamedAndRemoveUntil(Login.routeName, (route) => false);
              }
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 70.0),
            child: const Divider(),
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.fingerprint,
              color: kAppBarIconColor,
              size: 22.0,
            ),
            title: const Text(
              'Biometric Login',
              style: kDrawerTextStyle,
            ),
            trailing: Switch(
              value: allowBiometricAuth,
              onChanged: onToggleSwitch,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 70.0),
            child: const Divider(),
          ),
        ],
      ),
    );
  }
}