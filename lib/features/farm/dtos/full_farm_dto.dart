class FullFarmDto {
  Infor? infor;
  int? id;
  String? farm;
  String? modeManual;
  String? modeAuto;
  String? modeSensor;
  String? dataSensor;
  String? temp;
  String? humid;
  int? v;

  FullFarmDto({
    this.infor,
    this.id,
    this.farm,
    this.modeManual,
    this.modeAuto,
    this.modeSensor,
    this.dataSensor,
    this.v,
  }) {
    getData();
  }
  getData() {
    if ((dataSensor != null)) {
      final str = dataSensor?.split('|');
      if (str!.length > 1) {
        temp = str[0].toString();
        humid = str[1].toString();
      } else {
        temp = "NaN";
        humid = "NaN";
      }
    } else {
      temp = "NaN";
      humid = "NaN";
    }
  }

  FullFarmDto copyWith({
    Infor? infor,
    int? id,
    String? farm,
    String? modeManual,
    String? modeAuto,
    String? modeSensor,
    String? dataSensor,
    String? temp,
    String? humid,
  }) =>
      FullFarmDto(
          infor: infor ?? this.infor,
          id: id ?? this.id,
          farm: farm ?? this.farm,
          modeManual: modeManual ?? this.modeManual,
          modeAuto: modeAuto ?? this.modeAuto,
          modeSensor: modeSensor ?? this.modeSensor,
          dataSensor: dataSensor ?? this.dataSensor);

  factory FullFarmDto.fromJson(Map<String, dynamic> json) {
    return FullFarmDto(
      infor: Infor.fromJson(json),
      id: json['_id'],
      farm: json['farm'],
      modeManual: json['modeManual'],
      modeAuto: json['modeAuto'],
      modeSensor: json['modeSensor'],
      dataSensor: json['dataSensor'],
      v: json['v'],
    );
  }
  Map<String, dynamic> toJson() => {
        'infor': infor?.toJson(),
        '_id': id,
      };
}

class Infor {
  Status? status;
  Sensor? sensor;
  int? id;
  List<DayObjectList>? dayObjectList;
  StatusValve? statusValve;

  Infor({
    this.statusValve,
    this.status,
    this.sensor,
    this.id,
    this.dayObjectList,
  });
  factory Infor.fromJson(Map<String, dynamic> json) {
    return Infor(
      statusValve: (json['statusValve'] != null)
          ? StatusValve.fromJson(json['statusValve'])
          : StatusValve.fromJson(json['infor']['statusValve']),
      status: Status.fromJson(json['infor']['status']),
      sensor: Sensor.fromJson(json['infor']['sensor']),
      id: json['infor']['_id'],
      dayObjectList: json['infor']['dayObjectList'] != null
          ? List<DayObjectList>.from(json['infor']['dayObjectList']
              .map((x) => DayObjectList.fromJson(x)))
          : null,
    );
  }
  Map<String, dynamic> toJson() => {
        'statusValve': statusValve?.toJson(),
        'status': status?.toJson(),
        'sensor': sensor?.toJson(),
        'infor': id,
        'dayObjectList':
            dayObjectList!.map((dayObject) => dayObject.toJson()).toList()
      };
}

class DayObjectList {
  int? day;
  bool? status;
  int? hour;
  int? minute;
  int? second;
  int? timer;
  String? id;

  DayObjectList({
    this.day,
    this.status,
    this.hour,
    this.minute,
    this.second,
    this.timer,
    this.id,
  });
  factory DayObjectList.fromJson(Map<String, dynamic> json) {
    return DayObjectList(
      day: json['day'],
      status: json['status'],
      hour: json['hour'],
      minute: json['minute'],
      second: json['second'],
      timer: json['timer'],
      id: json['_id'],
    );
  }
  Map<String, dynamic> toJson() => {
        'day': day,
        'status': status,
        'hour': hour,
        'minute': minute,
        'second': second,
        'timer': timer,
        '_id': id,
      };
}

class Sensor {
  int? high;
  int? low;

  Sensor({
    this.high,
    this.low,
  });
  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      high: json['high'],
      low: json['low'],
    );
  }
  Map<String, dynamic> toJson() => {'high': high, 'low': low};
}

class Status {
  int? auto;
  int? manual;
  int? sensor;

  Status({
    this.auto,
    this.manual,
    this.sensor,
  });
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      auto: json['auto'],
      manual: json['manual'],
      sensor: json['sensor'],
    );
  }
  Map<String, dynamic> toJson() =>
      {'auto': auto, 'manual': manual, 'sensor': sensor};
}

class StatusValve {
  int? valve1;
  int? valve2;
  int? valve3;
  int? valve4;

  StatusValve({
    this.valve1,
    this.valve2,
    this.valve3,
    this.valve4,
  });
  factory StatusValve.fromJson(Map<String, dynamic> json) {
    return StatusValve(
      valve1: json['valve1'],
      valve2: json['valve2'],
      valve3: json['valve3'],
      valve4: json['valve4'],
    );
  }
  Map<String, dynamic> toJson() =>
      {'valve1': valve1, 'valve2': valve2, 'valve3': valve3, 'valve4': valve4};
}
