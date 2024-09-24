import 'package:flutter/material.dart';
import 'package:new_device_apps/device_apps.dart';
class AppUsageStatgeDetails extends StatefulWidget {
  const AppUsageStatgeDetails({super.key, required this.application});
  final Application application;

  @override
  State<AppUsageStatgeDetails> createState() => _AppUsageStatgeDetailsState();
}

class _AppUsageStatgeDetailsState extends State<AppUsageStatgeDetails> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("${widget.application.appName}"),
      centerTitle: true,
      backgroundColor: Colors.transparent.withOpacity(0.09),
    ),
  );

}
