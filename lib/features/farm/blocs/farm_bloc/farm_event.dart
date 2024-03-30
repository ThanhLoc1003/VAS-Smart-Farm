part of 'farm_bloc.dart';

sealed class FarmEvent {}

class FarmStarted extends FarmEvent {}

class FarmUpdateFromNode extends FarmEvent {
  final NodeDto nodeDto;
  FarmUpdateFromNode({required this.nodeDto});
}

class FarmUpdateFromClient extends FarmEvent {
  final FullFarmDto fullFarm;
  FarmUpdateFromClient({required this.fullFarm});
}

class SendFarmData extends FarmEvent {
 final String dataSend;

  SendFarmData(this.dataSend);
}
