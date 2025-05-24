import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserInfoController{
  SaveUserInfoController._();

  static String? _userEmail;
  static String? get userEmail => _userEmail;

  static Future<void> setUserEmail({required String? email}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if(email != null && email != ''){
      await sharedPreferences.setString('user_email', email);
    }else{
      await sharedPreferences.remove('user_email');
    }

    _userEmail = email;
    debugPrint("====> Set Use Email: $_userEmail");
  }



  static Future<void> getUserEmail()async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _userEmail =  sharedPreferences.getString('user_email');
    debugPrint("====>Use -Email: $_userEmail");
  }



  static Future<void> clearUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    debugPrint("====>Removed Use Email: $_userEmail");
  }
}