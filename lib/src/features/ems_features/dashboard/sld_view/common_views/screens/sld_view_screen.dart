import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/nz_power_sld/views/screens/nz_power_sld_screen.dart';
import 'package:flutter/material.dart';

class SldViewScreen extends StatefulWidget {
  const SldViewScreen({super.key});
  @override
  State<SldViewScreen> createState() => _SldViewScreenState();
}

class _SldViewScreenState extends State<SldViewScreen> {

  @override
  void initState() {
    super.initState();

  }

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
            child: NZPowerSldScreen(),
          ),
        )
      ),
    );
  }
}

