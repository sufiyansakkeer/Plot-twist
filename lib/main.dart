import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math';
import 'package:plot_twist/presentation/cubit/plot_twist_cubit.dart';
import 'package:plot_twist/presentation/ui/home_screen.dart';
import 'data/repositories/plot_twist_repository_impl.dart';
import 'domain/repositories/plot_twist_repository.dart';
import 'domain/usecases/generate_plot_twist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('Environment variables loaded successfully');
    
    // Verify API key is present and valid
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      debugPrint('API key found: ${apiKey.substring(0, min(5, apiKey.length))}...');
    } else {
      debugPrint('Warning: API_KEY not found or empty in .env file');
    }
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    // Continue without environment variables - app should handle missing values gracefully
  }

  final PlotTwistRepository repository = PlotTwistRepositoryImpl();
  final GeneratePlotTwist generatePlotTwist = GeneratePlotTwist(repository);

  runApp(PlotTwistApp(generatePlotTwist: generatePlotTwist));
}

class PlotTwistApp extends StatelessWidget {
  final GeneratePlotTwist generatePlotTwist;

  const PlotTwistApp({super.key, required this.generatePlotTwist});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlotTwistCubit(generatePlotTwist),
      child: MaterialApp(
        title: 'PlotTwist',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          chipTheme: Theme.of(context).chipTheme.copyWith(
            selectedColor: Colors.lightBlue.shade200,
            backgroundColor: Colors.grey.shade100,
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
