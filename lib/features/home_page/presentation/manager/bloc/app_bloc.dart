import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:new_device_apps/device_apps.dart';

part 'app_event.dart';
part 'app_state.dart';
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<LoadInstalledApps>(_onLoadInstalledApps);
  }

  Future<void> _onLoadInstalledApps(
      LoadInstalledApps event, Emitter<AppState> emit) async {
    emit(AppLoading());
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true,
      );
      if (apps.isEmpty) {
        emit(AppError("Dastur topilmadi yoki ruxsatlar noto'g'ri o'rnatilgan."));
      } else {
        emit(AppLoaded(apps));
      }
    } catch (e) {
      emit(AppError("Xatolik yuz berdi: $e"));
    }
  }
}
