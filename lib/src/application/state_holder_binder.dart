import 'package:nz_fabrics/src/features/authentication/forget_password/email_verify/controller/email_verify_controller.dart';
import 'package:nz_fabrics/src/features/authentication/forget_password/set_password/controller/set_password_controller.dart';
import 'package:nz_fabrics/src/features/authentication/login/controller/login_controller.dart';
import 'package:nz_fabrics/src/features/authentication/login/controller/refresh_token_api_controller.dart';
import 'package:nz_fabrics/src/features/authentication/logout/controller/logout_controller.dart';
import 'package:nz_fabrics/src/features/authentication/register/controller/create_account_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/all_live_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/busbar_load_connected_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/busbar_source_connected_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/live_data_load_pie_chart_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/all_live_data/controllers/live_data_source_pie_chart_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_day_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_monthly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/analysis_pro_yearly_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_day_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_month_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/analysis_pro/controllers/new_controller/electricity_year_analysis_pro_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/custom_diesel_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/daily_diesel_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/monthly_diesel_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/diesel_generator/controllers/yearly_diesel_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/custom_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/daily_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/monthly_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/gas_generator/controllers/yearly_gas_generator_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/get_button_from_all/controller/get_button_from_all_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/custom_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/daily_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/monthly_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/natural_gas/controllers/yearly_natural_gas_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/custom_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/daily_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/monthly_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/button_screen/water_process/controllers/yearly_water_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/dash_board_radio_button_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/search_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/dashboard/controllers/tab_bar_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/controllers/data_view_ui_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/controller/machine_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/controller/acknowledge_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/machine_screen/screen/daily_machine_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/data_view/views/screens/shed_screen/controller/shed_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/controller/electricity_long_sld_all_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/controller/electricity_long_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/controller/electricity_long_sld_live_pf_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/controller/electricity_long_sld_lt_production_vs_capacity_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/controller/electricity_long_sld_main_bus_bar_true_controller/electricity_long_sld_filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/electricity_long_sld/views/screens/electricity_long_sld_screen.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_all_info_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_live_all_node_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_live_pf_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_lt_production_vs_capacity_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/sld_view/long_sld/water_long_sld/controller/water_long_sld_main_bus_bar_true_controller/water_long_sld_filter_bus_bar_energy_cost_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/load_natural_gas_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/pie_chart_natural_gas_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/pie_chart_natural_gas_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/natural_gas_summary/controllers/source_natural_gas_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/each_category_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/each_machine_wise_load_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/find_power_value_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/load_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/machine_view_names_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/acknowledge_event_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/get_production_vs_capacityController.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/main_bus_bar_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pf_controller/pf_history_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/pie_chart_power_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/power_summary/controllers/source_power_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_each_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_each_load_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_load_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/water_source_category_wise_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/find_water_value_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/load_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_load_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/pie_chart_water_source_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/dashboard/summery_view/water_summary/controllers/source_water_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/element_button_view_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/filter_specific_node_data/filter_specific_node_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/generator/generator_ui_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/natural_gas/natural_gas_yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/plot_controller/plot_line_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/get_live_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/power_and_energy/yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_daily_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_monthly_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_this_day_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_this_month_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_this_year_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_today_runtime_data_controller.dart';
import 'package:nz_fabrics/src/features/ems_features/source_load_details/controllers/water/water_yearly_data_controller.dart';
import 'package:nz_fabrics/src/features/notification/controller/all_notification_controller.dart';
import 'package:nz_fabrics/src/features/notification/controller/notification_controller.dart';
import 'package:nz_fabrics/src/features/plant_over_view/controller/layout_controller.dart';
import 'package:nz_fabrics/src/features/plant_over_view/controller/layout_position_controller.dart';
import 'package:nz_fabrics/src/features/profile/controller/change_password_controller.dart';
import 'package:nz_fabrics/src/features/profile/controller/update_profile_controller.dart';
import 'package:nz_fabrics/src/features/profile/controller/user_profile_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/module_cleaning_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/schedule_chart_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/update_module_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/module_cleaning/controller/update_reason_module_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/ac_power/controller/ac_power_today_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/active_power_controller/controller/plant_today_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/assorted_data_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/assorted_data/controllers/daily_power_consumption_controller.dart';
import 'package:nz_fabrics/src/features/solar_feature/solar_summery/dgr/controllers/dgr_controller.dart';
import 'package:nz_fabrics/src/features/source/electricity/controller/over_all_source_data_controller.dart';
import 'package:nz_fabrics/src/features/source/electricity/controller/source_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/source/electricity/views/widgets/sub_part/source_table_widget.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/over_all_source_water_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/controller/water_source_category_wise_live_data_controller.dart';
import 'package:nz_fabrics/src/features/source/water_source/views/widgets/sub_part/water_source_table_widget.dart';
import 'package:nz_fabrics/src/features/summary_feature/controller/carbon_emission_controller.dart';
import 'package:nz_fabrics/src/features/summary_feature/controller/expense_per_person_controller.dart';
import 'package:nz_fabrics/src/features/summary_feature/controller/today_total_energy_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/change_user_type/change_user_type_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/change_user_type/grant_admin_permission_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/create_user_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/admin_approval_pending_request.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/delete_pending_user_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/pendin_request/pending_user_controller.dart';
import 'package:nz_fabrics/src/features/user_management/controller/user_management_controller.dart';
import 'package:get/get.dart';

