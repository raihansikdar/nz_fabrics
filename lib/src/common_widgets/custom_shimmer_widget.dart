
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerWidget extends StatelessWidget {
  const CustomShimmerWidget({
    super.key, required this.height, required this.width,
  });
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor:
        Colors.black.withOpacity(0.04),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(size.height * k16TextSize),

          ),
        )
    );
  }
}