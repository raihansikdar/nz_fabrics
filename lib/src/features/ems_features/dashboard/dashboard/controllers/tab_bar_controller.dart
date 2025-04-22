// import 'dart:convert';
// import 'dart:developer';
// import 'package:nz_ums/src/utility/app_urls/app_urls.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
//
// class TabControllerLogicController extends GetxController with SingleGetTickerProviderMixin {
//   List<String> tabNames = ['Electricity', 'Water'];
//   List<Widget> tabViews = [];
//   late TabController tabController;
//
//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(length: tabNames.length, vsync: this);
//     fetchBusBarInfo();
//   }
//
//   @override
//   void onClose() {
//     tabController.dispose();
//     super.onClose();
//   }
//
//   Future<void> fetchBusBarInfo() async {
//     try {
//       final response = await http.get(Uri.parse(Urls.getBusBarInfoUrl));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         updateTabs(['Electricity', 'Water']);
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (error) {
//       log("Error fetching bus bar info: $error");
//     }
//   }
//
//   void updateTabs(List<String> newTabs) {
//     tabNames = newTabs;
//     tabViews = createTabViews(newTabs);
//     tabController.dispose();
//     tabController = TabController(length: newTabs.length, vsync: this);
//     update();
//   }
//
//   List<Widget> createTabViews(List<String> tabNames) {
//     return tabNames.map((tab) {
//       switch (tab.toLowerCase()) {
//         case 'electricity':
//           return const Column(
//             children: [
//               Text("Power information here"),
//               Text("Energy information here"),
//             ],
//           );
//         case 'water':
//           return const Column(
//             children: [
//              // NaturalGasSLDScreen(),
//             //  WaterSLDScreen(),
//             ],
//           );
//         default:
//           return Center(child: Text("$tab information here"));
//       }
//     }).toList();
//     }
// }


import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';

class TabControllerLogicController extends GetxController with SingleGetTickerProviderMixin {
  List<String> tabNames = ['Electricity'];
  List<Widget> tabViews = [];
  late TabController tabController;




  @override
  void onInit() {
    super.onInit();
    tabViews = createTabViews(tabNames);
    tabController = TabController(length: tabNames.length, vsync: this);
    fetchWaterInfo();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> fetchWaterInfo() async {
     String apiUrl = Urls.getAllInfoUrl;
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': '${AuthUtilityController.accessToken}', // Include the token in the headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Filter data for "Water" category
        List<dynamic> waterData = data.where((item) => item['category'] == 'Water').toList();

        if (waterData.isNotEmpty) {
          updateTabs(['Electricity', 'Water']);
        } else {
          log("No water data available");
        }
      } else {
        throw Exception('Failed to load water data');
      }
    } catch (error) {
      log("Error fetching water info: $error");
    }
  }

  void updateTabs(List<String> newTabs) {
    tabNames = newTabs;
    tabViews = createTabViews(newTabs);
    tabController.dispose();
    tabController = TabController(length: newTabs.length, vsync: this);
    update();
  }

  List<Widget> createTabViews(List<String> tabNames) {
    return tabNames.map((tab) {
      switch (tab.toLowerCase()) {
        case 'electricity':
          return const Column(
            children: [
              Text("Power information here"),
              Text("Energy information here"),
            ],
          );
        case 'water':
          return const Column(
            children: [
              Text("Water information from API here"),
            ],
          );
        default:
          return Center(child: Text("$tab information here"));
      }
    }).toList();
  }
}