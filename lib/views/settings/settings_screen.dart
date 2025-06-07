import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/settings_viewmodel.dart';
import '../settings/setting_card.dart';

// TODO: Rework layout
// TODO: Slider label elsewhere
// TODO: Saving username
// TODO: Reset progress for the day if user changes daily goal?
// TODO: Add tests
// TODO: Refactor if there's time
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
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SettingCard(
            child: vm.username.isEmpty
                ? Column(
                    children: [
                      const Text(
                        'What do you want to be called?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onSubmitted: (value) {
                          final name = value.trim();
                          if (name.isNotEmpty) {
                            vm.setUsername(name);
                          }
                        },
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hello ${vm.username}!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          vm.setUsername('');
                        },
                      ),
                    ],
                  ),
          ),

          const SizedBox(height: 12),

          SettingCard(
            child: Column(
              children: [
                const Text(
                  'What\'s your daily goal?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 40),
                  child: Slider(
                    value: vm.dailyGoal.clamp(5, 180).toDouble(),
                    min: 5,
                    max: 180,
                    divisions: (180 - 5) ~/ 5,
                    label: '${vm.dailyGoal} min',
                    onChanged: (newVal) => vm.setDailyGoal(newVal.toInt()),
                  ),
                ),
                Center(
                  child: Text(
                    '${vm.dailyGoal} minutes',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SettingCard(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How blinded do you want to be?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
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
                  onSelectionChanged: (newSelection) {
                    final chosen = newSelection.first;
                    vm.setThemeMode(chosen);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
