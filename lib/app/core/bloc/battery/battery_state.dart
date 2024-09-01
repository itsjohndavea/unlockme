import 'package:equatable/equatable.dart';

class BatteryState extends Equatable {
  final int batteryStatus;

  const BatteryState({required this.batteryStatus});

  @override
  List<Object?> get props => [batteryStatus];
}
