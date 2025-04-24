/// Abstract interface for fetching generated content.
/// Defines the contract for the data layer implementation.
abstract class ContentRepository {
  /// Generates creative content based on the input text and format.
  ///
  /// Throws an exception if content generation fails.
  Future<String> generateContent(String inputText, String format);
}
