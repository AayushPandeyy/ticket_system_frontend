import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketsystem/features/auth/presentation/provider/AuthProvider.dart';
import 'package:ticketsystem/features/auth/presentation/screens/LoginScreen.dart';

class OrganizerDashboard extends StatefulWidget {
  const OrganizerDashboard({super.key});

  @override
  State<OrganizerDashboard> createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends State<OrganizerDashboard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return SafeArea(
          child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Organizer Dashboard"),
              ElevatedButton(
                  onPressed: () async {
                    await provider.logout();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                      (route) => false, 
                    );
                  },
                  child: Text("Logout"))
            ],
          ),
        ),
      ));
    });
  }
}
