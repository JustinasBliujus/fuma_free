import 'package:flutter/material.dart';
import 'package:fuma_free/pages/app_pages/achievements/achievement_tile.dart';

class Achievements extends StatefulWidget {
  const Achievements({super.key});

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ProgressTile(title: "Achievement one", progress: 1),
          ProgressTile(title: "Achievement one", progress: 0.6),
          ProgressTile(title: "Achievement two", progress: 0.5),
          ProgressTile(title: "Achievement three", progress: 0.4),
          ProgressTile(title: "Achievement four", progress: 0.3),
          ProgressTile(title: "Achievement one", progress: 1),
          ProgressTile(title: "Achievement one", progress: 0.6),
          ProgressTile(title: "Achievement two", progress: 0.5),
          ProgressTile(title: "Achievement three", progress: 0.4),
          ProgressTile(title: "Achievement four", progress: 0.3),
          ProgressTile(title: "Achievement one", progress: 1),
          ProgressTile(title: "Achievement one", progress: 0.6),
          ProgressTile(title: "Achievement two", progress: 0.5),
          ProgressTile(title: "Achievement three", progress: 0.4),
          ProgressTile(title: "Achievement four", progress: 0.3),
        ],
      ),
    );
  }
}
