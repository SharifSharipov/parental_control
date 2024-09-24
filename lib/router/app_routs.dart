import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/home_page/presentation/manager/bloc/app_bloc.dart';
import '../features/home_page/presentation/pages/home_page.dart';
import '../injection_container.dart';

part 'name_routs.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.homePage,
  routes: [
    GoRoute(
      path: Routes.homePage,
      name: Routes.homePage,
      builder: (__, _) => BlocProvider<AppBloc>(create: (_) => sl<AppBloc>(), child: const HomePage()),
    ),
  ],
);
