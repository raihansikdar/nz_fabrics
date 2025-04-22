import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nz_fabrics/src/application/state_holder_binder.dart';
import 'package:nz_fabrics/src/features/splash/splash_screen.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnergyManagementSystem extends StatefulWidget {
  static GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  const EnergyManagementSystem({super.key});

  @override
  State<EnergyManagementSystem> createState() => _EnergyManagementSystemState();
}

class _EnergyManagementSystemState extends State<EnergyManagementSystem> {

  final InternetListenerController internetListenerController = Get.put(InternetListenerController());
  late final StreamSubscription<List<ConnectivityResult>> _streamSubscription;


  void checkInitialInternetConnection() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
   // handleConnectivityStates(connectivityResult);
    if (!internetListenerController.isSplashScreenActive.value) {
      handleConnectivityStates(connectivityResult);
    }
  }

  void checkInternetConnectivityStatus(){
    _streamSubscription = Connectivity().onConnectivityChanged.listen((status) {
     // handleConnectivityStates(status);

      if (!internetListenerController.isSplashScreenActive.value) {
        handleConnectivityStates(status);
      }

    });
  }

  // void handleConnectivityStates(List<ConnectivityResult> connectivityResult){
  //
  //   final currentRoute = ModalRoute.of(context)?.settings.name;
  //   if(connectivityResult.contains(ConnectivityResult.none)){
  //     if (currentRoute != SplashScreen.routeName) {
  //       if (currentRoute != SplashScreen.routeName && !internetListenerController.isSplashScreenActive.value) {
  //         noInternetSnackBar();
  //         NoInternetPage(onRetry: () {  },);
  //       }
  //     }
  //
  //   }else{
  //
  //     if (Get.isSnackbarOpen) {
  //       Get.closeAllSnackbars();
  //     }
  //   }
  // }

  void handleConnectivityStates(List<ConnectivityResult> connectivityResult) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (currentRoute != SplashScreen.routeName && !internetListenerController.isSplashScreenActive.value) {
        noInternetSnackBar();
      }
    } else {
      if (internetListenerController.isSnackBarActive.value) {
        Get.closeAllSnackbars();
        internetListenerController.isSnackBarActive.value = false; // Reset flag
      }
    }
  }



  @override
  void initState() {


    Future.delayed(const Duration(seconds: 8), () {

      internetListenerController.hideSplashScreen();

      checkInitialInternetConnection();
      checkInternetConnectivityStatus();
    });


    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.sizeOf(context);

    return GetMaterialApp(
      navigatorKey: EnergyManagementSystem.globalKey,
      debugShowCheckedModeBanner: false,
      initialBinding: StateHolderBinders(),
      title: 'Energy Monitoring Management',
      theme: ThemeData(
        primarySwatch: MaterialColor(AppColors.primaryColor.value, AppColors.colors),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * k10TextSize)),
            backgroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor, width: size.height * 0.001),
            minimumSize: size.height < smallScreenWidth ?   Size(double.infinity, size.height * 0.080) : Size(double.infinity, size.height * 0.060),
            textStyle: TextStyle(
              fontSize: size.height < smallScreenWidth
                  ? size.height * 0.022
                  : size.height * 0.022,
              letterSpacing: 0.5,
              fontFamily: mediumFontFamily,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: AppColors.whiteTextColor,
          filled: true,
          contentPadding:  EdgeInsets.symmetric(horizontal:size.height * k16TextSize, vertical:  size.height < smallScreenWidth ? 0.004 : size.height * 0.016),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.containerBorderColor, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.010),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.010),
           borderSide: const BorderSide(color: AppColors.containerBorderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.010),
            borderSide: const BorderSide(color: AppColors.containerBorderColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(size.height * 0.010),
            borderSide: const BorderSide(color: AppColors.containerBorderColor),
          ),
          hintStyle: TextStyle(
            color: AppColors.secondaryTextColor,
            fontSize:  size.height < smallScreenWidth ? size.height * .025 :size.height * k18TextSize,
            fontFamily: regularFontFamily,
          ),
        ),
      ),
      home: const  SplashScreen(),


    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void noInternetSnackBar() {

    if (internetListenerController.isSnackBarActive.value) return;  // 2. Prevent duplicate snackbars

    internetListenerController.isSnackBarActive.value = true; // 3. Mark snackbar as active

    Size size = MediaQuery.of(context).size;
    Get.showSnackbar(
      GetSnackBar(
        title: "No Internet Connection.",
        message: "Please turn on your Wifi or Mobile data",
        isDismissible: false,
        // duration: const Duration(seconds: 30),
        margin: EdgeInsets.only(left: size.height * k8TextSize,right: size.height * k8TextSize,bottom: size.height *k8TextSize),
        mainButton: TextButton(
          onPressed: () {
           // Get.back();
           //  if (Get.isSnackbarOpen) {
           //    Get.closeCurrentSnackbar();
           //  }

            Get.closeAllSnackbars();
            internetListenerController.isSnackBarActive.value = false; // 4. Reset snackbar status

            log('---------remove internet snack bar------------');
          // Navigator.pop(context);
          },
          child: const Text(
            "DISMISS",
            style: TextStyle(color: Colors.white),
          ),
        ),
        //backgroundColor: Colors.redAccent,
      ),
    );
  }
}


class InternetListenerController extends GetxController{
  final RxBool isSplashScreenActive = true.obs;
  final RxBool isSnackBarActive = false.obs; // 1. Track snackbar status

  void hideSplashScreen() {
    isSplashScreenActive.value = false;
  }

}





