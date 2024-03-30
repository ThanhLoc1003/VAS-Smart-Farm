import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vas_farm/screens/farm/history_screen.dart';
import 'package:vas_farm/screens/farm/humid_chart_screen.dart';
import 'package:vas_farm/screens/farm/temp_chart_screen.dart';
import 'package:vas_farm/screens/farm/threshold_screen.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String sensor = '/sensor';
  static const String register = '/register';
  static const String history = '/history';
  static const String tempChart = '/tempChart';
  static const String humidChart = '/humidChart';

  static const publicRoutes = [
    login,
    register,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) {
      return null;
    }
    return RouteName.login;
  },
  routes: [
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    // GoRoute(
    //   path: RouteName.postDetail,
    //   builder: (context, state) => PostDetailScreen(
    //     id: state.pathParameters['id']!,
    //   ),
    // ),
    // GoRoute(
    //   path: RouteName.profile,
    //   builder: (context, state) => ProfileScreen(),
    // ),

    GoRoute(
        path: RouteName.sensor,
        builder: (context, state) => const ThresholdScreen()
        // ThresholdScreen(
        //     id: int.parse(state.pathParameters['id']!),
        //     stateSensor: state.pathParameters['stateSensor']!,
        //     temp: state.pathParameters['temp']!,
        //     humid: state.pathParameters['humid']!),
        ),
    GoRoute(
        path: RouteName.history,
        builder: (context, state) => const HistoryScreen()),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteName.tempChart,
      builder: (context, state) => const TempChartScreen(),
    ),
    GoRoute(
      path: RouteName.humidChart,
      builder: (context, state) => const HumidChartPage(),
    ),

  ],
);
