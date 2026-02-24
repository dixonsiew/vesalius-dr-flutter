import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/services/auth_service.dart';
import 'package:vesalius_dr_flutter/models/auth_manager.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:dio/dio.dart';
import 'dart:io';

import 'main_layout.dart';

class Login extends StatefulWidget {

  static const String routeName = 'login';

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool isPwd = false;
  bool isLoading = false;
  String deviceId = '';
  bool biometricAuthEnabled = false;
  List<BiometricType> listBiometric = [];
  final LocalAuthentication auth = LocalAuthentication();
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();
  static const AndroidId androidIdPlugin = AndroidId();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    usernameController.value = const TextEditingValue(text: 'nova.doctor');
    pwdController.value = const TextEditingValue(text: 'password');
    initPlatformState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    pwdController.dispose();
    super.dispose();
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
      final SharedPreferences prefs = await _prefs;
      String username = prefs.getString('__biometric-username__') ?? '';
      setState(() {
        biometricAuthEnabled = username.isEmpty ? false : true;
      });
    } on PlatformException catch (_) {
      listBiometric = [];
    }
  }

  void onPopInvokedWithResult(bool didPop, result) async {
    if (didPop) return;
    bool b = await CustomDialog.of(context).showConfirmDialog('Are you sure you want to exit ?');
    if (b) {
      SystemNavigator.pop();
    }
  }

  void login() async {
    final dlg = CustomDialog.of(context);
    try {
      var o = {
        'username': usernameController.text,
        'password': pwdController.text
      };
      setState(() {
        isLoading = true;
      });
      final nav = Navigator.of(context);
      var m = await authenticate(o);
      var x = m['data'];
      AuthManager.token = m['token'];
      AuthManager.role = x['role'];
      AuthManager.mcr = x['mcr'];
      AuthManager.branch = x['branch'];
      AuthManager.username = usernameController.text;
      setState(() {
        isLoading = false;
      });
      nav.pushReplacementNamed(MainLayout.routeName);
    }
    
    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        dlg.showCustomDialog('Incorrect username or password', AlertType.error);
      }

      else {
        dlg.handleError(error, login);
      }
    }

    catch (error) {
      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  void biometricLogin() async {
    final dlg = CustomDialog.of(context);
    final nav = Navigator.of(context);
    final SharedPreferences prefs = await _prefs;
    String username = prefs.getString('__biometric-username__') ?? '';
    bool allowBiometricAuth = username.isEmpty ? false : true;

    if (!allowBiometricAuth) {
      dlg.showCustomDialog('Biometric authentication not enabled on this device', AlertType.error);
      return;
    }

    try {
      bool x = await auth.canCheckBiometrics;
      if (x) {
        String s = 'fingerprint';
        if (listBiometric.contains(BiometricType.face)) {
          s = 'face';
        }

        bool a = await auth.authenticate(
          localizedReason: 'Please scan your $s to authenticate',
          persistAcrossBackgrounding: true,
        );
        if (a) {
          var o = {
            'username': username,
            'password': deviceId,
            'fromBiometric': 1
          };
          setState(() {
            isLoading = true;
          });
          var m = await authenticate(o);
          var x = m['data'];
          AuthManager.token = m['token'];
          AuthManager.role = x['role'];
          AuthManager.mcr = x['mcr'];
          AuthManager.branch = x['branch'];
          AuthManager.username = usernameController.text;
          setState(() {
            isLoading = false;
          });
          nav.pushReplacementNamed(MainLayout.routeName);
        }
      }

      else {
        dlg.showCustomDialog('Biometric not enrolled on this device', AlertType.info);
      }
    }

    on DioException catch (error) {
      setState(() {
        isLoading = false;
      });
      if (error.type == DioExceptionType.badResponse && error.response?.statusCode == 401) {
        dlg.showCustomDialog('Biometric authentication failed', AlertType.error);
      }

      else {
        dlg.handleError(error, biometricLogin);
      }
    }

    catch (error) {
      dlg.showCustomDialog(error.toString(), AlertType.error);
    }
  }

  Widget buildLogo() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 84, 74, 171),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.0),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('images/dr-im.jpg'),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Container(
                  width: 100.0,
                  height: 80.0,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage('images/nova_dr_logo.jpg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginBox() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 180.0, horizontal: 20.0),
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white, 
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color.fromARGB(90, 0, 0, 0),
                offset: Offset(0, 0),
                blurRadius: 10.0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 38.0, right: 38.0),
                child: TextField(
                  controller: usernameController,
                  style: const TextStyle(
                    fontFamily: 'texgyreadventor',
                    fontSize: 18.0,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outline,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 84, 74, 171)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 38.0, right: 38.0),
                child: TextField(
                  controller: pwdController,
                  obscureText: isPwd,
                  style: const TextStyle(
                    fontFamily: 'texgyreadventor',
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPwd ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPwd = !isPwd;
                        });
                      },            
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(255, 84, 74, 171)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: double.infinity,
                height: 45.0,
                padding: const EdgeInsets.only(left: 38.0, right: 38.0),
                child: RawMaterialButton(
                  fillColor: const Color.fromARGB(255, 84, 74, 171),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'texgyreadventor',
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () {
                    login();
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              biometricAuthEnabled ?
              RawMaterialButton(
                fillColor: const Color.fromARGB(255, 84, 74, 171),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                constraints: const BoxConstraints(minWidth: 80.0, minHeight: 60.0),
                child: const Icon(
                  Icons.fingerprint,
                  color: Colors.white,
                ),
                onPressed: () {
                  biometricLogin();
                },
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).padding;

    return PopScope(
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black),
          toolbarHeight: 0.0,
          backgroundColor: Colors.white,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: const CupertinoActivityIndicator(radius: 15.0),
          child: SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - padding.top - padding.bottom,
                  child: Stack(
                    children: [
                      buildLogo(),
                      buildLoginBox(),
                    ],
                  ),
                ),
              ),
            )
          ),
        ),
      ),
    );
  }
}