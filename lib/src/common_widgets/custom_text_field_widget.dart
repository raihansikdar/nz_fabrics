import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    super.key, required this.hintText,  this.keyboardType,this.onChanged,this.suffixIcon, this.obscureText,  this.controller, this.validator,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool? obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      height: size.height < smallScreenWidth ? size.height * 0.080 : null,
      child: TextFormField(
        controller: controller,
          style: TextStyle(fontSize: size.height * k18TextSize),
          keyboardType:keyboardType,
          obscureText : obscureText ?? false,
          decoration:  InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
        onChanged: onChanged,
        validator: validator,

      ),
    );
  }
}