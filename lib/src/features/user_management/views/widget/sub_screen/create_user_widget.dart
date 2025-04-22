import 'package:nz_fabrics/src/common_widgets/circular_inside_button_widget.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/features/user_management/controller/create_user_controller.dart';
import 'package:nz_fabrics/src/utility/app_toast/app_toast.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateUserWidget extends StatefulWidget {
  const CreateUserWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<CreateUserWidget> createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {

  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _phoneNumberTEController = TextEditingController();
  final TextEditingController _companyNameTEController = TextEditingController();
  final TextEditingController _addressTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

//  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:  widget.size.height * k16TextSize),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: GetBuilder<CreateUserController>(
            builder: (createUserController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: widget.size.height * k30TextSize,),
                  const TextComponent(text: "Name"),
                  Padding(
                    padding: EdgeInsets.only(top: widget.size.height * 0.004, bottom: widget.size.height * k16TextSize),
                    child: TextFormField(
                      controller: _nameTEController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: widget.size.height * k16TextSize),
                          hintText: "Write Name"
                      ),
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }else if(value!.length < 4){
                          return "Name must be greater than 4 digit";
                        }
                        return null;
                      },
                    ),
                  ),

                  const TextComponent(text: "Email"),
                  Padding(
                    padding: EdgeInsets.only(top: widget.size.height * 0.004, bottom: widget.size.height * k16TextSize),
                    child: TextFormField(
                      controller: _emailTEController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: widget.size.height * k16TextSize),
                          hintText: "Enter User Email",
                        suffixIcon: createUserController.isEmailError ? const Icon(Icons.error_outline, color: AppColors.primaryColor) : null,
                      ),
                      onChanged: (String? value){
                        if(value!.isEmail == true){
                            createUserController.changeErrorCondition(emailErrorValue: false);
                        }
                        if(value.isEmail == false){
                            createUserController.changeErrorCondition(emailErrorValue: true);
                        }
                        if(value.isEmpty){
                          createUserController.changeErrorCondition(emailErrorValue: false);
                        }
                      },
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }else if(value!.isEmail == false){
                          createUserController.changeErrorCondition(emailErrorValue: true);
                          return "Enter valid email address";
                        }
                        return null;
                      },
                    ),
                  ),

                  const TextComponent(text: "Phone Number"),
                  Padding(
                    padding: EdgeInsets.only(top: widget.size.height * 0.004, bottom: widget.size.height * k16TextSize),
                    child: TextFormField(
                      controller: _phoneNumberTEController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: widget.size.height * k16TextSize),
                          hintText: "Enter User Phone Number",
                          suffixIcon: createUserController.isPhoneNumberError ? const Icon(Icons.error_outline,color: AppColors.primaryColor,) : null,
                      ),
                      onChanged: (String? value){
                        if(value!.isEmpty){
                          createUserController.changePhoneNumberCondition(phoneNumberErrorValue: false);
                        }
                        if( value.isNotEmpty && value.length != 11 ){
                          createUserController.changePhoneNumberCondition(phoneNumberErrorValue: true);
                        }
                        if( value.length == 11 ){
                          createUserController.changePhoneNumberCondition(phoneNumberErrorValue: false);
                        }
                      },
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        } if( value!.length != 11 ){
                          return "Phone number is must be 11 digit";
                        }
                        return null;
                      },
                    ),
                  ),

                  const TextComponent(text: "Company Name"),
                  Padding(
                    padding: EdgeInsets.only(top: widget.size.height * 0.004, bottom: widget.size.height * k16TextSize),
                    child: TextFormField(
                      controller: _companyNameTEController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: widget.size.height * k16TextSize),
                        hintText: "Enter User Company Name",

                      ),
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }
                        return null;
                      },
                    ),
                  ),


                  const TextComponent(text: "Address"),
                  Padding(
                    padding: EdgeInsets.only(top: widget.size.height * 0.004, bottom: widget.size.height *k50TextSize),
                    child: TextFormField(
                      controller: _addressTEController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: widget.size.height * k16TextSize),
                          hintText: "Write User Address"
                      ),
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "This field is mandatory";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    height: widget.size.height * 0.05,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(widget.size.height * k8TextSize),
                            )
                        ),
                        onPressed: (){
                       if(!_formKey.currentState!.validate()){
                         return;
                       }
                       createUserAccount(createUserController);
                        }, child: createUserController.isCreateUserInProgress ? CircularInsideButtonWidget(size: widget.size) : TextComponent(text: "Create",color: AppColors.whiteTextColor,fontSize: widget.size.height * k18TextSize,)),
                  ),


                  SizedBox(height: widget.size.height * k30TextSize,),

                ],
              );
            }
          ),
        ),
      ),
    );
  }


  Future<void> createUserAccount(CreateUserController createUserController) async {
    final response = await createUserController.registerByAdmin(
        name: _nameTEController.text.trim(),
        email: _emailTEController.text.trim(),
        phoneNumber: _phoneNumberTEController.text.trim(),
        companyName: _companyNameTEController.text.trim(),
        address: _addressTEController.text.trim(),
    );

    if(response){
      AppToast.showSuccessToast("Successfully user account created and password has been sent in user email.");
      _nameTEController.clear();
      _emailTEController.clear();
      _phoneNumberTEController.clear();
      _companyNameTEController.clear();
      _addressTEController.clear();
    }else{
      AppToast.showWrongToast(createUserController.errorMessage);
    }
  }


}