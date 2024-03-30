import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas_farm/screens/farm/task_screen.dart';

import '../features/farm/blocs/farm_export.dart';
import 'custom_dialog.dart';

class ButterflyValveWidget extends StatelessWidget {
  const ButterflyValveWidget(
      {super.key, required this.state, required this.id});
  final RxBool state;
  final int id;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() => Container(
          height: size.height * 0.15,
          width: size.width * 0.33,
          decoration: BoxDecoration(
              color: !state.value ? Colors.grey[900] : Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/images/valve.png",
                    height: 40,
                    color: state.value ? Colors.black : Colors.white,
                  ),
                  Transform.rotate(
                    angle: -3.14 / 2,
                    child: CupertinoSwitch(
                      value: state.value,
                      onChanged: (value) {
                        if (isControlled) {
                          isControlled = false;
                          state.value = value;
                          if (value) {
                            datafullFarm.infor!.status!.auto = 1;
                            datafullFarm.infor!.status!.manual = 2;
                            datafullFarm.infor!.status!.sensor = 2;
                          } else {
                            datafullFarm.infor!.status!.auto = 2;
                            datafullFarm.infor!.status!.manual = 1;
                            datafullFarm.infor!.status!.sensor = 2;
                          }
                          context.read<FarmBloc>().add(
                              SendFarmData(json.encode(datafullFarm.toJson())));
                        } else {
                          customDialog(
                              context, "Warning", "Please wait for ACK");
                        }
                        // if (roleUser) {
                        //   if (!isSent) {
                        //     value
                        //         ? globalData[widget.index]['infor']
                        //             ['status']['manual'] = 1
                        //         : globalData[widget.index]['infor']
                        //             ['status']['manual'] = 0;
                        //     sendData(widget.index);
                        //     isSent = true;
                        //     setState(() {
                        //       state.value = value;
                        //       // value
                        //       //     ? dataSensor.modeSensor = "sensor_on"
                        //       //     : dataSensor.modeSensor = "sensor_off";
                        //       // dataSensor.modeSensor == 'sensor_on'
                        //       //     ? state.value = true
                        //       //     : state.value = false;
                        //       // print('$value        $state.value\n');
                        //       // print(dataSensor.dataSensor);
                        //     });
                        //   } else {
                        //     CustomDialog(
                        //         context, "Warning", "Please wait for ACK");
                        //   }
                        // } else {
                        //   CustomDialog(context, "Warning",
                        //       "Bạn không có quyền truy cập");
                        // }
                      },
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: 'Butterfly\n',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: state.value ? Colors.black : Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: 'Valve $id',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: state.value ? Colors.black : Colors.white,
                      ),
                    )
                  ])),
                  IconButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskScreen(),
                            ));
                        // if (roleUser) {
                        //   var data = await FarmApi.fetchDataHttp();
                        //   List<dynamic> jsonList = json.decode(data!);

                        //   // Lấy ra trường "valveList" từ đối tượng JSON đầu tiên
                        //   List<dynamic> valveList = jsonList[0]["valveList"];
                        //   var temp = Infor.fromJson(valveList[0]["infor"]);
                        //   dayObjectList = temp.dayObjectList!;
                        //   print(dayObjectList[2].day);
                        //   // print(temp.dayObjectList?[0].day);
                        //   // print(temp.dayObjectList?[0].minute);
                        //   Get.to(() => TaskPage(index: widget.index));
                        // } else {
                        //   CustomDialog(
                        //       context, "Warning", "Bạn không có quyền truy cập");
                        // }
                      },
                      icon: const Icon(Icons.settings),
                      color: state.value ? Colors.black : Colors.white)
                ],
              ),
            ],
          ),
        ));
  }
}
