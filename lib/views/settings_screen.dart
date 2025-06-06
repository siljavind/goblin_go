import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/settings_viewmodel.dart';

import 'circular_goal_picker.dart';
import 'spinning_dial_picker.dart';
import 'custom_circular_slider.dart';



class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1) Label for the spinning dial
            const Text(
              'Daily Goal:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // 2) The spinning dial itself
            Center(
              child: SpinningDialPicker(
                size: 200,                  // diameter in px
                initialValue: vm.dailyGoal,
                maxValue: 180,
                onChanged: (newVal) {
                  vm.setDailyGoal(newVal);
                },
              ),
            ),
            Center(
              child: CircularGoalPicker(
                size: 200,                    // 200×200 px widget
                initialValue: vm.dailyGoal,
                maxValue: 180,
                onChanged: (newVal) {
                  vm.setDailyGoal(newVal);
                },
              ),
            ),
            const SizedBox(height: 16),

            // ❸ Show the numeric value below, too
            Center(
              child: Text(
                '${vm.dailyGoal} min',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
            ),
            // Text(
            //   'Daily Goal: ${vm.dailyGoal} minutes',
            //   style: const TextStyle(fontSize: 18),
            // ),
            // Slider(
            //   year2023: false,
            //   value: vm.dailyGoal.toDouble(),
            //   min: 0,
            //   max: 180,
            //   divisions: 18,
            //   label: '${vm.dailyGoal}',
            //   onChanged: (newValue) => vm.setDailyGoal(newValue.toInt()),
            // ),
            const SizedBox(height: 32),

            // Theme selection: Light / Dark / System
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Choose Theme Mode',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  label: Text('Light'),
                  icon: Icon(Icons.light_mode, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  label: Text('Dark'),
                  icon: Icon(Icons.dark_mode, size: 18),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.system,
                  label: Text('System'),
                  icon: Icon(Icons.settings_brightness, size: 18),
                ),
              ],
              selected: {vm.themeMode},
              multiSelectionEnabled: false,
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                  final ThemeMode chosen = newSelection.first;
                  vm.setThemeMode(chosen);
              },
            ),
          ],
        ),
      ),
    );
  }
}