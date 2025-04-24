import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/electricity_short_sld_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/views/screens/electricity_short_sld.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/steam_short_sld/steam_short_sld_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/water_short_sld_screen.dart';

class SldTabViewScreen extends StatelessWidget {
  const SldTabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
          children: [
            // TabBar in the body
            const TabBar(
              tabs: [
                Tab(text: 'Electricity',),
                Tab(text: 'Water'),
                Tab(text: 'Steam'),
              ],
            ),
            // TabBarView takes the remaining space
            Expanded(
              child: TabBarView(
                children: [
                  const ElectricityShortSldScreen(),
                  const WaterShortSldScreen(),
                  const SteamShortSldScreen(),
                ],
              ),
            ),
          ],
        )

    );
  }
}