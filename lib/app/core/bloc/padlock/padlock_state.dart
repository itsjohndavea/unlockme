import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PadLockState extends Equatable {
  final bool isLocked;
  final Timestamp? lastUpdated; // Add this property

  const PadLockState({required this.isLocked, this.lastUpdated});

  @override
  List<Object?> get props => [isLocked, lastUpdated];
}
