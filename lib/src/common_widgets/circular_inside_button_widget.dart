import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';

class CircularInsideButtonWidget extends StatelessWidget {
  const CircularInsideButtonWidget({
    super.key, required Size size,
  }) : _size = size;
  
  final Size _size;
  
  @override
  Widget build(BuildContext context) {
    return  Center(
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
                height: _size.height * k20TextSize,
                width:_size.height * k20TextSize,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: _size.height * 0.004,
                )),
          ),
          SizedBox(width: _size.height * k30TextSize,),
          TextComponent(text: "Please wait",color: Colors.white,fontSize: _size.height * k20TextSize,)
          // Text("Please wait",style: TextStyle(
          //   color: Colors.white,
          // ),),
        ],),
    );
  }
}