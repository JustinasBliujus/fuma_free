import 'package:flutter/material.dart';

class IconTextWidget extends StatelessWidget {
  final IconData icon;
  final String line1;
  final String line2;

  const IconTextWidget({
    super.key,
    required this.icon,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36.0, color: Colors.blue),
          SizedBox(height: 8.0),
          Text(line1, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
          Text(line2, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
        ],
      ),
    );
  }
}
