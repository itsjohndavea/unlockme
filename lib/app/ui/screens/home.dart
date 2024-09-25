import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:unlockme/app/core/bloc/battery/battery_cubit.dart';
// import 'package:unlockme/app/core/bloc/battery/battery_state.dart';
import 'package:unlockme/app/core/services/firebase_service.dart';
import 'package:unlockme/app/ui/components/my_drawer.dart';
import 'package:unlockme/app/ui/screens/notifications.dart';
import 'package:badges/badges.dart' as badges;

class Home extends StatelessWidget {
  const Home({super.key});

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
        actions: [
          StreamBuilder<int>(
            stream: FirebaseService().getNotificationCount(),
            builder: (context, snapshot) {
              int notificationCount = snapshot.data ?? 0;

              return badges.Badge(
                badgeContent: Text(
                  notificationCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                showBadge: notificationCount > 0,
                badgeAnimation: const badges.BadgeAnimation.fade(
                  animationDuration: Duration(seconds: 1),
                  colorChangeAnimationDuration: Duration(seconds: 1),
                  loopAnimation: false,
                ),
                position: badges.BadgePosition.topEnd(top: 0, end: 3),
                child: IconButton(
                  icon: ImageIcon(
                    AssetImage(isDarkMode
                        ? 'assets/images/notifdark.png'
                        : 'assets/images/notiflight.png'),
                    size: 30.00,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Notifications(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to UNLOCK ME.',
              style: TextStyle(
                  fontSize: 25,
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
        // body: BlocBuilder<BatteryCubit, BatteryState>(
        //   builder: (context, state) {
        //     final batteryPercent = state.batteryStatus;

        //     return Column(
        //       children: [
        //         const SizedBox(height: 50),
        //         Center(
        //           child: CircularPercentIndicator(
        //             radius: 120.0,
        //             lineWidth: 30.0,
        //             animation: true,
        //             percent: batteryPercent / 100,
        //             center: Text(
        //               "${batteryPercent.toStringAsFixed(0)}%",
        //               style: const TextStyle(
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 30.0,
        //               ),
        //             ),
        //             circularStrokeCap: CircularStrokeCap.round,
        //             progressColor: Theme.of(context).colorScheme.inversePrimary,
        //           ),
        //         ),
        //         const SizedBox(height: 20.0),
        //         const Text(
        //           "Battery Status",
        //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        //         ),
        //         const SizedBox(height: 20.0),
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }
}
