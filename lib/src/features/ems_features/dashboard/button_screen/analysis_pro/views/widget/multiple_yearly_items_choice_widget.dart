import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_year_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/electricity_analysis_pro_model.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MultipleYearlyItemsChoiceWidget extends StatefulWidget {
  const MultipleYearlyItemsChoiceWidget({super.key});

  @override
  State<MultipleYearlyItemsChoiceWidget> createState() => _MultipleMonthItemsChoiceWidgetState();
}

class _MultipleMonthItemsChoiceWidgetState extends State<MultipleYearlyItemsChoiceWidget> {
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
      Get.find<ElectricityYearAnalysisProController>().toggleSelection(0,true);
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ElectricityYearAnalysisProController>(

      builder: (controller) {
        //  log("length: ${controller.dayDataList.length}");
        if (controller.isYearElectricityAnalysisProInProgress) {
          return CustomShimmerWidget(height:  size.height * 0.080, width: double.infinity);
        }
        else if (controller.electricityYearlyAnalysisProSourceList.isEmpty || (controller.electricityYearlyAnalysisProLoadList.isEmpty) ) {
          return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.080));
        }

        ElectricityAnalysisProModel yearlyModel = controller.electricityYearlyAnalysisProSourceList.first;

        return Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 7.0,
          children: _buildChoiceChips(yearlyModel, controller),
        );
      },
    );
  }

  List<Widget> _buildChoiceChips(ElectricityAnalysisProModel yearlyModel, ElectricityYearAnalysisProController controller) {
    List<Widget> chips = [];

    if (yearlyModel.nodeName?.isNotEmpty ?? false) {
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

/*    if (yearlyModel.waterData?.isNotEmpty ?? false) {
      chips.add(
        ChoiceChip(
          label: const Text('Water'),
          side: const BorderSide(color: AppColors.containerBorderColor),
          selected: controller.selectedIndices.contains(1),
          onSelected: (bool selected) {
            _onChipSelected(controller, 1, selected);
            //controller.fetchDayModelDGRData(fromDate: controller.fromDateTEController.text, toDate: controller.toDateTEController.text);
            //  controller.fetchSelectedNodeData(fromDate: controller.fromDateTEController.text, toDate: controller.toDateTEController.text);

          },
        ),
      );
    }

    if (yearlyModel.gasData?.isNotEmpty ?? false) {
      chips.add(
        ChoiceChip(
          label: const Text('Gas'),
          side: const BorderSide(color: AppColors.containerBorderColor),
          selected: controller.selectedIndices.contains(2),
          onSelected: (bool selected) {
            _onChipSelected(controller, 2, selected);
          },
        ),
      );
    }*/

    if (yearlyModel.nodeName?.isNotEmpty ?? false) {
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

  void _onChipSelected(ElectricityYearAnalysisProController controller, int index, bool selected) {
    // Use Future.micro task to avoid immediate update during build
    Future.microtask(() {
      controller.toggleSelection(index, selected);
    });
  }
}