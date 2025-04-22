import 'package:flutter/material.dart';

class PlantSummaryScreen extends StatefulWidget {
  const PlantSummaryScreen({super.key});

  @override
  State<PlantSummaryScreen> createState() => _PlantSummaryScreenState();
}

class _PlantSummaryScreenState extends State<PlantSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: const Text('Summary View'),
              backgroundColor: Colors.lightGreenAccent,
              centerTitle: true,
            ),
            body: const Center(
              child: Text('This Is Plant Summary Page'),
            ),
     );
    }
}