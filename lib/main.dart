import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    print("yek do se");
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    super.initState();
  }

  void getUsageStats() async {
    try {
      print("##################");
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(days: 10));
      List<AppUsageInfo> infoList = await AppUsage().getAppUsage(startDate, endDate);
      print(infoList);
      setState(() => _infos = infoList);
      print("************");
      // for (var info in infoList) {
      //   print("information");
      //   // print(info.toString());
      //   print(info.appName);
      // }
    } on AppUsageException catch (exception) {
      print("Exception");
      // print(exception);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Screen Timing'),
          backgroundColor: Colors.green,
        ),
        body: ListView.builder(
            itemCount: _infos.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_infos[index].appName),
                  trailing: Text(_infos[index].usage.toString()));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: Icon(Icons.file_download)),
      ),
    );
  }
}
