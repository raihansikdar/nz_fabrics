
import 'package:nz_fabrics/src/common_widgets/custom_shimmer_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/model/new_model/electricity_analysis_pro_model.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MultipleItemsChoiceWidget extends StatefulWidget {
  const MultipleItemsChoiceWidget({super.key});

  @override
  State<MultipleItemsChoiceWidget> createState() => _MultipleItemsChoiceWidgetState();
}

class _MultipleItemsChoiceWidgetState extends State<MultipleItemsChoiceWidget> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   Get.find<AnalysisProDateController>().fetchDayData(
    //     fromDate: Get.find<AnalysisProDateController>().fromDateTEController.text,
    //     toDate: Get.find<AnalysisProDateController>().toDateTEController.text,
    //   );
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ElectricityDayAnalysisProController>().toggleSelection(0,true);
    });

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<ElectricityDayAnalysisProController>(

      builder: (controller) {
     //  log("length: ${controller.dayDataList.length}");
        if (controller.isElectricityAnalysisProInProgress) {
          return CustomShimmerWidget(height:  size.height * 0.080, width: double.infinity);
        }
        else if (controller.electricityAnalysisProSourceList.isEmpty || (controller.electricityAnalysisProLoadList.isEmpty) ) {
          return Center(child: Lottie.asset(AssetsPath.emptyJson,height: size.height * 0.080));
        }

        ElectricityAnalysisProModel dayModel = controller.electricityAnalysisProSourceList.first;

        return Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 7.0,
          children: _buildChoiceChips(dayModel, controller),
        );
      },
    );
  }

  List<Widget> _buildChoiceChips(ElectricityAnalysisProModel dayModel, ElectricityDayAnalysisProController controller) {
    List<Widget> chips = [];

    if (dayModel.nodeName?.isNotEmpty ?? false) {
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
/*
    if (dayModel.waterData?.isNotEmpty ?? false) {
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

   if (dayModel.gasData?.isNotEmpty ?? false) {
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

    if (dayModel.nodeName?.isNotEmpty ?? false) {
      chips.add(
        ChoiceChip(
          label: const TextComponent(text:'Consumption'),
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

  void _onChipSelected(ElectricityDayAnalysisProController controller, int index, bool selected) {
    // Use Future.micro task to avoid immediate update during build
    Future.microtask(() {
      controller.toggleSelection(index, selected);
    });
  }
}
