import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScreenTimeTracker extends StatefulWidget {
  @override
  _ScreenTimeTrackerState createState() => _ScreenTimeTrackerState();
}

class _ScreenTimeTrackerState extends State<ScreenTimeTracker> {
  static const platform = MethodChannel('com.example.parental_control/screen_time');
  int _usageTime = 0;

  @override
  void initState() {
    super.initState();
    _getUsageTime();
  }

  Future<void> _getUsageTime() async {
    try {
      final int result = await platform.invokeMethod('getUsageTime');
      setState(() {
        _usageTime = result;
      });
    } on PlatformException catch (e) {
      print("Failed to get usage time: '${e.message}'.");
    }
  }

  Future<void> _resetUsageTime() async {
    try {
      await platform.invokeMethod('resetUsageTime');
      setState(() {
        _usageTime = 0; // Reset qilingandan so‘ng 0 ga o‘rnating
      });
    } on PlatformException catch (e) {
      print("Failed to reset usage time: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen Time Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Foydalanilgan vaqt (soniyalarda):',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              '$_usageTime',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _resetUsageTime,
              child: Text('Foydalanilgan vaqtni qayta tiklash'),
            ),
          ],
        ),
      ),
    );
  }
}
