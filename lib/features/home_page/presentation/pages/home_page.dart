import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:new_device_apps/device_apps.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../../../router/app_routs.dart';
import '../manager/bloc/app_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const platform = MethodChannel('com.example.parental_control/screen_time');
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
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
        _usageTime = 0;
      });
    } on PlatformException catch (e) {
      print("Failed to reset usage time: '${e.message}'.");
    }
  }

  // Vaqtni soat, minut, sekund formatiga aylantiruvchi funksiya
  String formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    return '${hours.toString().padLeft(2, '0')} soat, '
        '${minutes.toString().padLeft(2, '0')} minut, '
        '${remainingSeconds.toString().padLeft(2, '0')} sekund';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Screen Time Controller"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.withOpacity(0.7),
        ),
        body: BlocBuilder<AppBloc, AppState>(
          builder: (BuildContext context, AppState state) {
            if (state is AppLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.apps.length,
                      itemBuilder: (context, index) {
                        Application app = state.apps[index];
                        int usageTime = _usageTime; // Foydalanilgan vaqtni olish
                        String formattedTime = formatDuration(usageTime); // Formatlangan vaqt

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                            vertical: height * 0.01,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              onTap: () async {
                                await context.pushNamed(Routes.appUsageStatgeDetails, extra: app);
                              },
                              leading: app is ApplicationWithIcon ? Image.memory(app.icon) : null,
                              title: Text(app.appName),
                              subtitle: Text("Foydalanilgan vaqt: $formattedTime"),
                              trailing: IconButton(
                                onPressed: () {
                                  state.apps[index].openApp();
                                },
                                icon: const Icon(Icons.open_in_new),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /*Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.3),
                  child: ElevatedButton(
                    onPressed: _resetUsageTime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('restart', style: TextStyle(fontSize: 16)),
                  ),
                ),*/
                ],
              );
            } else if (state is AppError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text("Dastur topilmadi."));
            }
          },
        ),
        bottomNavigationBar: SizedBox(
            height: height * 0.13,
            width: double.infinity,
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.7),
                ),
                child: Center(
                  child: ZoomTapAnimation(
                    onTap:_resetUsageTime ,
                    child: SizedBox(
                      height: height * 0.05,
                      width: width * 0.8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Restart",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ))));
  }
}
