
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:nz_fabrics/src/features/authentication/login/views/screen/login_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/views/screen/ems_dashboard.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
     goToNextPage();
  }

  Future<void> goToNextPage() async {
    await AuthUtilityController.getAccessToken();
    await AuthUtilityController.getRefreshToken();
    await AuthUtilityController.getUserRole();
    Future.delayed(const Duration(seconds: 6), () {
      Get.offAll(()=> AuthUtilityController.isLoggedIn ? const EmsDashboardScreen() :  LoginScreen(),transition: Transition.fadeIn,duration: const Duration(seconds: 1));
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Column(
       // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: size.height * 0.1,),
          Text("NZ Fabrics",style: GoogleFonts.kadwa(color:AppColors.primaryColor,fontSize: size.height * 0.028,fontWeight: FontWeight.w700 )),
        /*  Text("Utility Management System",style: GoogleFonts.kadwa(color:AppColors.primaryColor,fontSize: size.height * 0.028,fontWeight: FontWeight.w500 ),),*/
         SizedBox(height: size.height * k16TextSize,),
          Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             SvgPicture.asset(AssetsPath.leftLineIconSVG),

             SizedBox(
               // width: 250.0,
               child: DefaultTextStyle(
                 style:  GoogleFonts.kavivanar(color:AppColors.primaryTextColor,fontSize: size.height * k16TextSize,fontWeight: FontWeight.w600 ),
                 child: AnimatedTextKit(
                   repeatForever: false,
                   pause: const Duration(seconds: 5),
                   animatedTexts: [
                     TyperAnimatedText('Powered by Scube Technologies Ltd.'),
                   ],
                 ),
               ),
             ),
             SvgPicture.asset(AssetsPath.rightLineIconSVG),
           ],
         ),
          SizedBox(height: size.height * 0.03,),
          Center(child: Image.asset(AssetsPath.splashGif)),
        ],
      ),
    );
  }
}