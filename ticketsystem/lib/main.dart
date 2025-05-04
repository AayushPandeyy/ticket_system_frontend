import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ticketsystem/QRScannerPage.dart';
import 'package:ticketsystem/SplashScreen.dart';
import 'package:ticketsystem/core/service/SharedPreferenceService.dart';
import 'package:ticketsystem/features/auth/presentation/provider/AuthProvider.dart';
import 'package:ticketsystem/features/auth/presentation/screens/LoginScreen.dart';
import 'package:ticketsystem/features/eventOrganizer/data/datasource/OrganizerDataSoruce.dart';
import 'package:ticketsystem/features/eventOrganizer/data/repository_impl/OrganizerRepositoryImpl.dart';
import 'package:ticketsystem/features/eventOrganizer/domain/usecase/CreateEventUseCase.dart';
import 'package:ticketsystem/features/eventOrganizer/presentation/provider/OrganizerProvider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
         Provider<SharedPreferencesService>(
            create: (_) => SharedPreferencesService(),
          ),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProvider<OrganizerProvider>(
            create: (context) => OrganizerProvider(createEventUseCase: CreateEvent(organizerRepository: OrganizerRepositoryImpl(OrganizerDataSource()))),
          ),
      ],
      child: MaterialApp(
        title: 'QR Scanner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

