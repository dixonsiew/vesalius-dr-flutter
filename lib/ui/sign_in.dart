import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dio/dio.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/sign_in_ctrl.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:vesalius_dr_flutter/models/data_manager.dart';
import 'package:vesalius_dr_flutter/models/notification_manager.dart';
import 'package:vesalius_dr_flutter/services/auth_service.dart';
import 'package:vesalius_dr_flutter/ui/main_layout.dart';

import 'forgot_password.dart';

class SignIn extends StatefulWidget {

  static const String routeName = '/SignIn';

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String deviceId = '';
  List<BiometricType>? listBiometric;
  final LocalAuthentication auth = LocalAuthentication();
  final formKey = GlobalKey<FormState>();
  late final TextEditingController txtusername;
  late final TextEditingController txtpwd;
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  final SignInCtrl ctrl = Get.put(SignInCtrl());

  @override
  void initState() {
    super.initState();
    txtusername = TextEditingController();
    txtpwd = TextEditingController();
    initPlatformState();
  }

  @override
  void dispose() {
    txtusername.dispose();
    txtpwd.dispose();
    super.dispose();
  }

  void initPlatformState() async {
    txtusername.text = 'nova.doctor';
    txtpwd.text = 'password';
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
    String username = await DataManager.instance.read('__biometric-username__') ?? '';
    Map<dynamic, dynamic>? m = await DataManager.instance.getItem('biometric');
    if (m != null && m.containsKey(username)) {
      biometricEnabled = true;
    }

    ctrl.setIsBiometricEnabled(biometricEnabled);

    OneSignal.Notifications.addForegroundWillDisplayListener(NotificationManager.instance.foregroundWillDisplayListener);

    await OneSignal.Notifications.requestPermission(true);
  }

  void validate(String s) {
    bool b = formKey.currentState!.validate();

    if (s.isEmpty) {
      ctrl.setIsValid(false);
    }

    else {
      ctrl.setIsValid(b);
    }
  }

