import 'dart:async';

import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/profile/controller/change_password_controller.dart';
import 'package:nz_fabrics/src/features/profile/controller/user_profile_controller.dart';
import 'package:nz_fabrics/src/features/profile/views/screens/update_profile_screen.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<UserProfileController>().fetchUserProfileData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Profile", backPreviousScreen: true),


      body: Padding(
        padding: EdgeInsets.all(size.height * k8TextSize),
        child: CustomContainer(
         height: size.height * 0.72,
          width: double.infinity,
          borderRadius: BorderRadius.circular(size.height * k12TextSize),
          child: Padding(
            padding: EdgeInsets.only(top: size.height * k16TextSize,left: size.height * k16TextSize,bottom: size.height * k16TextSize,right: size.height * 0.004),
            child: SingleChildScrollView(
              child: GetBuilder<UserProfileController>(
                builder: (userProfileController) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextComponent(text: "General Information",fontSize: size.height * k25TextSize,),
                      SizedBox(height: size.height * 0.01,),
                      Stack(
                        children: [
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
                                  child: SvgPicture.asset(AssetsPath.personImageSVG,fit: BoxFit.cover,),
                                ),

                              ),
                            ),
                          ),
                          // Positioned(
                          //     bottom: size.height * k10TextSize,
                          //     right: 0,
                          //     child: SvgPicture.asset(AssetsPath.addCircleIconSVG,height: size.height * 0.030,),
                          // )
                        ],
                      ),

                      SizedBox(height: size.height * 0.03,),
                      SizedBox(
                        height: size.height * 0.300,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextComponent(text: "Name",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: "Phone No",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: "Email",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: "Status",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: "Company Name",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: "Address",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                              ],
                            ),


                            SizedBox(width: size.width * 0.03,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                                TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                SizedBox(height: size.height * k10TextSize,),
                              ],
                            ),
                            SizedBox(width: size.width * 0.03,),
                            SizedBox(
                              width: size.width * 0.54,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextComponent(text: userProfileController.userProfileList.firstName ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                  SizedBox(height: size.height * k10TextSize,),
                                  TextComponent(text: userProfileController.userProfileList.phoneNo ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                  SizedBox(height: size.height * k10TextSize,),
                                  TextComponent(text: userProfileController.userProfileList.email ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                  SizedBox(height: size.height * k10TextSize,),
                                  TextComponent(text: "Admin",color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                  SizedBox(height: size.height * k10TextSize,),
                                  TextComponent(text: userProfileController.userProfileList.companyName ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                  SizedBox(height: size.height * k10TextSize,),
                                  SizedBox(
                                    width: size.width * 0.43,
                                    child: TextComponent(text: userProfileController.userProfileList.address ?? '',
                                      color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,
                                      maxLines: 4,overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: size.height * k10TextSize,),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),


                      SizedBox(height: size.height * k30TextSize,),

                      Padding(
                        padding: EdgeInsets.only(right: size.height * k12TextSize),
                        child: SizedBox(
                          height: size.height * 0.05,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k12TextSize))
                              ),
                              onPressed: (){
                                Get.to(()=> UpdateProfileScreen(
                                  name:  userProfileController.userProfileList.firstName ?? '',
                                  phoneNumber:  userProfileController.userProfileList.phoneNo ?? '',
                                  companyName:  userProfileController.userProfileList.companyName ?? '',
                                  address:  userProfileController.userProfileList.address ?? '',
                                ),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                              }, child: const TextComponent(text: "Update Profile",color: AppColors.whiteTextColor),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * k16TextSize,),
                      Padding(
                        padding: EdgeInsets.only(right: size.height * k12TextSize),
                        child: SizedBox(
                          height: size.height * 0.05,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.whiteTextColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k12TextSize))
                            ),
                            onPressed: (){
                              _showCustomAlertDialog(context,size);
                            }, child: const TextComponent(text: "Change Password",color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }




  void _showCustomAlertDialog(BuildContext context,Size size) {
    final TextEditingController oldPasswordTEController = TextEditingController();
    final TextEditingController newPasswordTEController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k8TextSize)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Spacer(),
               TextComponent(text: 'Change Password',fontFamily: boldFontFamily,fontSize: size.height * k18TextSize,),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.clear),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: GetBuilder<ChangePasswordController>(
              builder: (changePasswordController) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.004),
                      child: const TextComponent(text: "Old Password",color: AppColors.secondaryTextColor,),
                    ),
                    SizedBox(
                      height: size.height * 0.045,
                      child: TextFormField(
                        controller: oldPasswordTEController,
                        obscureText: changePasswordController.showOldPassword ? false : true,
                        decoration: InputDecoration(
                          contentPadding:  EdgeInsets.only(top:size.height * 0.002,left: size.height * k12TextSize,right: size.height * k12TextSize),
                          hintText: 'Password',
                          suffixIcon: GestureDetector(
                              onTap: (){
                                changePasswordController.showOldPasswordMethod();
                              },
                              child: Icon(changePasswordController.showOldPassword ? Icons.visibility : Icons.visibility_off ,color: AppColors.primaryColor,)
                          ),
                        ),
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return "This field is mandatory";
                          }if(value!.length <5){
                            return "Password will grater then 4 digit";
                          }
                          return null;
                        },
                      ),
                    ),
                     SizedBox(height: size.height * k10TextSize),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.004),
                      child: const TextComponent(text: "New Password",color: AppColors.secondaryTextColor,),
                    ),
                    SizedBox(
                      height: size.height * 0.045,
                      child: TextFormField(
                        controller: newPasswordTEController,
                        obscureText: changePasswordController.showNewPassword ? false : true,
                        decoration: InputDecoration(
                            contentPadding:  EdgeInsets.only(top:size.height * 0.002,left: size.height * k12TextSize,right: size.height * k12TextSize),
                          hintText: 'New Password',

                            suffixIcon:GestureDetector(
                                onTap: (){
                                    changePasswordController.showNewPasswordMethod();
                                },
                                child: Icon(changePasswordController.showNewPassword ? Icons.visibility : Icons.visibility_off ,color: AppColors.primaryColor,))
                        ),
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return "This field is mandatory";
                          }
                          if(value!.length <5){
                            return "Password will grater then 4 digit";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
          actions: [
            SizedBox(
              height: size.height * 0.040,
              child: GetBuilder<ChangePasswordController>(
                builder: (changePasswordController) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.height * k8TextSize)
                      )
                    ),
                    onPressed: () async {
                      if(!formKey.currentState!.validate()){
                        return;
                      }
                     final response =  await changePasswordController.changePassword(oldPassword: oldPasswordTEController.text.trim(), newPassword: newPasswordTEController.text.trim());

                      if(response){
                        AppToast.showSuccessToast("Successfully changed password");
                        Navigator.of(context).pop();
                      }else{
                        AppToast.showWrongToast(changePasswordController.errorMessage);
                      }
                     
                    },
                    child: const TextComponent(text: 'Save',color: AppColors.whiteTextColor,),
                  );
                }
              ),
            ),
          ],
        );
      },
    );
  }



}

