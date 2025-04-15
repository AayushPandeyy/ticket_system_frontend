import 'package:flutter/material.dart';
import 'package:ticketsystem/features/profile/presentation/screens/ProfileScreen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  static final _pages = [
    ProfileScreen(),
    ProfileScreen(),
    ProfileScreen(),
  ];
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                currentPage = index;
              });
            },
            currentIndex: currentPage,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xff0d7414),
            selectedLabelStyle: TextStyle(color: Color(0xff0d7414)),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
        body: _pages[currentPage],
      ),
    );
  }
}
