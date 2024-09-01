import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unlockme/app/core/services/notif_service.dart';
import 'package:unlockme/app/core/bloc/padlock/padlock_state.dart';

class LockCubit extends Cubit<PadLockState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService;
  final String _collection = dotenv.get('FIREBASE_COLLECTION');
  final String _document = dotenv.get('FIREBASE_DOCUMENT');
  final String _fieldLock = dotenv.get('FIREBASE_LOCKED');
  final String _timeUpdate = dotenv.get('FIREBASE_UPDATED');
  final String _notification = dotenv.get('FIREBASE_NOTIFICATION');
  final String _title = dotenv.get('FIREBASE_TITLE');
  final String _body = dotenv.get('FIREBASE_BODY');
  final String _notifyTime = dotenv.get('FIREBASE_TIMESTAMP');
  LockCubit(this._notificationService)
      : super(const PadLockState(isLocked: true)) {
    _initPadLock();
  }

  Future<void> _initPadLock() async {
    final doc = await _firestore.collection(_collection).doc(_document).get();
    final data = doc.data();
    final isLocked = data?[_fieldLock] ?? true;
    final lastUpdated = data?[_timeUpdate] as Timestamp?;

    emit(PadLockState(isLocked: isLocked, lastUpdated: lastUpdated));
  }

  Future<void> toggleLockState() async {
    final newLockState = !state.isLocked;
    final now = Timestamp.now(); // Get the current timestamp

    await _firestore.collection(_collection).doc(_document).update({
      _fieldLock: newLockState,
      _timeUpdate: now, // Update the timestamp in Firestore
    });

    emit(PadLockState(isLocked: newLockState, lastUpdated: now));

    // Send a notification with the lock state
    _notificationService.showNotification(
      title: "Security Status",
      body: newLockState
          ? "Device Security status is: LOCKED"
          : "Device Security status is: UNLOCKED",
    );

    // Save the lock/unlock state as a notification in Firestore
    await _firestore.collection(_notification).add({
      _title: "Security Status",
      _body: newLockState
          ? "Device Security status is: LOCKED"
          : "Device Security status is: UNLOCKED",
      _notifyTime: FieldValue.serverTimestamp(),
      _fieldLock: newLockState, // Include the lock state in the notification
    });
  }
}
