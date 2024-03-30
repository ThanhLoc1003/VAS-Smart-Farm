class TaskDto {
  String? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  int? day;
  bool status = false;
  int? hour = 2;
  int? minute = 55;
  int? second;
  int? timer = 15;

  TaskDto(
      {this.day,
      required this.hour,
      required this.minute,
      this.second,
      required this.timer,
      required this.status,
      this.id,
      this.title,
      this.note,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.color,
      this.remind,
      this.repeat});
  TaskDto.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    status = json['status'];
    hour = json['hour'];
    minute = json['minute'];
    second = json['second'];
    timer = json['timer'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['status'] = status;
    data['hour'] = hour;
    data['minute'] = minute;
    data['second'] = second;
    data['timer'] = timer;
    data['_id'] = id;
    return data;
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'day': day,
  //     'hour': hour,
  //     'minute': minute,
  //     'second': second,
  //     'timer': timer,
  //     'status': status,
  //     'id': id,
  //     'title': title,
  //     'note': note,
  //     'isCompleted': isCompleted,
  //     'date': date,
  //     'startTime': startTime,
  //     'endTime': endTime,
  //     'color': color,
  //     'remind': remind,
  //     'repeat': repeat,
  //   };
  // }

  // TaskDto.fromJson(Map<String, dynamic> json) {
  //   day = json['day'];
  //   hour = json['hour'];
  //   minute = json['minute'];
  //   second = json['second'];
  //   timer = json['timer'];
  //   status = json['status'];
  //   id = json['_id'];
  //   title = json['title'];
  //   note = json['note'];
  //   isCompleted = json['isCompleted'];
  //   date = json['date'];
  //   startTime = json['startTime'];
  //   endTime = json['endTime'];
  //   color = json['color'];
  //   remind = json['remind'];
  //   repeat = json['repeat'];
  // }
}
