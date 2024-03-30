import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vas_farm/features/farm/dtos/full_farm_dto.dart';

import 'valve_child.dart';

class ValveParent extends StatefulWidget {
  const ValveParent({super.key, required this.statusValve, required this.id});
  final StatusValve statusValve;
  final int id;
  @override
  State<ValveParent> createState() => _ValveParentState();
}

class _ValveParentState extends State<ValveParent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.17,
      width: size.width * 0.6,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValveChild(
                  index: 1,
                  id: widget.id,
                  state: widget.statusValve.valve1 == 1 ? true.obs : false.obs),
              ValveChild(
                  index: 2,
                  id: widget.id,
                  state: widget.statusValve.valve2 == 1 ? true.obs : false.obs),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValveChild(
                  index: 3,
                  id: widget.id,
                  state: widget.statusValve.valve3 == 1 ? true.obs : false.obs),
              ValveChild(
                  index: 4,
                  id: widget.id,
                  state: widget.statusValve.valve4 == 1 ? true.obs : false.obs),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Slave ${widget.id}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
          ),
        ],
      ),
    );
  }
}