/*
* import 'dart:async';

import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/profile/controller/change_password_controller.dart';
import 'package:nz_fabrics/src/features/profile/controller/user_profile_controller.dart';
import 'package:nz_fabrics/src/features/profile/views/screens/update_profile_screen.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
 Timer? _timer;
 bool needApiCall = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Get.find<UserProfileController>().fetchUserProfileData();
      _timer = Timer.periodic(Duration(seconds: 10), (timer){
       setState(() {
         needApiCall = true;
       });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Profile", backPreviousScreen: true),


      body: Padding(
        padding: EdgeInsets.all(size.height * k8TextSize),
        child: CustomContainer(
         height: size.height * 0.72,
          width: double.infinity,
          borderRadius: BorderRadius.circular(size.height * k12TextSize),
          child: Padding(
            padding: EdgeInsets.only(top: size.height * k16TextSize,left: size.height * k16TextSize,bottom: size.height * k16TextSize,right: size.height * 0.004),
            child: SingleChildScrollView(
              child: GetBuilder<UserProfileController>(
                builder: (userProfileController) {
                  return Stack(
                    children: [

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          TextComponent(text: "General Information",fontSize: size.height * k25TextSize,),
                          SizedBox(height: size.height * 0.01,),
                          Stack(
                            children: [
                              Container(
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
                              ),
                              Positioned(
                                  bottom: size.height * k10TextSize,
                                  right: 0,
                                  child: SvgPicture.asset(AssetsPath.addCircleIconSVG,height: size.height * 0.030,),
                              )
                            ],
                          ),

                          SizedBox(height: size.height * 0.03,),
                          SizedBox(
                            height: size.height * 0.300,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextComponent(text: "Name",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: "Phone No",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: "Email",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: "Status",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: "Company Name",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: "Address",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                  ],
                                ),


                                SizedBox(width: size.width * 0.03,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                    TextComponent(text: ":",color: AppColors.secondaryTextColor,fontSize: size.height *k18TextSize,),
                                    SizedBox(height: size.height * k10TextSize,),
                                  ],
                                ),
                                SizedBox(width: size.width * 0.03,),
                                SizedBox(
                                  width: size.width * 0.54,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextComponent(text: userProfileController.userProfileList.firstName ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                      SizedBox(height: size.height * k10TextSize,),
                                      TextComponent(text: userProfileController.userProfileList.phoneNo ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                      SizedBox(height: size.height * k10TextSize,),
                                      TextComponent(text: userProfileController.userProfileList.email ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                      SizedBox(height: size.height * k10TextSize,),
                                      TextComponent(text: "Admin",color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                      SizedBox(height: size.height * k10TextSize,),
                                      TextComponent(text: userProfileController.userProfileList.companyName ?? '',color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,),
                                      SizedBox(height: size.height * k10TextSize,),
                                      SizedBox(
                                        width: size.width * 0.43,
                                        child: TextComponent(text: userProfileController.userProfileList.address ?? '',
                                          color: AppColors.primaryTextColor,fontSize: size.height *k18TextSize,
                                          maxLines: 4,overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: size.height * k10TextSize,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),


                          SizedBox(height: size.height * k30TextSize,),

                          Padding(
                            padding: EdgeInsets.only(right: size.height * k12TextSize),
                            child: SizedBox(
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k12TextSize))
                                  ),
                                  onPressed: (){
                                    Get.to(()=> UpdateProfileScreen(
                                      name:  userProfileController.userProfileList.firstName ?? '',
                                      phoneNumber:  userProfileController.userProfileList.phoneNo ?? '',
                                      companyName:  userProfileController.userProfileList.companyName ?? '',
                                      address:  userProfileController.userProfileList.address ?? '',
                                    ),transition: Transition.rightToLeft,duration: const Duration(seconds: 1));
                                  }, child: const TextComponent(text: "Update Profile",color: AppColors.whiteTextColor),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * k16TextSize,),
                          Padding(
                            padding: EdgeInsets.only(right: size.height * k12TextSize),
                            child: SizedBox(
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.whiteTextColor,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k12TextSize))
                                ),
                                onPressed: (){
                                  _showCustomAlertDialog(context,size);
                                }, child: const TextComponent(text: "Change Password",color: AppColors.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0 ,
                        child: needApiCall ?  Center(
                          child: SizedBox(
                            height: 30,
                            width: 100,
                            child: ElevatedButton(onPressed: (){
                              Get.find<UserProfileController>().fetchUserProfileData();
                              setState(() {
                                needApiCall = false;
                              });
                            }, child: TextComponent(text: "text",color: AppColors.whiteTextColor,)),
                          ),
                        ) :SizedBox(),),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }




  void _showCustomAlertDialog(BuildContext context,Size size) {
    final TextEditingController oldPasswordTEController = TextEditingController();
    final TextEditingController newPasswordTEController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k8TextSize)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Spacer(),
              const TextComponent(text: 'Change Password'),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.clear),
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: GetBuilder<ChangePasswordController>(
              builder: (changePasswordController) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.004),
                      child: const TextComponent(text: "Old Password",color: AppColors.secondaryTextColor,),
                    ),
                    TextFormField(
                      controller: oldPasswordTEController,
                      obscureText: changePasswordController.showOldPassword ? false : true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: GestureDetector(
                            onTap: (){
                              changePasswordController.showOldPasswordMethod();
                            },
                            child: Icon(changePasswordController.showOldPassword ? Icons.visibility : Icons.visibility_off ,color: AppColors.primaryColor,)
                        ),
                      ),
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }if(value!.length <5){
                          return "Password will grater then 4 digit";
                        }
                        return null;
                      },
                    ),
                     SizedBox(height: size.height * k10TextSize),
                    Padding(
                      padding: EdgeInsets.only(left: size.height * 0.004),
                      child: const TextComponent(text: "New Password",color: AppColors.secondaryTextColor,),
                    ),
                    TextFormField(
                      controller: newPasswordTEController,
                      obscureText: changePasswordController.showNewPassword ? false : true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',

                          suffixIcon:GestureDetector(
                              onTap: (){
                                  changePasswordController.showNewPasswordMethod();
                              },
                              child: Icon(changePasswordController.showNewPassword ? Icons.visibility : Icons.visibility_off ,color: AppColors.primaryColor,))
                      ),
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }
                        if(value!.length <5){
                          return "Password will grater then 4 digit";
                        }
                        return null;
                      },
                    ),
                  ],
                );
              }
            ),
          ),
          actions: [
            SizedBox(
              height: size.height * 0.040,
              child: GetBuilder<ChangePasswordController>(
                builder: (changePasswordController) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(size.height * k8TextSize)
                      )
                    ),
                    onPressed: () async {
                      if(!formKey.currentState!.validate()){
                        return;
                      }
                     final response =  await changePasswordController.changePassword(oldPassword: oldPasswordTEController.text.trim(), newPassword: newPasswordTEController.text.trim());

                      if(response){
                        AppToast.showSuccessToast("Successfully changed password");
                        Navigator.of(context).pop();
                      }else{
                        AppToast.showWrongToast(changePasswordController.errorMessage);
                      }

                    },
                    child: const TextComponent(text: 'Save',color: AppColors.whiteTextColor,),
                  );
                }
              ),
            ),
          ],
        );
      },
    );
  }



}




*/