class StateHolderBinders extends Bindings{
  @override
  void dependencies() {
    /* ->>------------> UI Controller <--------------<<- */
     Get.lazyPut(()=>LiveDataController());
     Get.put(DashBoardRadioButtonController());


    /* ->>---------------------> Controller <-----------------------<<- */

     /* ->>-------------> Auth Controller <---------------<<- */
     Get.put(LoginController());
     Get.put(EmailVerifyController());
     Get.put(SetPasswordController());
     Get.put(CreateAccountInfoController());
    Get.put(RefreshTokenApiController());



     /* ->>-------------> Summary View Controller <---------------<<- */

     Get.put(CategoryWiseLiveDataController());
     Get.put(EachCategoryLiveDataController());
     Get.put(MachineViewNamesDataController());
     Get.put(EachMachineWiseLoadLiveDataController());
     Get.put(GetLiveDataController());


     Get.put(WaterSourceCategoryWiseDataController());
     Get.put(WaterLoadCategoryWiseDataController());
     Get.put(WaterEachCategoryWiseLiveDataController());
     Get.put(WaterEachLoadCategoryWiseLiveDataController());




     Get.put(GetButtonFromAllController());



     Get.put(SourcePowerController());
     Get.put(LoadPowerController());
     Get.put(PieChartPowerSourceController());
     Get.put(PieChartPowerLoadController());

     ///Get.put(LoadWaterController());
   ///  Get.put(SourceWaterController());
     Get.put(PieChartWaterSourceController());
     Get.put(PieChartWaterLoadController());


     Get.put(LoadNaturalGasController());
     Get.put(SourceNaturalGasController());
     Get.put(PieChartNaturalGasLoadController());
     Get.put(PieChartNaturalGasSourceController());




     Get.put(DashBoardButtonController());
     Get.put(TabControllerLogicController());




     Get.put(ElementButtonViewController());
     Get.put(TodayRuntimeDataController());
     Get.put(ThisDayDataController());
     Get.put(ThisMonthDataController());
     Get.put(ThisYearDataController());

     Get.put(WaterTodayRuntimeDataController());
     Get.put(WaterThisDayDataController());
     Get.put(WaterThisMonthDataController());
     Get.put(WaterThisYearDataController());


     Get.put(DailyDataController());
     Get.put(WaterDailyDataController());
     Get.put(MonthlyDataController());
     Get.put(WaterMonthlyDataController());
     Get.put(YearlyDataController());
     Get.put(WaterYearlyDataController());

     Get.put(GeneratorDataController());

     Get.put(NaturalGasThisDayDataController());
     Get.put(NaturalGasThisMonthDataController());
     Get.put(NaturalGasThisYearDataController());
     Get.put(NaturalGasDailyDataController());
     Get.put(NaturalGasMonthlyDataController());
     Get.put(NaturalGasYearlyDataController());


     //Get.put(AnalysisProDateController());
     Get.put(AnalysisProDayButtonController());
     Get.put(AnalysisProMonthlyButtonController());
     Get.put(AnalysisProYearlyButtonController());


     Get.put(ElectricityDayAnalysisProController());
     Get.put(ElectricityMonthAnalysisProController());
     Get.put(ElectricityYearAnalysisProController());



    // Get.put(PowerSldLatestDataController());
    // Get.put(EnergySldLatestDataController());


     Get.put(SearchDataController());
     //Get.put(NotificationController());

     //--------------------------- Solar Summary ---------------------------

     //------- Solar Summary  dgr-----------

     Get.put(DgrController());
     Get.put(CreateModuleCleaningController());
     Get.put(ScheduleChartController());
     Get.put(UpdateModuleController());
     Get.put(UpdateReasonModuleController());


     //------- Ac power Controller-----------
     Get.put(AcPowerTodayDataController());


     //------- Solar Summary Assorted Data -----------
     Get.put(AssortedDataController());
     Get.put(DailyPowerConsumptionController());
     Get.put(PlantTodayDataController());

     //--------------------------- Summary---------------------------
     Get.put(CarbonEmissionController());
     Get.put(TodayTotalEnergyController());
     Get.put(ExpensePerPersonController());

//--------------------------- Natural Gas View ---------------------------
     Get.put(DailyNaturalGasButtonController());
     Get.put(MonthlyNaturalGasButtonController());
     Get.put(YearlyNaturalGasButtonController());
     Get.put(CustomNaturalGasButtonController());

//--------------------------- Gas Generator View ---------------------------
     Get.put(DailyGasGeneratorButtonController());
     Get.put(MonthlyGasGeneratorButtonController());
     Get.put(YearlyGasGeneratorButtonController());
     Get.put(CustomGasGeneratorButtonController());


//--------------------------- Diesel Generator View ---------------------------
     Get.put(DailyDieselButtonController());
     Get.put(MonthlyDieselButtonController());
     Get.put(YearlyDieselButtonController());
     Get.put(CustomDieselButtonController());

//--------------------------- Water View ---------------------------
     Get.put(CustomWaterButtonController());
     Get.put(DailyWaterButtonController());
     Get.put(MonthlyWaterButtonController());
     Get.put(YearlyWaterButtonController());


//--------------------------- User management ---------------------------
     Get.put(UserManagementController());
     Get.put(ChangeUserTypeController());
     Get.put(CreateUserController());
     Get.put(PendingUserController());
     Get.put(DeletePendingUserController());
     Get.put(AdminApprovalPendingRequest());
     Get.put(GrantAdminUserController());

//--------------------------- Profile ---------------------------
    // Get.put(UserProfileController());
     Get.lazyPut(()=> UserProfileController(),fenix: true);
     Get.put(ChangePasswordController());
     Get.put(UpdateProfileController());

//--------------------------- Notification ---------------------------
     Get.put(AllNotificationController());
     Get.put(NotificationController());



//--------------------------- Data View ---------------------------
     Get.put(DataViewUIController());
     Get.put(MachineController());


//--------------------------- All Live Data ---------------------------
     Get.put(AllLiveInfoController());
     Get.put(BusBarLoadConnectedController());
     Get.put(BusBarSourceConnectedController());
     Get.put(LiveDataLoadPieChartController());
     Get.put(LiveDataSourcePieChartController());


     //Get.put(FindWaterValueController());
     Get.put(FindPowerValueController());


     Get.put(FilterSpecificNodeDataController());

//--------------------------- Source ---------------------------
    // Get.put(TimeUsagePercentageController());
     Get.put(OverAllSourceDataController());
     Get.put(SourceCategoryWiseLiveDataController());

    Get.put(WaterSourceCategoryWiseLiveDataController());
    Get.put(OverAllWaterSourceDataController());
    Get.put(WaterSourceDataController());

//--------------------------- PF History ---------------------------
     Get.put(PFHistoryController());
     Get.put(AcknowledgeEventController());
     Get.put(MainBusBarController());
     Get.put(GetProductionVsCapacityController());

     Get.put(PlantLayoutController());
     Get.put(SourceDataController());
     Get.put(MachineViewController());
     Get.put(AcknowledgeDataController());


     Get.put(PlotLineController());
     Get.put(LogoutController());



     /* ->>--------------------------> SLD <---------------------------<<- */
     Get.put(ElectricityLongSLDLtProductionVsCapacityController());
     Get.put(ElectricityLongSLDLiveAllNodePowerController());
     Get.put(ElectricityLongSldLivePfDataController());
     Get.put(ElectricityLongSLDAllInfoController());
    // Get.put(GetAllInfoControllers());
     Get.put(ElectricityLongSLDFilterBusBarEnergyCostController());



     /* ->>--------------------------> Water SLD <---------------------------<<- */
     Get.put(WaterLongSLDLtProductionVsCapacityController());
     Get.put(WaterLongSLDLiveAllNodePowerController());
     Get.put(WaterLongSldLivePfDataController());
     Get.put(WaterLongSLDAllInfoController());
     // Get.put(GetAllInfoControllers());
     Get.put(WaterLongSLDFilterBusBarEnergyCostController());


     Get.put(LayoutPositionController());
     Get.put(ShedViewController());




  }

}