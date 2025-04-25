import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plot_twist/domain/usecases/generate_plot_twist.dart';
import 'package:plot_twist/presentation/cubit/plot_twist_cubit.dart';
import 'dart:math';
import 'package:plot_twist/presentation/pages/home_screen.dart';
import 'package:plot_twist/presentation/pages/history_page.dart';
import 'package:plot_twist/data/repositories/plot_twist_repository_impl.dart';
import 'package:plot_twist/domain/repositories/plot_twist_repository.dart';
import 'package:plot_twist/core/init/hive_init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveInit.init();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
    debugPrint('Environment variables loaded successfully');

    // Verify API key is present and valid
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey != null && apiKey.isNotEmpty) {
      debugPrint(
        'API key found: ${apiKey.substring(0, min(5, apiKey.length))}...',
      );
    } else {
      debugPrint('Warning: API_KEY not found or empty in .env file');
    }
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    // Continue without environment variables - app should handle missing values gracefully
  }

  runApp(const PlotTwistApp());
}

class PlotTwistApp extends StatelessWidget {
  const PlotTwistApp({super.key});

  @override
  Widget build(BuildContext context) {
    final PlotTwistRepository repository = PlotTwistRepositoryImpl();
    final GeneratePlotTwist generator = GeneratePlotTwist(repository);

    return BlocProvider(
      create: (context) => PlotTwistCubit(generator),
      child: MaterialApp(
        title: 'PlotTwist',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
          chipTheme: Theme.of(context).chipTheme.copyWith(
            selectedColor: Colors.lightBlue.shade200,
            backgroundColor: Colors.grey.shade100,
            labelStyle: const TextStyle(color: Colors.black),
          ),
        ),
        home: HomeScreen(repository: repository),
        routes: {'/history': (context) => HistoryPage(repository: repository)},
      ),
    );
  }
}
