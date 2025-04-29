// import 'dart:developer';
//
// import 'package:nz_ums/src/common_widgets/text_component.dart';
// import 'package:nz_ums/src/shared_preferences/auth_utility_controller.dart';
// import 'package:nz_ums/src/utility/app_urls/app_urls.dart';
// import 'package:nz_ums/src/utility/assets_path/assets_path.dart';
// import 'package:nz_ums/src/utility/style/app_colors.dart';
// import 'package:nz_ums/src/utility/style/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lottie/lottie.dart';
// import 'dart:convert';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
//
//
// class PlantLiveDataTable extends StatefulWidget {
//   const PlantLiveDataTable({super.key});
//
//   @override
//   State<PlantLiveDataTable> createState() => _PlantLiveDataTableState();
// }
//
// class _PlantLiveDataTableState extends State<PlantLiveDataTable> {
//   Map<String, dynamic>? liveData;
//   late PlantDataSource _plantDataSource;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchPlantData();
//   }
//
//   Future<void> fetchPlantData() async {
//     var url = Urls.getPlantLiveDataUrl;
//     final headers = {
//       'Authorization': "${AuthUtilityController.accessToken}",
//     };
//     final response = await http.get(Uri.parse(url), headers: headers);
//     if (response.statusCode == 200) {
//     if(mounted){
//       setState(() {
//         liveData = json.decode(response.body);
//         _plantDataSource = PlantDataSource(liveData!);
//         isLoading = false;
//       });
//     }
//     } else {
//       log('Failed to load data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: AppColors.whiteTextColor,
//       body: isLoading
//           ?  Center(child: Lottie.asset(AssetsPath.loadingJson, height: size.height * 0.12))
//           : Container(
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//             child: SfDataGridTheme(
//                     data: SfDataGridThemeData(
//             headerColor: AppColors.secondaryTextColor,
//                     ),
//                     child: SfDataGrid(
//             verticalScrollPhysics: const NeverScrollableScrollPhysics(),
//             horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
//             rowHeight: 45,
//             headerRowHeight: 50,
//             gridLinesVisibility: GridLinesVisibility.both,
//             headerGridLinesVisibility: GridLinesVisibility.both,
//             columnWidthMode: ColumnWidthMode.fill,
//             columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
//             source: _plantDataSource,
//             columns: [
//               GridColumn(
//                   columnName: 'name',
//                   label: Container(
//                       padding: EdgeInsets.all(size.height * k8TextSize),
//                       alignment: Alignment.center,
//                       child: TextComponent(
//                         text: 'Name',
//                         color: AppColors.whiteTextColor,
//                         fontSize: size.height * k18TextSize,
//
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                   ),
//               ),
//               GridColumn(
//                 columnName: 'today',
//                 label: Container(
//                   padding: EdgeInsets.all(size.height * k8TextSize),
//                   alignment: Alignment.center,
//                   child: TextComponent(
//                     text: 'Today',
//                     color: AppColors.whiteTextColor,
//                     fontSize: size.height * k18TextSize,
//
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//
//               GridColumn(
//                 columnName: 'yesterday',
//                 label: Container(
//                   padding: EdgeInsets.all(size.height * k8TextSize),
//                   alignment: Alignment.center,
//                   child: TextComponent(
//                     text: 'Yesterday',
//                     color: AppColors.whiteTextColor,
//                     fontSize: size.height * k18TextSize,
//
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//
//
//             ],
//                     ),
//                   ),
//           ),
//     );
//   }
// }
//
// class PlantDataSource extends DataGridSource {
//   List<DataGridRow> _plantData = [];
//
//   PlantDataSource(Map<String, dynamic> data) {
//     _plantData = [
//       DataGridRow(cells: [
//         const DataGridCell<String>(columnName: 'name', value: 'Energy'),
//         DataGridCell<String>(columnName: 'today', value: "${(data['today_energy'] ?? 0.0).toStringAsFixed(2)} kWh"),
//         DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_energy'] ?? 0.0).toStringAsFixed(2)} kWh"),
//       ]),
//       DataGridRow(cells: [
//         const DataGridCell<String>(columnName: 'name', value: 'PR'),
//         DataGridCell<String>(columnName: 'today', value: "${(data['live_pr'] ?? 0.0).toStringAsFixed(2)}"),
//         DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_pr'] ?? 0.0).toStringAsFixed(2)}"),
//       ]),
//       DataGridRow(cells: [
//         const DataGridCell<String>(columnName: 'name', value: 'Max AC Power'),
//         DataGridCell<String>(columnName: 'today', value: "${(data['max_ac_power'] ?? 0.0).toStringAsFixed(2)} kW"),
//         DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_max_ac'] ?? 0.0).toStringAsFixed(2)} kW"),
//       ]),
//       DataGridRow(cells: [
//         const DataGridCell<String>(columnName: 'name', value: 'Max DC Power'),
//         DataGridCell<String>(columnName: 'today', value: "${(data['max_dc_power'] ?? 0.0).toStringAsFixed(2)} kW"),
//         DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_max_dc'] ?? 0.0).toStringAsFixed(2)} kW"),
//       ]),
//       DataGridRow(cells: [
//         const DataGridCell<String>(columnName: 'name', value: 'Specific Yield'),
//         DataGridCell<String>(columnName: 'today', value: "${(data['specific_yield'] ?? 0.0).toStringAsFixed(2)} kWh/kWp"),
//         DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_specific_yield'] ?? 0.0).toStringAsFixed(2)} kWh/kWp"),
//       ]),
//       DataGridRow(cells: [
//         const DataGridCell<String>(columnName: 'name', value: 'Max Irr'),
//         DataGridCell<String>(columnName: 'today', value: "${(data['max_irr_south'] ?? 0.0).toStringAsFixed(2)} W/m²"),
//         DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_max_irr'] ?? 0.0).toStringAsFixed(2)} W/m²"),
//       ]),
//     ];
//   }
//
//
//   @override
//   List<DataGridRow> get rows => _plantData;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(cells: [
//       for (var cell in row.getCells())
//         Container(
//           padding: const EdgeInsets.all(8.0),
//           alignment: Alignment.center,
//           child: TextComponent(text: cell.value.toString(),fontSize: 13,),
//         ),
//     ]);
//   }
// }

