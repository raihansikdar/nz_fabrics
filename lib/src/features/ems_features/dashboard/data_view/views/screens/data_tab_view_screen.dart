import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/data_view_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/electricity_short_sld_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/steam_short_sld/steam_short_sld_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/water_short_sld/water_short_sld_screen.dart';

class DataTabViewScreen extends StatelessWidget {
  const DataTabViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Column(
          children: [
            // TabBar in the body
            const TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Electricity'),
                Tab(text: 'Water'),
                Tab(text: 'Steam'),
              ],
            ),
            // TabBarView takes the remaining space
            Expanded(
              child: TabBarView(
                children: [
                //  const ElectricityShortSldScreen(),
                  DataViewScreen(),
                  const SteamShortSldScreen(),
                  const SteamShortSldScreen(),
                ],
              ),
            ),
          ],
        )

    );
  }
}