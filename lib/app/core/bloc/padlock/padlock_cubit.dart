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
    _listenToPadLockChanges();
  }

  Future<void> _initPadLock() async {
    final doc = await _firestore.collection(_collection).doc(_document).get();
    final data = doc.data();
    final isLocked = data?[_fieldLock] ?? true;
    final lastUpdated = data?[_timeUpdate] as Timestamp?;

    emit(PadLockState(isLocked: isLocked, lastUpdated: lastUpdated));
  }

  void _listenToPadLockChanges() {
    _firestore
        .collection(_collection)
        .doc(_document)
        .snapshots()
        .listen((snapshot) async {
      final data = snapshot.data();
      final isLocked = data?[_fieldLock] ?? true;
      final lastUpdated = data?[_timeUpdate] as Timestamp?;

      // Emit the new state
      emit(PadLockState(isLocked: isLocked, lastUpdated: lastUpdated));

      // Trigger local notification based on lock state change
      _notificationService.showNotification(
        title: "Security Status",
        body: isLocked
            ? "Device Security status is: LOCKED"
            : "Device Security status is: UNLOCKED",
      );

      // Add notification entry to Firestore 'notifications' collection
      await _firestore.collection(_notification).add({
        _title: "Security Status", // Notification title
        _body: isLocked
            ? "Device Security status is: LOCKED" // Notification body
            : "Device Security status is: UNLOCKED",
        _notifyTime: FieldValue.serverTimestamp(), // Firestore server timestamp
        _fieldLock:
            isLocked, // Store the lock state in the notification document
      });
    });
  }

  Future<void> toggleLockState() async {
    final newLockState = !state.isLocked;
    final now = Timestamp.now();

    await _firestore.collection(_collection).doc(_document).update({
      _fieldLock: newLockState,
      _timeUpdate: now,
    });

    emit(PadLockState(isLocked: newLockState, lastUpdated: now));
  }
}
