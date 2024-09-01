import 'package:flutter/material.dart';

class MyCardnotification extends StatelessWidget {
  final String title;
  final String description;
  final bool isLocked;
  final String timestamp;

  const MyCardnotification({
    super.key,
    required this.title,
    required this.description,
    required this.isLocked,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 8.0),
            if (title == "Security Status") ...[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Device Security status is: ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16.0),
                    ),
                    TextSpan(
                      text: isLocked ? "LOCKED" : "UNLOCKED",
                      style: TextStyle(
                        color: isLocked ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    TextSpan(
                      text: ".",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ] else if (title == "Battery Status") ...[
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 16.0,
                ),
              ),
            ],
            const SizedBox(height: 8.0),
            Text(
              'Last Updated: $timestamp',
              style: const TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
