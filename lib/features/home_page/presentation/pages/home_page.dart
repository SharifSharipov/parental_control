import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:new_device_apps/device_apps.dart';
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
        title: const Text("Screen Time controller"),
        centerTitle: true,
        backgroundColor: Colors.grey.withOpacity(0.5),
      ),
      body: BlocBuilder<AppBloc, AppState>(
        builder: (BuildContext context, AppState state) {
          if (state is AppLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AppLoaded) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Text(
                    'Foydalanilgan vaqt: $_usageTime soniya',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.apps.length,
                    itemBuilder: (context, index) {
                      Application app = state.apps[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                          vertical: height * 0.009,
                        ),
                        child: SizedBox(
                          height: height * 0.1,
                          width: double.infinity,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: ListTile(
                                onTap: () async {
                                  await context.pushNamed(Routes.appUsageStatgeDetails, extra: app);
                                },
                                leading: app is ApplicationWithIcon ? Image.memory(app.icon) : null,
                                title: Text(app.appName),
                                subtitle: Text("Active time: $_usageTime s"),
                                trailing: IconButton(
                                  onPressed: () {
                                    state.apps[index].openApp();
                                  },
                                  icon: const Icon(Icons.open_in_new),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _resetUsageTime,
                  child: const Text('Foydalanilgan vaqtni qayta tiklash'),
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
    );
  }
}
