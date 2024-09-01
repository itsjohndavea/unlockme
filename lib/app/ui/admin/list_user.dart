import 'package:flutter/material.dart';
import 'package:unlockme/app/core/model/usermodel.dart';
import 'package:unlockme/app/core/services/firebase_service.dart';
import 'update_user.dart';

class ListUsers extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  ListUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: firebaseService.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading users'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No users found'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        navigateToUpdateUser(context, user);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Prompt the user to confirm the deletion
                        showDeleteConfirmationDialog(context, user);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: Text("Are you sure you want to delete ${user.email}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Handle the delete action here
                try {
                  await firebaseService.deleteUser(user.email);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${user.email} deleted")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to delete user: $e")),
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

// Example of navigating to the UpdateUser screen from the list
void navigateToUpdateUser(BuildContext context, UserModel user) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => UpdateUser(
        user: user,
      ),
    ),
  );
}
