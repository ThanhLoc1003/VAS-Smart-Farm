import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:vas_farm/features/farm/dtos/full_farm_dto.dart';

import 'package:vas_farm/ultils/theme_ext.dart';
import 'package:vas_farm/widgets/buttefly_valve_widget.dart';
import 'package:vas_farm/widgets/sensor_widget.dart';
import 'package:vas_farm/widgets/valve_parent.dart';

import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';

import '../../features/farm/blocs/farm_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _handleLogout(BuildContext context) {
    // context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  void _handleRetry(BuildContext context) {
    context.read<FarmBloc>().add(FarmStarted());
  }

  Widget _buidldDrawerWidget() {
    return Drawer(
      child: ListView(children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.greenAccent,
          ),
          child: Stack(
            children: [
              Positioned(
                  bottom: 8.0,
                  left: 4.0,
                  child: Text(
                    "VAS Farm App",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ],
          ),
        ),
        const ListTile(
          leading: Icon(Icons.dashboard),
          title: Text("Dashboard"),
          onTap: null,
        ),
        ListTile(
          leading: const Icon(Icons.history_sharp),
          title: const Text("History"),
          onTap: () {
            // _launchURL();
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const HistoryScreen()));
            context.push(RouteName.history);
          },
        ),
        ListTile(
          leading: const Icon(Icons.bubble_chart),
          title: const Text("Temperature Chart"),
          onTap: () {
            context.push(RouteName.tempChart);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const TempChartScreen()));
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => const HostPage()),
            //   (Route<dynamic> route) => false,
            // );
          },
        ),
        ListTile(
          leading: const Icon(Icons.ssid_chart),
          title: const Text("Humidity Chart"),
          onTap: () {
            context.push(RouteName.humidChart);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const HumidChartPage()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () => _handleLogout(context),
        ),
      ]),
    );
  }

  Widget _buildInProgress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildFailureHomeWidget(BuildContext context, String message) {
    return Column(
      children: [
        Text(
          message,
          style: context.text.bodyLarge!.copyWith(
            color: context.color.error,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            _handleRetry(context);
          },
          label: const Text('Retry'),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildHomeWidget1(BuildContext context, FullFarmDto fullFarm) {
    return ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValveParent(
                    statusValve: fullFarm.infor!.statusValve!,
                    id: fullFarm.id!),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButterflyValveWidget(
                        state: fullFarm.infor!.status!.auto == 1
                            ? true.obs
                            : false.obs,
                        id: fullFarm.id!),
                    SensorWidget(
                        id: fullFarm.id!,
                        temp: fullFarm.temp!,
                        humid: fullFarm.humid!,
                        stateSensor: fullFarm.modeSensor!)
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValveParent(
                    statusValve: fullFarm.infor!.statusValve!,
                    id: fullFarm.id! + 1),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButterflyValveWidget(
                        state: fullFarm.infor!.status!.auto == 1
                            ? true.obs
                            : false.obs,
                        id: fullFarm.id! + 1),
                    SensorWidget(
                        id: fullFarm.id! + 1,
                        temp: fullFarm.temp!,
                        humid: fullFarm.humid!,
                        stateSensor: fullFarm.modeSensor!)
                  ],
                ),
              ],
            ),
          ),
        ]);
  }

  // _buildHomeWidget2(BuildContext context, NodeDto nodeDto) {
  //   return Center(
  //     child: Text(nodeDto.dataSensor!),
  //   );
  // }

  @override
  void initState() {
    context.read<FarmBloc>().add(FarmStarted());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final farmState = context.watch<FarmBloc>().state;

    // var homeWidget = (switch (farmState) {
    //   FarmLoading() => _buildInProgress(),
    //   FarmLoaded() => _buildHomeWidget1(context, farmState.fullFarm),
    //   FarmError() => _buildFailureHomeWidget(context, farmState.message),
    //   // FarmLoadedWsk() => _buildHomeWidget1(context, farmState.nodeDto),
    //   _ => Container()
    // });
    late Widget homeWidget;
    switch (farmState) {
      case FarmLoading():
        homeWidget = _buildInProgress();
        break;
      case FarmLoaded(fullFarm: final fullFarm):
        datafullFarm = fullFarm;
        // var dataSend = datafullFarm.toJson();

        // print("Data full farm: $dataSend");
        homeWidget = _buildHomeWidget1(context, fullFarm);
        break;
      case FarmError(message: final msg):
        homeWidget = _buildFailureHomeWidget(context, msg);
        break;
      default:
        homeWidget = Container();
    }

    homeWidget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthLogoutSuccess():
            context.read<AuthBloc>().add(AuthStarted());
            context.pushReplacement(RouteName.login);
            break;
          case AuthLogoutFailure(message: final msg):
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Logout Failure'),
                  content: Text(msg),
                  backgroundColor: context.color.surface,
                );
              },
            );
          default:
        }
      },
      child: homeWidget,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: context.color.primary,
      ),
      drawer: _buidldDrawerWidget(),
      body: SafeArea(child: homeWidget),
    );
  }
}
