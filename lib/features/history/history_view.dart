import 'package:flutter/material.dart';
import 'package:goblin_go/features/history/watering_button.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import 'custom_button.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 80,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FacetedProgressButton(
              progress: 0.6,
              onPressed: () => print('tapped'),
            ),
            WateringCanProgressButton(progress: 0.6, onPressed: () => print('tapped'))
          ],
        ),
      ),
    );
  }
}
