import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_farm/features/auth/bloc/auth_bloc.dart';
import 'package:vas_farm/features/auth/data/auth_api_client.dart';
import 'package:vas_farm/features/auth/data/auth_repository.dart';
import '../features/farm/blocs/farm_export.dart';
import 'package:vas_farm/features/farm/data/farm_api_client.dart';
import 'package:vas_farm/features/farm/data/farm_repository.dart';

import 'config/http_client.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/auth/data/auth_local_data_source.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();

  runApp(MainApp(sharedPreferences: sf)
      // DevicePreview(
      //     enabled: true, builder: (context) => MainApp(sharedPreferences: sf)),
      );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.sharedPreferences});
  final SharedPreferences sharedPreferences;
  @override
  Widget build(context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
              authApiClient: AuthApiClient(dioLogin),
              authLocalDataSource: AuthLocalDataSource(sharedPreferences)),
        ),
        RepositoryProvider(
          create: (context) => FarmRepository(FarmApiClient(dioFarm)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => FarmBloc(context.read<FarmRepository>()),
          ),
          BlocProvider(
            create: (context) => ThresholdBloc(),
          ),
        ],
        child: const AppContent(),
      ),
    );
  }
}

class AppContent extends StatefulWidget {
  const AppContent({
    super.key,
  });

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthAuthenticateStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    if (authState is AuthInitial) {
      return Container();
    }
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routerConfig: router,
    );
  }
}
