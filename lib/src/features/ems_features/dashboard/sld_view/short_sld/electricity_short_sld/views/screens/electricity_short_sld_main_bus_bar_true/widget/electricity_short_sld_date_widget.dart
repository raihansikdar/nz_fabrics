import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/small_button_circular_progress_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/controller/electricity_short_sld_main_bus_bar_true_controller/electricity_short_sld_filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElectricityShortSLDDateWidget extends StatefulWidget {
  final String nodeName;
  const ElectricityShortSLDDateWidget({super.key, required this.nodeName});

  @override
  State<ElectricityShortSLDDateWidget> createState() => _ElectricityShortSLDDateWidgetState();
}

class _ElectricityShortSLDDateWidgetState extends State<ElectricityShortSLDDateWidget> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
               Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * k16TextSize,vertical: size.height * k16TextSize),
                child: CustomContainer(
                    height: size.width > 600 ? size.height * 0.15 : size.height * 0.16,
                    width: double.infinity,
                    borderRadius:
                    BorderRadius.circular(size.height * k8TextSize),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.height * k16TextSize,right: size.height * k16TextSize,top:  size.height * k20TextSize,bottom:  size.height * k12TextSize),
                          child:  Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  GetBuilder<ElectricityShortSLDFilterBusBarEnergyCostController>(
                                      builder: (filterSpecificNodeDataController) {
                                        return SizedBox(
                                          width: size.width * 0.370,
                                          child: TextFormField(
                                            onTap: () async {

                                              filterSpecificNodeDataController.formDatePicker(context);
                                            },

                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: filterSpecificNodeDataController.fromDateTEController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: size.height * k16TextSize),
                                              hintText: "From Date",
                                              suffixIcon: Icon(
                                                Icons.calendar_today_outlined,
                                                size: size.height * k24TextSize,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                  SizedBox(
                                    width: size.width * 0.050,
                                  ),
                                  GetBuilder<ElectricityShortSLDFilterBusBarEnergyCostController>(
                                      builder: (filterBusBarEnergyCostController) {
                                        return SizedBox(
                                          width: size.width * 0.385,
                                          child: TextFormField(
                                            onTap: () {
                                              filterBusBarEnergyCostController.toDatePicker(context);
                                            },
                                            style: TextStyle(fontSize: size.height * k18TextSize),
                                            controller: filterBusBarEnergyCostController.toDateTEController,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: size.height * k16TextSize),
                                              hintText: "To Date",
                                              suffixIcon: Icon(
                                                Icons.calendar_today_outlined,
                                                size: size.height * k24TextSize,
                                              ),
                                            ),
                                            // validator: validator,
                                          ),
                                        );
                                      }),
                                ],
                              ),
                              SizedBox(height: size.width > 600 ? size.height * k12TextSize : size.height * k16TextSize,),
                              SizedBox(
                                height:  size.width > 600 ? size.width * 0.07 : size.width * 0.1,
                                width: size.width * 0.4,
                                child: GetBuilder<ElectricityShortSLDFilterBusBarEnergyCostController>(
                                    builder: (filterBusBarEnergyCostController) {
                                      return ElevatedButton(

                                          onPressed: () async {

                                            filterBusBarEnergyCostController.checkDateDifference(context);
                                            await filterBusBarEnergyCostController.fetchFilterSpecificData(busBarName: widget.nodeName,fromDate:  filterBusBarEnergyCostController.fromDateTEController.text, toDate:  filterBusBarEnergyCostController.toDateTEController.text,fromButton: true);

                                          }, child: filterBusBarEnergyCostController.isFilterBusBarEnergyCostInProgress ? SmallButtonCircularProgressBarWidget(size: size) :  const TextComponent(text: "Submit",color: AppColors.whiteTextColor,));
                                    }
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              )

      ],
    );
  }

}

