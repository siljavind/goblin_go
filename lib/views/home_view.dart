import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goblin_go/view_models/location_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final Position? pos = context.watch<LocationViewModel>().latest;

    return Center(
      child: pos == null
          ? const CircularProgressIndicator()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Latitude  ${pos.latitude.toStringAsFixed(5)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Longitude ${pos.longitude.toStringAsFixed(5)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  'Timestamp ${pos.timestamp.toLocal().toIso8601String()}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 24),
                Text(
                  'TODO: replace with outdoor-minutes progress',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
    );
  }
}
