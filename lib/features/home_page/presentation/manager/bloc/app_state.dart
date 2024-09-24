part of 'app_bloc.dart';

@immutable
sealed  class AppState {}

class AppInitial extends AppState {}

class AppLoading extends AppState {}

class AppLoaded extends AppState {
  final List<Application> apps;
  AppLoaded(this.apps);
}
class AppError extends AppState {
  final String message;
  AppError(this.message);
}