  void showError() {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/error.png',
              width: 54.0,
              height: 54.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24.0),
            Text(
              'Login Unsuccessful',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Incorrect username or password',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25.0),
            AppElevatedButton(
              text: 'Try Again',
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    ));
  }

  void onLogin() async {
    try {
      var o = {
        'username': txtusername.text,
        'password': txtpwd.text
      };
      ctrl.setIsLoading(true);
      var m = await authenticate(o);
      var x = m['data'];
      AuthManager.instance.token = m['token'];
      AuthManager.instance.role = x['role'];
      AuthManager.instance.mcr = x['mcr'];
      AuthManager.instance.branch = x['branch'];
      AuthManager.instance.username = txtusername.text;
      await AuthManager.instance.set(m['token'], x['role'], x['mcr'], x['branch'], txtusername.text, true);
      ctrl.setIsLoading(false);
      Get.off(() => const MainLayout());
    }
    
    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        showError();
      }

      else {
        handleError(error, onLogin);
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      await showCustomDialog(error.toString(), AlertType.error);
    }
  }

  void biometricLogin() async {
    String username = await DataManager.instance.read('__biometric-username__') ?? '';
    bool allowBiometricAuth = username.isEmpty ? false : true;

    if (!allowBiometricAuth) {
      await showCustomDialog('Biometric authentication not enabled on this device', AlertType.info);
      return;
    }

    try {
      bool x = await auth.canCheckBiometrics;
      if (x) {
        String s = 'fingerprint';
        if (listBiometric?.contains(BiometricType.face) ?? false) {
          s = 'face';
        }

        bool a = await auth.authenticate(
          localizedReason: 'Please scan your $s to authenticate',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
        if (a) {
          var o = {
            'username': username,
            'password': deviceId,
            'fromBiometric': 1
          };
          ctrl.setIsLoading(true);
          var m = await authenticate(o);
          var x = m['data'];
          AuthManager.instance.token = m['token'];
          AuthManager.instance.role = x['role'];
          AuthManager.instance.mcr = x['mcr'];
          AuthManager.instance.branch = x['branch'];
          AuthManager.instance.username = txtusername.text;
          await AuthManager.instance.set(m['token'], x['role'], x['mcr'], x['branch'], txtusername.text, true);
          ctrl.setIsLoading(false);
          Get.off(() => const MainLayout());
        }
      }

      else {
        showCustomDialog('Biometric not enrolled on this device', AlertType.info);
      }
    }

    on DioException catch (error) {
      ctrl.setIsLoading(false);
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        showCustomDialog('Biometric authentication failed', AlertType.error);
      }

      else {
        handleError(error, biometricLogin);
      }
    }

    catch (error) {
      ctrl.setIsLoading(false);
      showCustomDialog(error.toString(), AlertType.error);
    }
  }

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    bool b = await showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(bottom: ctrl.isBiometricEnabled ? 241.0 : 98.0),
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Image.asset(
                        'images/logo.png',
                        width: 123.0,
                        height: 112.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 50.0),
                    child: Text(
                      'Username',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kBgColor2.withValues(alpha: 0.1),
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: validate,
                      validator: ValidationBuilder().required('Username is required').minLength(1, 'Username is required').build(),
                      controller: txtusername,
                      cursorColor: kTextColor1,
                      style: const TextStyle(
                        fontFamily: kBodyFont,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'e.g doctor.nova',
                        hintStyle: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: kTextColor2,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.2)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: kTextColor3),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: kTextColor3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Text(
                      'Password',
                      style: kTextStyle1.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: kTextColor1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: kBgColor2.withValues(alpha: 0.1),
                          offset: const Offset(0, 4.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Obx(() =>
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: validate,
                        validator: ValidationBuilder().required('Password is required').minLength(1, 'Password is required').build(),
                        controller: txtpwd,
                        obscureText: ctrl.isPwd,
                        cursorColor: kTextColor1,
                        style: const TextStyle(
                          fontFamily: kBodyFont,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: kTextColor1,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter password',
                          hintStyle: kTextStyle1.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: kTextColor2,
                          ),
                          suffixIcon: Material(
                            color: Colors.white,
                            type: MaterialType.transparency,
                            child: IconButton(
                              icon: Obx(() =>
                                Icon(
                                  ctrl.isPwd ? Icons.visibility_off : Icons.visibility,
                                  color: kTextColor1,
                                ),
                              ),
                              color: kTextColor1,
                              splashRadius: 22.0,
                              onPressed: () {
                                ctrl.setIsPwd(!ctrl.isPwd);
                              },            
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.2)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: const Color(0xFFDBDBDB).withValues(alpha: 0.2)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(color: kTextColor3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 25.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Get.to(() => const ForgotPassword());
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: kTextColor1,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: kTextStyle1.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: kTextColor1,
                            decoration: TextDecoration.underline,
                            decorationColor: kTextColor1,
                            decorationThickness: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => ctrl.isBiometricEnabled ?
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppElevatedButton(
                    text: 'Sign In',
                    onPressed: onLogin,
                  ),
                  const SizedBox(height: 27.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1.0,
                          color: const Color(0xFFDADADA),
                        ),
                      ),
                      Text(
                        'OR',
                        style: kTextStyle1.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: kTextColor2,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1.0,
                          color: const Color(0xFFDADADA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                  Material(
                    borderRadius: BorderRadius.circular(5.0),
                    child: InkWell(
                      onTap: biometricLogin,
                      borderRadius: BorderRadius.circular(5.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'images/fingerprint.png',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Biometric Login',
                    style: kTextStyle1.copyWith(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ) :
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: kBgColor1,
              padding: const EdgeInsets.all(25.0),
              child: Obx(() =>
                AppElevatedButton(
                  text: 'Sign In',
                  onPressed: !ctrl.isValid ? null : onLogin,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark, statusBarColor: kBgColor1),
          toolbarHeight: 0.0,
          backgroundColor: kBgColor1,
          elevation: 0.0,
        ),
        backgroundColor: kBgColor1,
        body: SafeArea(
          child: Obx(() =>
            ModalProgressHUD(
              inAsyncCall: ctrl.isLoading,
              blur: kBlur,
              progressIndicator: const AppActivityIndicator(),
              child: buildForm(),
            ),
          ),
        ),
      ),
    );
  }
}