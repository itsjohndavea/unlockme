import 'package:flutter/material.dart';

class MyAdminTextfield extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final bool isEnable;
  const MyAdminTextfield({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.isEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: TextField(
        enabled: isEnable,
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.tertiary,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
