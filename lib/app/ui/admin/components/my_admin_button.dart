import 'package:flutter/material.dart';

class MyAdminButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyAdminButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.inversePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20, color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ));
  }
}
