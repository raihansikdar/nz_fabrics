import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/circular_inside_button_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/module_cleaning_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/schedule_chart_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/views/widget/completed_work_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/views/widget/not_done_work_widget.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/views/widget/pending_work_widget.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModuleCleaningScreen extends StatefulWidget {
  const ModuleCleaningScreen({super.key});

  @override
  State<ModuleCleaningScreen> createState() => _ModuleCleaningScreenState();
}

class _ModuleCleaningScreenState extends State<ModuleCleaningScreen> {

  final TextEditingController _shadeNameTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
   WidgetsBinding.instance.addPostFrameCallback((_){
     Get.find<ScheduleChartController>().fetchScheduleChart();
   });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Module Cleaning", backPreviousScreen: true),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(size.height * k13TextSize),
            child: GetBuilder<CreateModuleCleaningController>(
              builder: (createModuleCleaningController) {
                return Container(
                  width: double.infinity,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(size.height * k16TextSize),
                 color: AppColors.whiteTextColor,
                 border: Border.all(
                   color: AppColors.containerBorderColor,
                   width: 1.0,
                 ),
               ),
               //   borderRadius: BorderRadius.circular(size.height * k16TextSize),
                  child: Card(
                      color: AppColors.whiteTextColor,
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(size.height * k13TextSize),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent(text: "Set Date", fontSize: size.height * k18TextSize),
                            SizedBox(height: size.height * k8TextSize),
                            TextFormField(
                              onTap: (){
                                createModuleCleaningController.selectDatePicker(context);
                              },
                              controller: createModuleCleaningController.selectedDateTEController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                hintText: 'DD/MM/YYYY',
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: AppColors.secondaryTextColor,
                                ),
                              ),
                              validator: (String? value){
                                if (value?.isEmpty ?? true) {
                                  return 'This field is mandatory';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: size.height * k16TextSize),
                            TextComponent(text: "Select Shade", fontSize: size.height * k18TextSize),
                            SizedBox(height: size.height * k8TextSize),
                            TextFormField(
                              controller: _shadeNameTEController,
                              decoration:  InputDecoration(
                               // contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: size.height * k16TextSize),
                                hintText: 'Enter Shade Name',
                                border: OutlineInputBorder( // Optional: Add border style
                                  borderRadius: BorderRadius.circular(size.height * k16TextSize),
                                ),
                              ),
                              validator: (String? value){
                                if (value?.isEmpty ?? true) {
                                  return 'This field is mandatory';
                                }
                                return null;
                              },
                      
                            ),
                            SizedBox(height: size.height * k16TextSize),
                            SizedBox(
                              height: size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(size.height * k16TextSize),
                                  ),
                                  backgroundColor: AppColors.blueTextColor,
                                ),
                                onPressed: () {
                                  if(!_formKey.currentState!.validate()){
                                    return;
                                  }
                                  createModuleCleaning(createModuleCleaningController);
                                },
                                child: createModuleCleaningController.isModuleInProgress ? CircularInsideButtonWidget(size: size) : TextComponent(
                                  text: "Create Schedule",
                                  color: AppColors.whiteTextColor,
                                  fontSize: size.height * k18TextSize,
                                ),
                              ),
                            ),
                      
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),

          Expanded(
            child: Container(
              // height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.whiteTextColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.height * k16TextSize),
                  topRight: Radius.circular(size.height * k16TextSize),
                ),
                border: Border.all(color: AppColors.containerBorderColor)
              ),
              child: Padding(
                    padding: EdgeInsets.all(size.height * k12TextSize),
                    child: Column(
                      children: [
                        TextComponent(text: "Schedule Chart",fontSize: size.height * k18TextSize,fontFamily: boldFontFamily,),
                        SizedBox(height: size.height * k10TextSize ,),
                    
                        GetBuilder<ScheduleChartController>(
                          builder: (scheduleChartController) {
                            return Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: scheduleChartController.isScheduleChartInProgress ? 4 : scheduleChartController.scheduleChartList.length,
                                itemBuilder: (context,index){
                                                  
                                  if(scheduleChartController.isScheduleChartInProgress){
                                    return CustomShimmerWidget(height: size.height * 0.15, width: double.infinity);
                                  }
                                                  
                                  return scheduleChartController.scheduleChartList[index].cleaningStatus == "Pending" ?
                                                  
                                  PendingWorkWidget(size: size, chartData:scheduleChartController.scheduleChartList[index]) : scheduleChartController.scheduleChartList[index].cleaningStatus == "Not Done" ?
                                                  
                                  NotDoneWorkWidget(size: size, chartData:scheduleChartController.scheduleChartList[index]) : CompletedWorkWidget(size: size,chartData:scheduleChartController.scheduleChartList[index]);
                                                  
                                }, separatorBuilder: (context,index) => SizedBox(height: size.height * k8TextSize,), ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }

  Future<void>createModuleCleaning(CreateModuleCleaningController createModuleCleaningController) async {
    final response = await createModuleCleaningController.createModuleCleaning(
      date: createModuleCleaningController.selectedDateTEController.text.trim(),
      shedName: _shadeNameTEController.text.trim(),
    );

    if(response){
      AppToast.showSuccessToast("Successfully created schedule");

      createModuleCleaningController.selectedDateTEController.clear();
      _shadeNameTEController.clear();

      Get.find<ScheduleChartController>().fetchScheduleChart();

    }else{
      AppToast.showWrongToast(createModuleCleaningController.errorMessage);
    }
  }
}






