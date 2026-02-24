import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/profile_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/data_manager.dart';
import 'package:vesalius_dr_flutter/models/user.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';

import 'sign_in.dart';
import 'profile/change_password.dart';
import 'profile/personal_info.dart';

class Profile extends StatefulWidget {
  
  static const String routeName = '/Profile';

  final User user;

  const Profile({
    super.key,
    required this.user,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String deviceId = '';
  List<BiometricType> listBiometric = [];
  final LocalAuthentication auth = LocalAuthentication();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final ProfileCtrl ctrl = Get.put(ProfileCtrl());

  @override
  void initState() {
    super.initState();
    initPlatformState();
    load();
  }

  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        deviceId = await androidIdPlugin.getId() ?? '';
      }

      else {
        final IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceId = data.identifierForVendor ?? '';
      }

      listBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      listBiometric = [];
    }
    
    bool biometricEnabled = false;
    Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
    if (m != null && m.containsKey(AuthManager.instance.username!)) {
      biometricEnabled = true;
    }
    
    ctrl.setIsBiometricEnabled(biometricEnabled);
  }

  void load() async {

  }

  Future<void> onRefresh() async {
    load();
  }

  void showSuccessBiometric() async {
    await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 35.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/tick-1.png',
              width: 54.0,
              height: 54.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24.0),
            Text(
              'Biometric Authentication has been enabled sucessfully.',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            AppElevatedButton(
              text: 'Done',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  void onBiometric() async {
    String s = 'fingerprint';
    if (Platform.isIOS) {
      if (listBiometric.contains(BiometricType.face)) {
        s = 'face';
      }
    }

    bool a = await auth.authenticate(
      localizedReason: 'Please scan your $s to authenticate',
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
    if (a) {
      await submitBiometricLogin(deviceId);
      await DataManager.instance.write('__biometric-username__', AuthManager.instance.username!);
      Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
      m ??= <dynamic, dynamic>{};
      m[AuthManager.instance.username!] = 1;
      await DataManager.instance.setItem('biometric', m);
      ctrl.setIsBiometricEnabled(true);
      showSuccessBiometric();
    }
  }

  Future<bool> onConfirmBiometric() async {
    return await Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 35.0),
            Text(
              'Would you like to enable biometric authentication?',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25.0),
            AppElevatedButton(
              text: 'Enable',
              onPressed: () => Get.back(result: true),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () => Get.back(result: false),
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor,
              ),
              child: Text(
                'Not now',
                style: kTextStyle1.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  decorationColor: kPrimaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    ));
  }

  Widget buildContent() {
    final user = widget.user;
    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(height: 30.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              children: [
                Image.asset(
                  'images/doc.png',
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${user.title} ${user.firstName} ${user.middleName} ${user.lastName ?? ''}'.trim(),
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor1,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Consultant Cardiothoracic Surgeon',
                        style: kTextStyle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Account Settings',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
          ),
          const SizedBox(height: 17.0),
          InkWell(
            onTap: () => Get.to(() => PersonalInfo(user: user)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/user.png',
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Personal Information',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
            child: Row(
              children: [
                Image.asset(
                  'images/biometric.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'Biometric Login',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Obx(() =>
                  Switch(
                    value: ctrl.isBiometricEnabled,
                    activeThumbColor: const Color(0xFF08B86E),
                    onChanged: (value) async {
                      if (value) {
                        try {
                          bool x = await auth.canCheckBiometrics;
                          if (listBiometric.isEmpty) {
                            showCustomDialog('Biometric not enrolled on this device', AlertType.info);
                            return;
                          }
                
                          if (x) {
                            bool b = await onConfirmBiometric();
                            if (b) {
                              onBiometric();
                            }
                
                            else {
                              ctrl.setIsBiometricEnabled(false);
                            }
                          }
                
                          else {
                            showCustomDialog('Biometric not enrolled on this device', AlertType.info);
                          }
                        }
                
                        on PlatformException catch (_) {
                          showCustomDialog('Biometric not enrolled on this device', AlertType.info);
                        }
                  
                        on DioException catch (error) {
                          handleError(error, onBiometric);
                        }
                  
                        catch (error) {
                          showCustomDialog(error.toString(), AlertType.error);
                        }
                      }
                
                      else {
                        try {
                          await submitBiometricLogin('__disabled__');
                          await DataManager.instance.remove('__biometric-username__');
                          Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
                          if (m != null) {
                            m.remove(AuthManager.instance.username!);
                            await DataManager.instance.setItem('biometric', m);
                          }
                          ctrl.setIsBiometricEnabled(false);
                        }
                
                        catch (_) {}
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => Get.to(() => const ChangePassword()),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/padlock.png',
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Change Password',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Notification Settings',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: kTextColor2,
              ),
            ),
          ),
          const SizedBox(height: 23.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
            child: Row(
              children: [
                Image.asset(
                  'images/bell.png',
                  width: 20.0,
                  height: 20.0,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    'Push Notification',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kTextColor1,
                    ),
                  ),
                ),
                Obx(() =>
                  Switch(
                    value: ctrl.isPushEnabled,
                    activeThumbColor: const Color(0xFF08B86E),
                    onChanged: (value) {
                      ctrl.setIsPushEnabled(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1.0,
            color: kBgColor2,
          ),
          const SizedBox(height: 17.0),
          InkWell(
            onTap: () async {
              bool b = await showConfirmDialog('Are you sure you want to logout ?');
              if (b) {
                await AuthManager.instance.signOut();
                Get.offAll(() => const SignIn());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
              child: Row(
                children: [
                  Image.asset(
                    'images/logout.png',
                    width: 20.0,
                    height: 20.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Logout',
                    style: kTextStyle1.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'My Profile',
      body: SafeArea(
        child: Obx(() =>
          ModalProgressHUD(
            inAsyncCall: ctrl.isLoading,
            blur: kBlur,
            progressIndicator: const AppActivityIndicator(),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              onRefresh: onRefresh,
              color: kPrimaryColor,
              child: buildContent(),
            ),
          ),
        ),
      ),
    );
  }
}