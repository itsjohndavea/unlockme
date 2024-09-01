import 'package:flutter/material.dart';

class AdminContact extends StatelessWidget {
  const AdminContact({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Contact"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Theme.of(context).colorScheme.inversePrimary,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Contact Information",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Phone: +123 456 7890",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "Address: 123 Admin St, City, Country",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        "Follow Us",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.facebook),
                            color: Theme.of(context).colorScheme.onPrimary,
                            onPressed: () {
                              // Handle Facebook button press
                            },
                          ),
                          Text(
                            "johndoe@fb.me",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
                        indent: 10,
                        endIndent: 10,
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: Image.asset(
                          isDarkMode
                              ? 'assets/images/logolight.png'
                              : 'assets/images/logodark.png',
                          width: 80.0,
                          height: 80.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
