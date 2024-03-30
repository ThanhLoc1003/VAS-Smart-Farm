


class Status {
  String? id;
  int? sensor;
  List<SensorStatus>? sensorStatus;
  Status(this.id, this.sensor, this.sensorStatus);
  Status.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        sensor = json['sensor'],
        sensorStatus = (json['sensorStatus'] as List<dynamic>)
            .map((e) => SensorStatus.fromJson(e as Map<String, dynamic>))
            .toList();
}



class SensorStatus {
  String? id;
  int? timeSave;
  ValueSensor? value;
  SensorStatus(this.id, this.timeSave, this.value);
  SensorStatus.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        timeSave = json['timeSave'],
        value = ValueSensor.fromJson(json['value']);
}

class ValueSensor {
  double? temp1;
  double? temp2;
  double? humid1;
  double? humid2;
  ValueSensor(this.temp1, this.temp2, this.humid1, this.humid2);
  factory ValueSensor.fromJson(Map<String, dynamic> json) {
    // Kiểm tra nếu json['temp1'] là kiểu int, thì chuyển đổi thành double
    final temp1Value = json['temp1'];
    final t1 = (temp1Value is int) ? temp1Value.toDouble() : temp1Value ?? 0.0;
    final temp2Value = json['temp2'];
    final t2 = (temp2Value is int) ? temp2Value.toDouble() : temp2Value ?? 0.0;
    final humid1Value = json['humid1'];
    final h1 =
        (humid1Value is int) ? humid1Value.toDouble() : humid1Value ?? 0.0;
    final humid2Value = json['humid2'];
    final h2 =
        (humid2Value is int) ? humid2Value.toDouble() : humid2Value ?? 0.0;
    return ValueSensor(t1, t2, h1, h2);
  }
  // ValueSensor.fromJson(Map<String, dynamic> json)
  //     : temp1 = json['temp1'] as double? ?? 0.0,
  //       temp2 = json['temp2'] as double? ?? 0.0,
  //       humid1 = json['humid1'] as double? ?? 0.0,
  //       humid2 = json['humid2'] as double? ?? 0.0;
}