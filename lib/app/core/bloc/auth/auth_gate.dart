import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/ui/admin/admin.dart';
import 'package:unlockme/app/ui/screens/home.dart';
import 'package:unlockme/app/ui/screens/login.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state) {
            case AuthState.admin:
              return const Admin(); // Your admin interface screen
            case AuthState.signedIn:
              return const Home(); // Regular user home screen
            case AuthState.signedOut:
              return const Login(); // Login screen
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
