import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:unlockme/app/core/services/firebase_service.dart';
import 'package:unlockme/app/ui/components/my_cardnotification.dart'; // Import the MyCardnotification widget

class Notifications extends StatelessWidget {
  final FirebaseService _firebaseService = FirebaseService();

  Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseService.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications available"));
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              Timestamp? timestamp = data['timestamp'];
              bool isLocked = data['isLocked'] ?? true;
              String formattedDate = timestamp != null
                  ? DateFormat('yyyy-MM-dd – hh:mm a')
                      .format(timestamp.toDate())
                  : "N/A";

              return MyCardnotification(
                title: data['title'] ?? "No Title",
                description: data['body'] ?? "No Description",
                isLocked: isLocked,
                timestamp: formattedDate,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
