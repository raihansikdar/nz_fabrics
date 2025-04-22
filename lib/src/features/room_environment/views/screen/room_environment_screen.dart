import 'package:nz_fabrics/src/common_widgets/app_bar/custom_app_bar_widget.dart';
import 'package:nz_fabrics/src/common_widgets/custom_container_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoomEnvironmentScreen extends StatefulWidget {
  const RoomEnvironmentScreen({super.key});

  @override
  State<RoomEnvironmentScreen> createState() => _RoomEnvironmentScreenState();
}

class _RoomEnvironmentScreenState extends State<RoomEnvironmentScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBarWidget(text: "Room Environment", backPreviousScreen: true),
      body:  Padding(
        padding: EdgeInsets.only(top: size.height * k30TextSize),
        child: Container(
          height: size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size.height * k20TextSize),
              topRight: Radius.circular(size.height * k20TextSize),
            ),
            border: Border.all(color: AppColors.containerBorderColor),
            color: AppColors.whiteTextColor,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: size.height * k16TextSize,left: size.height * k16TextSize,right: size.height * k16TextSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Average Sensor Data',style: TextStyle(color: AppColors.secondaryTextColor,fontSize: size.height * k18TextSize,fontFamily: boldFontFamily)),
                      TextSpan(text: ' Floor List!',style: TextStyle(color: AppColors.mistyBoldTextColor,fontSize: size.height * k18TextSize,fontFamily: boldFontFamily)),
                    ],
                  ),
                ),
                Divider(height: size.height * k8TextSize,),
                SizedBox(height: size.height * k16TextSize,),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: size.height * k16TextSize),
                    shrinkWrap: true,
                    primary: false,
                    itemCount: 10,
                      itemBuilder: (context,index){
                        return CustomContainer(
                            height: size.height * .16,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(size.height * k16TextSize),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                             children: [
                              Row(
                                children: [
                                  TextComponent(text: "Floor ${index + 1} Average Data",fontSize: size.height * k16TextSize,fontWeight: FontWeight.w600,),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: (){
                                        showBottomSheet(context,size, index);
                                      },
                                      child: SvgPicture.asset(AssetsPath.roomUpArrowIconSVG)),
                                ],
                              ),
                              const Divider(color: AppColors.containerBorderColor,),
                                                          
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextComponent(text: "Temperature",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: "Humidity",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: "Air Quality",color: AppColors.secondaryTextColor,),
                                    ],
                                  ),

                                  SizedBox(width: size.width * k25TextSize,),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                    ],
                                  ),
                                  SizedBox(width: size.width * k25TextSize,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextComponent(text: "45.3°C, 109.45°F",color: AppColors.primaryTextColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: "75%",color: AppColors.primaryTextColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: "Air Quality",color: AppColors.primaryTextColor,),
                                    ],
                                  ),

                                  SizedBox(width: size.width * k25TextSize,),

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const TextComponent(text: "| Good",color: AppColors.primaryColor,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: "| Bad",color: Colors.red,),
                                      SizedBox(height: size.height * k8TextSize,),
                                      const TextComponent(text: "| Moderate",color: AppColors.mistyBoldTextColor,),
                                    ],
                                  ),
                                ],
                              )
                              ],
                           ),
                          ));
                      },
                      separatorBuilder: (context,index) => SizedBox(height: size.height * k16TextSize,),
                  
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  void showBottomSheet(BuildContext context,Size size, int index) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return FractionallySizedBox(
         heightFactor: 0.82,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.height * k50TextSize,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(size.height * k16TextSize), topRight: Radius.circular(size.height * k16TextSize) )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     TextComponent(text: "Floor ${index + 1} All Sensor Data",color: AppColors.whiteTextColor,),
                      SizedBox(width: size.width * k30TextSize,),
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(AssetsPath.xCircleIconSVG)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.height * k8TextSize),
                child: CustomContainer(height: size.height * .16,
                width: double.infinity,
                borderRadius: BorderRadius.circular(size.height * k16TextSize),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextComponent(text: "Floor ${index + 1} Average Data",fontSize: size.height * k16TextSize,fontWeight: FontWeight.w600,color: AppColors.primaryColor,),

                        ],
                      ),
                      const Divider(color: AppColors.containerBorderColor,),

                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextComponent(text: "Temperature",color: AppColors.secondaryTextColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: "Humidity",color: AppColors.secondaryTextColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: "Air Quality",color: AppColors.secondaryTextColor,),
                            ],
                          ),

                          SizedBox(width: size.width * k25TextSize,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                            ],
                          ),
                          SizedBox(width: size.width * k25TextSize,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextComponent(text: "45.3°C, 109.45°F",color: AppColors.primaryTextColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: "75%",color: AppColors.primaryTextColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: "Air Quality",color: AppColors.primaryTextColor,),
                            ],
                          ),

                          SizedBox(width: size.width * k25TextSize,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextComponent(text: "| Good",color: AppColors.primaryColor,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: "| Bad",color: Colors.red,),
                              SizedBox(height: size.height * k8TextSize,),
                              const TextComponent(text: "| Moderate",color: AppColors.mistyBoldTextColor,),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: size.height * k10TextSize),
                  shrinkWrap: true,
                    primary: false,
                    itemCount: 10,
                    itemBuilder: (context,index){
                      return   Padding(
                        padding: EdgeInsets.symmetric(horizontal: size.height * k8TextSize),
                        child: CustomContainer(
                            height: size.height * .16,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(size.height * k16TextSize),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      TextComponent(text: "Room 1(East) Sensor Data",fontSize: size.height * k16TextSize,fontWeight: FontWeight.w600,color: AppColors.primaryTextColor,),

                                    ],
                                  ),
                                  const Divider(color: AppColors.containerBorderColor,),

                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextComponent(text: "Temperature",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: "Humidity",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: "Air Quality",color: AppColors.secondaryTextColor,),
                                        ],
                                      ),

                                      SizedBox(width: size.width * k25TextSize,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: ":",color: AppColors.secondaryTextColor,),
                                        ],
                                      ),
                                      SizedBox(width: size.width * k25TextSize,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextComponent(text: "45.3°C, 109.45°F",color: AppColors.primaryTextColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: "75%",color: AppColors.primaryTextColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: "Air Quality",color: AppColors.primaryTextColor,),
                                        ],
                                      ),

                                      SizedBox(width: size.width * k25TextSize,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const TextComponent(text: "| Good",color: AppColors.primaryColor,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: "| Bad",color: Colors.red,),
                                          SizedBox(height: size.height * k8TextSize,),
                                          const TextComponent(text: "| Moderate",color: AppColors.mistyBoldTextColor,),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                      );
                    },
                    separatorBuilder: (context,index) => SizedBox(height: size.height * k8TextSize,),
                
                ),
              )

            ],
          ),
        );
      },
    );
  }

}
