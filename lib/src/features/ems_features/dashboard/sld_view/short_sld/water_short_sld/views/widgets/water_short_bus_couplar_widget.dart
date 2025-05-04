import 'package:flutter/material.dart';

class WaterShortBusCouplerWidget extends StatelessWidget {
  final String label;
  final double width, height;
  final bool status; // ✅ Ensure status is a boolean
  final String shape, sourceType;

  const WaterShortBusCouplerWidget({
    required this.label,
    required this.width,
    required this.height,
    required this.status, // ✅ Now explicitly expects a boolean
    required this.shape,
    required this.sourceType,
    required ValueKey<String> key,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('Building BusCoupler Widget for $label with Sensor Status: $status');

    String iconPath = _getIconPath();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: status ? Colors.lightGreen : Colors.red, width: 2), // ✅ Boolean check
      ),
      child: Center(
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Dynamically decide which icon to show based on the sensor status
  String _getIconPath() {
    switch (shape) {
    case "BusCoupler":
    return status ? 'assets/images/Group1000007881.png' : 'assets/images/switch.png';
    case "Loop":
    return status ? 'assets/images/SwitchOn90.png' : 'assets/images/SwitchOff90.png';
    default:
    return 'assets/images/default_icon.png';
    }
    }
}