import 'dart:developer';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nz_fabrics/src/common_widgets/text_component.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:nz_fabrics/src/utility/app_urls/app_urls.dart';
import 'package:nz_fabrics/src/utility/assets_path/assets_path.dart';
import 'package:nz_fabrics/src/utility/style/app_colors.dart';
import 'package:nz_fabrics/src/utility/style/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';


class PlantLiveDataTable extends StatefulWidget {
  const PlantLiveDataTable({super.key});

  @override
  State<PlantLiveDataTable> createState() => _PlantLiveDataTableState();
}

class _PlantLiveDataTableState extends State<PlantLiveDataTable> {
  Map<String, dynamic>? liveData;
  late PlantDataSource _plantDataSource;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlantData();
  }

  Future<void> fetchPlantData() async {
    var url = Urls.getPlantLiveDataUrl;
    final headers = {
      'Authorization': "${AuthUtilityController.accessToken}",
    };
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      if(mounted){
        setState(() {
          liveData = json.decode(response.body);
          _plantDataSource = PlantDataSource(liveData!,MediaQuery.of(context).size);
          isLoading = false;
        });
      }
    } else {
      log('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteTextColor,
      body: isLoading
          ?  Center(child: SpinKitFadingCircle(
        color: AppColors.primaryColor,
        size: 50.0,
      ),)
          : Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            headerColor: AppColors.secondaryTextColor,
          ),
          child: SfDataGrid(
            verticalScrollPhysics: const NeverScrollableScrollPhysics(),
            horizontalScrollPhysics: const NeverScrollableScrollPhysics(),
            rowHeight:  size.height * 0.050,
            headerRowHeight:   size.height * 0.050,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
            columnWidthMode: ColumnWidthMode.fill,
            columnWidthCalculationRange: ColumnWidthCalculationRange.allRows,
            source: _plantDataSource,
            columns: [
              GridColumn(
                columnName: 'name',
                label: Container(
                  padding: EdgeInsets.all(size.height * k8TextSize),
                  alignment: Alignment.center,
                  child: TextComponent(
                    text: 'Name',
                    color: AppColors.whiteTextColor,
                    fontSize: size.height * k18TextSize,

                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              GridColumn(
                columnName: 'today',
                label: Container(
                  padding: EdgeInsets.all(size.height * k8TextSize),
                  alignment: Alignment.center,
                  child: TextComponent(
                    text: 'Today',
                    color: AppColors.whiteTextColor,
                    fontSize: size.height * k18TextSize,

                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),

              GridColumn(
                columnName: 'yesterday',
                label: Container(
                  padding: EdgeInsets.all(size.height * k8TextSize),
                  alignment: Alignment.center,
                  child: TextComponent(
                    text: 'Yesterday',
                    color: AppColors.whiteTextColor,
                    fontSize: size.height * k18TextSize,

                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class PlantDataSource extends DataGridSource {
  List<DataGridRow> _plantData = [];
  final Size size;
  PlantDataSource(Map<String, dynamic> data,this.size) {
    _plantData = [
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'name', value: 'Energy'),
        DataGridCell<String>(columnName: 'today', value: "${(data['today_energy'] ?? 0.0).toStringAsFixed(2)} kWh"),
        DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_energy'] ?? 0.0).toStringAsFixed(2)} kWh"),
      ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'name', value: 'PR'),
        DataGridCell<String>(columnName: 'today', value: "${(data['live_pr'] ?? 0.0).toStringAsFixed(2)}"),
        DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_pr'] ?? 0.0).toStringAsFixed(2)}"),
      ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'name', value: 'Max (Irradiation)'),
        DataGridCell<String>(columnName: 'today', value: "${(data['daily_max_irr'] ?? 0.0).toStringAsFixed(2)} W/m²"),
        DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_max_irr'] ?? 0.0).toStringAsFixed(2)} W/m²"),
      ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'name', value: 'Max AC Power'),
        DataGridCell<String>(columnName: 'today', value: "${(data['max_ac_power'] ?? 0.0).toStringAsFixed(2)} kW"),
        DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_max_ac'] ?? 0.0).toStringAsFixed(2)} kW"),
      ]),
      // DataGridRow(cells: [
      //   const DataGridCell<String>(columnName: 'name', value: 'Max DC Power'),
      //   DataGridCell<String>(columnName: 'today', value: "${(data['max_dc_power'] ?? 0.0).toStringAsFixed(2)} kW"),
      //   DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_max_dc'] ?? 0.0).toStringAsFixed(2)} kW"),
      // ]),
      DataGridRow(cells: [
        const DataGridCell<String>(columnName: 'name', value: 'Specific Yield'),
        DataGridCell<String>(columnName: 'today', value: "${(data['specific_yield'] ?? 0.0).toStringAsFixed(2)} kWh/kWp"),
        DataGridCell<String>(columnName: 'yesterday', value: "${(data['yesterday_specific_yield'] ?? 0.0).toStringAsFixed(2)} kWh/kWp"),
      ]),

    ];
  }


  @override
  List<DataGridRow> get rows => _plantData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      for (var cell in row.getCells())
        Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: TextComponent(text: cell.value.toString(),fontSize: size.width > 500 ? size.height * k16TextSize : size.height * k14TextSize,),
        ),
    ]);
  }
}