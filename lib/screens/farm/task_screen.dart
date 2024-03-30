import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vas_farm/features/farm/dtos/task_dto.dart';

import '../../config/theme.dart';
import '../../ultils/size_config.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../widgets/task_tile.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime monday =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  // Lấy ngày hiện tại
  var _selectedDate = DateTime.now();

  // Tìm ngày thứ 2 của tuần hiện tại
  List<String> title = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  var dayObjectList = <TaskDto>[
    TaskDto.fromJson(jsonDecode(
        '{"day":1,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e56a"}')),
    TaskDto.fromJson(jsonDecode(
        '{"day":2,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e56b"}')),
    TaskDto.fromJson(jsonDecode(
        '{"day":3,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e56c"}')),
    TaskDto.fromJson(jsonDecode(
        '{"day":4,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e56d"}')),
    TaskDto.fromJson(jsonDecode(
        '{"day":5,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e56e"}')),
    TaskDto.fromJson(jsonDecode(
        '{"day":6,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e56f"}')),
    TaskDto.fromJson(jsonDecode(
        '{"day":7,"status":true,"hour":2,"minute":45,"second":0,"timer":15,"_id":"6501911da50e57fe3f90e570"}')),
  ];

  //  DateTime _selectedDate = now.subtract(Duration(days: now.weekday - 1));

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    _addTaskBar() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: subHeadingStyle,
                ),
              ],
            ),

            // onTap: () async {
            //   // await Navigator.of(context).pushReplacement(MaterialPageRoute(
            //   //     builder: (context) => const AddTaskPage()));
            //   await Get.to(() => const AddTaskPage());
            //   _taskController.getTasks();
            // }),
          ],
        ),
      );
    }

    _addDateBar() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 10, top: 10),
        child: DatePicker(
          monday,
          width: 80,
          height: 100,
          initialSelectedDate: _selectedDate,
          selectedTextColor: Colors.white,
          selectionColor: primaryClr,
          dateTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
          dayTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
          monthTextStyle: GoogleFonts.lato(
              textStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          )),
          onDateChange: (newDate) {
            setState(() {
              _selectedDate = newDate;
            });
          },
        ),
      );
    }

    _showTasks() {
      return Expanded(
        child: ListView.builder(
          scrollDirection: SizeConfig.orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 1375),
              child: SlideAnimation(
                horizontalOffset: 300,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, dayObjectList[index], index);
                    },
                    child: TaskTile(
                      task: dayObjectList[index],
                      title: title[index],
                    ),
                  ),
                ),
              ),
            );
          },
          itemCount: 7,
        ),
      );
    }

    return Scaffold(
        // ignore: deprecated_member_use
        backgroundColor: context.theme.backgroundColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.indigo,
            ),
          ),
        ),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 6,
            ),
            _showTasks(),
          ],
        ));
  }

  _showBottomSheet(BuildContext context, TaskDto task, int index) {
    TimeOfDay selectedTime = TimeOfDay.now();

    Future<void> _selectTime() async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null && picked != selectedTime) {
        setState(() {
          selectedTime = picked;
          dayObjectList[index].hour = selectedTime.hour;
          dayObjectList[index].minute = selectedTime.minute;
        });
        Navigator.pop(context);
      }
    }

    showBottomSheet(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 4),
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.6,
              // (SizeConfig.orientation == Orientation.landscape)
              //     ? (task.isCompleted == 1
              //         ? SizeConfig.screenHeight * 0.6
              //         : SizeConfig.screenHeight * 0.8)
              //     : (task.isCompleted == 1
              //         ? SizeConfig.screenHeight * 0.30
              //         : SizeConfig.screenHeight * 0.39),
              color: Get.isDarkMode ? darkHeaderClr : Colors.white,
              child: Column(
                children: [
                  // Flexible(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildBottomSheet(
                      label:
                          'Time Start: ${dayObjectList[index].hour}:${dayObjectList[index].minute}',
                      onTap: () {
                        _selectTime();
                      },
                      clr: const Color.fromRGBO(255, 193, 7, 1)),
                  _buildBottomSheet(
                      label: 'Time Last: ${dayObjectList[index].timer}',
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                decoration: const InputDecoration(
                                  labelText: 'Enter Time',
                                  hintText: 'e.g., 15',
                                ),
                                onEditingComplete: () => Navigator.pop(context),
                                onSubmitted: (String value) {
                                  // Xử lý giá trị nhập vào ở đây
                                  setState(() {
                                    dayObjectList[index].timer =
                                        int.tryParse(value) ?? 15;
                                  });
                                  // Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        );
                        Navigator.pop(context);
                      },
                      clr: Colors.amber),
                  _buildBottomSheet(
                      label: 'On Task',
                      onTap: () {
                        // NotifyHelper().cancelNotification(task);
                        // _taskController.markTaskAsCompleted(task.id!);
                        setState(() {
                          task.status = true;
                          dayObjectList[index].status = true;

                          // updateValveDay(widget.index, dayObjectList[index], index);
                        });
                        Navigator.pop(context);
                      },
                      clr: primaryClr),
                  _buildBottomSheet(
                      label: 'Off Task',
                      onTap: () {
                        // NotifyHelper().cancelNotification(task);
                        // _taskController.deleteTasks(task);
                        setState(() {
                          task.status = false;
                          dayObjectList[index].status = false;

                          // updateValveDay(widget.index, dayObjectList[index], index);
                        });
                        Navigator.pop(context);
                      },
                      clr: Colors.red[300]!),
                  Divider(color: Get.isDarkMode ? Colors.grey : darkGreyClr),
                  _buildBottomSheet(
                      label: 'Cancel',
                      onTap: () {
                        Navigator.pop(context);
                      },
                      clr: primaryClr),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 45,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(20),
            color: isClose ? Colors.transparent : clr),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
