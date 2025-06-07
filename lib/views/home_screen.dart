import 'package:flutter/material.dart';
import 'package:goblin_go/view_models/location_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();

    Widget body;
    if (vm.error != null) {
      body = Center(child: Text('Error: ${vm.error}'));
    } else if (vm.currentPosition == null) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      final p = vm.currentPosition!;
      body = Center(
        child: Text(
          'Lat: ${p.latitude.toStringAsFixed(6)}\n'
          'Lng: ${p.longitude.toStringAsFixed(6)}\n'
          'Time: ${p.timestamp?.toLocal().toIso8601String() ?? '-'}',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Location')),
      body: body,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Home placeholder', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
