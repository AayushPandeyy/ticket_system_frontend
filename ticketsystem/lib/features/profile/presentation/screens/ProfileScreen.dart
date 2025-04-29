import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticketsystem/core/service/SharedPreferenceService.dart';
import 'package:ticketsystem/features/auth/presentation/screens/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
          child: Column(
        children: [
          QrImageView(
            data: "67f54938c7c124c73ef05bea",
            size: 200,
          ),
          ElevatedButton(onPressed: () async{
              await SharedPreferencesService.clearAllTokens();
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => const LoginScreen()));
          }, child: Text("Logout"))
        ],
      )),
    ));
  }
}
