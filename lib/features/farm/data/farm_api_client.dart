import 'package:dio/dio.dart';
import 'package:vas_farm/features/farm/dtos/full_farm_dto.dart';

class FarmApiClient {
  final Dio dio;

  FarmApiClient(this.dio);
  Future<FullFarmDto> getFullFarm() async {
    try {
      final res = await dio.get('/allfarm');
      // List<dynamic> data = json.decode(res.data);

      // List<dynamic> valveList = data[0]['valveList'];
      // var datas =
      //     valveList.map((valve) => FullFarmDto.fromJson(valve)).toList();
      // print(res.data[0]['valveList'][0].runtimeType);
      // log('${res.data[0]['valveList'][0]}');
      // log('${jsonDecode(res.data[0]['valveList'][0])}');

      return FullFarmDto.fromJson(res.data[0]['valveList'][0]);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception(e.message);
    }
  }
}
