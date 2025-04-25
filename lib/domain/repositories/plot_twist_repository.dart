import '../../data/models/plot_twist_history_model.dart';

abstract class PlotTwistRepository {
  Future<String> generateContent(String inputText, String format);

  // History related methods
  Future<void> saveToHistory(
    String inputText,
    String generatedContent,
    String format,
  );
  Future<List<PlotTwistHistoryModel>> getHistoryItems();
  Future<void> deleteHistoryItem(String id);
  Future<void> clearAllHistory();
}
