// import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
// import 'package:nz_fabrics/src/utility/style/app_colors.dart';
// import 'package:nz_fabrics/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
//
//
// class MyErrorWidget extends StatelessWidget {
//   const MyErrorWidget({
//     super.key,
//     required Size size, required this.onPressed,
//   }) : _size = size;
//
//   final Size _size;
//   final VoidCallback onPressed;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.only(bottom: _size.height * 0.10),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(child: Lottie.asset(AssetsPath.errorJson, height: _size.height * 0.36)),
//           // Text(
//           //   "Oops some this went wrong",
//           //   style:  TextStyle(
//           //       fontSize: _size.height * k18TextSize,
//           //       fontWeight: FontWeight.w600,
//           //       color: Colors.grey),
//           // ),
//           // SizedBox(
//           //   height: _size.height * k16TextSize,
//           // ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               side: BorderSide.none,
//               minimumSize: _size.height < smallScreenWidth ?   Size(_size.width * 0.250, _size.height * 0.065) : Size(_size.width * 0.250, _size.height * 0.045),
//             ),
//             onPressed:onPressed,
//             child: Text('Try Again',style: TextStyle(color: AppColors.whiteTextColor,fontSize: _size.height *k16TextSize),),
//           ),
//         ],
//       ),
//     );
//   }
// }
