import 'package:flutter/material.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'package:fuma_free/assets/diary_constants.dart';

class DiaryEntryTile extends StatelessWidget {
  final Map<String, dynamic> entry;

  const DiaryEntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entry["date"], style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  entry["smoked"] == "Smoked" ? DiaryIcons.smokedTileIcon : DiaryIcons.controlledTileIcon,
                  color: entry["smoked"] == "Smoked" ? AppColors.failed : AppColors.achieved,
                ),
                SizedBox(width: 8),
                Text(entry["smoked"], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            Text(entry["activity"].toString()),
          ],
        ),
      ),
    );
  }
}