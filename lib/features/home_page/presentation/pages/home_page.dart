import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

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
            return ListView.builder(
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
                          onTap: ()async{
                            await context.pushNamed(Routes.appUsageStatgeDetails,extra: app);
                          },
                          leading: app is ApplicationWithIcon
                              ? Image.memory(app.icon)
                              : null,
                          title: Text(app.appName),
                          subtitle: const Text("Active time: 0 s"),
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
