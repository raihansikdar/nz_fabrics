import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/views/screens/electricity_long_sld_screen.dart';

class SldViewScreen extends StatefulWidget {
  const SldViewScreen({super.key});
  @override
  State<SldViewScreen> createState() => _SldViewScreenState();
}

class _SldViewScreenState extends State<SldViewScreen> {



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FittedBox(
          child: SizedBox(
            height: size.height * .68,
            width: size.width,
            //child:  const PowerSLDScreen(),
            child: ElectricityLongSldScreen(),
          ),
        )
      ),
    );
  }
}

