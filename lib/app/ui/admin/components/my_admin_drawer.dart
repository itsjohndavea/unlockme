import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/ui/admin/add_user.dart';
import 'package:unlockme/app/ui/admin/list_user.dart';
import 'package:unlockme/app/ui/screens/login.dart';

class MyAdminDrawer extends StatelessWidget {
  const MyAdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          DrawerHeader(
            child: Center(
              child: Image(
                width: 100,
                image: AssetImage(isDarkMode
                    ? 'assets/images/logodark.png'
                    : 'assets/images/logolight.png'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('ADD USERS'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddUser(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('U S E R S'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListUsers(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('L O G O U T'),
            onTap: () {
              _showLogoutConfirmationDialog(context, authCubit);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(
      BuildContext context, AuthCubit authCubit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await authCubit.signOut();
                  // Navigate to the login screen after signing out
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                  );
                } catch (e) {
                  // Handle any errors that occur during sign out
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sign out failed: ${e.toString()}')),
                  );
                }
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }
}
