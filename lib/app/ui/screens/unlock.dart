import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlockme/app/core/bloc/padlock/padlock_cubit.dart';
import 'package:unlockme/app/core/bloc/padlock/padlock_state.dart';
import 'package:unlockme/app/core/services/firebase_service.dart';
import 'package:unlockme/app/ui/components/my_drawer.dart';
import 'package:unlockme/app/ui/screens/notifications.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;

class Unlock extends StatelessWidget {
  const Unlock({super.key});

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
      body: BlocBuilder<LockCubit, PadLockState>(
        builder: (context, state) {
          final lastUpdated = state.lastUpdated;
          final formattedDate = lastUpdated != null
              ? DateFormat('yyyy-MM-dd – kk:mm').format(lastUpdated.toDate())
              : 'N/A';

          return Column(
            children: [
              const SizedBox(height: 50),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showConfirmationDialog(context, state.isLocked);
                  },
                  child: Icon(
                    state.isLocked ? Icons.lock : Icons.lock_open_outlined,
                    size: 300.00,
                  ),
                ),
              ),
              const SizedBox(height: 20.00),
              Text.rich(
                TextSpan(
                  text: "Security Status: ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                  children: [
                    TextSpan(
                      text: state.isLocked ? "LOCKED" : "UNLOCKED",
                      style: TextStyle(
                        color: state.isLocked ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.00),
              Text(
                "Last Updated: $formattedDate",
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, bool isLocked) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isLocked ? "Unlock Device" : "Lock Device"),
          content: Text(
            isLocked
                ? "Are you sure you want to unlock the device?"
                : "Are you sure you want to lock the device?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Confirm"),
              onPressed: () {
                context.read<LockCubit>().toggleLockState();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
