class Urls{
  Urls._();

  // static const String _baseUrl = "http://192.168.15.61:8086/react";
  //static const String _baseUrl = "http://192.168.15.60:8081/react";
   static const String _baseUrl = "http://175.29.147.118/react";


  static  String get baseUrl => _baseUrl;

  /*----------------- post api call --------------------*/
  static String createAccountUrl = "$_baseUrl/register/";
 // static String loginUrl = "$_baseUrl/login/";
  static String loginUrl = "$_baseUrl/api-login-V2/";
  static String refreshTokenUrl = "$_baseUrl/api/token/refresh/";
  static String emailVerifyUrl = "$_baseUrl/forget-password/";




/*----------------- get api call --------------------*/
 static String getAllInfoUrl = "/get-all-info/";
 static String getAllButtonUrl = "$_baseUrl/api/source-info-categories/";

 static String getSourceCategoryWiseLiveDataUrl = "$_baseUrl/api/get-source-categorywise-live-data/";
 static String getLoadMachineWiseLiveDataUrl = "$_baseUrl/api/get-load-machinewise-live-data/";
 static String getEachCategoryLiveDataUrl(String categoryName) => "$_baseUrl/api/get-each-category-live-data/$categoryName/";
 static String getEachMachineWiseLoadLiveDataUrl(String categoryName) => "$_baseUrl/api/get-machinewise-load-live-data/$categoryName/";


 static String getWaterSourceCategoryWiseLiveDataUrl = "$_baseUrl/api/get-water-source-categorywise-live-data/";
 static String getWaterLoadMachineWiseLiveDataUrl = "$_baseUrl/api/get-water-load-machinewise-live-data/";
 static String getWaterEachCategoryLiveDataUrl(String categoryName) => "$_baseUrl/api/get-water-each-category-live-data/$categoryName/";
 static String getWaterLoadEachCategoryLiveDataUrl(String categoryName) => "$_baseUrl/api/get-water-machinewise-load-live-data/$categoryName/";



 static String getLiveDataUrl(String sourceName) => "/get-live-data/$sourceName/";

 //static String getButtonInfoUrl = "$_baseUrl/get-button-info/";
 static String getBusBarInfoUrl = "$_baseUrl/get-bus_bar-info/";
 //static String pieChartSourcePowerUrl = "$_baseUrl/total-contribution/?type=Source&category=Electricity/";
 static String pieChartWaterSourceUrl = "$_baseUrl/total-contribution/?type=Source&category=Water";
 static String pieChartNaturalGasSourceUrl = "$_baseUrl/total-contribution/?type=Source&category=Natural_Gas";
 static String pieChartLoadPowerUrl = "$_baseUrl/total-contribution/?type=Load&category=Electricity/";
 static String pieChartWaterLoadUrl = "$_baseUrl/total-contribution/?type=Load&category=Water";
 static String pieChartNaturalGasLoadUrl = "$_baseUrl/total-contribution/?type=Load&category=Natural_Gas";
 // static String getConnectedInfoUrl = "$_baseUrl/get-connected-info/";
 // static String getTodayEnergyDataUrl(String sourceName) => "$_baseUrl/get-todays-node-energy/$sourceName/";
 static String todayRuntimeDataUrl(String sourceName) => "$_baseUrl/runtime-today/$sourceName/";
 static String thisDayDataUrl(String sourceName) => "$_baseUrl/get-todays-node-energy/$sourceName/";
 static String thisMonthDataUrl(String sourceName) => "$_baseUrl/get-yearly-data/$sourceName/";
 static String thisYearDataUrl(String sourceName) => "$_baseUrl/whole-year-energy-sum/$sourceName/";
 static String dailyDataUrl(String elementName) => "$_baseUrl/get-today-data/$elementName/";
 static String monthlyDataUrl(String elementName) => "$_baseUrl/get-monthly-data/$elementName/";
 static String yearlyDataUrl(String elementName) => "$_baseUrl/get-yearly-data/$elementName/";

 static String searchDataUrl(String searchData) => "$_baseUrl/search-item/?q=$searchData";

 static String busCouplerConnectedMeterUrl(String nodeName,String nodeType) => "$_baseUrl/buscoupler-connected-meter-data/$nodeName/$nodeType";




 /*----------------- Analysis Pro --------------------*/
 //static String getDayUrl = "$_baseUrl/filter-dgr-data/";

 static String nodeNameElectricityAnalysisProUrl = "$_baseUrl/get-node-name-for-analysis-pro/Electricity/";
 static String postFilterDgrDataUrl = "$_baseUrl/api/v2/filter-dgr-data/";

