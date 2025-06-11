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
    final settingsVm = context.watch<SettingsViewModel>();
    final vm = context.watch<HomeViewModel>();
    final cs = Theme.of(context).colorScheme;
    final titleImage = cs.brightness == Brightness.dark
        ? 'assets/title_dark.png'
        : 'assets/title_light.png';

    final progress = (vm.minutes / settingsVm.dailyGoal).clamp(0, 1).toDouble();
    final minutesLeft = settingsVm.dailyGoal - vm.minutes;

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
          Expanded(
            child: PaddedCard(
              title: 'Daily Progress',
              bigTitle: true,
              bottomText: minutesLeft > 0
                  ? '$minutesLeft minutes until daily goal is reached!'
                  : 'Daily goal reached!',
              child: SizedBox(
                height: 250,
                width: 250,
                child: LiquidCircularProgressIndicator(
                  value: progress,
                  valueColor: AlwaysStoppedAnimation(cs.primary),
                  borderColor: cs.primary,
                  borderWidth: 4.0,
                  direction: Axis.vertical,
                  center: Text(
                    '${(progress * 100).toInt()} %',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PaddedCard(
                    title: 'Total XP',
                    bigTitle: true,
                    child: Text(vm.xp.toString(), style: Theme.of(context).textTheme.displayMedium),
                  ),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PaddedCard(
                    title: 'Streak',
                    bigTitle: true,
                    child: Text(
                      vm.streak.toString(),
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
