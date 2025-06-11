import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/padded_card.dart';
import 'settings_viewmodel.dart';

// TODO: Rework layout
// TODO: Slider label elsewhere
// TODO: Saving username
// TODO: Reset progress for the day if user changes daily goal?
// TODO: Add tests
// TODO: Refactor if there's time
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 80,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          PaddedCard(
            title: 'What would you want to be called?',
            child: TextField(
              controller: TextEditingController(text: vm.username),
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
              ),
              onSubmitted: (value) {
                final name = value.trim();
                if (name.isNotEmpty) vm.setUsername(name);
              },
            ),
          ),

          const SizedBox(height: 12),

          PaddedCard(
            title: 'What\'s your daily goal?',
            bottomText: '${vm.dailyGoal} minutes',
            child: Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(
                    context,
                  ).copyWith(trackHeight: 58, overlayShape: SliderComponentShape.noOverlay),
                  child: Slider(
                    value: vm.dailyGoal.clamp(5, 180).toDouble(),
                    min: 5,
                    max: 180,
                    divisions: (180 - 5) ~/ 5,
                    label: '${vm.dailyGoal} min',
                    onChanged: (newVal) => vm.setDailyGoal(newVal.toInt()),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          PaddedCard(
            title: 'What\'s your preferred theme?',
            child: SegmentedButton<ThemeMode>(
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
              onSelectionChanged: (newSelection) {
                final chosen = newSelection.first;
                vm.setThemeMode(chosen);
              },
              style: const ButtonStyle(
                visualDensity: VisualDensity(horizontal: 0.5, vertical: 3.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
