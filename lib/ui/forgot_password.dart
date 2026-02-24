import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:vesalius_dr_flutter/components/app_shared.dart';
import 'package:vesalius_dr_flutter/components/inner_page.dart';
import 'package:vesalius_dr_flutter/constants.dart';
import 'package:vesalius_dr_flutter/controllers/forgot_password_ctrl.dart';

import 'sign_in.dart';

class ForgotPassword extends StatefulWidget {
  
  static const String routeName = '/ForgotPassword';

  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final formKey = GlobalKey<FormState>();
  late final TextEditingController txtemail;

  final ForgotPasswordCtrl ctrl = Get.put(ForgotPasswordCtrl());

  @override
  void initState() {
    super.initState();
    txtemail = TextEditingController();
  }

  @override
  void dispose() {
    txtemail.dispose();
    super.dispose();
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

  void showSuccess() async {
    Get.dialog(AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              'Success',
              style: kTextStyle1.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: kTextColor1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Text(
              'A new password has been sent to your registered email address. Please login using the new password.',
              style: kTextStyle1.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: kTextColor2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25.0),
            AppElevatedButton(
              text: 'Back to Login',
              onPressed: () {
                Get.back();
                Get.back();
              },
            ),
          ],
        ),
      ),
    ));
  }

  void onSubmit() {
    showSuccess();
  }

  Widget buildForm() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 134.0),
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
                      'Email',
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
                      validator: ValidationBuilder().required('Email is required').minLength(1, 'Email is required').build(),
                      controller: txtemail,
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
                        hintText: 'e.g doctor@abc.com',
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
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: kBgColor1,
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() =>
                  AppElevatedButton(
                    text: 'Send New Password',
                    onPressed: !ctrl.isValid ? null : onSubmit,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password?',
                      style: kTextStyle1.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: kTextColor1,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => const SignIn());
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimaryColor,
                      ),
                      child: Text(
                        'Log In',
                        style: kTextStyle1.copyWith(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: kPrimaryColor,
                          decorationThickness: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InnerPage(
      title: 'Forgot Password',
      body: Obx(() =>
        ModalProgressHUD(
          inAsyncCall: ctrl.isLoading,
          blur: kBlur,
          progressIndicator: const AppActivityIndicator(),
          child: SafeArea(
            child: buildForm(),
          ),
        ),
      ),
    );
  }
}