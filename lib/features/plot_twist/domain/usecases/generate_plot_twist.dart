import '../repositories/plot_twist_repository.dart';

class GeneratePlotTwist {
  final PlotTwistRepository repository;

  GeneratePlotTwist(this.repository);

  Future<String> call(String inputText, String format) {
    return repository.generateContent(inputText, format);
  }
}
