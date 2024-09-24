import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'features/home_page/presentation/manager/bloc/app_bloc.dart';

final GetIt sl = GetIt.instance;
late Box<dynamic> _box;
Future<void > init() async{
  sl.registerFactory<AppBloc>(() => AppBloc()..add(LoadInstalledApps()));
}