import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plot_twist/features/plot_twist/data/models/plot_twist_history_model.dart';

class HiveInit {
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register adapters
    Hive.registerAdapter(PlotTwistHistoryModelAdapter());
  }
}
