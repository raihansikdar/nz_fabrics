import 'package:nz_fabrics/src/common_widgets/app_bar/custom_login_appbar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/circular_inside_button_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_text_field_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/set_password/controller/set_password_controller.dart';
import 'package:nz_fabrics/src/features/authentication/login/views/screen/login_screen.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SetPasswordScreen extends StatefulWidget {
  final int otp;
  const SetPasswordScreen({super.key, required this.otp});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
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

                GetBuilder<SetPasswordController>(
                    builder: (setPasswordController) {
                      return CustomTextFormFieldWidget(
                        controller: _passwordTEController,
                        hintText: 'Password',  obscureText: !setPasswordController.showPassword,
                        suffixIcon: GestureDetector(
                            onTap: setPasswordController.showPasswordMethod,
                            child: Icon(setPasswordController.showPassword ? Icons.visibility : Icons.visibility_off, color: AppColors.primaryColor, size: size.height * iconSize,)),
                        validator: (String? password){
                          if(password?.isEmpty ?? true){
                            return "Enter your password";
                          }else if(password!.length < 5){
                            return "Password length must be larger than 4 characters";
                          }
                          return null;
                        },
                      );
                    }
                ),


                SizedBox(height: size.height * 0.012,),
                GetBuilder<SetPasswordController>(
                    builder: (setPasswordController) {
                      return CustomTextFormFieldWidget(
                        controller: _confirmPasswordTEController,
                        hintText: 'Confirm Password',  obscureText: !setPasswordController.showConfirmPassword,
                        suffixIcon: GestureDetector(
                            onTap: setPasswordController.showConfirmPasswordMethod,
                            child: Icon(setPasswordController.showConfirmPassword ? Icons.visibility : Icons.visibility_off, color: AppColors.primaryColor, size: size.height * iconSize,)),
                        validator: (String? confirmPassword){
                          if(confirmPassword?.isEmpty ?? true){
                            return "Enter your confirm password";
                          }else if(_passwordTEController.text != confirmPassword){
                            return "Password and Confirm Password are not same";
                          }
                          return null;
                        },
                      );
                    }
                ),


                SizedBox(height: size.height * 0.06,),
                GetBuilder<SetPasswordController>(
                    builder: (setPasswordController) {
                      return ElevatedButton(
                        onPressed: () {
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          setPasswordApiCall(setPasswordController,widget.otp);
                        },
                        child:setPasswordController.isSetPassWordInProgress ? CircularInsideButtonWidget(size: size) : const Text(
                          "Save",
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



  Future<void>setPasswordApiCall(SetPasswordController setPasswordController,int otp) async {


    final response = await setPasswordController.setPassword(
      password: _passwordTEController.text.trim(),
      otp: otp.toString(),
    );

    if(response){
      _showResetPasswordDialog(context);

      Future.delayed(const Duration(milliseconds: 2100)).then((_){
         otp = 0;
        _passwordTEController.clear();
        _confirmPasswordTEController.clear();
        Get.offAll(()=>  LoginScreen(), transition: Transition.fadeIn,duration: const Duration(seconds: 0));
      });




    }else{
      AppToast.showWrongToast(setPasswordController.errorMessage);
    }
  }


  void _showResetPasswordDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.of(context).pop();
         // Get.to(()=>OtpVerifyScreen(),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Lottie.asset(AssetsPath.successfulJson, height: size.height * 0.25),
          content: TextComponent(
            text: 'Password reset successful.',
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