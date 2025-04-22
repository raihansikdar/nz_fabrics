import 'package:get/get.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/controllers/data_view_ui_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/details_screen/details_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/machine_view.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/new_machine_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/shed_screen/shed_views.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class DataViewScreen extends StatefulWidget {
  const DataViewScreen({super.key});

  @override
  State<DataViewScreen> createState() => _DataViewScreenState();
}

class _DataViewScreenState extends State<DataViewScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  DashBoardButtonController controllerExitOrNot = Get.put(DashBoardButtonController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: GetBuilder<DataViewUIController>(
        builder: (dataViewUIController) {
          return Column(
            children: [
              Stack(
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.035,left: size.height * k8TextSize,right:size.height * k8TextSize ),
                    child: Container(
                      height: MediaQuery.sizeOf(context).width > 500 ? controllerExitOrNot.buttonList.isEmpty ? MediaQuery.sizeOf(context).height * 0.79 : MediaQuery.sizeOf(context).height * 0.72 : MediaQuery.sizeOf(context).height * 0.91,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.containerBorderColor),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(size.height * k30TextSize),
                            topRight: Radius.circular(size.height * k30TextSize),
                            bottomLeft: Radius.circular(size.height * k10TextSize),
                            bottomRight: Radius.circular(size.height * k10TextSize)
                        ),
                      ),
                    ),
                  ),
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
                        child: TabBar(
                          unselectedLabelColor: Colors.black,
                          labelColor: AppColors.whiteTextColor,
                          labelStyle: TextStyle(
                            fontSize: size.height * k16TextSize,
                            fontWeight: FontWeight.w500,
                          ),
                          unselectedLabelStyle: TextStyle(
                            fontSize: size.height * k16TextSize,
                            fontWeight: FontWeight.w500,
                          ),
                          indicatorColor: Colors.blue,
                          indicatorWeight: 2,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(size.height * 0.006),
                          ),
                          dividerColor: Colors.transparent,
                          controller: tabController,
                          tabs: const [
                            Tab(text: 'Machine'),
                            Tab(text: 'Shed'),
                            Tab(text: 'Details'),


                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.085,
                    left: size.height * k8TextSize,
                    right: size.height * k8TextSize,
                    bottom: 0,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController,
                      children: [
                        const MachineView(),
                        const ShedView(),
                        Container(
                          color: Colors.white,
                          child: const DetailsScreen(),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

}
//
// import 'package:get/get.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/controllers/data_view_ui_controller.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/details_screen/details_screen.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/machine_view.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/new_machine_screen.dart';
// import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/shed_screen/shed_views.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
//
// class DataViewScreen extends StatefulWidget {
//   const DataViewScreen({super.key});
//
//   @override
//   State<DataViewScreen> createState() => _DataViewScreenState();
// }
//
// class _DataViewScreenState extends State<DataViewScreen> with SingleTickerProviderStateMixin {
//
//   late TabController tabController;
//
//   @override
//   void initState() {
//     tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     tabController.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       backgroundColor: AppColors.whiteTextColor,
//       body: GetBuilder<DataViewUIController>(
//         builder: (dataViewUIController) {
//           return SizedBox(
//             height: 800,
//             child: Column(
//               children: [
//
//                 // Padding(
//                 //   padding: EdgeInsets.only(top: size.height * 0.035,left: size.height * k8TextSize,right:size.height * k8TextSize ),
//                 //   child: Container(
//                 //     height: size.height * 0.85,
//                 //     decoration: BoxDecoration(
//                 //       border: Border.all(color: AppColors.containerBorderColor),
//                 //       borderRadius: BorderRadius.only(
//                 //           topLeft: Radius.circular(size.height * k30TextSize),
//                 //           topRight: Radius.circular(size.height * k30TextSize),
//                 //           bottomLeft: Radius.circular(size.height * k10TextSize),
//                 //           bottomRight: Radius.circular(size.height * k10TextSize)
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//
//                   Container(
//                     height: size.height * k60TextSize,
//                     decoration: BoxDecoration(
//                       color: AppColors.whiteTextColor,
//                       border: Border.all(color: AppColors.containerBorderColor),
//                       borderRadius: BorderRadius.circular(size.height * k8TextSize),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(size.height * k5TextSize),
//                       child: TabBar(
//                         unselectedLabelColor: Colors.black,
//                         labelColor: AppColors.whiteTextColor,
//                         labelStyle: TextStyle(
//                           fontSize: size.height * k16TextSize,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         unselectedLabelStyle: TextStyle(
//                           fontSize: size.height * k16TextSize,
//                           fontWeight: FontWeight.w500,
//                         ),
//                         indicatorColor: Colors.blue,
//                         indicatorWeight: 2,
//                         indicatorSize: TabBarIndicatorSize.tab,
//                         indicator: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           borderRadius: BorderRadius.circular(size.height * 0.006),
//                         ),
//                         dividerColor: Colors.transparent,
//                         controller: tabController,
//                         tabs: const [
//                           Tab(text: 'Machine'),
//                           Tab(text: 'Shed'),
//                           Tab(text: 'Details'),
//
//
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 TabBarView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     controller: tabController,
//                     children: [
//                       const MachineView(),
//                       const ShedView(),
//                       Container(
//                         color: Colors.white,
//                         child: const DetailsScreen(),
//                       ),
//
//                     ],
//                   ),
//
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
// }
//
