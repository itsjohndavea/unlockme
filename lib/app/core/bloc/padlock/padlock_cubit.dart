import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
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

  bool _isUpdatingFirestore = false;

  LockCubit(this._notificationService)
      : super(const PadLockState(isLocked: true)) {
    _initPadLock();
    _listenToPadLockChanges();
  }

  Future<void> _initPadLock() async {
    try {
      final doc = await _firestore.collection(_collection).doc(_document).get();
      if (doc.exists) {
        final data = doc.data();
        final isLocked = data?[_fieldLock] ?? true;
        final lastUpdated = data?[_timeUpdate] as Timestamp?;
        emit(PadLockState(isLocked: isLocked, lastUpdated: lastUpdated));
      } else {
        throw 'Document $_document not found in collection $_collection.';
      }
    } catch (e) {
      throw 'Error initializing padlock state: $e';
    }
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

  /// Toggles the lock state and updates Firestore
  Future<void> toggleLockState() async {
    try {
      final newLockState = !state.isLocked;
      final now = Timestamp.now();
      _isUpdatingFirestore = true;

      await _firestore.collection(_collection).doc(_document).update({
        _fieldLock: newLockState,
        _timeUpdate: now,
      });

      emit(PadLockState(isLocked: newLockState, lastUpdated: now));

      // If the device is unlocked, schedule it to re-lock after 5 seconds
      if (!newLockState) {
        Future.delayed(const Duration(seconds: 5), () async {
          // Update Firestore with the new lock state (locked) after the delay
          await _firestore.collection(_collection).doc(_document).update({
            _fieldLock: true,
            _timeUpdate: Timestamp.now(),
          });

          // Emit the new locked state
          emit(PadLockState(isLocked: true, lastUpdated: Timestamp.now()));

          // Send notification for locking
          _notificationService.showNotification(
            title: "Security Status",
            body: "Device Security status is: LOCKED",
          );

          // Reset the feedback prevention flag
          _isUpdatingFirestore = false;
        });
      } else {
        // Reset the feedback prevention flag immediately when locking
        _isUpdatingFirestore = false;
      }
    } catch (e) {
      throw 'Error toggling lock state: $e';
    }
  }
}
