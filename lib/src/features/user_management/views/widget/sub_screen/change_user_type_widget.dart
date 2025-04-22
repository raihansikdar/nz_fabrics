import 'package:flutter_svg/svg.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_radio_button/custom_radio_button.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/user_management/controller/change_user_type/change_user_type_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/change_user_type/grant_admin_permission_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/delete_pending_user_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeUserTypeWidget extends StatefulWidget {
  const ChangeUserTypeWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<ChangeUserTypeWidget> createState() => _ChangeUserTypeWidgetState();
}

class _ChangeUserTypeWidgetState extends State<ChangeUserTypeWidget> {
  double width = -200;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Get.find<ChangeUserTypeController>().startAnimation();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:  widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top:widget.size.height * k25TextSize ),
      child: GetBuilder<ChangeUserTypeController>(
        builder: (changeUserTypeController) {
          return Column(
            children: [

             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [

                 Row(
                   children: [
                     CustomRectangularRadioButton<int>(
                       value: 1,
                       groupValue: changeUserTypeController.selectedButton,
                       onChanged: (value) {
                         changeUserTypeController.updateSelectedButton(value: value!);
                       },
                       label: 'All',
                     ),
                   ],
                 ),

                 Row(
                   children: [
                     CustomRectangularRadioButton<int>(
                       value: 2,
                       groupValue: changeUserTypeController.selectedButton,
                       onChanged: (value) {
                         changeUserTypeController.updateSelectedButton(value: value!);
                       },
                       label: 'Super Admin',
                     ),
                   ],
                 ),

                 Row(
                   children: [
                     CustomRectangularRadioButton<int>(
                       value: 3,
                       groupValue: changeUserTypeController.selectedButton,
                       onChanged: (value) {
                         changeUserTypeController.updateSelectedButton(value: value!);
                       },
                       label: 'Admin',
                     ),
                   ],
                 ),

                 Row(
                   children: [
                     CustomRectangularRadioButton<int>(
                       value: 4,
                       groupValue: changeUserTypeController.selectedButton,
                       onChanged: (value) {
                         changeUserTypeController.updateSelectedButton(value: value!);
                       },
                       label: 'User',
                     ),
                   ],
                 ),
               ],
             ),

              SizedBox(height: widget.size.height * k16TextSize,),
              Expanded(
                child: changeUserTypeController.selectedButton == 1 ?  RefreshIndicator(
                  onRefresh: ()async{
                    await Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: widget.size.height * k20TextSize),
                    itemCount: changeUserTypeController.isApprovedUserInProgress ? 4 :  changeUserTypeController.approvedUserList.length,
                    itemBuilder: (context,index){

                      if(changeUserTypeController.isApprovedUserInProgress){
                        return  Padding(
                          padding: EdgeInsets.all(widget.size.height * k8TextSize),
                          child: CustomShimmerWidget(height: widget.size.height * 0.22 , width: double.infinity,),
                        );
                      }
                      if(changeUserTypeController.approvedUserList.isEmpty){
                        return EmptyPageWidget(size: widget.size);
                      }
                     // final double startOffset = index % 2 == 0 ? -width : width;
                      return AnimatedContainer(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        duration:  Duration(milliseconds: 1200 + (index * 250)),
                        curve: Curves.easeInOutCubic,
                        transform: Matrix4.translationValues(changeUserTypeController.myAnimation ?  0 : width, 0, 0),
                        child: CustomContainer(
                          height: widget.size.height * 0.215,
                          width: double.infinity,
                          borderRadius: BorderRadius.circular(widget.size.height * k8TextSize),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top: widget.size.height * k16TextSize),
                                child: Row(
                                  children: [

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const TextComponent(text: "ID",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        const TextComponent(text: "Name",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        const TextComponent(text: "Email",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        const TextComponent(text: "Role",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                      ],
                                    ),
                                    SizedBox(width: widget.size.width * k50TextSize,),
                                    Column(
                                      children: [
                                        const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),

                                      ],
                                    ),
                                    SizedBox(width: widget.size.width * k50TextSize,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextComponent(text: changeUserTypeController.approvedUserList[index].id.toString(),color: AppColors.primaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        TextComponent(text: changeUserTypeController.approvedUserList[index].firstName ?? '',color: AppColors.primaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                        TextComponent(text: changeUserTypeController.approvedUserList[index].email ?? '',color: AppColors.primaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                       (changeUserTypeController.approvedUserList[index].isSuperuser == true &&  changeUserTypeController.approvedUserList[index].isStaff == true) ?
                                        const TextComponent(text: "Super Admin",color: AppColors.primaryTextColor,) :
                                       (changeUserTypeController.approvedUserList[index].isSuperuser == false &&  changeUserTypeController.approvedUserList[index].isStaff == false) ?
                                       const TextComponent(text: "User",color: AppColors.primaryTextColor,) :
                                       const TextComponent(text: "Admin",color: AppColors.primaryTextColor,),
                                        SizedBox(height: widget.size.height * k8TextSize,),
                                      ],
                                    ),
                                    /*  const Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,

                                      children: [
                                        const TextComponent(text: "Permission",color: AppColors.secondaryTextColor,),
                                        SizedBox(height: widget.size.height * 0.004,),
                                        SizedBox(
                                          height: widget.size.height * 0.040,
                                          width: widget.size.width * 0.220,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                              ),
                                              onPressed: (){
                                                _checkConfiqDialog(context,widget.size);
                                              }, child: const TextComponent(text: "View",color: AppColors.whiteTextColor,)),
                                        ),
                                        SizedBox(height: widget.size.height * k10TextSize,),
                                        SizedBox(
                                          height: widget.size.height * 0.040,
                                          width: widget.size.width * 0.220,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.whiteTextColor,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                              ),
                                              onPressed: (){
                                                _checkConfiqDialog(context,widget.size);
                                              }, child: const TextComponent(text: "Confiq",color: AppColors.primaryColor,)),
                                        ),

                                      ],
                                    ),*/

                                  ],
                                ),
                              ),
                              SizedBox(height: widget.size.height * k16TextSize,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: widget.size.height * 0.040,
                                    width: widget.size.width * 0.350,
                                    child: GetBuilder<DeletePendingUserController>(
                                      builder: (deletePendingUserController) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004)),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: (changeUserTypeController.approvedUserList[index].isSuperuser == true &&  changeUserTypeController.approvedUserList[index].isStaff == true) ? null : (){
                                            deletePendingUserController.deletePendingUserRequest(id: changeUserTypeController.approvedUserList[index].id!);

                                            Future.delayed(const Duration(seconds: 1)).then((_){
                                              Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                                            });


                                          }, child: const TextComponent(text: "Delete",color: AppColors.whiteTextColor,),
                                        );
                                      }
                                    ),
                                  ),

                                  SizedBox(
                                    height: widget.size.height * 0.040,
                                    width: widget.size.width * 0.350,
                                    child: GetBuilder<GrantAdminUserController>(
                                      builder: (grantAdminUserController) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004)),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: (changeUserTypeController.approvedUserList[index].isSuperuser == true &&  changeUserTypeController.approvedUserList[index].isStaff == true) ? null : (){
                                            grantAdminUserController.grantAdminPermissionToChangeUser(id: changeUserTypeController.approvedUserList[index].id!);
                                            Future.delayed(const Duration(milliseconds: 500)).then((_){
                                              Get.find<ChangeUserTypeController>().fetchApprovedUserDataWithOutLoading();
                                            });
                                          }, child:   (changeUserTypeController.approvedUserList[index].isSuperuser == false &&  changeUserTypeController.approvedUserList[index].isStaff == false) ?
                                           const TextComponent(text: "Make Admin",color: AppColors.whiteTextColor,) :  const TextComponent(text: "Make User",color: AppColors.whiteTextColor,) ,
                                        );
                                      }
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: widget.size.height *k16TextSize,)

                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context,index) => SizedBox(height: widget.size.height * k13TextSize,),

                  ),
                ) :

                changeUserTypeController.selectedButton == 2 ? RefreshIndicator(
                  onRefresh: ()async{
                   await Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: widget.size.height * k20TextSize),
                    itemCount: changeUserTypeController.isApprovedUserInProgress ? 2 : changeUserTypeController.onlySuperAdminList.isEmpty ? 1 : changeUserTypeController.onlySuperAdminList.length,
                    itemBuilder: (context,index){
                      if(changeUserTypeController.isApprovedUserInProgress){
                        return  Padding(
                          padding: EdgeInsets.all(widget.size.height * k8TextSize),
                          child: CustomShimmerWidget(height: widget.size.height * 0.16 , width: double.infinity,),
                        );
                      }
                      if(changeUserTypeController.onlySuperAdminList.isEmpty){
                        return EmptyPageWidget(size: widget.size);
                      }


                      return CustomContainer(
                        height: widget.size.height * 0.16,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(widget.size.height * k8TextSize),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top: widget.size.height * k16TextSize),
                              child: Row(
                                children: [

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextComponent(text: "ID",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: "Name",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: "Email",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: "Role",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                    ],
                                  ),
                                  SizedBox(width: widget.size.width * k50TextSize,),
                                  Column(
                                    children: [
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),

                                    ],
                                  ),
                                  SizedBox(width: widget.size.width * k50TextSize,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextComponent(text: changeUserTypeController.onlySuperAdminList[index].id.toString(),color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      TextComponent(text: changeUserTypeController.onlySuperAdminList[index].firstName ?? '',color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      TextComponent(text: changeUserTypeController.onlySuperAdminList[index].email ?? '',color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),

                                      const TextComponent(text: "Super Admin",color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                    ],
                                  ),
                                 /* const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      const TextComponent(text: "Permission",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * 0.004,),
                                      SizedBox(
                                        height: widget.size.height * 0.040,
                                        width: widget.size.width * 0.220,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                            ),
                                            onPressed: (){
                                              _checkConfiqDialog(context,widget.size);
                                            }, child: const TextComponent(text: "View",color: AppColors.whiteTextColor,)),
                                      ),
                                      SizedBox(height: widget.size.height * k10TextSize,),
                                      SizedBox(
                                        height: widget.size.height * 0.040,
                                        width: widget.size.width * 0.220,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.whiteTextColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                            ),
                                            onPressed: (){
                                              _checkConfiqDialog(context,widget.size);
                                            }, child: const TextComponent(text: "Confiq",color: AppColors.primaryColor,)),
                                      ),

                                    ],
                                  ),*/

                                ],
                              ),
                            ),
                          //  SizedBox(height: widget.size.height * k16TextSize,),


                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context,index) => SizedBox(height: widget.size.height * k13TextSize,),

                  ),
                ) :
                    changeUserTypeController.selectedButton == 3 ? RefreshIndicator(
                      onRefresh: ()async{
                        await Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                      },
                      child: ListView.separated(
                        padding: EdgeInsets.only(bottom: widget.size.height * k20TextSize),
                        itemCount: changeUserTypeController.isApprovedUserInProgress ? 4 : changeUserTypeController.onlyAdminList.isEmpty ? 1 : changeUserTypeController.onlyAdminList.length,
                        itemBuilder: (context,index){

                          if(changeUserTypeController.isApprovedUserInProgress){
                            return  Padding(
                              padding: EdgeInsets.all(widget.size.height * k8TextSize),
                              child: CustomShimmerWidget(height: widget.size.height * 0.22 , width: double.infinity,),
                            );
                          }
                          if(changeUserTypeController.onlyAdminList.isEmpty){
                            return EmptyPageWidget(size: widget.size);
                          }

                          return CustomContainer(
                            height: widget.size.height * 0.215,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(widget.size.height * k8TextSize),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top: widget.size.height * k16TextSize),
                                  child: Row(
                                    children: [

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextComponent(text: "ID",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          const TextComponent(text: "Name",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          const TextComponent(text: "Email",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          const TextComponent(text: "Role",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                        ],
                                      ),
                                      SizedBox(width: widget.size.width * k50TextSize,),
                                      Column(
                                        children: [
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),

                                        ],
                                      ),
                                      SizedBox(width: widget.size.width * k50TextSize,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TextComponent(text: changeUserTypeController.onlyAdminList[index].id.toString(),color: AppColors.primaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          TextComponent(text: changeUserTypeController.onlyAdminList[index].firstName ?? '',color: AppColors.primaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                          TextComponent(text: changeUserTypeController.onlyAdminList[index].email ?? '',color: AppColors.primaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),

                                          const TextComponent(text: "Admin",color: AppColors.primaryTextColor,),
                                          SizedBox(height: widget.size.height * k8TextSize,),
                                        ],
                                      ),
                                      /* const Spacer(),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [
                                          const TextComponent(text: "Permission",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: widget.size.height * 0.004,),
                                          SizedBox(
                                            height: widget.size.height * 0.040,
                                            width: widget.size.width * 0.220,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                                ),
                                                onPressed: (){
                                                  _checkConfiqDialog(context,widget.size);
                                                }, child: const TextComponent(text: "View",color: AppColors.whiteTextColor,)),
                                          ),
                                          SizedBox(height: widget.size.height * k10TextSize,),
                                          SizedBox(
                                            height: widget.size.height * 0.040,
                                            width: widget.size.width * 0.220,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.whiteTextColor,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                                ),
                                                onPressed: (){
                                                  _checkConfiqDialog(context,widget.size);
                                                }, child: const TextComponent(text: "Confiq",color: AppColors.primaryColor,)),
                                          ),

                                        ],
                                      ),*/

                                    ],
                                  ),
                                ),
                                SizedBox(height: widget.size.height * k16TextSize,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: widget.size.height * 0.040,
                                      width: widget.size.width * 0.350,
                                      child: GetBuilder<DeletePendingUserController>(
                                          builder: (deletePendingUserController) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004)),
                                                side: BorderSide.none,
                                              ),
                                              onPressed: (){
                                                deletePendingUserController.deletePendingUserRequest(id: changeUserTypeController.onlyAdminList[index].id!);

                                                Future.delayed(const Duration(seconds: 1)).then((_){
                                                  Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                                                });


                                              }, child: const TextComponent(text: "Delete",color: AppColors.whiteTextColor,),
                                            );
                                          }
                                      ),
                                    ),

                                    SizedBox(
                                      height: widget.size.height * 0.040,
                                      width: widget.size.width * 0.350,
                                      child: GetBuilder<GrantAdminUserController>(
                                          builder: (grantAdminUserController) {
                                            return ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004)),
                                                side: BorderSide.none,
                                              ),
                                              onPressed: (){
                                                grantAdminUserController.grantAdminPermissionToChangeUser(id: changeUserTypeController.onlyAdminList[index].id!);
                                                Future.delayed(const Duration(milliseconds: 500)).then((_){
                                                  Get.find<ChangeUserTypeController>().fetchApprovedUserDataWithOutLoading();
                                                });
                                              }, child:   (changeUserTypeController.onlyAdminList[index].isSuperuser == false &&  changeUserTypeController.onlyAdminList[index].isStaff == false) ?
                                            const TextComponent(text: "Make Admin",color: AppColors.whiteTextColor,) :  const TextComponent(text: "Make User",color: AppColors.whiteTextColor,) ,
                                            );
                                          }
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: widget.size.height *k16TextSize,)

                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context,index) => SizedBox(height: widget.size.height * k13TextSize,),

                      ),
                    ) :
                RefreshIndicator(
                  onRefresh: ()async{
                    await Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: widget.size.height * k20TextSize),
                    itemCount: changeUserTypeController.isApprovedUserInProgress ? 4 : changeUserTypeController.onlyUserList.isEmpty ? 1 :  changeUserTypeController.onlyUserList.length,
                    itemBuilder: (context,index){
                      if(changeUserTypeController.isApprovedUserInProgress){
                        return  Padding(
                          padding: EdgeInsets.all(widget.size.height * k8TextSize),
                          child: CustomShimmerWidget(height: widget.size.height * 0.22 , width: double.infinity,),
                        );
                      }
                      if(changeUserTypeController.onlyUserList.isEmpty){
                        return EmptyPageWidget(size: widget.size);
                      }
                      return CustomContainer(
                        height: widget.size.height * 0.215,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(widget.size.height * k8TextSize),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top: widget.size.height * k16TextSize),
                              child: Row(
                                children: [

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextComponent(text: "ID",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: "Name",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: "Email",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: "Role",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                    ],
                                  ),
                                  SizedBox(width: widget.size.width * k50TextSize,),
                                  Column(
                                    children: [
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),

                                    ],
                                  ),
                                  SizedBox(width: widget.size.width * k50TextSize,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextComponent(text: changeUserTypeController.onlyUserList[index].id.toString(),color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      TextComponent(text: changeUserTypeController.onlyUserList[index].firstName ?? '',color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                      TextComponent(text: changeUserTypeController.onlyUserList[index].email ?? '',color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),

                                      const TextComponent(text: "User",color: AppColors.primaryTextColor,),
                                      SizedBox(height: widget.size.height * k8TextSize,),
                                    ],
                                  ),
                                 /* const Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    children: [
                                      const TextComponent(text: "Permission",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: widget.size.height * 0.004,),
                                      SizedBox(
                                        height: widget.size.height * 0.040,
                                        width: widget.size.width * 0.220,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                            ),
                                            onPressed: (){
                                              _checkConfiqDialog(context,widget.size);
                                            }, child: const TextComponent(text: "View",color: AppColors.whiteTextColor,)),
                                      ),
                                      SizedBox(height: widget.size.height * k10TextSize,),
                                      SizedBox(
                                        height: widget.size.height * 0.040,
                                        width: widget.size.width * 0.220,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.whiteTextColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004))
                                            ),
                                            onPressed: (){
                                              _checkConfiqDialog(context,widget.size);

                                            }, child: const TextComponent(text: "Confiq",color: AppColors.primaryColor,)),
                                      ),

                                    ],
                                  ),*/

                                ],
                              ),
                            ),
                            SizedBox(height: widget.size.height * k16TextSize,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: widget.size.height * 0.040,
                                  width: widget.size.width * 0.350,
                                  child: GetBuilder<DeletePendingUserController>(
                                      builder: (deletePendingUserController) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004)),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: (){
                                            deletePendingUserController.deletePendingUserRequest(id: changeUserTypeController.onlyUserList[index].id!);

                                            Future.delayed(const Duration(seconds: 1)).then((_){
                                              Get.find<ChangeUserTypeController>().fetchApprovedUserData();
                                            });


                                          }, child: const TextComponent(text: "Delete",color: AppColors.whiteTextColor,),
                                        );
                                      }
                                  ),
                                ),

                                SizedBox(
                                  height: widget.size.height * 0.040,
                                  width: widget.size.width * 0.350,
                                  child: GetBuilder<GrantAdminUserController>(
                                      builder: (grantAdminUserController) {
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * 0.004)),
                                            side: BorderSide.none,
                                          ),
                                          onPressed: (){
                                            grantAdminUserController.grantAdminPermissionToChangeUser(id: changeUserTypeController.onlyUserList[index].id!);
                                            Future.delayed(const Duration(milliseconds: 500)).then((_){
                                              Get.find<ChangeUserTypeController>().fetchApprovedUserDataWithOutLoading();
                                            });
                                          }, child:   (changeUserTypeController.onlyUserList[index].isSuperuser == false &&  changeUserTypeController.onlyUserList[index].isStaff == false) ?
                                        const TextComponent(text: "Make Admin",color: AppColors.whiteTextColor,) :  const TextComponent(text: "Make User",color: AppColors.whiteTextColor,) ,
                                        );
                                      }
                                  ),
                                ),

                              ],
                            ),
                            SizedBox(height: widget.size.height *k16TextSize,)

                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context,index) => SizedBox(height: widget.size.height * k13TextSize,),

                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }




  void _checkConfiqDialog(BuildContext context,Size size) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * k8TextSize),
          ),
          title: Align(
            alignment: Alignment.center,
            child: Container(
              transform: Matrix4.translationValues(0, -size.height * k25TextSize, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(AssetsPath.alertIconSVG,height: size.height * 0.045,),
                  SizedBox(height: size.height * k10TextSize),
                  TextComponent(
                    text: "This feature is not available now!",
                    color: Colors.red,
                    fontSize: size.height * k20TextSize,
                    fontFamily: semiBoldFontFamily,
                  ),
                ],
              ),
            ),
          ),
          /*content: Padding(
            padding: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize,bottom: size.height * k8TextSize),
            child: const TextComponent(text: "Only Higher Authority can access this part.",maxLines: 2,color: AppColors.primaryColor,),
          ),*/
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: size.height < smallScreenWidth ?   Size(size.width * 0.04, size.height * 0.060) : Size(size.width * 0.04, size.height * 0.040),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                      color: AppColors.whiteTextColor,
                      fontSize: size.height * k16TextSize,
                      fontFamily: boldFontFamily
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }







}

