import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:app_settings/app_settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _packageNames = [];

  @override
  void initState() {
    super.initState();
    getUsageStats();
  }

  void getUsageStats() async {
    // Grant usage permission - opens Usage Settings
    UsageStats.grantUsagePermission();

    // Wait briefly to ensure permission is granted
    await Future.delayed(Duration(seconds: 1));

    // Check if permission is granted
    bool? isPermission = await UsageStats.checkUsagePermission();

    if (isPermission == null || !isPermission) {
      // If permission is not granted or null, guide the user to enable it
      AppSettings.openAppSettings();
      return;
    }

    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

    // Query usage stats
    List<UsageInfo?>? usageStats = await UsageStats.queryUsageStats(startDate, endDate);

    if (usageStats == null) {
      // Handle the case where usageStats is null (e.g., no data available)
      return;
    }

    // Extract package names from usage stats
    _packageNames = usageStats
        .where((info) => info != null && info.packageName != null)
        .map((info) => info!.packageName!)
        .toList();

    // Update the UI with package names
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('App Usage Stats'),
        ),
        body: ListView.builder(
          itemCount: _packageNames.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_packageNames[index]),
            );
          },
        ),
      ),
    );
  }
}