 static String getMonthlyAnalysisProUrl = "$_baseUrl/filter-monthly-data-flutter/";
// static String getMonthUrl = "$_baseUrl/filter-monthly-data/";
 //static String getYearlyUrl = "$_baseUrl/filter-yearly-data/";
 static String getYearlyAnalysisProUrl = "$_baseUrl/filter-yearly-data-flutter/";

 /*----------------- Diesel button--------------------*/
 static String getDailyDieselUrl = "$_baseUrl/get-todays-generator-data/Diesel_Generator/";
 static String postMonthlyDieselUrl = "$_baseUrl/get-monthly-generator-data/Diesel_Generator/";
 static String postYearlyDieselUrl = "$_baseUrl/get-yearly-generator-data/Diesel_Generator/";
 static String postFilterDieselUrl = "$_baseUrl/filter-by-date-generator/Diesel_Generator/";

 /*----------------- Natural Gas button--------------------*/
 static String getDailyNaturalGasUrl = "$_baseUrl/get-todays-gas-data/";
 static String postMonthlyNaturalGasUrl = "$_baseUrl/get-monthly-gas-data/";
 static String postYearlyNaturalGasUrl = "$_baseUrl/get-yearly-gas-data/";
 static String postFilterNaturalGasUrl = "$_baseUrl/filter-by-date-gas/";


 /*----------------- Gas Generator button--------------------*/
 static String getDailyGasGeneratorUrl = "$_baseUrl/get-todays-generator-data/Gas_Generator/";
 static String postMonthlyGasGeneratorUrl = "$_baseUrl/get-monthly-generator-data/Gas_Generator/";
 static String postYearlyGasGeneratorUrl = "$_baseUrl/get-yearly-generator-data/Gas_Generator/";
 static String postFilterGasGeneratorUrl = "$_baseUrl/filter-by-date-generator/Gas_Generator/";

 /*----------------- Water button--------------------*/
 static String getDailyWaterUrl = "$_baseUrl/get-todays-water-data/";
 static String postMonthlyWaterUrl = "$_baseUrl/get-monthly-water-data/";
 static String postYearlyWaterUrl = "$_baseUrl/get-yearly-water-data/";
 static String postFilterWaterUrl = "$_baseUrl/filter-by-date-water/";


  /*----------------- Solar summary --------------------*/
  static String getSolarDayUrl = "$_baseUrl/filter-plant-dgr/";
  static String getSolarMonthUrl = "$_baseUrl/filter-monthy-plant-dgr/";
  static String getSolarYearUrl = "$_baseUrl/filter-yearly-plant-dgr/";

  static String getShedTodayYesterdayEnergyUrl = "$_baseUrl/shed-today-yesterday-energy/";

 /*----------------- Solar summary Assorted --------------------*/
  static String getPlantLiveDataUrl = "$_baseUrl/plant-live-data/";
  static String getPlantTodayDataUrl = "$_baseUrl/plant-today-data/";



  static String getInverterDataUrl = "$_baseUrl/inverter-data-live/";


  /*----------------- Module Cleaning --------------------*/
  static String createModuleCleaningUrl = "$_baseUrl/create-module-cleaning/";
  static String getModuleCleaningUrl = "$_baseUrl/get-module-cleaning/";
  static String updateModuleCleaningUrl(int id) => "$_baseUrl/update-module-cleaning/$id/";
  static String updateReasonModuleCleaningUrl(int id) => "$_baseUrl/update-module-reason/$id/";

/*----------------- Summary --------------------*/
 static String getCarbonEmissionUrl = "$_baseUrl/today-carbon-emission/";
 static String getTodayTotalEnergyUrl = "$_baseUrl/todays-total-energy/";
 static String getExpensePerPersonUrl = "$_baseUrl/expense-per-person/";

 static String getTimeUsageInPercentageUrl = "$_baseUrl/time-usage-in-percentage/";
 static String getMonthlyPowerCutsUrl = "$_baseUrl/yearly-total-energy/";
 static String getPowerCutsInMinutesUrl = "$_baseUrl/power-cuts-in-minutes/";
 static String getYearlyPowerCutsUrl = "$_baseUrl/power-cuts-years/";


 /*----------------- User Management --------------------*/
 static String getPendingUserUrl = "$_baseUrl/pending-user/";
 static String postRegisterByAdminUrl = "$_baseUrl/register-by-admin/";
 static String deleteUserUrl(int id) => "$_baseUrl/delete-user/$id/";
 static String putAdminApprovalUrl(int id) => "$_baseUrl/admin-approval/$id/";
 static String putGrantSuperuserUrl(int id) => "$_baseUrl/grant-superuser/$id/";
 static String getApprovedUserUrl = "$_baseUrl/approved-users/";


