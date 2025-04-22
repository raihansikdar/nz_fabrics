import 'package:nz_fabrics/src/features/user_management/controller/user_management_controller.dart';
import 'package:nz_fabrics/src/features/user_management/views/widget/active_user_management_box_widget.dart';
import 'package:nz_fabrics/src/features/user_management/views/widget/user_management_box_widget.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../utility/assets_path/assets_path.dart';

class ManagementRowWidget extends StatelessWidget {
  const ManagementRowWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserManagementController>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(height: size.height * k16TextSize),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => controller.setActiveBox(0),
                  child: controller.selectedIndex == 0
                      ? ActiveUserManagementBoxWidget(
                    size: size,
                    boxColor: AppColors.primaryColor,
                    textColor: AppColors.whiteTextColor,
                    firstText: 'Create',
                    secondText: 'user',
                    firstSvgPicture: SvgPicture.asset(
                      AssetsPath.createUserIconSVG,
                      color: AppColors.whiteTextColor,
                      height: size.height * 0.038,
                    ),
                    secondSvgPicture: SvgPicture.asset(
                      AssetsPath.blueTriangleIconSVG,
                      color: AppColors.primaryColor,
                      height: size.height * k25TextSize,
                    ),
                  )
                      : UserManagementBoxWidget(
                    size: size,
                    boxColor: const Color(0xFFe2f1f5),
                    textColor: AppColors.primaryColor,
                    firstText: 'Create',
                    secondText: 'user',
                    firstSvgPicture: SvgPicture.asset(
                      AssetsPath.createUserIconSVG,
                      color: AppColors.primaryColor,
                      height: size.height * 0.038,
                    ),
                  ),
                ),

                // Second Box (Create Request)
                GestureDetector(
                  onTap: () => controller.setActiveBox(1),
                  child: controller.selectedIndex == 1
                      ? ActiveUserManagementBoxWidget(
                    size: size,
                    boxColor: AppColors.mistyBoldTextColor,
                    textColor: AppColors.whiteTextColor,
                    firstText: 'Pending',
                    secondText: 'Request',
                    firstSvgPicture: SvgPicture.asset(
                      AssetsPath.pendingRequestIconSVG,
                      color: AppColors.whiteTextColor,
                      height: size.height * 0.038,
                    ),
                    secondSvgPicture: SvgPicture.asset(
                      AssetsPath.blueTriangleIconSVG,
                      color: AppColors.mistyBoldTextColor,
                      height: size.height * k25TextSize,
                    ),
                  )
                      : UserManagementBoxWidget(
                    size: size,
                    boxColor: AppColors.mistyTextColor,
                    textColor: AppColors.mistyBoldTextColor,
                    firstText: 'Pending',
                    secondText: 'Request',
                    firstSvgPicture: SvgPicture.asset(
                      AssetsPath.pendingRequestIconSVG,
                      color: AppColors.mistyBoldTextColor,
                      height: size.height * 0.038,
                    ),
                  ),
                ),

                // Third Box (Change User Type)
                GestureDetector(
                  onTap: () => controller.setActiveBox(2),
                  child: controller.selectedIndex == 2
                      ? ActiveUserManagementBoxWidget(
                    size: size,
                    boxColor: AppColors.greyBoldTextColor,
                    textColor: AppColors.whiteTextColor,
                    firstText: 'Change',
                    secondText: 'User Type',
                    firstSvgPicture: SvgPicture.asset(
                      AssetsPath.userManagementIconSVG,
                      color: AppColors.whiteTextColor,
                      height: size.height * 0.038,
                    ),
                    secondSvgPicture: SvgPicture.asset(
                      AssetsPath.blueTriangleIconSVG,
                      color: AppColors.greyBoldTextColor,
                      height: size.height * k25TextSize,
                    ),
                  )
                      : UserManagementBoxWidget(
                    size: size,
                    boxColor: AppColors.greyTextColor,
                    textColor: AppColors.greyBoldTextColor,
                    firstText: 'Change',
                    secondText: 'User Type',
                    firstSvgPicture: SvgPicture.asset(
                      AssetsPath.userManagementIconSVG,
                      color: AppColors.greyBoldTextColor,
                      height: size.height * 0.038,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}