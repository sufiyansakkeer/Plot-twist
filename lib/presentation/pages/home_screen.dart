import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plot_twist/core/extension/sized_box_extension.dart';
import 'package:plot_twist/domain/repositories/plot_twist_repository.dart';
import 'package:share_plus/share_plus.dart';

import '../cubit/plot_twist_cubit.dart';

class HomeScreen extends StatelessWidget {
  final PlotTwistRepository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    // Provide the repository to the cubit
    return const _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlotTwistCubit, PlotTwistState?>(
      builder: (context, state) {
        final cubit = context.read<PlotTwistCubit>();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Write the plot twist",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              IconButton(
                                icon: const Icon(Icons.history),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/history');
                                },
                                tooltip: 'View History',
                              ),
                            ],
                          ),
                          20.height(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child:
                                state?.generatedContent.isNotEmpty == true
                                    ? _buildGeneratedContent(context, state!)
                                    : Text(
                                      'Generated content will appear here.',
                                      textAlign: TextAlign.center,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.height(),
                  // Format selection chips
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      ChoiceChip(
                        label: Text('Movie Script'),
                        selected: state?.selectedFormat == 'Movie Script',
                        onSelected: (isSelected) {
                          if (isSelected) {
                            cubit.updateFormat('Movie Script');
                          }
                        },
                        selectedColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      ChoiceChip(
                        label: Text('Rap Verse'),
                        selected: state?.selectedFormat == 'Rap Verse',
                        onSelected: (isSelected) {
                          if (isSelected) {
                            cubit.updateFormat('Rap Verse');
                          }
                        },
                        selectedColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      ChoiceChip(
                        label: Text('Shakespearean Monologue'),
                        selected:
                            state?.selectedFormat == 'Shakespearean Monologue',
                        onSelected: (isSelected) {
                          if (isSelected) {
                            cubit.updateFormat('Shakespearean Monologue');
                          }
                        },
                        selectedColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      ChoiceChip(
                        label: Text('Story'),
                        selected: state?.selectedFormat == 'Story',
                        onSelected: (isSelected) {
                          if (isSelected) {
                            cubit.updateFormat('Story');
                          }
                        },
                        selectedColor: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ],
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
                  10.height(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            minLines: 1,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Your real-life moment',
                              border: InputBorder.none,
                            ),
                            onChanged: cubit.updateInputText,
                            expands: false,
                          ),
                        ),
                        5.width(),
                        GestureDetector(
                          onTap:
                              state?.isLoading == true
                                  ? null
                                  : cubit.generateContent,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child:
                                state?.isLoading == true
                                    ? CupertinoActivityIndicator(
                                      color: Colors.white,
                                    )
                                    : Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.height(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneratedContent(BuildContext context, PlotTwistState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.generatedContent,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButton(
                    icon: Icons.copy,
                    label: 'Copy',
                    onTap:
                        () => _copyToClipboard(context, state.generatedContent),
                  ),
                  const SizedBox(width: 12),
                  _ActionButton(
                    icon: Icons.share,
                    label: 'Share',
                    onTap: () => _shareContent(context, state.generatedContent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Content copied to clipboard')),
    );
  }

  void _shareContent(BuildContext context, String content) {
    Share.share(content, subject: 'Check out this plot twist!');
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.blue[700]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
