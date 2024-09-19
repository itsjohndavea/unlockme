import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/battery/battery_state.dart';
import 'package:unlockme/app/core/services/notif_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BatteryCubit extends Cubit<BatteryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService;
  final String _batteryField = dotenv.get('FIREBASE_BATTERY_STATUS');
  final String _collection = dotenv.get('FIREBASE_COLLECTION');
  final String _document = dotenv.get('FIREBASE_DOCUMENT');
  final String _fieldLock = dotenv.get('FIREBASE_LOCKED');
  final String _notification = dotenv.get('FIREBASE_NOTIFICATION');
  final String _title = dotenv.get('FIREBASE_TITLE');
  final String _body = dotenv.get('FIREBASE_BODY');
  final String _notifyTime = dotenv.get('FIREBASE_TIMESTAMP');
  BatteryCubit(this._notificationService)
      : super(const BatteryState(batteryStatus: 100)) {
    _initBatteryListener();
  }

  void _initBatteryListener() {
    _firestore
        .collection(_collection)
        .doc(_document) 
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        final batteryStatus = data[_batteryField] as int;
        _checkAndNotify(batteryStatus);
        emit(BatteryState(batteryStatus: batteryStatus));
      }
    });
  }

  void _checkAndNotify(int batteryStatus) {
    // Notify at specific battery levels
    if ([100, 90, 80, 70, 60, 50, 40, 30, 10, 5, 0].contains(batteryStatus)) {
      _notificationService.showNotification(
        title: "Battery Status",
        body: "Device battery status is: $batteryStatus%.",
      );

      // Save the battery status as a notification in Firestore
      _firestore.collection(_notification).add({
        _title: "Battery Status",
        _body: "Battery is at $batteryStatus%.",
        _notifyTime: FieldValue.serverTimestamp(),
        _fieldLock: null, // Not applicable for battery status
      });
    }
  }
}
