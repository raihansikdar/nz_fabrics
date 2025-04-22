import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/empty_page_widget/empty_page_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/admin_approval_pending_request.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/delete_pending_user_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/pending_user_controller.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendingRequestWidget extends StatefulWidget {
  const PendingRequestWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<PendingRequestWidget> createState() => _PendingRequestWidgetState();
}

class _PendingRequestWidgetState extends State<PendingRequestWidget> {

  double width = -200;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      Get.find<PendingUserController>().startPendingAnimation();

    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left:  widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top:widget.size.height * k25TextSize ),
      child: GetBuilder<PendingUserController>(
        builder: (pendingUserController) {

          return RefreshIndicator(
            onRefresh: ()async{
              await Get.find<PendingUserController>().fetchPendingUserData();
            },
            child: ListView.separated(
              padding: EdgeInsets.only(bottom: widget.size.height * k20TextSize),
              itemCount: pendingUserController.isPendingUserInProgress ? 4 :
                         pendingUserController.pendingUserList.isEmpty ? 1 :
                         pendingUserController.pendingUserList.length,
              itemBuilder: (context,index){
                if(pendingUserController.isPendingUserInProgress){
                  return  Padding(
                    padding: EdgeInsets.all(widget.size.height * k8TextSize),
                    child: CustomShimmerWidget(height: widget.size.height * 0.16 , width: double.infinity,),
                  );
                }
                if(pendingUserController.pendingUserList.isEmpty){
                  return EmptyPageWidget(size: widget.size);
                }
                return AnimatedContainer(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  duration:  Duration(milliseconds: 1200 + (index * 350)),
                  curve: Curves.easeInOutCubic,
                  transform: Matrix4.translationValues(pendingUserController.pendingCardAnimation ?  0 : width, 0, 0),
                  child: CustomContainer(
                    height: widget.size.height * 0.18,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(widget.size.height * k8TextSize),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: widget.size.height * k16TextSize,right: widget.size.height * k16TextSize,top: widget.size.height * k16TextSize),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextComponent(text: "ID",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  const TextComponent(text: "Name",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  const TextComponent(text: "Role",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  const TextComponent(text: "Email",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),

                                ],
                              ),
                              SizedBox(width: widget.size.width * k40TextSize,),
                              Column(
                                children: [
                                  const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),

                                ],
                              ),
                              SizedBox(width: widget.size.width * k40TextSize,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextComponent(text: pendingUserController.pendingUserList[index].id.toString(),color: AppColors.primaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  TextComponent(text: pendingUserController.pendingUserList[index].firstName ?? '',color: AppColors.primaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  TextComponent(text: (pendingUserController.pendingUserList[index].isSuperuser == false && pendingUserController.pendingUserList[index].isSuperuser == false) ? "User" : "Admin",color: AppColors.primaryTextColor,),
                                  SizedBox(height: widget.size.height * k12TextSize,),
                                  SizedBox(
                                      width: 150,
                                      child: TextComponent(text: pendingUserController.pendingUserList[index].email ?? '',color: AppColors.primaryTextColor,maxLines: 3,)),
                                  SizedBox(height: widget.size.height * k12TextSize,),

                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  SizedBox(
                                    height: widget.size.height * 0.040,
                                    width: widget.size.width * 0.270,
                                    child: GetBuilder<AdminApprovalPendingRequest>(
                                      builder: (adminApprovalPendingRequest) {
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * k8TextSize))
                                            ),
                                            onPressed: (){

                                              adminApprovalUser(adminApprovalPendingRequest,pendingUserController.pendingUserList[index].id!);

                                            }, child: adminApprovalPendingRequest.isAdminApprovalPendingRequestInProgress ?  Center(child: SizedBox(
                                            height: widget.size.height * k20TextSize,
                                            width: widget.size.height * k20TextSize,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: widget.size.height * 0.004,
                                            )),):  const TextComponent(text: "Approve",color: AppColors.whiteTextColor,));
                                      }
                                    ),
                                  ),
                                  SizedBox(height: widget.size.height * k16TextSize,),
                                  SizedBox(
                                    height: widget.size.height * 0.040,
                                    width: widget.size.width * 0.270,
                                    child: GetBuilder<DeletePendingUserController>(
                                      builder: (deletePendingUserController) {
                                        return ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                side: BorderSide.none,
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size.height * k8TextSize))
                                            ),
                                            onPressed: (){

                                              deletePendingUser(deletePendingUserController,pendingUserController.pendingUserList[index].id!);
                                            }, child: deletePendingUserController.isDeleteUserInProgress ?  Center(child: SizedBox(
                                            height: widget.size.height * k20TextSize,
                                            width: widget.size.height * k20TextSize,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: widget.size.height * 0.004,
                                            )),) : const TextComponent(text: "Delete",color: AppColors.whiteTextColor,));
                                      }
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context,index) => SizedBox(height: widget.size.height * k13TextSize,),

            ),
          );
        }
      ),
    );
  }

  Future<void> deletePendingUser(DeletePendingUserController deletePendingUserController ,int id) async {
    final response = await deletePendingUserController.deletePendingUserRequest(id: id);

    if(response){
      AppToast.showSuccessToast("Successfully user request deleted.");
      Get.find<PendingUserController>().fetchPendingUserData();

    }else{
      AppToast.showWrongToast(deletePendingUserController.errorMessage);
    }
  }

  Future<void> adminApprovalUser(AdminApprovalPendingRequest adminApprovalPendingRequest ,int id) async {
    final response = await adminApprovalPendingRequest.adminApprovalPendingUserRequest(id: id);

    if(response){
      AppToast.showSuccessToast("Approved user successfully done.");
      Get.find<PendingUserController>().fetchPendingUserData();

    }else{
      AppToast.showWrongToast(adminApprovalPendingRequest.errorMessage);
    }
  }
}