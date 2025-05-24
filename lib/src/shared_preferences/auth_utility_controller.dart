import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUtilityController{
  static String? _accessToken;
  static String? _refreshToken;
  static String? _userRole;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;
  static String? get userRole => _userRole;

  static String? _userName;
  static String? get userName => _userName;

  /*----------------> Access Token <------------------*/
  static Future<void> setUserName({required String email}) async {
    // Save email to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', email);
  }

  static Future<String?> getUserName() {
    // Retrieve email from SharedPreferences
    return SharedPreferences.getInstance().then((prefs) => prefs.getString('user_email'));
  }

  static Future<void> clearUserName() async {
    // Clear saved email
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }






  static Rxn<String> accessTokenForApiCall = Rxn<String>();

/*----------------> Access Token <------------------*/
  static Future<void> setAccessToken({required String? token}) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (token != null) {
      await sharedPreferences.setString('accessToken', token);
    } else {
      await sharedPreferences.remove('accessToken');
    }

    _accessToken = token;
    accessTokenForApiCall.value = token;
    debugPrint("====> Set Token: $_accessToken");
  }


  static Future<void> getAccessToken()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _accessToken =  sharedPreferences.getString('accessToken');
    accessTokenForApiCall.value =  _accessToken;
    debugPrint("====>Token: $_accessToken");
  }




  /*----------------> Refresh Token <------------------*/
  static Future<void> setRefreshToken({required String? refreshToken}) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (refreshToken != null) {
      await sharedPreferences.setString('refreshToken', refreshToken);
    } else {
      await sharedPreferences.remove('refreshToken');
    }

    _refreshToken = refreshToken;
    debugPrint("====> Set refreshToken: $_refreshToken");
  }


  static Future<void> getRefreshToken()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _refreshToken =  sharedPreferences.getString('refreshToken');
    debugPrint("====>get Refresh Token: $_refreshToken");
  }





  /*----------------> User Role <------------------*/
  static Future<void>setUserRole({required String? userRole}) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(userRole != null){
      await  sharedPreferences.setString('userRole', userRole);
    }else{
      await sharedPreferences.remove('userRole');
    }

    _userRole = userRole;
    debugPrint("====> Set User Role: $_userRole");
  }


  static Future<void> getUserRole()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _userRole =  sharedPreferences.getString('userRole');
    debugPrint("====>Get User Role: $_userRole");
  }

  static Future<void> clearInfo()async{
    accessTokenForApiCall.value = null;
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
  static bool get isLoggedIn{
    return _accessToken != null;
  }

}