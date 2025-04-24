import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plot_twist/presentation/ui/home_screen.dart';
import 'state/api_service.dart';
import 'data/repositories/plot_twist_repository_impl.dart';
import 'domain/repositories/plot_twist_repository.dart';
import 'domain/usecases/generate_plot_twist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }

  final ApiService apiService = ApiService();
  final PlotTwistRepository repository = PlotTwistRepositoryImpl(apiService);
  final GeneratePlotTwist generatePlotTwist = GeneratePlotTwist(repository);

  runApp(PlotTwistApp(generatePlotTwist: generatePlotTwist));
}

class PlotTwistApp extends StatelessWidget {
  final GeneratePlotTwist generatePlotTwist;

  const PlotTwistApp({super.key, required this.generatePlotTwist});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlotTwist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}
