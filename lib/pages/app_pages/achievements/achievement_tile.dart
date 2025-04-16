import 'package:flutter/material.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'package:fuma_free/assets/achievements_constants.dart';

class ProgressTile extends StatelessWidget {
  final String title;
  final double progress;

  // Constructor to accept the title and progress value
  const ProgressTile({
    super.key,
    required this.title,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 8),
                if (progress == 1.0)
                  Icon(
                    AchievementIcons.completedIcon,
                    color: AppColors.achieved,
                    size: 24,
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
