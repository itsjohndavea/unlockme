import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:unlockme/app/core/model/usermodel.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseService() {
    _initializeLocalNotifications();
    deleteOldNotifications();
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse response) async {},
    );
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    const sound = 'notification_sound.mp3';
    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        ),
      ),
      payload: message.data.toString(),
    );

    // Save notification to Firestore
    await _saveNotificationToFirestore(message);
  }

  Future<void> _saveNotificationToFirestore(RemoteMessage message) async {
    await _firestore.collection('notifications').add({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Stream<QuerySnapshot> getNotifications() {
    return _firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getBatteryStatus() {
    return _firestore
        .collection('device')
        .doc('WuEC8rfVaZLOuSrp8p33')
        .snapshots();
  }

  Stream<int> getNotificationCount() {
    return _firestore
        .collection('notifications')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> deleteOldNotifications() async {
    // Define the cutoff time (3 days ago)
    final cutoffTime = DateTime.now().subtract(const Duration(days: 3)).toUtc();

    // Query for notifications older than the cutoff time
    final query = _firestore
        .collection('notifications')
        .where('timestamp', isLessThan: cutoffTime);

    final snapshots = await query.get();
    for (final doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<UserModel>> getUsers() {
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs
          .where((doc) =>
              doc.id != currentUserUid &&
              !doc['email'].contains(
                  'admin')) // Exclude users with email containing 'admin'
          .map((doc) {
        return UserModel(
          id: doc.id,
          email: doc['email'] ?? 'No Name',
          password: doc['password'] ?? 'No Password',
        );
      }).toList();
    });
  }

  // Method to delete a user by ID
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();
    } catch (e) {
      throw 'Failed to delete user: $e';
    }
  }
}
