import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/application/app.dart';
import 'package:nz_fabrics/src/features/authentication/login/controller/refresh_token_api_controller.dart';
import 'package:nz_fabrics/src/features/authentication/login/views/screen/login_screen.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:http/http.dart';
import 'package:get/get.dart' as getx;


class NetworkCaller{
  //static var myError;
  /* ->>------------------------------------> get request method <----------------------------------<<- */
  static Future<NetworkResponse> getRequest({required String url}) async{
    try{
      Response response = await get(Uri.parse(url),headers: {'Authorization': AuthUtilityController.accessToken ?? ''});

      // log("getRequest URL ==> ${url}");
      // log("getRequest statusCode ==> ${response.statusCode}");
      //  log("getRequest body ==> ${response.body}");

      if(response.statusCode == 200 ){
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      } else if(response.statusCode == 401){
          log("--------> 401<---------");
          log("getRequest URL ==> $url");
          log("getRequest statusCode ==> ${response.statusCode}");
          log("Error time accessToken ==> ${AuthUtilityController.accessToken}");

         gotoLogin();

      }else{
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: null);
      }

    }catch (e) {
    //  myError = e.toString();
      log('Error : $e');
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: /*myError*/ null);
  }

  /* ->>------------------------------------>> post request method <<----------------------------------<<- */

  static Future<NetworkResponse> postRequest({required String url,required Map<String, dynamic> body}) async{
    try{

      Response response = await post(Uri.parse(url),headers: {'Content-Type': 'application/json','Authorization': "${AuthUtilityController.accessToken}"}, body: jsonEncode(body));

      // log("postRequest statusCode ==> ${response.statusCode}");
      // log("postRequest body ==> ${response.body}");

      if(response.statusCode == 201 || response.statusCode == 200){
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      }else if(response.statusCode == 401){
        log("--------> 401<---------");
        log("postRequest URL ==> $url");
        log("postRequest statusCode ==> ${response.statusCode}");

     //   gotoLogin();

      } else{
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: jsonDecode(response.body));
      }
    }catch(e){
      log(e.toString());
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }




  static Future<NetworkResponse> loginRegiPostRequest({required String url,required Map<String, dynamic> body}) async{
    try{

      Response response = await post(Uri.parse(url),headers: {'Content-Type': 'application/json'}, body: jsonEncode(body)).timeout(const Duration(seconds: 10));

      // log("postRequest statusCode ==> ${response.statusCode}");
      // log("postRequest body ==> ${response.body}");

      if(response.statusCode == 201 || response.statusCode == 200){
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      }else{
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body:  jsonDecode(response.body));
      }
    }catch(e){
      log(e.toString());
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }





  static Future<NetworkResponse> refreshTokenRequest({required String url,required Map<String, dynamic> body}) async{
    try{

      Response response = await post(Uri.parse(url),headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

      // log("postRequest statusCode ==> ${response.statusCode}");
      // log("postRequest body ==> ${response.body}");

      if(response.statusCode == 201 || response.statusCode == 200){
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      }else{
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body:  jsonDecode(response.body));
      }
    }catch(e){
      log(e.toString());
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }












  static Future<NetworkResponse> logoutPostRequest({required String url}) async{
    try{

      Response response = await post(Uri.parse(url),headers: {'Content-Type': 'application/json','Authorization': "${AuthUtilityController.accessToken}"});

      // log("logoutPostRequest statusCode ==> ${response.statusCode}");
      // log("logoutPostRequest body ==> ${response.body}");

      if(response.statusCode == 201 || response.statusCode == 200){
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      }else{
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body:  jsonDecode(response.body));
      }
    }catch(e){
      log(e.toString());
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }




  static Future<NetworkResponse> postRegisterRequest({required String url,required Map<String, dynamic> body}) async{
    try{

      Response response = await post(Uri.parse(url),headers: {'Content-Type': 'application/json',}, body: jsonEncode(body));

      // log("postRequest statusCode ==> ${response.statusCode}");
      // log("postRequest body ==> ${response.body}");

      if(response.statusCode == 201 || response.statusCode == 200){
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      }else{
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: jsonDecode(response.body));
      }
    }catch(e){
      log(e.toString());
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }


  ///----------------------------------->> put request method <<----------------------------------
  static Future<NetworkResponse> putRequest({required String url,required Map<String, dynamic> body}) async {
    try {
      Response response = await put(Uri.parse(url), headers: {'Content-Type': 'application/json','Authorization': "${AuthUtilityController.accessToken}"}, body: jsonEncode(body)).timeout(const Duration(seconds: 10));

     // log("putRequest statusCode ==> ${response.statusCode}");
     // log("putRequest body ==> ${response.body}");

      if (response.statusCode == 200) {
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      }else if(response.statusCode == 401){
        log("--------> 401<---------");
        log("postRequest URL ==> $url");
        log("postRequest statusCode ==> ${response.statusCode}");

       gotoLogin();

      }else {
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: null);
      }
    } catch (e) {
      log(e.toString());
    }

    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }

  static Future<NetworkResponse> putRequestWithoutBody({required String url}) async {
    try {
      Response response = await put(Uri.parse(url), headers: {'Content-Type': 'application/json','Authorization': "${AuthUtilityController.accessToken}"}).timeout(const Duration(seconds: 10));

      log("putRequest statusCode ==> ${response.statusCode}");
      log("putRequest body ==> ${response.body}");

      if (response.statusCode == 200) {
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      } else {
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: null);
      }
    } catch (e) {
      log(e.toString());
    }

    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }


  ///----------------------------------->> patch request method <<----------------------------------
  static Future<NetworkResponse> patchRequest({required String url}) async {
    try {
      Response response = await patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "${AuthUtilityController.accessToken}"
        },
      ).timeout(const Duration(seconds: 10));

    //  log("patchRequest statusCode ==> ${response.statusCode}");
     // log("patchRequest body ==> ${response.body}");

      if (response.statusCode == 200) {
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: jsonDecode(response.body));
      } else {
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: jsonDecode(response.body));
      }
    } catch (e) {
      log(e.toString());
    }

    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }

  /*----------------------------------->> delete request method <<----------------------------------*/
  static Future<NetworkResponse> deleteRequest({required String url}) async {
    try {
      Response response = await delete(Uri.parse(url), headers: {'Authorization': "${AuthUtilityController.accessToken}"}).timeout(const Duration(seconds: 10));

      log("deleteRequest statusCode ==> ${response.statusCode}");
      log("deleteRequest body ==> ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return NetworkResponse(isSuccess: true, statusCode: response.statusCode, body: response.body.isNotEmpty ? jsonDecode(response.body) : null);
      } else {
        return NetworkResponse(isSuccess: false, statusCode: response.statusCode, body: null);
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(isSuccess: false, statusCode: -1, body: null);
  }

  // static Future<void> gotoLogin() async {
  //   await AuthUtilityController.clearInfo();
  //   AuthUtilityController.accessTokenForApiCall.value = null;
  //   Navigator.pushAndRemoveUntil(
  //       EnergyManagementSystem.globalKey.currentContext!,
  //       MaterialPageRoute(builder: (context) =>  LoginScreen()), (route) => false);
  // }

  // static Future<void> gotoLogin() async {
  //     await AuthUtilityController.clearInfo();
  //     AuthUtilityController.accessTokenForApiCall.value = null;
  //
  //     Navigator.pushAndRemoveUntil(
  //       EnergyManagementSystem.globalKey.currentContext!,
  //       PageRouteBuilder(
  //         pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
  //         transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //
  //           var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
  //           return FadeTransition(opacity: fadeAnimation, child: child);
  //         },
  //         transitionDuration: const Duration(milliseconds: 300)
  //       ),
  //           (route) => false,
  //     );
  //
  //   }

  static Future<void> gotoLogin() async {
    final result  = await getx.Get.find<RefreshTokenApiController>().getRefreshToken(refreshToken: AuthUtilityController.refreshToken ?? '');

    if(!result){
        await AuthUtilityController.clearInfo();
        AuthUtilityController.accessTokenForApiCall.value = null;

        Navigator.pushAndRemoveUntil(
          EnergyManagementSystem.globalKey.currentContext!,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {

              var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);
              return FadeTransition(opacity: fadeAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 300)
          ),
              (route) => false,
        );

      }
    }


}