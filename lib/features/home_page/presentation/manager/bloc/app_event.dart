part of 'app_bloc.dart';

@immutable
sealed class AppEvent {}

class LoadInstalledApps extends AppEvent {}