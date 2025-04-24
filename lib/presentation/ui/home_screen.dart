import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc

import '../../state/api_service.dart';
import '../cubit/plot_twist_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlotTwistCubit(ApiService()),
      child: BlocBuilder<PlotTwistCubit, PlotTwistState?>(
        builder: (context, state) {
          final cubit = context.read<PlotTwistCubit>();

          return Scaffold(
            appBar: AppBar(title: const Text('PlotTwist (Bloc)')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            state?.generatedContent.isEmpty == true
                                ? 'Generated content will appear here.'
                                : state?.generatedContent ?? '',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: state?.selectedFormat ?? 'Movie Script',
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'Movie Script',
                        child: Text('Movie Script'),
                      ),
                      DropdownMenuItem(
                        value: 'Rap Verse',
                        child: Text('Rap Verse'),
                      ),
                      DropdownMenuItem(
                        value: 'Shakespearean Monologue',
                        child: Text('Shakespearean Monologue'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        cubit.updateFormat(value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        state?.isLoading == true ? null : cubit.generateContent,
                    child:
                        state?.isLoading == true
                            ? const CircularProgressIndicator(strokeWidth: 2)
                            : const Text('Generate'),
                  ),
                  if (state?.error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      state!.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Your real-life moment',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: cubit.updateInputText,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
