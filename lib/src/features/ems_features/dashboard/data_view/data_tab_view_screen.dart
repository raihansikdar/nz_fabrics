import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/data_view_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/utility_data_screen/utility_data_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/electricity/views/screens/water/combine_water_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/steam/views/screen/combine_steam_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/steam/steam_data_view_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/water/water_data_view_screen.dart';

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
                physics: NeverScrollableScrollPhysics(),
                children: [
                  UtilityDataScreen(),
                  DataViewScreen(),
                  WaterDataViewScreen(),
                  SteamDataViewScreen(),
                ],
              ),
            ),
          ],
        )

    );
  }
}