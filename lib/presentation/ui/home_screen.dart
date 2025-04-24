import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:plot_twist/core/extension/sizedbox_extension.dart';

import '../cubit/plot_twist_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  Text(
                    "Write the plot twist",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  20.height(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        child: Text(
                          state?.generatedContent.isEmpty == true
                              ? 'Generated content will appear here.'
                              : state?.generatedContent ?? '',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  20.height(),
                  Wrap(
                    spacing: 8.0,
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
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
}
