import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/router.dart';

class SensorWidget extends StatelessWidget {
  const SensorWidget(
      {super.key,
      required this.id,
      required this.temp,
      required this.humid,
      required this.stateSensor});
  final int id;
  final String temp;
  final String humid;
  final String stateSensor;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.15,
        width: size.width * 0.34,
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(12.0)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        "assets/images/sensor.png",
                        height: 40,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$temp°C\n',
                                ),
                                TextSpan(text: '$humid%')
                              ])),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Sensor $id',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            context.push(RouteName.sensor);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ThresholdScreen(
                            //               id: id,
                            //               humid: humid,
                            //               temp: temp,
                            //               stateSensor: stateSensor,
                            //             )));

                            // if (roleUser) {
                            //   Get.to(() => ThershPage(id: widget.index));
                            // } else {
                            //   CustomDialog(context, "Warning",
                            //       "Bạn không có quyền truy cập");
                            // }
                          },
                          icon: const Icon(Icons.settings))
                    ],
                  ),
                ],
              )
            ]));
  }
}
