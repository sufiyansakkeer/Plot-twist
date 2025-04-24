import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('PlotTwist')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Your real-life moment',
                border: OutlineInputBorder(),
              ),
              onChanged: appState.updateInputText,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: appState.selectedFormat,
              items: const [
                DropdownMenuItem(
                  value: 'Movie Script',
                  child: Text('Movie Script'),
                ),
                DropdownMenuItem(value: 'Rap Verse', child: Text('Rap Verse')),
                DropdownMenuItem(
                  value: 'Shakespearean Monologue',
                  child: Text('Shakespearean Monologue'),
                ),
              ],
              onChanged:
                  (String? value) => appState.updateSelectedFormat(value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: appState.isLoading ? null : appState.generateOutput,
              child:
                  appState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Generate'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(appState.outputText),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
