import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

mixin HomePageMixin  on State<HomePage>{
  static const platform = MethodChannel('com.example.parental_control/screen_time');
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  Map<String, int> usageTimeMap = {};
  Timer? timer;
  ValueNotifier<Map<String, int>> valueNotifier = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    getUsageTime();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    valueNotifier.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      usageTimeMap.updateAll((key, value) => value + 1);
      valueNotifier.value = Map.from(usageTimeMap);
    });
  }

  Future<void> getUsageTime() async {
    try {
      final result = await platform.invokeMethod('getUsageStats');
      if (result != null) {
        usageTimeMap = (result as Map<Object?, Object?>).map((key, value) {
          return MapEntry(key as String, value as int);
        });
        valueNotifier.value = Map.from(usageTimeMap);
      }
    } on PlatformException catch (e) {
      print("Failed to get usage time: '${e.message}'.");
    }
  }

  Future<void> resetUsageTime() async {
    try {
      await platform.invokeMethod('resetUsageTime');
      setState(() {
        usageTimeMap.clear();
        valueNotifier.value = Map.from(usageTimeMap);
      });
    } on PlatformException catch (e) {
      print("Failed to reset usage time: '${e.message}'.");
    }
  }

  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')} soat, '
        '${minutes.toString().padLeft(2, '0')} minut, '
        '${remainingSeconds.toString().padLeft(2, '0')} sekund';
  }

}