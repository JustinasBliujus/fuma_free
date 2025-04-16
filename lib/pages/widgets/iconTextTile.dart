import 'package:flutter/material.dart';

class IconTextTile extends StatelessWidget {
  final IconData icon;
  final String line1;
  final String line2;

  const IconTextTile({
    super.key,
    required this.icon,
    required this.line1,
    required this.line2,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 40.0, color: Colors.blue),
      title: Text(line1, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
      subtitle: Text(line2, style: TextStyle(fontSize: 16.0, color: Colors.grey)),
    );
  }
}