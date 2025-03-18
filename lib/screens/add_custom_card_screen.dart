import 'package:flutter/material.dart';

class AddCustomCardScreen extends StatelessWidget {
  const AddCustomCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Custom Card'),
      ),
      body: const Center(
        child: Text('Add Custom Card Screen'),
      ),
    );
  }
}
