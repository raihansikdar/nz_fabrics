import 'package:flutter_svg/svg.dart';
import 'package:nz_fabrics/src/common_widgets/app_bar/custom_login_appbar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_text_field_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/authentication/login/views/screen/login_screen.dart';
import 'package:nz_fabrics/src/features/authentication/register/controller/create_account_info_controller.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CreateAccountInfoScreen extends StatefulWidget {
  const CreateAccountInfoScreen({super.key});

  @override
  State<CreateAccountInfoScreen> createState() => _CreateAccountInfoScreenState();
}

class _CreateAccountInfoScreenState extends State<CreateAccountInfoScreen> {

  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _companyNameTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();

  final GlobalKey <FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomLoginAppbar(text: "Create an Account ", needLeading: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height * k16TextSize),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               // TabContainerWidget(size: _size, color1: AppColors.primaryTextColor,color2: AppColors.accountTabContainerColor, color3:  AppColors.accountTabContainerColor,),

                SizedBox(height: size.height * k16TextSize),
                GetBuilder<CreateAccountInfoController>(
                  builder: (createAccountInfoController) {
                    return GestureDetector(
                      onTap: createAccountInfoController.pickImageMethod,
                      child: Center(
                        child: Container(
                          height: size.height * 0.150,
                          width: size.height * 0.150,
                          decoration: BoxDecoration(
                            //  color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(size.height * 0.095),
                            border: Border.all(color: Colors.grey.shade500,),
                          ),
                          child:  Padding(
                            padding: EdgeInsets.all(size.height * k8TextSize),
                            child: Container(
                              height: size.height * 0.250,
                              width: size.height * 0.250,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade500,
                                borderRadius: BorderRadius.circular(size.height * 0.125),
                                border: Border.all(color: Colors.grey.shade500,),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SvgPicture.asset(AssetsPath.personImageSVG,fit: BoxFit.cover,),
                              ),

                            ),
                          ),
                        ),
                        /*Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2.0, // Border width
                            ),
                          ),
                          child: CircleAvatar(
                            radius: size.height * 0.055,
                            backgroundColor: Colors.white,
                            backgroundImage: createAccountInfoController.pikeImage != null ? FileImage(createAccountInfoController.pikeImage!) : null,
                            child: createAccountInfoController.pikeImage == null ? Column(
                              children: [
                                SizedBox(height: size.height * k16TextSize),
                                // SvgPicture.asset(
                                //   AssetsPath.cameraIconSVG,
                                //   width: size.height * 0.03,
                                // ),

                                SizedBox(height: size.height * 0.003),

                                TextComponent(
                                  text: "Add",
                                  color: AppColors.secondaryTextColor,
                                  fontSize: size.height * k13TextSize,
                                  fontFamily: mediumFontFamily,
                                ),
                                TextComponent(
                                  text: "your Photo",
                                  color: AppColors.secondaryTextColor,
                                  fontSize: size.height * k13TextSize,
                                  fontFamily: mediumFontFamily,
                                ),
                              ],
                            )
                                : null,
                          ),
                        ),*/
                      ),
                    );
                  },
                ),

                SizedBox(height: size.height * k30TextSize),
                CustomTextFormFieldWidget(
                  controller: _nameTEController,
                  hintText: "Name",  keyboardType: TextInputType.name,
                  validator: (String? name){
                    if(name?.isEmpty ?? true){
                      return "Enter your name";
                    }else if(name!.length < 4){
                      return "Name must be greater than 4 letter";
                    }
                    return null;
                  },
                ),

                SizedBox(height: size.height * k12TextSize,),

                GetBuilder<CreateAccountInfoController>(
                  builder: (createAccountInfoController) {
                    return CustomTextFormFieldWidget(
                      controller: _emailTEController,
                      hintText: 'E-mail', keyboardType: TextInputType.emailAddress,
                      suffixIcon: createAccountInfoController.isEmailError ? const Icon(Icons.error_outline,color: AppColors.primaryColor,) : null,
                      onChanged: (String? value){
                        if(value!.isEmail == true){
                          createAccountInfoController.changeErrorCondition(emailErrorValue: false);
                        }
                        if(value.isEmail == false){
                          createAccountInfoController.changeErrorCondition(emailErrorValue: true);
                        }
                        if(value.isEmpty){
                          createAccountInfoController.changeErrorCondition(emailErrorValue: false);
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

                SizedBox(height: size.height * k12TextSize),
                GetBuilder<CreateAccountInfoController>(
                  builder: (createAccountInfoController) {
                    return CustomTextFormFieldWidget(
                      controller: _phoneNumberTEController,
                      keyboardType: TextInputType.number,
                      hintText: "Phone Number",
                      suffixIcon: createAccountInfoController.isPhoneNumberError ? const Icon(Icons.error_outline,color: AppColors.primaryColor,) : null,
                      onChanged: (String? value){
                        if(value!.isEmpty){
                          createAccountInfoController.changePhoneNumberCondition(phoneNumberErrorValue: false);
                        }
                        if( value.isNotEmpty && value.length != 11 ){
                          createAccountInfoController.changePhoneNumberCondition(phoneNumberErrorValue: true);
                        }
                        if( value.length == 11 ){
                          createAccountInfoController.changePhoneNumberCondition(phoneNumberErrorValue: false);
                        }
                      },
                      validator: (String? phoneNumber){
                        if(phoneNumber?.isEmpty ?? true){
                          return "Enter your phone number";
                        }else if(phoneNumber!.isPhoneNumber == false){
                          return "Enter valid phone number";
                        }
                        else if(phoneNumber.length != 11 ){
                          return "Phone number must be 11 digit";
                        }
                        return null;
                      },
                    );
                  }
                ),

                SizedBox(height: size.height * k12TextSize,),

                GetBuilder<CreateAccountInfoController>(builder: (createAccountInfoController) {
                  return CustomTextFormFieldWidget(
                    controller: _passwordTEController,
                    hintText: 'Password',  obscureText: !createAccountInfoController.showPassword,
                    suffixIcon: GestureDetector(
                      onTap: createAccountInfoController.showPasswordMethod,
                      child: Icon(
                        createAccountInfoController.showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.primaryColor,
                        size: size.height * iconSize,
                      ),
                    ),
                    validator: (String? password){
                      if(password?.isEmpty ?? true){
                        return "Enter your password";
                      }
                      return null;
                    },

                  );
                }),



                SizedBox(height: size.height * k12TextSize),
                CustomTextFormFieldWidget(
                  controller: _companyNameTEController,
                  hintText: "Company Name",  keyboardType: TextInputType.name,
                  validator: (String? name){
                    if(name?.isEmpty ?? true){
                      return "Enter your name";
                    }else if(name!.length < 4){
                      return "Name must be greater than 4 letter";
                    }
                    return null;
                  },
                ),


                SizedBox(height: size.height * k12TextSize),

                SizedBox(height: size.height * k12TextSize),
                TextFormField(
                  controller: _addressTEController,
                  style:  TextStyle(color: AppColors.primaryTextColor,fontFamily: mediumFontFamily,fontSize:  size.height *k18TextSize),
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Your Address',
                  ),
                  validator: (String? address){
                    if(address?.isEmpty ?? true){
                      return "Enter your present address";
                    }
                    return null;
                  },
                ),



                SizedBox(height: size.height * 0.040),
                GetBuilder<CreateAccountInfoController>(
                  builder: (createAccountInfoController) {
                    return ElevatedButton(
                      onPressed: () {
                        if(!_formKey.currentState!.validate() /*|| !_validateImage()*/){
                          return;
                        }
                        createOwnAccount(createAccountInfoController,context);
                      },
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: AppColors.whiteTextColor),
                      ),
                    );
                  }
                ),
                SizedBox(height:size.height *  0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextComponent(
                      text: "Already have an account? ",
                      color: AppColors.secondaryTextColor,
                      fontSize: size.height * k16TextSize,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(() =>  LoginScreen(),transition: Transition.fadeIn,duration: const Duration(seconds: 0));
                      },
                      child:  TextComponent(
                        text: "Login",
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

  // bool _validateImage() {
  //   if (Get.find<CreateAccountInfoController>().pikeImage == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please upload a profile picture'),
  //         backgroundColor: Colors.black,
  //       ),
  //     );
  //     return false;
  //   }
  //   return true;
  // }




  void _showCreateAccountDialog(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 3000), () {
          Navigator.of(context).pop();
           Get.offAll(()=>LoginScreen(),transition: Transition.fadeIn,duration: const Duration(seconds: 1));
        });
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Lottie.asset(AssetsPath.successfulJson,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextComponent(
                text: 'Account creation successful.',
                fontSize: size.height * k16TextSize,
                fontFamily: mediumFontFamily,
                color: AppColors.primaryTextColor,
                textAlign: TextAlign.center,
              ),
              TextComponent(
                text: 'Please wait for Admin approval.',
                fontSize: size.height * k20TextSize,
                fontFamily: semiBoldFontFamily,
                color: AppColors.primaryColor,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> createOwnAccount(CreateAccountInfoController createAccountInfoController,context) async {
    final response = await createAccountInfoController.createOwnAccount(
      name: _nameTEController.text.trim(),
      email: _emailTEController.text.trim(),
      phoneNumber: _phoneNumberTEController.text.trim(),
      password: _passwordTEController.text,
      companyName: _companyNameTEController.text.trim(),
      address: _addressTEController.text.trim(),
    );

    if(response){
     // AppToast.showSuccessToast("Successfully user account created and password has benn sent in your email.");
      _nameTEController.clear();
      _emailTEController.clear();
      _phoneNumberTEController.clear();
      _passwordTEController.clear();
      _companyNameTEController.clear();
      _addressTEController.clear();
      _showCreateAccountDialog(context);

    }else{
      AppToast.showWrongToast(createAccountInfoController.errorMessage);
    }
  }


}