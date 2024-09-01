import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/ui/admin/components/my_admin_button.dart';
import 'package:unlockme/app/ui/admin/components/my_admin_drawer.dart';
import 'package:unlockme/app/ui/admin/components/my_admin_textfield.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Unlocked Me",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: ImageIcon(
                AssetImage(Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/menudark.png'
                    : 'assets/images/menulight.png'),
                size: 30.00,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const MyAdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text(
                "Add User",
                style: TextStyle(
                    fontSize: 40.0,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1b1b1b)),
              ),
              const SizedBox(height: 20.0),
              Text(
                "Email",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1b1b1b)),
              ),
              const SizedBox(height: 8.0),
              MyAdminTextfield(
                hintText: "",
                isPassword: false,
                controller: _emailController,
                isEnable: true,
              ),
              const SizedBox(height: 16.0),
              Text(
                "Password",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1b1b1b)),
              ),
              const SizedBox(height: 8.0),
              MyAdminTextfield(
                hintText: "",
                isPassword: false,
                controller: _passwordController,
                isEnable: true,
              ),
              const SizedBox(height: 40.0),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: MyAdminButton(
                        onTap: clearFields,
                        text: "Clear",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyAdminButton(
                        onTap: addUser,
                        text: "Add User",
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void clearFields() {
    _emailController.clear();
    _passwordController.clear();
  }

  void addUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authCubit = BlocProvider.of<AuthCubit>(context);
      // Call Cloud Function to create user here
      await authCubit.createUserWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
      // Notify the admin
      showSuccessDialog();
      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSuccessDialog() {
    PanaraInfoDialog.show(
      context,
      title: "Success",
      message: "User added successfully.",
      buttonText: "Okay",
      textColor: Theme.of(context).colorScheme.primary,
      onTapDismiss: () {
        Navigator.pop(context);
      },
      color: Theme.of(context).colorScheme.inversePrimary,
      panaraDialogType: PanaraDialogType.success,
      barrierDismissible: false,
    );
  }

  void showErrorDialog(String message) {
    PanaraInfoDialog.show(
      context,
      title: "Error",
      message: message,
      buttonText: "Okay",
      textColor: Theme.of(context).colorScheme.primary,
      onTapDismiss: () {
        Navigator.pop(context);
      },
      color: Theme.of(context).colorScheme.inversePrimary,
      panaraDialogType: PanaraDialogType.error,
      barrierDismissible: false,
    );
  }
}
