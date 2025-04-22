import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';

enum ExitOption {bottomSheet, popUp, backPressExit}

class FlutterSmartExitWidget extends StatefulWidget {
  final String? exitMessage;
  final ExitOption exitOption;
  final Color? backgroundColor;
  final TextStyle? exitMessageStyle;
  final Widget child;

  @override
  State<FlutterSmartExitWidget> createState() => _FlutterSmartExitWidgetState();

  const FlutterSmartExitWidget({
    super.key,
    this.exitMessage,
    required this.exitOption,
    this.backgroundColor,
    this.exitMessageStyle,
    required this.child,

  });
}

class _FlutterSmartExitWidgetState extends State<FlutterSmartExitWidget> {

  bool canPop = false;
  int backPressCounter = 0;
  Timer? backPressTimer;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return PopScope(
        canPop: canPop,
       /* onPopInvokedWithResult: (didPop,dynamic){
      if (canPop) {
        return;
      } else {
        backPressCounter++;
        if (backPressCounter == 2) {
          canPop = true;
          SystemNavigator.pop();
        } else {
          backPressTimer?.cancel();
          backPressTimer = Timer(const Duration(seconds: 2), () {
            backPressCounter = 0;
          });
          //AppToast.showSuccessToast(widget.message);


         widget.exitOption == ExitOption.popUp  ?  exitPopUp(size)
             : widget.exitOption == ExitOption.backPressExit ?  exitSnackBar()
          :   exitBottomSheet();
        }
      }
    },*/

        onPopInvokedWithResult: (didPop, dynamic) {
          if (canPop) {
            return; // Allow the app to exit
          } else {
            backPressCounter++;

            if (widget.exitOption == ExitOption.bottomSheet) {
              exitBottomSheet();
            }else if (widget.exitOption == ExitOption.popUp) {
              exitPopUp(size);
            }  else if (backPressCounter == 2) {
              canPop = true;
              SystemNavigator.pop();
            } else {
              backPressTimer?.cancel();
              backPressTimer = Timer(const Duration(seconds: 2), () {
                backPressCounter = 0;
              });
              exitSnackBar();
            }
          }
        },


        child: widget.child
    );
  }

  void exitPopUp(Size size){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.backgroundColor ?? Colors.white,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          title: Align(
            alignment: Alignment.center,
            child: Container(
              transform: Matrix4.translationValues(0, -size.height * 0.027, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                 // SvgPicture.asset(AssetsPath.alertIconSVG,height: size.height * 0.045,),
                  Container(
                    height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.whiteTextColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: AppColors.redColor,width: 2)
                      ),
                      child: Image.asset(AssetsPath.exitGif,height: size.height * 0.045,)),
                  SizedBox(height: size.height * k10TextSize),
                  Text(
                   widget.exitMessage ?? "Are you ready to exit ?",
                    style: widget.exitMessageStyle ?? TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),

         // content: Text(widget.message),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.grey.shade400, width: size.height * 0.001),
                    minimumSize: size.width < 600 ?   Size(size.width * 0.26, size.height * 0.04) : Size(size.width * 0.025, size.height * 0.050),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: size.height * 0.016,
                    ),
                  ),
                ),
                SizedBox(width: size.width *0.016,),
                ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          side: BorderSide.none,
                          minimumSize: size.width < 600 ?   Size(size.width * 0.26, size.height * 0.04) : Size(size.width * 0.025, size.height * 0.050),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),

                        ),
                        onPressed: () async{
                          SystemNavigator.pop();
                        },
                        child:  Text(
                          "Exit",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.016,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      )

              ],
            ),
          ],
        );
      },
    );
  }

  void exitSnackBar() {
    final textLength = widget.exitMessage?.length ?? 25;
    const minMargin = 45.0;
    const maxMargin = 110.0;

    // Calculate the margin based on text length
    double dynamicMargin = (textLength > 30) // You can adjust this threshold
        ? minMargin
        : maxMargin;

    final snackBar = SnackBar(
      content: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            widget.exitMessage ?? 'Press back again to exit',
            textAlign: TextAlign.center,
            style: widget.exitMessageStyle ??  const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        left: dynamicMargin,
        right: dynamicMargin,
        bottom: 30.0,
      ),
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
      backgroundColor: widget.backgroundColor ?? /*Colors.black87.withOpacity(0.6)*/ Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( dynamicMargin == minMargin ? 50 : 20.0),
      ),
          elevation: 8.0,
          // action: SnackBarAction(
          //   label: 'ok',
          //   textColor: Colors.white,
          //   onPressed: () {
          //     // Handle the action when pressed.
          //   },
          // ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void exitBottomSheet() {
    Size size = MediaQuery.sizeOf(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.backgroundColor ?? Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        //side: BorderSide(color: Colors.red,width: 3)
      ),
      builder: (BuildContext context) {
        return Container(
          height: size.width > 600 ? 207 : 175,
            transform: Matrix4.translationValues(0, -size.height * k40TextSize, 0),

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: size.width > 600 ? 70: 50,
                    width: size.width > 600 ? 70 : 50,
                    decoration: BoxDecoration(
                        color: AppColors.whiteTextColor,
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(color: AppColors.redColor,width: 2)
                    ),
                    child: Image.asset(AssetsPath.exitGif,height: size.width > 600 ? size.height * 0.080 : size.height * 0.045,)),
                 SizedBox(height: size.width > 600 ? 10 : 20),
                 Text(
                  widget.exitMessage ?? "Are you ready to exit ?",
                  style: widget.exitMessageStyle ??  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width < 600 ? 18 : 24,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade400, width: size.height * 0.001),
                        minimumSize: size.width < 600 ?   Size(size.width * 0.4, size.height * 0.04) : Size(size.width * 0.25, size.height * 0.050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.height * 0.016,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width *0.016,),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide.none,
                        minimumSize: size.width < 600 ?   Size(size.width * 0.4, size.height * 0.04) : Size(size.width * 0.25, size.height * 0.050),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),

                      ),
                      onPressed: () async{
                        SystemNavigator.pop();
                      },
                      child:  Text(
                        "Exit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.016,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    )

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

