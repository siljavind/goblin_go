import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
        centerTitle: true,
        elevation: 2,
        toolbarHeight: 80,
      ),
      body: const Center(child: Text('History placeholder', style: TextStyle(fontSize: 18))),
    );
  }
}
