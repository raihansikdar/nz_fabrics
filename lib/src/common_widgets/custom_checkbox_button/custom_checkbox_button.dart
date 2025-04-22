// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// class CustomIconCheckbox extends StatefulWidget {
//   final String checkedIcon;
//   final String uncheckedIcon;
//   final bool initialValue;
//   final ValueChanged<bool> onChanged;
//
//   const CustomIconCheckbox({
//     super.key,
//     required this.checkedIcon,
//     required this.uncheckedIcon,
//     this.initialValue = false,
//     required this.onChanged,
//   });
//
//   @override
//   State<CustomIconCheckbox> createState() => _CustomIconCheckboxState();
// }
//
// class _CustomIconCheckboxState extends State<CustomIconCheckbox> {
//   late bool isChecked;
//
//   @override
//   void initState() {
//     super.initState();
//     isChecked = widget.initialValue;
//   }
//
//   void _toggleCheckbox() {
//     setState(() {
//       isChecked = !isChecked;
//       widget.onChanged(isChecked);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size =MediaQuery.of(context).size;
//     return GestureDetector(
//       onTap: _toggleCheckbox,
//       //child: isChecked ? widget.checkedIcon : widget.uncheckedIcon,
//       child: isChecked 
//        ? SvgPicture.asset(widget.checkedIcon, width: size.width * k25TextSize, height:  size.height * k25TextSize,color: AppColors.primaryColor,)
//         : SvgPicture.asset(widget.uncheckedIcon, width: 24, height: 24,color: const Color(0xFF776F86),),
//     );
//   }
// }
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconCheckbox extends StatefulWidget {
  final bool initialValue;
  final String checkedIcon;
  final String uncheckedIcon;
  final ValueChanged<bool> onChanged;

  const CustomIconCheckbox({
    super.key,
    required this.initialValue,
    required this.checkedIcon,
    required this.uncheckedIcon,
    required this.onChanged,
  });

  @override
  State<CustomIconCheckbox> createState() => _CustomIconCheckboxState();
}

class _CustomIconCheckboxState extends State<CustomIconCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomIconCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _isChecked = widget.initialValue;
      });
    }
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _toggleCheckbox,
        child: Row(
            children: [
              SvgPicture.asset(
                _isChecked ? widget.checkedIcon : widget.uncheckedIcon,
                height: 24.0,
                width: 24.0,
                colorFilter: ColorFilter.mode(
                  _isChecked ? AppColors.primaryColor : const Color(0xFF776F86),
                  BlendMode.srcIn,
                ),
              ),
            ],
            ),
        );
  }
}