import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/application/app.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(Connectivity(), permanent: true);

  await Upgrader.clearSavedSettings();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const EnergyManagementSystem());
}

/*
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info App',
      debugShowCheckedModeBanner: false,
      home: InfoScreen(),
    );
  }
}

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String deviceName = '';
  String deviceModel = '';
  String uniqueUserId = '';
  String lastLogin = '';
  String appVersionName = '';
  String appVersionCode = '';
  String staticEmail = 'kawsar@scube.com.bd'; // 🔒 Your Static Email Here

  @override
  void initState() {
    super.initState();
    fetchAllInfo();
  }

  Future<void> fetchAllInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // Generate or get existing unique user ID
    String? storedUserId = prefs.getString('user_id');
    if (storedUserId == null) {
      storedUserId = const Uuid().v4();
      await prefs.setString('user_id', storedUserId);
    }

    // Format last login date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MMM-yyyy hh:mm a').format(now);
    await prefs.setString('last_login', formattedDate);

    // Get device info
    final deviceInfo = DeviceInfoPlugin();
    String name = '', model = '';

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      name = androidInfo.device ?? 'Unknown';
      model = androidInfo.model ?? 'Unknown';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      name = iosInfo.name ?? 'Unknown';
      model = iosInfo.utsname.machine ?? 'Unknown';
    }

    // Get app version
    final packageInfo = await PackageInfo.fromPlatform();
    final versionName = packageInfo.version;
    final versionCode = packageInfo.buildNumber;

    setState(() {
      deviceName = name;
      deviceModel = model;
      uniqueUserId = storedUserId!;
      lastLogin = formattedDate; // 👈 formatted
      appVersionName = versionName;
      appVersionCode = versionCode;
    });
  }

  Widget infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontSize: 16, color: Colors.blueGrey[700])),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            infoTile("📱 Device Name", deviceName),
            infoTile("📦 Device Model", deviceModel),
            infoTile("🆔 Unique User ID", uniqueUserId),
            infoTile("🕒 Last Login", lastLogin),
            infoTile("📧 User Email", staticEmail),
             infoTile("🧭 App Version Name", appVersionName),
            infoTile("🔢 App Version Code", appVersionCode),
          ],
        ),
      ),
    );
  }
}
*/

