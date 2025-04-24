import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'state/app_state.dart';
import 'ui/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Load the .env file from assets
    await dotenv.load(fileName: ".env");
    debugPrint('Loaded .env file successfully.');
  } catch (e) {
    // It's common for dotenv to fail if the file is not found,
    // which might be expected in release builds if you don't include it.
    // Log the error but allow the app to continue.
    debugPrint('Error loading .env file: $e');
  }
  runApp(const PlotTwistApp());
}

class PlotTwistApp extends StatelessWidget {
  const PlotTwistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'PlotTwist',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
