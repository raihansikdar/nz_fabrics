
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/water/controller/water_data_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/water/views/screens/combine_water_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/water/views/screens/water_details_screen.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

//enum ViewTab { machine, shed, details }
enum ViewTab { machine, details }

class WaterDataViewScreen extends StatefulWidget {
  const WaterDataViewScreen({super.key});

  @override
  State<WaterDataViewScreen> createState() => _WaterDataViewScreenState();
}

class _WaterDataViewScreenState extends State<WaterDataViewScreen> {
  // Use enum for selected tab instead of TabController
  ViewTab _selectedTab = ViewTab.machine;



 // DashBoardButtonController controllerExitOrNot = Get.put(DashBoardButtonController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: GetBuilder<WaterDataViewUIController>(
        builder: (dataViewUIController) {
          return Column(
            children: [
              Stack(
                children: [
                  // Container with border
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height * 0.035,
                        left: size.height * k8TextSize,
                        right: size.height * k8TextSize),
                    child: Container(
                      height: MediaQuery.sizeOf(context).width > 500
                          //? controllerExitOrNot.buttonList.isEmpty
                          ? MediaQuery.sizeOf(context).height * 0.79
                          //: MediaQuery.sizeOf(context).height * 0.72
                          : MediaQuery.sizeOf(context).height * 0.85,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.containerBorderColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(size.height * k30TextSize),
                            topRight: Radius.circular(size.height * k30TextSize),
                            bottomLeft: Radius.circular(size.height * k10TextSize),
                            bottomRight: Radius.circular(size.height * k10TextSize)),
                      ),
                    ),
                  ),

                  // Radio button tab selection container
                  Positioned(
                    top: 10,
                    left: 10.0,
                    right: 10.0,
                    child: Container(
                      height: size.height * k60TextSize,
                      decoration: BoxDecoration(
                        color: AppColors.whiteTextColor,
                        border: Border.all(color: AppColors.containerBorderColor),
                        borderRadius: BorderRadius.circular(size.height * k8TextSize),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(size.height * k5TextSize),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Machine Radio Button
                            _buildRadioOption(
                              context: context,
                              title: 'Machine',
                              value: ViewTab.machine,
                              size: size,
                            ),

                            // // Shed Radio Button
                            // _buildRadioOption(
                            //   context: context,
                            //   title: 'Shed',
                            //   value: ViewTab.shed,
                            //   size: size,
                            // ),

                            // Details Radio Button
                            _buildRadioOption(
                              context: context,
                              title: 'Details',
                              value: ViewTab.details,
                              size: size,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content area based on selected radio button
                  Positioned(
                    top: size.height * 0.085,
                    left: size.height * k8TextSize,
                    right: size.height * k8TextSize,
                    bottom: 0,
                    child: _buildSelectedView(),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper widget to build each radio button option
  Widget _buildRadioOption({
    required BuildContext context,
    required String title,
    required ViewTab value,
    required Size size,
  }) {
    return Row(
      children: [
        Radio<ViewTab>(
          value: value,
          groupValue: _selectedTab,
          activeColor: AppColors.primaryColor,
          onChanged: (ViewTab? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedTab = newValue;
              });
            }
          },
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedTab = value;
            });
          },
          child: Text(
            title,
            style: TextStyle(
              fontSize: size.height * k16TextSize,
              fontWeight: FontWeight.w500,
              color: _selectedTab == value ? AppColors.primaryColor : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build the view based on selected radio button
  Widget _buildSelectedView() {
    switch (_selectedTab) {
      case ViewTab.machine:
        return const WaterCombinedScreen();
    // case ViewTab.shed:
    //   return const ShedView();
      case ViewTab.details:
        return Container(
          color: Colors.white,
          child: const WaterDetailsScreen(),
        );
    }
  }
}