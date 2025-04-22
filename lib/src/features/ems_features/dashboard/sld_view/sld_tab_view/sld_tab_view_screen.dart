import 'package:flutter/material.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/short_sld/electricity_short_sld/electricity_short_sld_screen.dart';

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
                Tab(text: 'Electricity'),
                Tab(text: 'Water'),
                Tab(text: 'Steam'),
              ],
            ),
            // TabBarView takes the remaining space
            const Expanded(
              child: TabBarView(
                children: [
                  ElectricityShortSldScreen(),
                  // Water Tab Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.water_drop, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'Water Usage',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Track water consumption and flow rates'),
                      ],
                    ),
                  ),
                  // Steam Tab Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'Steam Monitoring',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Monitor steam production and distribution'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )

    );
  }
}