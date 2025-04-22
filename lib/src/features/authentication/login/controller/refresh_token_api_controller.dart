// import 'dart:async';
// import 'dart:developer';
// import 'package:nz_ums/src/services/internet_connectivity_check_mixin.dart';
// import 'package:nz_ums/src/services/network_caller.dart';
// import 'package:nz_ums/src/services/network_response.dart';
// import 'package:nz_ums/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_ums/src/utility/app_urls/app_urls.dart';
// import 'package:nz_ums/src/utility/exception/app_exception.dart';
// import 'package:get/get.dart';
//
// class RefreshTokenApiController extends GetxController with InternetConnectivityCheckMixin{
//
//   bool _isConnected = true;
//   bool _isRefreshInProgress = false;
//   String _errorMessage = '';
//
//   bool get isConnected => _isConnected;
//   bool get isRefreshInProgress => _isRefreshInProgress;
//   String get errorMessage => _errorMessage;
//
//
//   Timer? _timer;
//
//
//
//   @override
//   void onInit() {
//    _timer = Timer.periodic(const Duration(minutes: 5), (_){
//      getRefreshToken(refreshToken: AuthUtilityController.refreshToken ?? '');
//    });
//     super.onInit();
//   }
//
//
//
//   Future<bool>getRefreshToken({required String refreshToken}) async{
//
//     _isRefreshInProgress = true;
//     update();
//
//     Map<String,String> requestBody = {
//       "refresh_token": refreshToken,
//     };
//
//
//     try{
//       await internetConnectivityCheck();
//
//       NetworkResponse response = await NetworkCaller.refreshTokenRequest(url: Urls.refreshTokenUrl, body: requestBody);
//
//        log("refreshTokenUrl statusCode ==> ${response.statusCode}");
//        log("refreshTokenUrl body ==> ${response.body}");
//
//       _isRefreshInProgress = false;
//
//       if(response.isSuccess){
//         var responseBody = response.body;
//         AuthUtilityController.setAccessToken(token: "Bearer ${responseBody['access']}");
//
//         log("========== refreshTokenUrl ======= Bearer ${response.body['access']}");
//
//         update();
//         return true;
//       }else{
//         _errorMessage = "Token Refresh Failed";
//         update();
//         return false;
//       }
//     }catch(e){
//       _isRefreshInProgress = false;
//
//       _errorMessage = e.toString();
//       if (e is AppException) {
//         _errorMessage = e.error.toString();
//         _isConnected = false;
//       }
//       _errorMessage = "Token Refresh Failed";
//       log('Error in Refresh Token : $_errorMessage');
//
//       update();
//       return false;
//     }
//
//   }
//
//   /*----------------------------ui -------------------------*/
//   bool showPassword = false;
//
//   void showPasswordMethod(){
//     showPassword = !showPassword;
//     update();
//   }
//
//
//
// }