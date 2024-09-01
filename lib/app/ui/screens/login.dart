import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/ui/screens/admin_contact.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:unlockme/app/ui/components/my_button.dart';
import 'package:unlockme/app/ui/components/my_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  int _failedAttempts = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state == AuthState.signedIn) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state == AuthState.admin) {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (state == AuthState.signedOut) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50.0),
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1b1b1b)),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminContact()),
                          );
                        },
                        child: const Text(
                          "Contact now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Username",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : const Color(0xFF1b1b1b)),
                  ),
                  const SizedBox(height: 8.0),
                  MyTextfield(
                    hintText: "",
                    isPassword: false,
                    controller: _usernameController,
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
                  MyTextfield(
                    hintText: "",
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 40.0),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    MyButton(onTap: login, text: "Login"),
                  const SizedBox(height: 130.0),
                  Center(
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'assets/images/logodark.png'
                          : 'assets/images/logolight.png',
                      width: 80.0,
                      height: 80.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });

    final authCubit = BlocProvider.of<AuthCubit>(context);
    try {
      await authCubit.signInWithEmailPassword(
        _usernameController.text,
        _passwordController.text,
      );
    } catch (e) {
      setState(() {
        _failedAttempts++;
        _isLoading = false;
      });

      if (_failedAttempts >= 5) {
        showWarningDialog();
      } else {
        showErrorDialog(e.toString());
      }
    } finally {
      // Ensure _isLoading is set to false in both cases
      if (_failedAttempts < 5) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  void showWarningDialog() {
    PanaraConfirmDialog.show(
      context,
      title: "Warning!",
      message:
          "You’ve entered the wrong username and password multiple times. Do you want to contact the admin for the correct account? Press Yes to proceed to the admin contact information screen.",
      confirmButtonText: "Yes",
      cancelButtonText: "No",
      textColor: Theme.of(context).colorScheme.primary,
      onTapCancel: () {
        Navigator.pop(context);
      },
      onTapConfirm: () {
        Navigator.pop(context);
        setState(() {
          _failedAttempts = 0;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdminContact(),
          ),
        );
      },
      color: Theme.of(context).colorScheme.inversePrimary,
      panaraDialogType: PanaraDialogType.warning,
      barrierDismissible: false,
    );
  }
}
