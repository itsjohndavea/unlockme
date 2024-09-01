import 'package:flutter/material.dart';
import 'package:unlockme/app/ui/admin/components/my_admin_drawer.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                AssetImage(isDarkMode
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Admin!',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              isDarkMode
                  ? 'assets/images/logodark.png'
                  : 'assets/images/logolight.png',
              width: 80.0,
              height: 80.0,
            ),
          ],
        ),
      ),
    );
  }
}
