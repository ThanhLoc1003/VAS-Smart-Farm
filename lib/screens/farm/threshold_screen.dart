import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vas_farm/features/farm/blocs/farm_export.dart';

import '../../widgets/custom_dialog.dart';

class ThresholdScreen extends StatefulWidget {
  const ThresholdScreen({super.key});

  @override
  State<ThresholdScreen> createState() => _ThresholdScreenState();
}

class _ThresholdScreenState extends State<ThresholdScreen> {
  int low_t = 20, high_t = 30;
  var stateSensor;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.indigo.shade50,
            body: BlocListener<FarmBloc, FarmState>(listener: (context, state) {
              if (state is FarmLoaded) {
                context
                    .read<ThresholdBloc>()
                    .add(UpdateEvent(dataFull: state.fullFarm));
              }
            }, child: BlocBuilder<ThresholdBloc, ThresholdState>(
              builder: (context, state) {
                // print(
                //     "Builder: ${state.dataFull.toJson()}/n ${state.dataFull.modeSensor}");
                stateSensor =
                    state.dataFull.modeSensor == "sensor_on" ? true : false;
                // state.dataFull.infor!.status!.sensor == 1 ? true : false;
                low_t = state.dataFull.infor!.sensor!.low!;
                high_t = state.dataFull.infor!.sensor!.high!;
                return Container(
                  margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.pop();
                            // Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.indigo,
                          ),
                        ),
                        const Text(
                          "Setting Sensor",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                        const RotatedBox(
                          quarterTurns: 135,
                          child: Icon(
                            Icons.bar_chart_rounded,
                            color: Colors.indigo,
                            size: 28,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                        child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.heat_pump),
                                      Text('${state.dataFull.temp}°C'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(Icons.water_drop_outlined),
                                      Text('${state.dataFull.humid}%'),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CupertinoSwitch(
                                        value: stateSensor,
                                        onChanged: (value) {
                                          if (isControlled) {
                                            isControlled = false;
                                            context.read<ThresholdBloc>().add(
                                                SwitchEvent(
                                                    dataFull: state.dataFull));

                                            context.read<FarmBloc>().add(
                                                SendFarmData(json.encode(
                                                    state.dataFull.toJson())));
                                          } else {
                                            customDialog(context, "Warning",
                                                "Please wait for ACK");
                                          }
                                        },
                                      ),
                                      Text(stateSensor ? 'Auto' : 'Manual'),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    "High threshold",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Slider(
                                    max: 100,
                                    value: high_t.toDouble(),
                                    onChanged: (newVal) {
                                      context.read<ThresholdBloc>().add(
                                          AdjustHighEvent(
                                              dataFull: state.dataFull,
                                              value: newVal.toInt()));
                                      // setState(() {
                                      //   high_t = newVal.toInt();
                                      // });
                                    }),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('0\u00B0'),
                                      Text('50\u00B0'),
                                      Text('100\u00B0'),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Text(
                                    "Low threshold",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Slider(
                                    max: 100,
                                    value: low_t.toDouble(),
                                    onChanged: (newVal) {
                                      context.read<ThresholdBloc>().add(
                                          AdjustLowEvent(
                                              dataFull: state.dataFull,
                                              value: newVal.toInt()));
                                      // setState(() {
                                      //   low_t = newVal.toInt();
                                      // });
                                    }),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('0\u00B0'),
                                      Text('50\u00B0'),
                                      Text('100\u00B0'),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ],
                    )),
                  ]),
                );
              },
            ))));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
// class _ThresholdScreenState extends State<ThresholdScreen> {
//   int low_t = 20, high_t = 30;
//   late bool stateSensor;
//   // int id = 1;
//   // String stateSensorS = "sensor_on";
//   // String temp = "23-53";
//   // String humid = "15-23";
//   @override
//   void initState() {
//     // stateSensor = stateSensorS == 'sensor_on' ? true : false;
//     context.read<FarmBloc>().add(FarmStarted());
//     super.initState();
//   }

//   void _handleRetry(BuildContext context) {
//     context.read<FarmBloc>().add(FarmStarted());
//   }

//   Widget _buildInProgress() {
//     return const Center(
//       child: CircularProgressIndicator(),
//     );
//   }

//   Widget _buildFailureHomeWidget(BuildContext context, String message) {
//     return Column(
//       children: [
//         Text(
//           message,
//           style: context.text.bodyLarge!.copyWith(
//             color: context.color.error,
//           ),
//         ),
//         const SizedBox(height: 24),
//         FilledButton.icon(
//           onPressed: () {
//             _handleRetry(context);
//           },
//           label: const Text('Retry'),
//           icon: const Icon(Icons.refresh),
//         ),
//       ],
//     );
//   }

