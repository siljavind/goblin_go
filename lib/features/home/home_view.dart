import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  //TODO Move ChangeNotifierProvider to app.dart
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/title_dark.png', height: 48),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 96,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress card
              _ProgressCard(progress: vm.progress, cs: cs),
              const SizedBox(height: 24),

              // XP / Streak cards
              Row(
                children: [
                  Expanded(
                    child: _MiniCard(label: 'XP', value: vm.xp.toString(), cs: cs),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _MiniCard(label: 'Streak', value: vm.streak.toString(), cs: cs),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.progress, required this.cs});
  final double progress;
  final ColorScheme cs;

  //TODO Use padded card widget
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 300,
    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Daily Progress', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          width: 180,
          child: LiquidCircularProgressIndicator(
            value: progress,
            valueColor: AlwaysStoppedAnimation(cs.primary),
            backgroundColor: cs.surfaceContainerHighest,
            borderColor: cs.primary,
            borderWidth: 4.0,
            direction: Axis.vertical,
            center: Text(
              '${(progress * 100).toInt()} %',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.label, required this.value, required this.cs});
  final String label;
  final String value;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Container(
    height: 120,
    decoration: BoxDecoration(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ],
    ),
  );
}

// import 'package:flutter/material.dart';
//
// class HomeView extends StatelessWidget {
//   const HomeView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     // Mock data for now (replace with real from ViewModel/repository later)
//     final String title = 'Goblin Go!';
//     final double progress = 0.65; // 65% progress
//     final int xp = 1200;
//     final int streak = 7;
//
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // App Title Card
//             Container(
//               width: double.infinity,
//               height: 64,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: colorScheme.surfaceContainerHighest,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Text(
//                 title,
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Daily Progress Bar Card
//             Container(
//               width: double.infinity,
//               height: 180,
//               decoration: BoxDecoration(
//                 color: colorScheme.surfaceContainerHighest,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               alignment: Alignment.center,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Daily Progress',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 16),
//                   // Placeholder for progress bar
//                   LinearProgressIndicator(
//                     value: progress,
//                     minHeight: 12,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   const SizedBox(height: 12),
//                   Text('${(progress * 100).toInt()}% complete'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Cards Row
//             Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: colorScheme.surfaceContainerHighest,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     alignment: Alignment.center,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'XP',
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '$xp',
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Container(
//                     height: 120,
//                     decoration: BoxDecoration(
//                       color: colorScheme.surfaceContainerHighest,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     alignment: Alignment.center,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Streak',
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '$streak days',
//                           style: Theme.of(context).textTheme.headlineSmall,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
