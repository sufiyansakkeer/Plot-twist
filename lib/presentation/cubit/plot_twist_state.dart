part of 'plot_twist_cubit.dart';

class PlotTwistState extends Equatable {
  final bool isLoading;
  final String generatedContent;
  final String? error;
  final String selectedFormat;
  final String inputText; // Keep track of input text in state if needed by UI

  const PlotTwistState({
    this.isLoading = false,
    this.generatedContent = '',
    this.error,
    this.selectedFormat = 'Movie Script', // Default format
    this.inputText = '',
  });

  // Helper method to create a copy with updated values
  PlotTwistState copyWith({
    bool? isLoading,
    String? generatedContent,
    String? error,
    bool clearError = false, // Flag to explicitly clear error
    String? selectedFormat,
    String? inputText,
  }) {
    return PlotTwistState(
      isLoading: isLoading ?? this.isLoading,
      generatedContent: generatedContent ?? this.generatedContent,
      error: clearError ? null : error ?? this.error,
      selectedFormat: selectedFormat ?? this.selectedFormat,
      inputText: inputText ?? this.inputText,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    generatedContent,
    error,
    selectedFormat,
    inputText,
  ];
}
