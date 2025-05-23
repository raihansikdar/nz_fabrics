import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:nz_fabrics/src/common_widgets/circular_inside_button_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_text_field_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/email_verify/views/screens/email_verify_screen.dart';
import 'package:nz_fabrics/src/features/authentication/login/controller/login_controller.dart';
import 'package:nz_fabrics/src/features/authentication/register/views/screen/create_account_info_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/views/screen/ems_dashboard.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/shared_preferences/save_user_info_controller.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    final loginController = Get.find<LoginController>();
    if (loginController.saveUser && SaveUserInfoController.userEmail?.isNotEmpty == true) {
      _emailTEController.text = SaveUserInfoController.userEmail!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.06),
                SizedBox(height: size.height * k16TextSize),
                Text(
                  "NZ Fabrics",
                  style: GoogleFonts.kadwa(
                    color: AppColors.primaryColor,
                    fontSize: size.height * 0.028,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: size.height * k8TextSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(AssetsPath.leftLineIconSVG),
                    SizedBox(
                      child: DefaultTextStyle(
                        style: GoogleFonts.kavivanar(
                          color: AppColors.primaryTextColor,
                          fontSize: size.height * k16TextSize,
                          fontWeight: FontWeight.w600,
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(seconds: 3),
                          animatedTexts: [
                            TyperAnimatedText('Powered by Scube Technologies Ltd.'),
                          ],
                        ),
                      ),
                    ),
                    SvgPicture.asset(AssetsPath.rightLineIconSVG),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Image.asset(AssetsPath.loginGif, height: size.height * 0.25),
                SizedBox(height: size.height * 0.02),
                CustomTextFormFieldWidget(
                  controller:   _emailTEController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? email) {
                    if (email?.isEmpty ?? true) {
                      return "Enter your email";
                    } else if (email!.isEmail == false) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * k12TextSize),
                GetBuilder<LoginController>(builder: (loginController) {
                  return CustomTextFormFieldWidget(
                    controller: _passwordTEController,
                    hintText: 'Password',
                    obscureText: !loginController.showPassword,
                    suffixIcon: GestureDetector(
                      onTap: loginController.showPasswordMethod,
                      child: Icon(
                        loginController.showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primaryColor,
                        size: size.height * iconSize,
                      ),
                    ),
                    validator: (String? password) {
                      if (password?.isEmpty ?? true) {
                        return "Enter your password";
                      }
                      return null;
                    },
                  );
                }),
                SizedBox(height: size.height * k12TextSize),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GetBuilder<LoginController>(
                      builder: (loginController) {
                        return Row(
                          children: [
                            Checkbox(
                              value: loginController.saveUser,
                              activeColor: AppColors.primaryColor,
                              onChanged: (value) {
                                loginController.toggleSaveUser(value: value ?? false);
                              },
                            ),
                            TextComponent(
                              text: 'Save Email',
                              color: AppColors.primaryTextColor,
                              fontFamily: regularFontFamily,
                              fontSize: size.height * 0.016,
                            ),
                          ],
                        );
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => EmailVerifyScreen(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 1500));
                      },
                      child: TextComponent(
                        text: 'Forget password?',
                        textAlign: TextAlign.end,
                        color: AppColors.secondaryTextColor,
                        fontFamily: semiBoldFontFamily,
                        fontSize: size.height * 0.016,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                GetBuilder<LoginController>(
                  builder: (loginController) {
                    return ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        loginPostApiCall(loginController);
                      },
                      child: loginController.isLoginInProgress
                          ? CircularInsideButtonWidget(size: size)
                          : const Text(
                        "Login",
                        style: TextStyle(color: AppColors.whiteTextColor),
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent(
                      text: "Don't have an account? ",
                      color: AppColors.secondaryTextColor,
                      fontSize: size.height * k16TextSize,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() => const CreateAccountInfoScreen(),
                            transition: Transition.fadeIn,
                            duration: const Duration(seconds: 0));
                      },
                      child: TextComponent(
                        text: "Register Now",
                        color: AppColors.primaryColor,
                        fontFamily: semiBoldFontFamily,
                        fontSize: size.height * k18TextSize,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginPostApiCall(LoginController loginController) async {
    final response = await loginController.login(
      email: _emailTEController.text.trim(),
      password: _passwordTEController.text.trim(),
    );

    if (response) {
      AppToast.showSuccessToast("Successfully login");
      Get.offAll(() => const EmsDashboardScreen(),
          transition: Transition.fadeIn, duration: const Duration(seconds: 1));

      Future.delayed(const Duration(seconds: 2)).then((_) {
        _emailTEController.clear();
        _passwordTEController.clear();
      });
    } else {
      if (!loginController.isConnected) {
        Get.showSnackbar(
          const GetSnackBar(
            title: "No Internet Connection.",
            message: "Please turn on your Wifi or Mobile data",
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        AppToast.showWrongToast(loginController.errorMessage);
      }
    }
  }
}