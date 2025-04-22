import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_monthly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_month_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/monthly_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/electricity_analysis_pro_model.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/only_month_analysis_pro_model.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MultipleMonthItemsChoiceWidget extends StatefulWidget {
  const MultipleMonthItemsChoiceWidget({super.key});

  @override
  State<MultipleMonthItemsChoiceWidget> createState() => _MultipleMonthItemsChoiceWidgetState();
}

class _MultipleMonthItemsChoiceWidgetState extends State<MultipleMonthItemsChoiceWidget> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   Get.find<AnalysisProMonthlyButtonController>().fetchMonthDGRData(
    //     selectedMonth: Get.find<AnalysisProMonthlyButtonController>().selectedMonth.toString(),
    //     selectedYear: Get.find<AnalysisProMonthlyButtonController>().selectedYear.toString(),
    //   );
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ElectricityMonthAnalysisProController>().toggleSelection(0,true);
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ElectricityMonthAnalysisProController>(

      builder: (controller) {
        //  log("length: ${controller.dayDataList.length}");
        if (controller.isMonthElectricityAnalysisProInProgress) {
          return CustomShimmerWidget(height:  size.height * 0.080, width: double.infinity);
        }
        else if (controller.electricityMonthAnalysisProSourceList.isEmpty || (controller.electricityMonthAnalysisProLoadList.isEmpty) ) {
          return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.080));
        }

        ElectricityAnalysisProModel monthlyModel = controller.electricityMonthAnalysisProSourceList.first;

        return Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 7.0,
          children: _buildChoiceChips(monthlyModel, controller),
        );
      },
    );
  }

  List<Widget> _buildChoiceChips(ElectricityAnalysisProModel monthlyModel, ElectricityMonthAnalysisProController controller) {
    List<Widget> chips = [];

    if (monthlyModel.nodeName?.isNotEmpty ?? false) {
      chips.add(
        ChoiceChip(
          label: const TextComponent(text: 'Electricity'),
          side: const BorderSide(color: AppColors.containerBorderColor),
          selected: controller.selectedIndices.contains(0),
          onSelected: (bool selected) {
            _onChipSelected(controller, 0, selected);
          },
        ),
      );
    }

    // if (monthlyModel.waterData?.isNotEmpty ?? false) {
    //   chips.add(
    //     ChoiceChip(
    //       label: const Text('Water'),
    //       side: const BorderSide(color: AppColors.containerBorderColor),
    //       selected: controller.selectedIndices.contains(1),
    //       onSelected: (bool selected) {
    //         _onChipSelected(controller, 1, selected);
    //         //controller.fetchDayModelDGRData(fromDate: controller.fromDateTEController.text, toDate: controller.toDateTEController.text);
    //         //  controller.fetchSelectedNodeData(fromDate: controller.fromDateTEController.text, toDate: controller.toDateTEController.text);
    //
    //       },
    //     ),
    //   );
    // }
    //
    // if (monthlyModel.gasData?.isNotEmpty ?? false) {
    //   chips.add(
    //     ChoiceChip(
    //       label: const Text('Gas'),
    //       side: const BorderSide(color: AppColors.containerBorderColor),
    //       selected: controller.selectedIndices.contains(2),
    //       onSelected: (bool selected) {
    //         _onChipSelected(controller, 2, selected);
    //       },
    //     ),
    //   );
    // }

    if (monthlyModel.nodeName?.isNotEmpty ?? false) {
      chips.add(
        ChoiceChip(
          label: const TextComponent(text: 'Consumption'),
          side: const BorderSide(color: AppColors.containerBorderColor),
          selected: controller.selectedIndices.contains(1),
          onSelected: (bool selected) {
            _onChipSelected(controller, 1, selected);
          },
        ),
      );
      chips.add(
        ChoiceChip(
          label: const TextComponent(text: 'Cost'),
          side: const BorderSide(color: AppColors.containerBorderColor),
          selected: controller.selectedIndices.contains(2),
          onSelected: (bool selected) {
            _onChipSelected(controller, 2, selected);
          },
        ),
      );
    }


    return chips;
  }

  void _onChipSelected(ElectricityMonthAnalysisProController controller, int index, bool selected) {
    // Use Future.micro task to avoid immediate update during build
    Future.microtask(() {
      controller.toggleSelection(index, selected);
    });
  }
}