 /*----------------- User Profile --------------------*/
 static String getUserProfileUrl = "$_baseUrl/user-profile/";
 static String postChangePasswordUrl = "$_baseUrl/change-password/";
 static String putUpdateProfileUrl = "$_baseUrl/update-profile/";



/*----------------- notification -------------------*/
 static String getNotificationUrl = "http://192.168.68.60:8040/get-all-notification/";

  /*----------------- Data view call --------------------*/
// static String getMachineViewNameDataUrl = "$_baseUrl/api/get-machine-view-names-data/";
 static String getMainBusBarNamesUrl = "$_baseUrl/api/get-main-busbar-names/";

 static String getRunningMonthDataUrl(String nodeName) => "$_baseUrl/api/get-running-month-data/$nodeName/";

 static String getBusBarLoadConnectedDataUrl(String nodeName) => "$_baseUrl/busbar-load-connected-data/$nodeName/";
 static String getBusBarSourceConnectedDataUrl(String nodeName) => "$_baseUrl/busbar-source-connected-data/$nodeName/";

 static String getPowerUsagePercentageLoadUrl(String nodeName) => "$_baseUrl/power-usage-in-percentage-load/$nodeName/";
 static String getPowerUsagePercentageSourceUrl(String nodeName) => "$_baseUrl/power-usage-in-percentage-source/$nodeName/";






  /*----------------- PF History --------------------*/
 static String getPFHistoryUrl(String nodeName) => "/api/get-pf-history/$nodeName/";
 static String putAcknowledgeEventUrl(int id) => "$_baseUrl/api/acknowledge-event/$id/";
 static String getProductionVsCapacityUrl = "/api/get-production-vs-capacity/";
 static String getInnerChildrenDataUrl(String nodeName) => "$_baseUrl/api/V2.1/get-children-name/?parent=&node=$nodeName";
  /*----------------- specific Data --------------------*/


 static String postFilterSpecificNodeDataUrl(String nodeName) => "$_baseUrl/api/filter-specific-node-data/$nodeName/";

 //static String getTimeUsageInPercentageUrl = "$_baseUrl/time-usage-in-percentage/";


 /*----------------- Source Data --------------------*/
 static String getFilterOverallSourceDataUrl = "$_baseUrl/api/filter-overall-source-data/";


 static String getSourceCategoryWiseLiveDataDaUrl = "$_baseUrl/api/get-source-categorywise-live-data/";
 static String getFilterSSpecificTableDataUrl = "$_baseUrl/api/filter-specific-node-table-data/";


 static String getAcKnowledgeHistoryUrl(String nodeName) => "$_baseUrl/api/get-acknowledge-data/$nodeName/";



 static String getFilterOverallWaterSourceDataUrl = "$_baseUrl/api/filter-overall-water-source-data/";

 static String getWaterSourceCategoryWiseLiveDataDaUrl = "$_baseUrl/api/get-source-categorywise-live-data-water/";



 /*----------------- Plant Summary Data --------------------*/
 static String getLayoutImageUrl = "$_baseUrl/get-images/";
 static String getLayoutSummaryDetailsUrl(String layoutName) => "$_baseUrl/api/layout-summary-detailed/$layoutName/";
 static String getLayoutNodePositionUrl = "$_baseUrl/api/layout-node-positions/";


 /*----------------- get-machine-max-power --------------------*/
 static String getMachineMaxPowerUrl(String nodeName) => "$_baseUrl/api/get-machine-max-power/$nodeName/";


 /*----------------- SLD --------------------*/
 static String getLTProductionVsCapacityUrl = "/api/get-lt-production-vs-capacity/";
 static String getElectricityLiveAllNodePowerUrl = "$_baseUrl/live-all-node-power/?type=electricity";
 static String getWaterLiveAllNodePowerUrl = "$_baseUrl/live-all-node-power/?type=water";
 static String getLivePFDataUrl(String nodeName) => "/api/get-live-pf-data/$nodeName/";
 static String filterBusBarEnergyCostUrl(String busBarName) => "$_baseUrl/api/filter-busbar-energy-cost/$busBarName/";


 static String shortElectricityUrl = "$_baseUrl/api/layout-node-positions/?page_type=es";
 static String longElectricityUrl = "$_baseUrl/get-all-info/?sld_type=electricity";

 static String getBusBarStatusUrl = "$_baseUrl/get-busbar-status-info/";

 static String shortWaterUrl = "$_baseUrl/api/layout-node-positions/?page_type=ws";
 static String longWateryUrl = "$_baseUrl/get-all-info/?sld_type=water";


 //static String logoutUrl = "$_baseUrl/logout/";
 static String logoutUrl = "$_baseUrl/api-logout-V2/";
 static String postDgrFilterPlantDataUrl = "$_baseUrl/filter-plant-dynamic-data/";

}