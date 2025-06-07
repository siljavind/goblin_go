import 'package:flutter/material.dart';
import 'package:goblin_go/view_models/location_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LocationViewModel>();
    final loc = vm.current;

    if (vm.error != null) {
      return Center(child: Text('Error: ${vm.error}'));
    }
    if (loc == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Live Location')),
      body: Text(
        'Lat: ${loc.latitude.toStringAsFixed(6)}\n'
        'Lng: ${loc.longitude.toStringAsFixed(6)}\n'
        'Time: ${DateTime.parse(loc.time as String)}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Home placeholder', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
