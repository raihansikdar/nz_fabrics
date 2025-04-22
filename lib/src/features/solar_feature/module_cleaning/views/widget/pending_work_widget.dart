import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/schedule_chart_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/update_module_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/update_reason_module_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/model/schedule_chart_model.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PendingWorkWidget extends StatelessWidget {
  const PendingWorkWidget({
    super.key,
    required this.size, required this.chartData,
  });

  final Size size;
  final ScheduleChartModel chartData;



  @override
  Widget build(BuildContext context) {

    DateTime date = DateTime.parse(chartData.timedate ?? '');
    String formattedDate = DateFormat('dd-MM yyyy').format(date);

    return CustomContainer(
      height: size.height * 0.15,
      width: double.infinity,
      borderRadius: BorderRadius.circular(size.height * k12TextSize),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextComponent(text: "Cleaning Date",color: AppColors.secondaryTextColor,),
                    SizedBox(height: size.height * k10TextSize ,),
                    const TextComponent(text: "Shade Name",color: AppColors.secondaryTextColor,),
                  ],
                ),
                SizedBox(width:size.width * k30TextSize ,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextComponent(text: ":",),
                    SizedBox(height: size.height * k10TextSize ,),
                    const TextComponent(text: ":",),
                  ],
                ),
                SizedBox(width:size.width * k30TextSize ,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextComponent(text: formattedDate, color: AppColors.primaryTextColor,),
                        SizedBox(width: size.width * 0.24,),
                        const TextComponent(text: "Pending",color: AppColors.mistyBoldTextColor),
                      ],
                    ),
                    SizedBox(height: size.height * k10TextSize ,),
                    TextComponent(text: chartData.shedName ?? '',color: AppColors.primaryTextColor,),

                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * k20TextSize ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    _showDoneAlertDialog(context,size, chartData.id ?? 0);
                  },
                  child: CustomContainer(
                      height: size.height * 0.040,
                      width: size.width * 0.35,
                      borderRadius: BorderRadius.circular(size.height * 0.006),
                      child: const Center(child: TextComponent(text: "Done",color: AppColors.secondaryTextColor,))),
                ),
                GetBuilder<UpdateModuleController>(
                  builder: (updateModuleController) {
                    return GestureDetector(
                      onTap: () async{
                        final response = await updateModuleController.updateModuleDone(id: chartData.id ?? 0, status: "Not Done");
                        if(response){
                          _showNotDoneAlertDialog(context,size,chartData.id ?? 0);
                        }else{
                          AppToast.showWrongToast(updateModuleController.errorMessage);
                        }
                      },
                      child: CustomContainer(
                          height: size.height * 0.040,
                          width: size.width * 0.35,
                          borderRadius: BorderRadius.circular(size.height * 0.006),
                          child: const Center(child: TextComponent(text: "Not Done",color: AppColors.secondaryTextColor,))),
                    );
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }



  void _showDoneAlertDialog(BuildContext context,Size size,int id) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * k12TextSize),
          ),
          title:  TextComponent(text: "Are You Sure ?",textAlign: TextAlign.center,fontSize: size.height * k20TextSize,fontFamily: boldFontFamily,),
          content: const TextComponent(text: "The Shade Cleaning is Complete.",color: AppColors.secondaryTextColor,),
          actions: <Widget>[

            SizedBox(
              height: size.height * 0.050,
              width: size.width * 0.28,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.height * k12TextSize),
                  ),
                  backgroundColor: Colors.red,
                    side: BorderSide.none,
                ),
                onPressed: (){
                Navigator.of(context).pop();
              }, child: const TextComponent(text: "Cancel",color: AppColors.whiteTextColor,),
              ),
            ),


            SizedBox(
              height: size.height * 0.050,
              width: size.width * 0.3,
              child: GetBuilder<UpdateModuleController>(
                builder: (updateModuleController) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(size.height * k12TextSize),

                        ),
                      backgroundColor: AppColors.primaryColor,
                      side: BorderSide.none,
                    ),
                    onPressed: (){
                      updateModuleController.updateModuleDone(id: id, status: 'Done');
                      Navigator.of(context).pop();
                      Get.find<ScheduleChartController>().fetchScheduleChart();
                    }, child: const TextComponent(text: "Done",color: AppColors.whiteTextColor,),
                  );
                }
              ),
            ),
          ],
        );
      },
    );
  }



  void _showNotDoneAlertDialog(BuildContext context,Size size,int id) {
    final TextEditingController _reasonTEController = TextEditingController();

    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.height * k12TextSize),
          ),
          title:  TextComponent(text: "Write the reason \n for not Cleaning  ?",textAlign: TextAlign.center,fontSize: size.height * k18TextSize,fontFamily: boldFontFamily,maxLines: 2,),
          content: TextFormField(
            controller: _reasonTEController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "Write the Reason....",
            ),
          ),
          actions: <Widget>[

            SizedBox(
              height: size.height * 0.050,
              width: size.width * 0.28,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.height * k12TextSize),
                  ),
                  backgroundColor: Colors.red,
                    side: BorderSide.none,
                ),
                onPressed: (){
                Navigator.of(context).pop();
              }, child: const TextComponent(text: "Cancel",color: AppColors.whiteTextColor,),
              ),
            ),


            SizedBox(
              height: size.height * 0.050,
              width: size.width * 0.3,
              child: GetBuilder<UpdateReasonModuleController>(
                builder: (updateReasonModuleController) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(size.height * k12TextSize),

                        ),
                      backgroundColor: AppColors.primaryColor,
                      side: BorderSide.none,
                    ),
                    onPressed: (){
                      updateReasonModuleController.updateReasonModuleDone(id: id, reason: _reasonTEController.text.trim());
                      Navigator.of(context).pop();
                      Get.find<ScheduleChartController>().fetchScheduleChart();
                    }, child: const TextComponent(text: "Confirm",color: AppColors.whiteTextColor,),
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