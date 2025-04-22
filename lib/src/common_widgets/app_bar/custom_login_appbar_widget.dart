
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class CustomLoginAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomLoginAppbar({
    super.key, required this.text,this.color,this.fontSize,this.fontFamily, required this.needLeading
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final bool needLeading ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      centerTitle: true,
      title: TextComponent(
        text: text,
        color: color ?? AppColors.primaryTextColor,
        fontSize: fontSize ?? size.height * .024,
        fontFamily: fontFamily ?? semiBoldFontFamily,
      ),
      toolbarHeight: size.height * 0.56,
      leading: needLeading ? IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back,size: size.height * iconSize,)) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}