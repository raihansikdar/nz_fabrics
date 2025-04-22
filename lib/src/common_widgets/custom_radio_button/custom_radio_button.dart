import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class CustomRectangularRadioButton<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  // final double width;
  // final double height;
  final Color selectedColor;
  final Color unselectedColor;
  final String label;

  const CustomRectangularRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    // this.width = 100.0,
    // this.height = 50.0,
    this.selectedColor = AppColors.primaryColor,
    this.unselectedColor = AppColors.secondaryTextColor,
    required this.label,
  });

  @override
  State<CustomRectangularRadioButton<T>> createState() => _CustomRectangularRadioButtonState<T>();
}

class _CustomRectangularRadioButtonState<T> extends State<CustomRectangularRadioButton<T>> {
  @override
  Widget build(BuildContext context) {
    final isSelected = widget.value == widget.groupValue;
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          widget.onChanged(widget.value);
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              height: size.width > 800 ?  size.height * 0.026 : size.height * 0.022,
              width: size.width > 800 ? size.height * 0.026 :size.height * 0.022,
              decoration: BoxDecoration(
                  color:  AppColors.whiteTextColor,
                  borderRadius: BorderRadius.circular(size.height * 0.013),
                  border: Border.all(color: isSelected ? widget.selectedColor : widget.unselectedColor,width: 2)
              ),
              alignment: Alignment.center,
              child: Padding(
                padding:  EdgeInsets.all(size.height * 0.0025),
                child: isSelected ? Container(
                  decoration: BoxDecoration(
                    color: isSelected ? widget.selectedColor : widget.unselectedColor,
                    borderRadius: BorderRadius.circular(size.height * 0.013),
                  ),
                ) : const SizedBox(),
              ),
            ),
            SizedBox(width: size.width * k16TextSize,),
            TextComponent(text: widget.label,fontSize: size.height * k18TextSize,fontFamily: isSelected  ?  boldFontFamily : mediumFontFamily,color:isSelected ? widget.selectedColor : widget.unselectedColor,)
          ],
        ),
      ),
    );
  }
}
