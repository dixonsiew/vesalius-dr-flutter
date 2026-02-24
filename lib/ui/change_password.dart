import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vesalius_dr_flutter/components/app_drawer.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/helpers.dart';
import 'package:vesalius_dr_flutter/services/data_service.dart';
import 'package:dio/dio.dart';
import 'package:vesalius_dr_flutter/ui/main_layout.dart';

class ChangePassword extends StatefulWidget {
  
  static const String routeName = 'ChangePassword';

  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  bool isCurrentPwd = false;
  bool isNewPwd = false;
  bool isConfirmPwd = false;
  String currentPwd = '';
  String newPwd = '';
  String confirmPwd = '';
  bool isValid = false;
  final txtCurrentPwdController = TextEditingController();
  final txtNewPwdController = TextEditingController();
  final txtConfirmPwdController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  @override
  void dispose() {
    txtCurrentPwdController.dispose();
    txtNewPwdController.dispose();
    txtConfirmPwdController.dispose();
    super.dispose();
  }

  void submit() async {
    final dlg = CustomDialog.of(context);
    try {
      var o = {
        'newPassword': newPwd,
        'oldPassword': currentPwd
      };
      String x = await submitChangePassword(o);
      if (x == '200') {
        dlg.showCustomDialog('Password successfully changed', AlertType.success);
      }
    }

    catch (error) {
      if (error is DioException) {
        if (error.response?.statusCode == 417) {
          dlg.showCustomDialog('New Password is not allowed to be the same with Current Password', AlertType.info);
        }
      }

      else {
        dlg.showCustomDialog('Invalid password', AlertType.error);
      }
      //handleError(context, error, () => submit());
    }
  }

  Widget buildContent() {
    return SafeArea(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Material(
              elevation: 5.0,
              color: kOutpatientCardColor,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: kOutpatientDecoration,
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10.0),
                            FaIcon(
                              FontAwesomeIcons.lock,
                              color: kAppBarIconColor,
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              'Current Password',
                              style: kLabelTextStyle,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: txtCurrentPwdController,
                        cursorColor: Colors.black,
                        obscureText: isCurrentPwd,
                        style: const TextStyle(
                          fontFamily: 'texgyreadventor',
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isCurrentPwd ? Icons.visibility : Icons.visibility_off,
                              color: kAppBarIconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isCurrentPwd = !isCurrentPwd;
                              });
                            },
                          ),
                          errorStyle: const TextStyle(
                            fontFamily: 'texgyreadventor',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          errorMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF203B8C),
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String s) {
                          setState(() {
                            currentPwd = s;
                            isValid = formKey.currentState?.validate() ?? false;
                          });
                        },
                        validator: (String? s) {
                          if (s?.isEmpty ?? true) {
                            return '';
                          }

                          return null;
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.0,
                            ),
                            FaIcon(
                              FontAwesomeIcons.lock,
                              color: kAppBarIconColor,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              'New Password',
                              style: kLabelTextStyle,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: txtNewPwdController,
                        cursorColor: Colors.black,
                        obscureText: isNewPwd,
                        style: const TextStyle(
                          fontFamily: 'texgyreadventor',
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isNewPwd ? Icons.visibility : Icons.visibility_off,
                              color: kAppBarIconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isNewPwd = !isNewPwd;
                              });
                            },
                          ),
                          errorStyle: const TextStyle(
                            fontFamily: 'texgyreadventor',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          errorMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF203B8C),
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String s) {
                          setState(() {
                            newPwd = s;
                            isValid = formKey.currentState?.validate() ?? false;
                          });
                        },
                        validator: (String? s) {
                          if (s?.isEmpty ?? true) {
                            return '';
                          }

                          else {
                            if ((s?.length ?? 0) < 6) {
                              return 'Password need at least 6 characters (alphanumeric)';
                            }

                            RegExp rx = RegExp(r'^[a-zA-Z0-9]+$');
                            if (!rx.hasMatch(s ?? '')) {
                              return '';
                            }
                          }

                          return null;
                        },
                      ),

                      const Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 10.0),
                            FaIcon(
                              FontAwesomeIcons.lock,
                              color: kAppBarIconColor,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              'Confirm Password',
                              style: kLabelTextStyle,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: txtConfirmPwdController,
                        cursorColor: Colors.black,
                        obscureText: isConfirmPwd,
                        style: const TextStyle(
                          fontFamily: 'texgyreadventor',
                          fontSize: 14.0,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPwd ? Icons.visibility : Icons.visibility_off,
                              color: kAppBarIconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPwd = !isConfirmPwd;
                              });
                            },
                          ),
                          errorStyle: const TextStyle(
                            fontFamily: 'texgyreadventor',
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                          errorMaxLines: 3,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF203B8C),
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String s) {
                          setState(() {
                            confirmPwd = s;
                            isValid = formKey.currentState?.validate() ?? false;
                          });
                        },
                        validator: (String? s) {
                          if (s?.isEmpty ?? true) {
                            return '';
                          }

                          else {
                            if ((s?.length ?? 0) < 6) {
                              return 'Password need at least 6 characters (alphanumeric)';
                            }

                            if (newPwd.isNotEmpty && newPwd != s) {
                              return 'New Password does not match with Confirm Password';
                            }

                            RegExp rx = RegExp(r'^[a-zA-Z0-9]+$');
                            if (!rx.hasMatch(s ?? '')) {
                              return '';
                            }
                          }

                          return null;
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                        child: Text(
                          'Password requirement',
                          style: kLabelTextStyle.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            String.fromCharCode(0x2022),
                            style: kNoteTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Flexible(
                            child: Text(
                              'New Password is not allowed to be the same with Current Password',
                              style: kNoteTextStyle,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            String.fromCharCode(0x2022),
                            style: kNoteTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          const Flexible(
                            child: Text(
                              'Minimum password length: 6 characters (alphanumeric)',
                              style: kNoteTextStyle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.light, statusBarColor: Colors.black),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: kAppBarIconColor, //change your color here
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              drawerKey.currentState?.openEndDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: kAppBarIconColor,
            ),
          ),
        ],
        title: const Text(
          'Change Password',
          style: kAppBarTitleTextStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: buildContent(),
      persistentFooterButtons: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: RawMaterialButton(
                    fillColor: const Color(0xFFA6A6A6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'texgyreadventor',
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(MainLayout.routeName, (route) => false);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: RawMaterialButton(
                    fillColor: const Color(0xFFFFBF00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    onPressed: !isValid ? null : () {
                      submit();
                    },
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'texgyreadventor',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      endDrawer: const AppDrawer(),
    );
  }
}