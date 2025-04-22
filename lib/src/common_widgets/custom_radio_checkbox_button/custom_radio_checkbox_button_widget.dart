import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

class CustomRadioCheckboxButtonWidget<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String checkedIcon;
  final String uncheckedIcon;
  final Color selectedColor;
  final Color unselectedColor;
  final String label;

  const CustomRadioCheckboxButtonWidget({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.checkedIcon,
    required this.uncheckedIcon,
    this.selectedColor = AppColors.primaryColor,
    this.unselectedColor = AppColors.secondaryTextColor,
    required this.label,
  });

  @override
  State<CustomRadioCheckboxButtonWidget<T>> createState() => _CustomRadioCheckboxButtonWidgetState<T>();
}

class _CustomRadioCheckboxButtonWidgetState<T> extends State<CustomRadioCheckboxButtonWidget<T>> {
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
      child: Row(
        children: [
          // SVG Icon for Checkbox
          SvgPicture.asset(
            isSelected ? widget.checkedIcon : widget.uncheckedIcon,
            height: size.width > 700 ? size.height * 0.03 : size.height * 0.025,
            width: size.width > 700 ? size.height * 0.03 : size.height * 0.025,
            colorFilter: ColorFilter.mode(
              isSelected ? widget.selectedColor : widget.unselectedColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: size.width * 0.02),
          // Text Label
          TextComponent(
            text: widget.label,
            fontSize: size.height * 0.018,
            fontFamily: isSelected ? boldFontFamily : mediumFontFamily,
            color: isSelected ? widget.selectedColor : widget.unselectedColor,
          ),
        ],
      ),
    );
  }
}
