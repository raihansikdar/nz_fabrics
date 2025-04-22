import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/profile/controller/update_profile_controller.dart';
import 'package:nz_fabrics/src/features/profile/controller/user_profile_controller.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String companyName;
  final String address;
  const UpdateProfileScreen({super.key, required this.name, required this.phoneNumber, required this.companyName, required this.address});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  final TextEditingController _nameTEController = TextEditingController();
 // final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _companyNameTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();



  @override
  void initState() {
    _nameTEController.text = widget.name;
    _phoneNumberTEController.text = widget.phoneNumber;
    _companyNameTEController.text = widget.companyName;
    _addressTEController.text = widget.address;
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Update Profile", backPreviousScreen: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height * k14TextSize),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.height * k16TextSize),
              border: Border.all(color: AppColors.containerBorderColor)
            ),
            child: Card(
              margin: EdgeInsets.zero,
              color: AppColors.whiteTextColor,
              child: Padding(
                padding: EdgeInsets.all(size.height * k14TextSize),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextComponent(text: "Update your profile Information",fontSize: size.height * k22TextSize,),
                      SizedBox(height: size.height * 0.01,),
                      Stack(
                        children: [
                          /*Container(
                            height: size.height * 0.150,
                            width: size.height * 0.150,
                            decoration: BoxDecoration(
                              //  color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(size.height * 0.095),
                              border: Border.all(color: AppColors.primaryColor),
                            ),
                            child:  Padding(
                              padding: EdgeInsets.all(size.height * k8TextSize),
                              child: Container(
                                height: size.height * 0.250,
                                width: size.height * 0.250,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(size.height * 0.125),
                                  border: Border.all(color: AppColors.primaryColor),
                                ),

                              ),
                            ),
                          ),*/

                          Container(
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
                                  child: SvgPicture.asset(AssetsPath.personImageSVG,),
                                ),

                              ),
                            ),
                          ),

                          /*Positioned(
                            bottom: size.height * k10TextSize,
                            right: 0,
                            child: SvgPicture.asset(AssetsPath.addCircleIconSVG,height: size.height * 0.030,),
                          )*/
                        ],
                      ),


                     SizedBox(height: size.height * k16TextSize,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          const TextComponent(text: "Name",color: AppColors.secondaryTextColor,),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.004, bottom: size.height * k16TextSize),
                            child: TextFormField(
                              controller: _nameTEController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
                                  hintText: "Write Name"
                              ),
                              validator: (String? value){
                                if(value?.isEmpty ?? true){
                                  return "This field is mandatory";
                                }else if(value!.length < 4){
                                  return "Name must be greater than 4 digit";
                                }
                                return null;
                              },
                            ),
                          ),

                          // const TextComponent(text: "Email",color: AppColors.secondaryTextColor,),
                          // Padding(
                          //   padding: EdgeInsets.only(top: size.height * 0.004, bottom: size.height * k16TextSize),
                          //   child: TextFormField(
                          //     controller: _emailTEController,
                          //     decoration: InputDecoration(
                          //       contentPadding: EdgeInsets.symmetric(horizontal:size.height * k16TextSize),
                          //       hintText: "Enter User Email",
                          //      // suffixIcon: createUserController.isEmailError ? const Icon(Icons.error_outline) : null,
                          //     ),
                          //     onChanged: (String? value){
                          //       if(value!.isEmail == true){
                          //         //createUserController.changeErrorCondition(emailErrorValue: false);
                          //       }
                          //       if(value.isEmail == false){
                          //        // createUserController.changeErrorCondition(emailErrorValue: true);
                          //       }
                          //       if(value.isEmpty){
                          //        // createUserController.changeErrorCondition(emailErrorValue: false);
                          //       }
                          //     },
                          //     validator: (String? value){
                          //       if(value?.isEmpty ?? true){
                          //         return "This field is mandatory";
                          //       }else if(value!.isEmail == false){
                          //         //createUserController.changeErrorCondition(emailErrorValue: true);
                          //         return "Enter valid email address";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),

                          const TextComponent(text: "Phone Number",color: AppColors.secondaryTextColor,),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.004, bottom: size.height * k16TextSize),
                            child: GetBuilder<UpdateProfileController>(
                              builder: (updateProfileController) {
                                return TextFormField(
                                  controller: _phoneNumberTEController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
                                    hintText: "Enter User Phone Number",
                                    suffixIcon: updateProfileController.isPhoneNumberError ? const Icon(Icons.error_outline) : null,
                                  ),
                                  onChanged: (String? value){
                                    if(value!.isEmpty){
                                      updateProfileController.changePhoneNumberCondition(phoneNumberErrorValue: false);
                                    }
                                    if( value.isNotEmpty && value.length != 11 ){
                                      updateProfileController.changePhoneNumberCondition(phoneNumberErrorValue: true);
                                    }
                                    if( value.length == 11 ){
                                      updateProfileController.changePhoneNumberCondition(phoneNumberErrorValue: false);
                                    }
                                  },
                                  validator: (String? value){
                                    if(value?.isEmpty ?? true){
                                      return "This field is mandatory";
                                    } if( value!.length != 11 ){
                                      return "Phone number is must be 11 digit";
                                    }
                                    return null;
                                  },
                                );
                              }
                            ),
                          ),

                          const TextComponent(text: "Company Name",color: AppColors.secondaryTextColor,),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.004, bottom: size.height * k16TextSize),
                            child: TextFormField(
                              controller: _companyNameTEController,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
                                hintText: "Enter User Company Name",

                              ),
                              validator: (String? value){
                                if(value?.isEmpty ?? true){
                                  return "This field is mandatory";
                                }
                                return null;
                              },
                            ),
                          ),


                          const TextComponent(text: "Address",color: AppColors.secondaryTextColor,),
                          Padding(
                            padding: EdgeInsets.only(top: size.height * 0.004, bottom: size.height *k50TextSize),
                            child: TextFormField(
                              controller: _addressTEController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize),
                                  hintText: "Write User Address"
                              ),
                              validator: (String? value){
                                if(value?.isEmpty ?? true){
                                  return "This field is mandatory";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                        child: GetBuilder<UpdateProfileController>(
                          builder: (updateProfileController) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k12TextSize))
                              ),
                              onPressed: (){
                                if(!_formKey.currentState!.validate()){
                                  return;
                                }
                                updateProfile(updateProfileController);
                              }, child: const TextComponent(text: "Update Done",color: AppColors.whiteTextColor),
                            );
                          }
                        ),
                      ),
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
  
  
 Future<void>updateProfile(UpdateProfileController updateProfileController) async {
  final response = await  updateProfileController.putUpdateProfile(
       name: _nameTEController.text.trim(), 
       phoneNumber: _phoneNumberTEController.text.trim(), 
       companyName: _companyNameTEController.text.trim(), 
       address: _addressTEController.text.trim(),
   );
  
   if(response){
     AppToast.showSuccessToast("User profile updated successfully");
     _nameTEController.clear();
     _phoneNumberTEController.clear();
     _companyNameTEController.clear();
     _addressTEController.clear();

     Get.find<UserProfileController>().fetchUserProfileData();
     Navigator.pop(context);
   }else{
     AppToast.showWrongToast(updateProfileController.errorMessage);
   }
  
 }
  
  
  
}
