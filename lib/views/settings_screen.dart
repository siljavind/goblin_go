import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/settings_viewmodel.dart';

//TODO Make it sound more goblin-y
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
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: vm.username.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'What should we call you?',
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
                            if (value.trim().isNotEmpty) {
                              vm.setUsername(value.trim());
                            }
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hello, ${vm.username}!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            //TODO Change functionality to not just clear the name
                            vm.setUsername('');
                          },
                        ),
                      ],
                    ),
            ),
          ),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column (
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            const Row(
            children: [
            Icon(Icons.timer, size: 28, color: Colors.green),
            SizedBox(width: 8),
            Text(
              'Daily Goal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ],
          ),
      const SizedBox(height: 12),

      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 12, // makes the track 12px tall
          activeTrackColor: Colors.green.shade600,
          inactiveTrackColor: Colors.grey.shade300,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          thumbColor: Colors.green.shade800,
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          overlayColor: Colors.green.withOpacity(0.2),
        ),
        child: Slider(
          value: vm.dailyGoalMinutes.toDouble().clamp(5.0, 180.0),
          min: 5,
          max: 180,
          divisions: (180 - 5) ~/ 5, // 35 steps (5,10,15,…,180)
          label: '${vm.dailyGoalMinutes} min',
          onChanged: (newVal) {
            // Round to nearest multiple of 5 just in case
            final rounded = (newVal / 5).round() * 5;
            vm.setDailyGoal(rounded);
          },
        ),
      ),
      const SizedBox(height: 8),
      Center(
        child: Text(
          '${vm.dailyGoalMinutes} minutes',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),


            )
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       // 1) Label for the spinning dial
      //       const Text(
      //         'Daily Goal:',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //       ),
      //       const SizedBox(height: 12),
      //
      //       // 2) The spinning dial itself
      //       Center(
      //         child: SpinningDialPicker(
      //           size: 200,                  // diameter in px
      //           initialValue: vm.dailyGoal,
      //           maxValue: 180,
      //           onChanged: (newVal) {
      //             vm.setDailyGoal(newVal);
      //           },
      //         ),
      //       ),
      //       Center(
      //         child: CircularGoalPicker(
      //           size: 200,                    // 200×200 px widget
      //           initialValue: vm.dailyGoal,
      //           maxValue: 180,
      //           onChanged: (newVal) {
      //             vm.setDailyGoal(newVal);
      //           },
      //         ),
      //       ),
      //       const SizedBox(height: 16),
      //
      //       // ❸ Show the numeric value below, too
      //       Center(
      //         child: Text(
      //           '${vm.dailyGoal} min',
      //           style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      //         ),
      //       ),
      //       // Text(
      //       //   'Daily Goal: ${vm.dailyGoal} minutes',
      //       //   style: const TextStyle(fontSize: 18),
      //       // ),
      //       // Slider(
      //       //   year2023: false,
      //       //   value: vm.dailyGoal.toDouble(),
      //       //   min: 0,
      //       //   max: 180,
      //       //   divisions: 18,
      //       //   label: '${vm.dailyGoal}',
      //       //   onChanged: (newValue) => vm.setDailyGoal(newValue.toInt()),
      //       // ),
      //       const SizedBox(height: 32),
      //
      //       // Theme selection: Light / Dark / System
      //       const Align(
      //         alignment: Alignment.center,
      //         child: Text(
      //           'Choose Theme Mode',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //       SegmentedButton<ThemeMode>(
      //         segments: const [
      //           ButtonSegment<ThemeMode>(
      //             value: ThemeMode.light,
      //             label: Text('Light'),
      //             icon: Icon(Icons.light_mode, size: 18),
      //           ),
      //           ButtonSegment<ThemeMode>(
      //             value: ThemeMode.dark,
      //             label: Text('Dark'),
      //             icon: Icon(Icons.dark_mode, size: 18),
      //           ),
      //           ButtonSegment<ThemeMode>(
      //             value: ThemeMode.system,
      //             label: Text('System'),
      //             icon: Icon(Icons.settings_brightness, size: 18),
      //           ),
      //         ],
      //         selected: {vm.themeMode},
      //         multiSelectionEnabled: false,
      //         onSelectionChanged: (Set<ThemeMode> newSelection) {
      //             final ThemeMode chosen = newSelection.first;
      //             vm.setThemeMode(chosen);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
