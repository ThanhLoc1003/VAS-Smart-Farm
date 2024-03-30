import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../features/farm/dtos/status_dto.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class FarmApi {
  static var clientHttp = http.Client();
  static Future<String?> fetchDataHttp() async {
    var respone =
        await clientHttp.get(Uri.parse('http://115.79.196.171:6789/allfarm'));
    if (respone.statusCode == 200) {
      return respone.body;
    } else {
      return null;
    }
  }

  static Future<List<Status>?> getStatus(
      int id, DateTime dateStart, DateTime dateEnd) async {
    var url =
        'http://115.79.196.171:6789/getStatus?dayStart=${dateStart.day}&monthStart=${dateStart.month}&yearStart=${dateStart.year}&dayEnd=${dateEnd.day}&monthEnd=${dateEnd.month}&yearEnd=${dateEnd.year}&id=$id';
    var res = await clientHttp.get(Uri.parse(url));
    if (res.statusCode == 200) {
      List<Status> statusList = [];

      List<dynamic> jsonList = json.decode(res.body);

      for (var jsonItem in jsonList) {
        if (jsonItem != null) {
          Status status = Status.fromJson(jsonItem);
          statusList.add(status);
        }
      }
      return statusList; //Status.fromJson(jsonDecode(res.body));
    } else {
      return null;
    }
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedDate = '';
  bool isSearched = false;
  String convertToDateTimeString(String inputString, int minutes) {
    // Tách chuỗi thành các thành phần ngày, tháng, năm, giờ, phút
    final parts = inputString.split('/');

    if (parts.length == 5) {
      final day = parts[0].padLeft(2, '0');
      final month = parts[1].padLeft(2, '0');
      final year = parts[2];
      final hour = parts[3].padLeft(2, '0');
      // final minute = parts[4].padLeft(2, '0');
      final minute = minutes.toString().padLeft(2, '0');
      // Định dạng lại chuỗi theo định dạng yyyymmddTHHMM
      final formattedString = '$year$month${day}T$hour$minute';

      return formattedString;
    } else {
      // Trường hợp chuỗi không hợp lệ
      return 'Invalid input';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      //  && picked != DateTime.now()) {
      // setState(() {
      //   // selectedDate = picked.toString();
      //   _startDate =
      //       DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0);
      //   if (picked.day < DateTime.now().day) {
      //     _endDate =
      //         DateTime(picked.year, picked.month, picked.day, 23, 59, 59, 0);
      //   } else {
      //     _endDate = DateTime.now();
      //   }
      //   isSearched = true;
      //   // print(_startDate);
      //   //print(_endDate);
      //   if (_startDate != null) _getData(_startDate!, _endDate!);
      //   selectedDate = DateFormat('dd/MM/yyyy').format(picked).toString();
      // });
      _startDate = DateTime(picked.year, picked.month, picked.day, 0, 0, 0, 0);
      if (picked.day < DateTime.now().day) {
        _endDate =
            DateTime(picked.year, picked.month, picked.day, 23, 59, 59, 0);
      } else {
        _endDate = picked;
      }
      isSearched = true;
      // print(_startDate);
      //print(_endDate);
      if (_startDate != null) _getData(_startDate!, _endDate!);
      selectedDate = DateFormat('dd/MM/yyyy').format(picked).toString();
    }
  }

  // final List<String> entries = <String>['A', 'B', 'C', 'D', 'E'];
  // final List<int> colorCodes = <int>[600, 500, 100, 200, 700];
  List<DateTime> dataTime = [], dataHistory = [];
  List<double> dataTemp1 = [];
  DateTime? _startDate;
  DateTime? _endDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check data loss history'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected date: $selectedDate',
                  //$selectedDate',
                  style: const TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  child: const Text('Select date'),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            isSearched
                ? dataHistory.isNotEmpty
                    ? Expanded(
                        child: SizedBox(
                        height: 200.0,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: dataHistory.length,
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 50,
                              //color: Colors.amber[colorCodes[index]],
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                              DateFormat('dd/MM/yyyy')
                                                  .format(dataHistory[index]),
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'SegoeUI-Bold',
                                                  color: Colors.black)),
                                          Text(
                                              DateFormat('HH:mm')
                                                  .format(dataHistory[index]),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'SegoeUI',
                                                  color: Colors.blueGrey)),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        color: Colors.grey,
                                        height: 40,
                                        width: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text("Lose data",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'SegoeUI',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red))
                                    ],
                                  )
                                ],
                              ),
                              //Center(child: Text('Entry ${entries[index]}')),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ))
                    : Text(
                        "Date ${DateFormat('dd/MM/yyyy').format(_startDate!).toString()} does not lost data",
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'SegoeUI',
                            fontWeight: FontWeight.bold,
                            color: Colors.black))
                : const Text("Please select date",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SegoeUI',
                        fontWeight: FontWeight.bold,
                        color: Colors.black))
          ],
        ),
      ),
    );
  }

  void _getData(DateTime startDate, DateTime endDate) async {
    // Ở đây, bạn có thể sử dụng thư viện fl_chart để vẽ biểu đồ nhiệt độ
    // và sử dụng dữ liệu nhiệt độ trong khoảng thời gian đã chọn để cập nhật biểu đồ.
    // Ví dụ: https://pub.dev/packages/fl_chart
    // Lấy dữ liệu nhiệt độ từ các biến và thêm vào danh sách

    dataTime.clear();
    dataHistory.clear();
    var statusData = await FarmApi.getStatus(1, _startDate!, _endDate!);

    if (statusData != null) {
      for (int i = 0; i < statusData.length; i++) {
        for (int j = 0; j < statusData[i].sensorStatus!.length; j++) {
          dataTemp1.add(statusData[i].sensorStatus![j].value!.temp1!);

          dataTime.add(DateTime.parse(convertToDateTimeString(
              statusData[i].id!, statusData[i].sensorStatus![j].timeSave!)));
        }
      }
    } else {
      // print("Failed to fetch status data.");
    }

    // Tính toán số lượng điểm trên trục x dựa trên khoảng thời gian
    var numberOfTicks = endDate.difference(startDate).inMinutes;

    int count = 0, counter = 3;
    for (int i = 0; i < numberOfTicks; i++) {
      final currentTime = startDate.add(Duration(minutes: i));
      if (currentTime == startDate || currentTime == endDate) {
        // _chartData1.add(DataChart(0.0, 0.0, currentTime));
        // _chartData2.add(DataChart(0.0, 0.0, currentTime));
      } else {
        int index = dataTime.indexOf(currentTime);
        if (index == -1) {
          count++;
        } else {
          count = 0;
          if (dataTemp1[index] == 101) {
            dataHistory.add(dataTime[index]);
          }
        }

        if (count >= 3) {
          counter++;
          //print(counter);
          if (count == 3 && dataTemp1[index + 1] != 0) {
          } else {
            if (counter % (sqrt(counter)).toInt() == 0) {
              dataHistory.add(currentTime);
            }
          }
        } else {
          counter = 3;
        }
      }
    }
    setState(() {
      // if (dataHistory.isNotEmpty) print(dataHistory[0]);
    });
  }
}
