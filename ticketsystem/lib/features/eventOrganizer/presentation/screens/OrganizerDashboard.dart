import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketsystem/QRScannerPage.dart';
import 'package:ticketsystem/features/auth/presentation/provider/AuthProvider.dart';
import 'package:ticketsystem/features/auth/presentation/screens/LoginScreen.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/screens/CreateEventScreen.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/widgets/EventCard.dart';

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Organizer Dashboard"),
                EventCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                  title: 'Flutter Developer Meetup 2025',
                  description:
                      'Join us for an exciting meetup where we\'ll discuss the latest Flutter updates, share best practices, and network with fellow developers.',
                  dateTime: DateTime(2025, 6, 15, 18, 30),
                  capacity: 120,
                  onScanQRPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRScannerPage()));
                  },
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateEventScreen()));
                    },
                    child: Text("Create Event")),
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
        ),
      ));
    });
  }
}
