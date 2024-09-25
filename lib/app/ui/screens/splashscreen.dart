import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDarkMode
                  ? 'assets/images/logodark.png'
                  : 'assets/images/logolight.png',
              width: 100.0,
              height: 100.0,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
