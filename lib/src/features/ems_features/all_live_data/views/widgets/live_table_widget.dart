import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class LiveTableWidget extends StatelessWidget {
  const LiveTableWidget({
    super.key,
    required this.size, required this.color, required this.line1, required this.line2, required this.line3,
  });

  final Size size;
  final Color color;
  final String line1;
  final String line2;
  final String line3;
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(
          color: AppColors.containerBorderColor,
          width: 1.0,
          borderRadius: BorderRadius.circular(size.height * k8TextSize)
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(size.height * k8TextSize),topRight: Radius.circular(size.height * k8TextSize)),
          ),
          children:  [
            Center(
              child: SizedBox(
                height: size.height * k40TextSize,
                child: const Center(child: TextComponent(text: "Line1")),
              ),
            ),
            Center(
              child: SizedBox(
                height: size.height * k40TextSize,
                child: const Center(child: TextComponent(text: "Line2")),
              ),
            ),
            Center(
              child: SizedBox(
                height: size.height * k40TextSize,
                child: const Center(child: TextComponent(text: "Line3")),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Center(
              child: SizedBox(
                height: size.height * k40TextSize,
                child:  Center(child: TextComponent(text: line1)),
              ),
            ),
            Center(
              child: SizedBox(
                height: size.height * k40TextSize,
                child:  Center(child: TextComponent(text: line1)),
              ),
            ),
            Center(
              child: SizedBox(
                height: size.height * k40TextSize,
                child:  Center(child: TextComponent(text: line1)),
              ),
            ),
          ],
        ),
        // Add more TableRows here for additional data
      ],
    );
  }
}