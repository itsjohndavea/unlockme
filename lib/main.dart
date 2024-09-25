import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unlockme/app/core/bloc/auth/auth_gate.dart';
import 'package:unlockme/app/core/bloc/battery/battery_cubit.dart';
import 'package:unlockme/app/core/services/firebase_service.dart';
import 'package:unlockme/app/core/bloc/padlock/padlock_cubit.dart';
import 'package:unlockme/app/core/bloc/notification/notif_cubit.dart';
import 'package:unlockme/app/core/services/notif_service.dart';
import 'package:unlockme/app/ui/admin/admin.dart';
import 'package:unlockme/app/ui/screens/home.dart';
import 'package:unlockme/app/ui/screens/login.dart';
import 'package:unlockme/app/ui/screens/splashscreen.dart';
import 'package:unlockme/app/ui/theme/theme.dart';
import 'package:unlockme/firebase_options.dart';
import 'package:unlockme/app/core/bloc/auth/auth_cubit.dart';
import 'package:unlockme/app/core/bloc/theme/theme_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init();
  await FirebaseService().initNotifications();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(FirebaseAuth.instance, FirebaseFirestore.instance),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => BatteryCubit(NotificationService()),
        ),
        BlocProvider(
          create: (context) => LockCubit(NotificationService()),
        ),
        BlocProvider(create: (context) => NotificationCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeMode = themeState == ThemeState.dark
              ? ThemeMode.dark
              : (themeState == ThemeState.light
                  ? ThemeMode.light
                  : ThemeMode.system);

          return MaterialApp(
            title: 'Unlocked Me',
            debugShowCheckedModeBanner: false,
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: themeMode,
            routes: {
              '/home': (context) => const Home(),
              '/login': (context) => const Login(),
              '/admin': (context) => const Admin(),
              '/splashscreen': (context) => const SplashScreen(),
              // other routes
            },
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
