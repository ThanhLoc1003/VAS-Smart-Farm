import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas_farm/widgets/custom_dialog.dart';

import '../features/farm/blocs/farm_export.dart';

class ValveChild extends StatefulWidget {
  const ValveChild(
      {super.key, required this.index, required this.state, required this.id});
  final int index, id;

  final RxBool state;
  @override
  State<ValveChild> createState() => _ValveChildState();
}

class _ValveChildState extends State<ValveChild> {
  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Valve ${widget.index}',
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Obx(() => CupertinoSwitch(
            value: widget.state.value,
            onChanged: ((value) {
              if (isControlled) {
                isControlled = false;
                widget.state.value = value;
                switch (widget.index) {
                  case 1:
                    datafullFarm.infor!.statusValve!.valve1 = value ? 1 : 0;
                    break;
                  case 2:
                    datafullFarm.infor!.statusValve!.valve2 = value ? 1 : 0;
                    break;
                  case 3:
                    datafullFarm.infor!.statusValve!.valve3 = value ? 1 : 0;
                    break;
                  default:
                    datafullFarm.infor!.statusValve!.valve4 = value ? 1 : 0;
                    break;
                }

                // datafullFarm.infor?.statusValve. = value;
                context
                    .read<FarmBloc>()
                    .add(SendFarmData(json.encode(datafullFarm.toJson())));
              } else {
                customDialog(context, "Warning", "Please wait for ACK");
              }
            }))),
        // CupertinoSwitch(
        //     value: widget.state,
        //     onChanged: (value) {
        // if (roleUser) {
        //   if (!isSent) {
        //     isSent = true;
        //     setState(() {
        //       widget.state = value;
        //       switch (widget.index) {
        //         case 1:
        //           value
        //               ? globalData[widget.id]['infor']['statusValve']
        //                   ['valve1'] = 1
        //               : globalData[widget.id]['infor']['statusValve']
        //                   ['valve1'] = 0;
        //           break;
        //         case 2:
        //           value
        //               ? globalData[widget.id]['infor']['statusValve']
        //                   ['valve2'] = 1
        //               : globalData[widget.id]['infor']['statusValve']
        //                   ['valve2'] = 0;
        //           break;
        //         case 3:
        //           value
        //               ? globalData[widget.id]['infor']['statusValve']
        //                   ['valve3'] = 1
        //               : globalData[widget.id]['infor']['statusValve']
        //                   ['valve3'] = 0;
        //           break;
        //         default:
        //           value
        //               ? globalData[widget.id]['infor']['statusValve']
        //                   ['valve4'] = 1
        //               : globalData[widget.id]['infor']['statusValve']
        //                   ['valve4'] = 0;
        //           break;
        //       }
        //     });
        //     sendData(widget.id);
        //   } else {
        //     CustomDialog(context, "Warning", "Please wait for ACK");
        //   }
        // } else {
        //   CustomDialog(context, "Warning", "Bạn không có quyền truy cập");
        // }
        // }),
      ],
    );
  }
}
