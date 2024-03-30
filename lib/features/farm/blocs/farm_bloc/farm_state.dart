part of 'farm_bloc.dart';

sealed class FarmState {}

final class FarmInitial extends FarmState {}

class FarmLoaded extends FarmState {
  final FullFarmDto fullFarm;
  FarmLoaded({required this.fullFarm});
}

class FarmLoading extends FarmState {}

class FarmError extends FarmState {
  final String message;
  FarmError({required this.message});
}

class FarmLoadedWsk extends FarmState {
  final NodeDto nodeDto;
  FarmLoadedWsk({required this.nodeDto});
}
