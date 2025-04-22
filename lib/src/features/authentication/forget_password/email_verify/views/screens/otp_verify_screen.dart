
import 'dart:developer';

import 'package:nz_fabrics/src/common_widgets/app_bar/custom_login_appbar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/email_verify/controller/email_verify_controller.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/set_password/views/screen/set_password_screen.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerifyScreen extends StatelessWidget {
  OtpVerifyScreen({super.key});

  final  TextEditingController _otpTEController = TextEditingController();

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomLoginAppbar(text: "Forget Password", needLeading: false,),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.002,),
                Image.asset(AssetsPath.loginGif,height: size.height * 0.25,),
                SizedBox(height: size.height * k16TextSize,),

                TextComponent(text: "Fill the fields with 6 digits OTP", fontSize: size.height * k18TextSize,fontFamily: semiBoldFontFamily,color: AppColors.primaryColor,),
                SizedBox(height: size.height * 0.03,),

                PinCodeTextField(
                  controller: _otpTEController,
                  validator: (String? value){
                    if(value?.isEmpty ?? true){
                      return "Please enter the OTP code";
                    }else if(value!.length != 6){
                      return 'OTP code must be 6 digits long';
                    }
                    return null;
                  },
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight:  size.height * 0.060,
                    fieldWidth:  size.height * 0.060,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: AppColors.primaryColor,
                    activeColor: AppColors.containerBorderColor,
                    inactiveColor: AppColors.primaryColor,
                    selectedColor: Colors.transparent,
                    inactiveBorderWidth: 1.0,

                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onCompleted: (v) {
                    log("Completed");
                  },
                  onChanged: (value) {

                  },
                  beforeTextPaste: (text) {
                    return true;
                  }, appContext: context,
                ),


                SizedBox(height: size.height * 0.06,),
                GetBuilder<EmailVerifyController>(
                    builder: (emailVerifyController) {
                      return ElevatedButton(
                        onPressed: () {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          Get.to(()=> SetPasswordScreen(otp: emailVerifyController.otp,),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));

                        },
                        child: const Text(
                          "Next",
                          style: TextStyle(color: AppColors.whiteTextColor),
                        ),
                      );
                    }
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }

}