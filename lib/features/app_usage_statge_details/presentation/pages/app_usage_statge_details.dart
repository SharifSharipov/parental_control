import 'package:flutter/material.dart';
class AppUsageStatgeDetails extends StatefulWidget {
  const AppUsageStatgeDetails({super.key});

  @override
  State<AppUsageStatgeDetails> createState() => _AppUsageStatgeDetailsState();
}

class _AppUsageStatgeDetailsState extends State<AppUsageStatgeDetails> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title:const Text("App Usage Statge Details"),
      centerTitle: true,
      backgroundColor: Colors.transparent.withOpacity(0.09),
    ),
  );

}
