import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_farm/features/farm/blocs/farm_export.dart';
import 'package:vas_farm/features/farm/data/farm_wsk_client.dart';
import 'package:vas_farm/features/farm/dtos/node_dto.dart';

import '../../../result_type.dart';
import '../../data/farm_repository.dart';
import '../../dtos/full_farm_dto.dart';

part 'farm_event.dart';
part 'farm_state.dart';
FullFarmDto datafullFarm = FullFarmDto();

class FarmBloc extends Bloc<FarmEvent, FarmState> {
  final FarmRepository farmRepository;
  late WebSocketManager _webSocketManager;
  FarmBloc(this.farmRepository) : super(FarmInitial()) {
    on<FarmStarted>(_onStarted);
    on<FarmUpdateFromNode>(_onUpdateFromNode);
    // on<FarmUpdateFromClient>(_onUpdateFromClient);
    on<SendFarmData>(_onSendFarmData);

    _webSocketManager = WebSocketManager();
    _webSocketManager.stream.listen((data) {
      // Xử lý dữ liệu nhận được từ WebSocket
      log('$data');
      isControlled = true;
      if (json.decode(data)['_id'] == 1) {
        add(FarmStarted());
      }

      // add(FarmUpdateFromNode(nodeDto: NodeDto.fromJson(jsonDecode(data))));
    });
  }
  void _onStarted(FarmStarted event, Emitter<FarmState> emit) async {
    emit(FarmLoading());
    // await Future.delayed(500.milliseconds);
    final result = await farmRepository.getFullFarm();
    return switch (result) {
      Success(data: final fullFarm) => emit(FarmLoaded(fullFarm: fullFarm)),
      Failure() => emit(FarmError(message: result.message)),
    };
  }

  void _onUpdateFromNode(
      FarmUpdateFromNode event, Emitter<FarmState> emit) async {
    emit(FarmLoadedWsk(nodeDto: event.nodeDto));
  }

  // void _onUpdateFromClient(
  //     FarmUpdateFromClient event, Emitter<FarmState> emit) async {
  //   emit(FarmUpdateFromClient(fullFarm: event.fullFarm));
  // }

  void _onSendFarmData(SendFarmData event, Emitter<FarmState> emit) async {
    _webSocketManager.send(event.dataSend);
    // emit(FarmUpdateFromClient(fullFarm: event.farmDataToSend));
  }

  @override
  Future<void> close() {
    _webSocketManager.close();
    return super.close();
  }
}
