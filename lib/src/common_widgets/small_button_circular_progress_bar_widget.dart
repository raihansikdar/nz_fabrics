import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class SmallButtonCircularProgressBarWidget extends StatelessWidget {
  const SmallButtonCircularProgressBarWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: size.height * k20TextSize,
        width: size.height * k20TextSize,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: size.height * 0.004,
        ));
  }
}