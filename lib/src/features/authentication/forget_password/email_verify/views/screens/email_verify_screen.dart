import 'package:nz_fabrics/src/common_widgets/app_bar/custom_login_appbar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/circular_inside_button_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_text_field_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/email_verify/controller/email_verify_controller.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/email_verify/views/screens/otp_verify_screen.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class EmailVerifyScreen extends StatelessWidget {
  EmailVerifyScreen({super.key});

  final TextEditingController _emailTEController = TextEditingController();

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return  Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.whiteTextColor,
      appBar: const CustomLoginAppbar(text: "Forget Password", needLeading: false,),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04,),
                Image.asset(AssetsPath.loginGif,height: size.height * 0.25,),
                SizedBox(height: size.height * 0.0616,),

                GetBuilder<EmailVerifyController>(
                  builder: (emailVerifyController) {
                    return CustomTextFormFieldWidget(
                      controller: _emailTEController,
                      hintText: 'E-mail', keyboardType: TextInputType.emailAddress,
                      suffixIcon: emailVerifyController.isEmailError ? const Icon(Icons.error_outline,color: AppColors.primaryColor,) : null,
                      onChanged: (String? value){
                        if(value!.isEmail == true){
                          emailVerifyController.changeErrorCondition(emailErrorValue: false);
                        }
                        if(value.isEmail == false){
                          emailVerifyController.changeErrorCondition(emailErrorValue: true);
                        }
                        if(value.isEmpty){
                          emailVerifyController.changeErrorCondition(emailErrorValue: false);
                        }
                      },
                      validator: (String? email){
                        if(email?.isEmpty ?? true){
                          return "Enter your email";
                        }else if(email!.isEmail == false){
                          return "Enter valid email";
                        }
                        return null;
                      },
                    );
                  }
                ),

                SizedBox(height: size.height * k12TextSize,),
                TextComponent(text: "You will get an OTP Code on your provided email", fontSize: size.height * k14TextSize,fontFamily: regularFontFamily,),
                SizedBox(height: size.height * 0.06,),
                GetBuilder<EmailVerifyController>(
                    builder: (emailVerifyController) {
                      return ElevatedButton(
                        onPressed: () {
                          // if(!_formKey.currentState!.validate()){
                          //   return;
                          // }
                         // _showEmailVerifyDialog(context);
                          verifyEmailPostApiCall(context,emailVerifyController);
                        },
                        child:emailVerifyController.isEmailVerifyInProgress ? CircularInsideButtonWidget(size: size) : const Text(
                          "Send",
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




  Future<void>verifyEmailPostApiCall(BuildContext context,EmailVerifyController emailVerifyController) async {

    final response = await emailVerifyController.verifyEmail(
      email: _emailTEController.text.trim(),
    );

    if(response){
      _showEmailVerifyDialog(context);

      Future.delayed(const Duration(milliseconds: 3600)).then((_){
        _emailTEController.clear();
        Get.to(()=>OtpVerifyScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
      });


    }else{
      AppToast.showWrongToast(emailVerifyController.errorMessage);
  }
 }




  void _showEmailVerifyDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 3500), () {
          Navigator.of(context).pop();
          Get.to(()=>OtpVerifyScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Lottie.asset(AssetsPath.emailJson, height: size.height * 0.16),
          content: TextComponent(
            text: 'Check your email to get OTP',
            fontSize: size.height * k16TextSize,
            fontFamily: mediumFontFamily,
            color: AppColors.primaryTextColor,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

}