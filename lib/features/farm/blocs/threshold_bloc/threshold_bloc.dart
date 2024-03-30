import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_farm/features/farm/blocs/farm_bloc/farm_bloc.dart';
import 'package:vas_farm/features/farm/dtos/full_farm_dto.dart';

part 'threshold_event.dart';
part 'threshold_state.dart';

class ThresholdBloc extends Bloc<ThresholdEvent, ThresholdState> {
  ThresholdBloc() : super(ThresholdState(dataFull: datafullFarm)) {
    on<UpdateEvent>(_onUpdate);
    on<SwitchEvent>(_onSwitch);
    on<AdjustHighEvent>(_onAdjustHigh);
    on<AdjustLowEvent>(_onAdjustLow);
  }

  void _onUpdate(UpdateEvent event, Emitter<ThresholdState> emit) {
    emit(ThresholdState(dataFull: event.dataFull));
  }

  void _onSwitch(SwitchEvent event, Emitter<ThresholdState> emit) {
    final dataFull = event.dataFull;
    // late FullFarmDto newData;
    if (dataFull.modeSensor == "sensor_off") {
      // newData = dataFull.copyWith(infor: Infor.fromJson({
      //   "status": {
      //     "sensor": 1,
      //     "manual": 2,
      //     "auto": 2
      //   },
      // }),);
      dataFull.infor!.status!.sensor = 2;
      dataFull.infor!.status!.manual = 1;
      dataFull.infor!.status!.auto = 2;
      dataFull.modeSensor = "sensor_on";
    } else {
      dataFull.infor!.status!.sensor = 1;
      dataFull.infor!.status!.manual = 2;
      dataFull.infor!.status!.auto = 2;
      dataFull.modeSensor = "sensor_off";
    }
    // print(dataFull.toJson());
    emit(ThresholdState(dataFull: dataFull));
  }

  void _onAdjustHigh(AdjustHighEvent event, Emitter<ThresholdState> emit) {
    final dataFull = event.dataFull;
    dataFull.infor!.sensor!.high = event.value;
    emit(ThresholdState(dataFull: dataFull));
  }

  void _onAdjustLow(AdjustLowEvent event, Emitter<ThresholdState> emit) {
    final dataFull = event.dataFull;
    dataFull.infor!.sensor!.low = event.value;
    emit(ThresholdState(dataFull: dataFull));
  }
}
