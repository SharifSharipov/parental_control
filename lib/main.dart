import 'package:flutter/material.dart';

import 'app.dart';
import 'injection_container.dart';

Future<void> main() async{
  await init();
  runApp(const App());
}



/*import 'package:flutter/material.dart';
import 'dart:async';
import 'package:usage_stats_new/usage_stats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EventUsageInfo> events = [];
  Map<String?, NetworkInfo?> _netInfoMap = Map();

  @override
  void initState() {
    super.initState();

    initUsage();
  }

  Future<void> initUsage() async {
    try {
      UsageStats.grantUsagePermission();

      DateTime endDate = new DateTime.now();
      DateTime startDate = endDate.subtract(Duration(days: 1));

      List<EventUsageInfo> queryEvents =
      await UsageStats.queryEvents(startDate, endDate);
      List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(
        startDate,
        endDate,
        networkType: NetworkType.all,
      );

      Map<String?, NetworkInfo?> netInfoMap = Map.fromIterable(networkInfos,
          key: (v) => v.packageName, value: (v) => v);

      List<UsageInfo> t = await UsageStats.queryUsageStats(startDate, endDate);

      for (var i in t) {
        if (double.parse(i.totalTimeInForeground!) > 0) {
          print(
              DateTime.fromMillisecondsSinceEpoch(int.parse(i.firstTimeStamp!))
                  .toIso8601String());

          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeStamp!))
              .toIso8601String());

          print(i.packageName);
          print(DateTime.fromMillisecondsSinceEpoch(int.parse(i.lastTimeUsed!))
              .toIso8601String());
          print(int.parse(i.totalTimeInForeground!) / 1000 / 60);

          print('-----\n');
        }
      }

      this.setState(() {
        events = queryEvents.reversed.toList();
        _netInfoMap = netInfoMap;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Usage Stats"), actions: [
          IconButton(
            onPressed: UsageStats.grantUsagePermission,
            icon: Icon(Icons.settings),
          )
        ]),
        body: Container(
          child: RefreshIndicator(
            onRefresh: initUsage,
            child: ListView.separated(
              itemBuilder: (context, index) {
                var event = events[index];
                var networkInfo = _netInfoMap[event.packageName];
                return ListTile(
                  title: Text(events[index].packageName!),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Last time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(events[index].timeStamp!)).toIso8601String()}"),
                      networkInfo == null
                          ? Text("Unknown network usage")
                          : Text("Received bytes: ${networkInfo.rxTotalBytes}\n" +
                          "Transfered bytes : ${networkInfo.txTotalBytes}"),
                    ],
                  ),
                  trailing: Text(events[index].eventType!),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: events.length,
            ),
          ),
        ),
      ),
    );
  }
}*/
///1
/*package com.example.parental_control

import android.app.usage.UsageStats
import android.app.usage.UsageStatsManager
import android.content.Context
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class ScreenTimeActivity : FlutterActivity() {
    private val CHANNEL = "com.example.parental_control/screen_time"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getUsageTime" -> {
                    val usageTime = getTotalUsageTimeForApps()
                    result.success(usageTime)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP_MR1)
    private fun getTotalUsageTimeForApps(): Map<String, Long> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 1000 * 3600 * 24 // oxirgi 24 soatni oladi

        val usageStatsList: List<UsageStats> =
            usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startTime, endTime)

        val appUsageMap = mutableMapOf<String, Long>()

        for (usageStats in usageStatsList) {
            val appName = usageStats.packageName
            val timeInForeground = usageStats.totalTimeInForeground
            if (timeInForeground > 0) {
                appUsageMap[appName] = timeInForeground
            }
        }

        return appUsageMap
    }
}
*/