import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/model/schedule_chart_model.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompletedWorkWidget extends StatelessWidget {
  const CompletedWorkWidget({
    super.key,
    required this.size, required this.chartData,
  });

  final Size size;
  final ScheduleChartModel chartData;
  @override
  Widget build(BuildContext context) {

    DateTime date = DateTime.parse(chartData.timedate ?? '');
    String formattedDate = DateFormat('dd-MM yyyy').format(date);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.containerBorderColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(size.height * k12TextSize),
      ),
      child: Card(
        color: AppColors.whiteTextColor,
        elevation: 0,

        child: Padding(
          padding: EdgeInsets.all(size.height * k8TextSize),
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
                          SizedBox(width: size.width * 0.18,),
                          const TextComponent(text: "Completed",color: AppColors.primaryColor),
                        ],
                      ),
                      SizedBox(height: size.height * k10TextSize ,),
                      TextComponent(text: chartData.shedName ?? '',color: AppColors.primaryTextColor,),

                    ],
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}