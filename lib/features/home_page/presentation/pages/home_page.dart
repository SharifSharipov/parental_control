import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:new_device_apps/device_apps.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../manager/bloc/app_bloc.dart';
import 'home_page_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomePageMixin {
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
                      int usageTime = valueNotifier.value[app.packageName] ?? 0;
                      String formattedTime = formatDuration(usageTime);

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
                              // await context.pushNamed(Routes.appUsageStatgeDetails, extra: app);
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
              onTap: resetUsageTime,
              child: SizedBox(
                height: height * 0.05,
                width: width * 0.8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
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
          ),
        ),
      ),
    );
  }
}
