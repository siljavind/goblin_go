import 'package:flutter/material.dart';
import 'package:goblin_go/features/shared/padded_card.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:provider/provider.dart';

import '../settings/settings_viewmodel.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final sVm = context.watch<SettingsViewModel>();
    final vm = context.watch<HomeViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    final progress = (vm.minutes / sVm.dailyGoal).clamp(0, 1).toDouble();
    final minutesLeft = sVm.dailyGoal - vm.minutes;
    final user = sVm.username.isNotEmpty ? sVm.username : 'Goblin';
    final titleImage = colorScheme.brightness == Brightness.dark
        ? 'assets/title_dark.png'
        : 'assets/title_light.png';

    final bottomText = minutesLeft > 0
        ? "Hey $user, $minutesLeft minutes left to loot today!"
        : "All done, $user - enjoy your peace!";

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(titleImage, height: 48),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ProgressWidget(bottomText: bottomText, progress: progress, colorScheme: colorScheme),
          const SizedBox(height: 12),
          StatCardsWidget(vm: vm),
        ],
      ),
    );
  }
}

class ProgressWidget extends StatelessWidget {
  const ProgressWidget({
    super.key,
    required this.bottomText,
    required this.progress,
    required this.colorScheme,
  });

  final String bottomText;
  final double progress;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    const double size = 250;
    return PaddedCard(
      title: 'Daily Progress',
      bigTitle: true,
      bottomText: bottomText,
      child: SizedBox(
        height: size,
        width: size,
        child: LiquidCircularProgressIndicator(
          value: progress,
          valueColor: AlwaysStoppedAnimation(colorScheme.primary),
          borderColor: colorScheme.primary,
          backgroundColor: colorScheme.surfaceContainer,
          borderWidth: 4.0,
          direction: Axis.vertical,
          center: Text(
            '${(progress * 100).toInt()} %',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
  }
}

class StatCardsWidget extends StatelessWidget {
  const StatCardsWidget({super.key, required this.vm});

  final HomeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PaddedCard(
              title: 'Total XP',
              bigTitle: true,
              child: Text(vm.xp.toString(), style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PaddedCard(
              title: 'Streak',
              bigTitle: true,
              child: Text(vm.streak.toString(), style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
        ),
      ],
    );
  }
}
