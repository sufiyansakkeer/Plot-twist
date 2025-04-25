import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:plot_twist/domain/usecases/generate_plot_twist.dart';

part 'plot_twist_state.dart';

class PlotTwistCubit extends Cubit<PlotTwistState> {
  final GeneratePlotTwist generatePlotTwist;

  PlotTwistCubit(this.generatePlotTwist) : super(const PlotTwistState());

  void updateFormat(String newFormat) {
    emit(
      state.copyWith(
        selectedFormat: newFormat,
        generatedContent: '',
        clearError: true,
      ),
    );
  }

  void updateInputText(String text) {
    emit(state.copyWith(inputText: text, clearError: true));
  }

  Future<void> generateContent() async {
    if (state.isLoading) return; // Prevent concurrent requests
    
    if (state.inputText.trim().isEmpty) {
      emit(state.copyWith(error: 'Please enter some text'));
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        generatedContent: '',
        clearError: true,
      ),
    );

    try {
      final content = await generatePlotTwist(
        state.inputText,
        state.selectedFormat,
      );
      emit(state.copyWith(isLoading: false, generatedContent: content));
    } catch (e) {
      debugPrint('Error in Cubit generateContent: $e');
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to generate content: ${e.toString()}',
        ),
      );
    }
  }
}
