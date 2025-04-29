import 'package:hive/hive.dart';

part 'plot_twist_history_model.g.dart';

@HiveType(typeId: 0)
class PlotTwistHistoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String inputText;

  @HiveField(2)
  final String generatedContent;

  @HiveField(3)
  final String format;

  @HiveField(4)
  final DateTime createdAt;

  PlotTwistHistoryModel({
    required this.id,
    required this.inputText,
    required this.generatedContent,
    required this.format,
    required this.createdAt,
  });
}
