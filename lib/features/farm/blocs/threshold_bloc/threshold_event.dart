part of 'threshold_bloc.dart';

sealed class ThresholdEvent {}

class UpdateEvent extends ThresholdEvent {
  final FullFarmDto dataFull;
  UpdateEvent({required this.dataFull});
}
class SwitchEvent extends ThresholdEvent {
  final FullFarmDto dataFull;
  SwitchEvent({required this.dataFull});
}

class AdjustHighEvent extends ThresholdEvent {
  final FullFarmDto dataFull;
  final int value;
  AdjustHighEvent({required this.dataFull, required this.value});
}

class AdjustLowEvent extends ThresholdEvent {
  final FullFarmDto dataFull;
  final int value;
  AdjustLowEvent({required this.dataFull, required this.value});
}
