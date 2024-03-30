import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vas_farm/features/farm/dtos/status_dto.dart';


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