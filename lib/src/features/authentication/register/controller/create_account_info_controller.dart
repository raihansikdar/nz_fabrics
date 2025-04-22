// import 'dart:developer';
// import 'dart:io';
//
// import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
// import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
// import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'package:mime/mime.dart';
//
// class CreateAccountInfoController extends GetxController with InternetConnectivityCheckMixin{
//
//   bool _isConnected = true;
//   bool _isCreateAccountInProgress = false;
//   String _errorMessage = '';
//
//   bool get isConnected =>  _isConnected;
//   bool get isCreateAccountInProgress => _isCreateAccountInProgress;
//   String get errorMessage => _errorMessage;
//   Future<bool> createAccount({
//     required String name,
//     required String bloodGroup,
//     required String phoneNumber,
//     required String birthDate,
//     required String gender,
//     required String personalAddress,
//     required String lastDonateDate,
//     required String lastDonateLocation,
//     required String email,
//     required String password,
//     required File profileImage,
//   }) async {
//     _isConnected = true;
//     _isCreateAccountInProgress = true;
//     update();
//
//     try {
//
//       await internetConnectivityCheck();
//
//       var uri = Uri.parse(Urls.createAccountUrl);
//       var request = http.MultipartRequest('POST', uri)
//         ..fields['name'] = name
//         ..fields['email'] = email
//         ..fields['password'] = password
//         ..fields['blood_group'] = bloodGroup
//         ..fields['phone_no'] = phoneNumber
//         ..fields['birth_date'] = birthDate
//         ..fields['gender'] = gender
//         ..fields['address'] = personalAddress
//         ..fields['last_donation_date'] = lastDonateDate
//         ..fields['last_donation_address'] = lastDonateLocation;
//
//       // Determine the content type based on the file extension
//       final mimeType = lookupMimeType(profileImage.path) ?? 'application/octet-stream';
//       final contentType = MediaType.parse(mimeType);
//
//       request.files.add(await http.MultipartFile.fromPath(
//         'picture',
//         profileImage.path,
//         contentType: contentType,
//       ));
//
//       var response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       log("Create account request statusCode: ${response.statusCode}");
//       log("Create account request body: $responseBody");
//
//       if (response.statusCode == 201) {
//         _isCreateAccountInProgress = false;
//         update();
//         return true;
//       } else {
//         _errorMessage = "Error: ${response.statusCode} - $responseBody";
//         log("Error response body: $responseBody");
//         return false;
//       }
//     } catch (e) {
//
//       _isCreateAccountInProgress = false;
//
//       _errorMessage = e.toString();
//       if (e is AppException) {
//         _errorMessage = e.error.toString();
//         _isConnected = false;
//       }
//
//       log('Error in fetchProjectData: $_errorMessage');
//
//       update();
//       return false;
//     } /*finally {
//       _isCreateAccountInProgress = false;
//       update();
//     }*/
//   }
//
//   /* ------------------------------------------------- UI -----------------------------------------------*/
//   File? pikeImage;
//
//   Future<void> pickImageMethod() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       pikeImage = File(pickedFile.path);
//       update();
//     }
//   }
//
//   bool showPassword = false;
//
//   void showPasswordMethod(){
//     showPassword = !showPassword;
//     update();
//   }
//
// }

import 'dart:developer';
import 'dart:io';

import 'package:nz_fabrics/src/services/internet_connectivity_check_mixin.dart';
import 'package:nz_fabrics/src/services/network_caller.dart';
import 'package:nz_fabrics/src/services/network_response.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/exception/app_exception.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateAccountInfoController extends GetxController with InternetConnectivityCheckMixin{

  bool _isConnected = true;
  bool _isCreateAccountInProgress = false;
  String _errorMessage = '';

  bool get isConnected => _isConnected;
  bool get isCreateAccountInProgress => _isCreateAccountInProgress;
  String get errorMessage => _errorMessage;



  Future<bool>createOwnAccount({required String name, required String email, required String phoneNumber,required String password ,required String companyName, required String address}) async {

    _isCreateAccountInProgress = true;
    update();


    Map<String,String> requestBody = {
      "first_name": name,
      "email": email,
      "phone_no": phoneNumber,
      "password": password,
      "company_name": companyName,
      "address": address,
    };


    try {
      await internetConnectivityCheck();

      NetworkResponse response = await NetworkCaller.postRegisterRequest(url: Urls.createAccountUrl,body: requestBody);

      // log("createAccountUrl statusCode ==> ${response.statusCode}");
      // log("createAccountUrl body ==> ${response.body}");

      _isCreateAccountInProgress = false;
      update();

      if (response.isSuccess) {

        update();
        return true;

      } else {
        _errorMessage = " Failed to create account!";
        update();
        return false;
      }
    } catch (e) {
      _isCreateAccountInProgress = false;
      _errorMessage = e.toString();

      if (e is AppException) {
        _errorMessage = e.error.toString();
        _isConnected = false;
      }
      log('Error in create account: $_errorMessage');
      _errorMessage = " Failed to create account!";

      return false;
    }
  }




  /*------------------------------- UI ---------------------------------*/
  bool  isEmailError = false;

  void changeErrorCondition({required bool emailErrorValue}) {
    isEmailError = emailErrorValue;
    update();
  }

  bool  isPhoneNumberError = false;

  void changePhoneNumberCondition({required bool phoneNumberErrorValue}) {
    isPhoneNumberError = phoneNumberErrorValue;
    update();
  }

  File? pikeImage;

  Future<void> pickImageMethod() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      pikeImage = File(pickedFile.path);
      update();
    }
  }

  bool showPassword = false;

  void showPasswordMethod(){
    showPassword = !showPassword;
    update();
  }

}