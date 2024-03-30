class NodeDto {
  int? id;
  String? modeManual;
  String? modeSensor;
  String? dataSensor;
  StatusValve? statusValve;

  NodeDto({
    this.id,
    this.modeManual,
    this.modeSensor,
    this.dataSensor,
    this.statusValve,
  });
  factory NodeDto.fromJson(Map<String, dynamic> json) {
    return NodeDto(
      id: json['_id'],
      modeManual: json['modeManual'],
      modeSensor: json['modeSensor'],
      dataSensor: json['dataSensor'],
      statusValve: StatusValve.fromJson(json['statusValve']),
    );
  }
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
}