//   Widget _buildMainWidget(BuildContext context, FullFarmDto fullFarm) {
//     stateSensor = fullFarm.infor!.status!.sensor == 1 ? true : false;
//     low_t = fullFarm.infor!.sensor!.low!;
//     high_t = fullFarm.infor!.sensor!.high!;
//     return Container(
//       margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
//       child: Column(children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 context.pop();
//                 // Navigator.pop(context);
//               },
//               child: const Icon(
//                 Icons.arrow_back_ios,
//                 color: Colors.indigo,
//               ),
//             ),
//             const Text(
//               "Setting Sensor",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.indigo,
//               ),
//             ),
//             const RotatedBox(
//               quarterTurns: 135,
//               child: Icon(
//                 Icons.bar_chart_rounded,
//                 color: Colors.indigo,
//                 size: 28,
//               ),
//             )
//           ],
//         ),
//         Expanded(
//             child: ListView(
//           physics: const BouncingScrollPhysics(),
//           children: [
//             const SizedBox(
//               height: 32,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Icon(Icons.heat_pump),
//                           Text('${fullFarm.temp}°C'),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Icon(Icons.water_drop_outlined),
//                           Text('${fullFarm.humid}%'),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CupertinoSwitch(
//                             value: stateSensor,
//                             onChanged: (value) {
//                               if (value) {
//                                 datafullFarm.infor!.status!.auto = 2;
//                                 datafullFarm.infor!.status!.manual = 2;
//                                 datafullFarm.infor!.status!.sensor = 1;
//                               } else {
//                                 datafullFarm.infor!.status!.auto = 2;
//                                 datafullFarm.infor!.status!.manual = 1;
//                                 datafullFarm.infor!.status!.sensor = 2;
//                               }
//                               context.read<FarmBloc>().add(SendFarmData(
//                                   json.encode(datafullFarm.toJson())));

//                               // value
//                               //     ? globalData[widget.id]['infor']
//                               //         ['status']['sensor'] = 1
//                               //     : globalData[widget.id]['infor']
//                               //         ['status']['sensor'] = 0;
//                               // globalData[widget.id]['infor']['status']
//                               //     ['manual'] = 3;
//                               // globalData[widget.id]['infor']['status']
//                               //     ['auto'] = 3;
//                               // globalData[widget.id]['infor']['sensor']
//                               //     ['high'] = high_t.toInt();
//                               // globalData[widget.id]['infor']['sensor']
//                               //     ['low'] = low_t.toInt();
//                               // sendData(widget.id);
//                             },
//                           ),
//                           Text(stateSensor ? 'Auto' : 'Manual'),
//                         ],
//                       ),
//                     ),
//                   ]),
//             ),
//             const SizedBox(
//               height: 32,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24),
//                       child: Text(
//                         "High threshold",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Slider(
//                         max: 100,
//                         value: high_t.toDouble(),
//                         onChanged: (newVal) {
//                           setState(() {
//                             high_t = newVal.toInt();
//                           });
//                         }),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('0\u00B0'),
//                           Text('50\u00B0'),
//                           Text('100\u00B0'),
//                         ],
//                       ),
//                     )
//                   ]),
//             ),
//             const SizedBox(
//               height: 32,
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24),
//                       child: Text(
//                         "Low threshold",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Slider(
//                         max: 100,
//                         value: low_t.toDouble(),
//                         onChanged: (newVal) {
//                           setState(() {
//                             low_t = newVal.toInt();
//                           });
//                         }),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 24),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('0\u00B0'),
//                           Text('50\u00B0'),
//                           Text('100\u00B0'),
//                         ],
//                       ),
//                     )
//                   ]),
//             ),
//           ],
//         )),
//       ]),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final farmState = context.watch<FarmBloc>().state;

//     var bodyWidget = (switch (farmState) {
//       FarmLoading() => _buildInProgress(),
//       FarmLoaded() => _buildMainWidget(context, farmState.fullFarm),
//       FarmError() => _buildFailureHomeWidget(context, farmState.message),
//       // FarmLoadedWsk() => _buildHomeWidget1(context, farmState.nodeDto),
//       _ => Container()
//     });
//     return SafeArea(
//         child: Scaffold(
//             //appBar: AppBar(title: const Text("Setting Sensor")),
//             backgroundColor: Colors.indigo.shade50,
//             body: bodyWidget));
//   }
// }
