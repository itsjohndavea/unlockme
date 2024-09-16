import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/core/model/usermodel.dart';
import 'package:unlockme/app/ui/admin/components/my_admin_button.dart';
import 'package:unlockme/app/ui/admin/components/my_admin_textfield.dart';

class UpdateUser extends StatefulWidget {
  final UserModel user;

  const UpdateUser({super.key, required this.user});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _mobileController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);
    _mobileController =
        TextEditingController(text: formatMobileNumber(widget.user.mobileNo));
  }

  String formatMobileNumber(String mobileNo) {
    if (mobileNo.startsWith('+63')) {
      return '0${mobileNo.substring(3)}';
    }
    return mobileNo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update User",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Text(
                " Email",
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
                isEnable: true, // Enable new email field
              ),
              const SizedBox(height: 8.0),
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
                isEnable: true, // Enable new password field
              ),
              const SizedBox(height: 8.0),
              Text(
                "Mobile Number",
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
                controller: _mobileController,
                isEnable: true,
              ),
              const SizedBox(height: 40.0),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyAdminButton(
                        onTap: updateUser,
                        text: "Update User",
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

  void updateUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authCubit = BlocProvider.of<AuthCubit>(context);

      // Get the new email and password
      final newEmail = _emailController.text.trim();
      final newPassword = _passwordController.text.trim();
      String newMobileNo = _mobileController.text.trim();
      if (newMobileNo.startsWith('0')) {
        newMobileNo = '+63${newMobileNo.substring(1)}';
      }

      //validate if the password the same no record updated

      final updatedUser = UserModel(
          id: widget.user.id,
          email: newEmail,
          password: newPassword,
          mobileNo: newMobileNo);

      // Update the user record in Firestore
      await authCubit.updateUserRecord(updatedUser);
      // Show success dialog
      showSuccessDialog();
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
      message: "User updated successfully.",
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
      title: "Warning",
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
