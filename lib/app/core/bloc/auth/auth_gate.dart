import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/ui/admin/admin.dart';
import 'package:unlockme/app/ui/screens/home.dart';
import 'package:unlockme/app/ui/screens/login.dart';
import 'package:unlockme/app/ui/screens/splashscreen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  AuthGateState createState() => AuthGateState();
}

class AuthGateState extends State<AuthGate> {
  bool _isSplashVisible = true;

  @override
  void initState() {
    super.initState();
    _startSplashScreenTimer();
  }

  void _startSplashScreenTimer() async {
    // Add a delay of 2 seconds to show the SplashScreen
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isSplashVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isSplashVisible
        ? const SplashScreen() // Show SplashScreen initially
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              switch (state) {
                case AuthState.initial:
                  return const SplashScreen(); // Still show the SplashScreen if it's in the initial state
                case AuthState.admin:
                  return const Admin();
                case AuthState.signedIn:
                  return const Home();
                case AuthState.signedOut:
                  return const Login();
                default:
                  return const SplashScreen();
              }
            },
          );
  }
}
