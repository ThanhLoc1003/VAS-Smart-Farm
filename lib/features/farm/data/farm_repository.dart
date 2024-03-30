import 'dart:developer';

import 'package:vas_farm/features/farm/dtos/full_farm_dto.dart';

import '../../result_type.dart';
import 'farm_api_client.dart';

class FarmRepository {
  final FarmApiClient farmApiClient;

  FarmRepository(this.farmApiClient);

  Future<Result<FullFarmDto>> getFullFarm() async {
    try {
      final res = await farmApiClient.getFullFarm();
      return Success(res);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
  }
}
