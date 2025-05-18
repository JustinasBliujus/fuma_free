import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fuma_free/pages/app_pages/achievements/achievement_tile.dart';
import 'package:fuma_free/assets/achievements_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'package:fuma_free/database_service.dart';

class Achievements extends StatefulWidget {
  const Achievements({super.key});

  @override
  State<Achievements> createState() => _AchievementsState();
}

class _AchievementsState extends State<Achievements> {
  DateTime? lastSmoke;
  bool isLoading = true;
  Map<dynamic, dynamic> data = {};

  final List<Map<String, dynamic>> _milestones = [
    {"title": AchievementStrings.achieve_1, "duration": Duration(hours: 1)},
    {"title": AchievementStrings.achieve_2, "duration": Duration(hours: 12)},
    {"title": AchievementStrings.achieve_3, "duration": Duration(days: 1)},
    {"title": AchievementStrings.achieve_4, "duration": Duration(days: 3)},
    {"title": AchievementStrings.achieve_5, "duration": Duration(days: 7)},
    {"title": AchievementStrings.achieve_6, "duration": Duration(days: 30)},
    {"title": AchievementStrings.achieve_7, "duration": Duration(days: 90)},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserSettings();
  }

  Future<void> fetchUserSettings() async {
    DataSnapshot? snapshot = await DatabaseService().read(path: 'userData');
    if (snapshot?.value != null) {
      data = jsonDecode(snapshot?.value as String);
    }
    if (data['lastSmoke'] != null) {
      lastSmoke = DateTime.tryParse(data['lastSmoke']);
    }
    setState(() {
      isLoading = false; // Update loading state
    });
  }


  double _calculateProgress(Duration sinceLastSmoke, Duration milestoneDuration) {
    double progress = sinceLastSmoke.inSeconds / milestoneDuration.inSeconds;
    return progress.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : lastSmoke == null
          ? const Center(child: Text("Error loading data."))
          : ListView.builder(
        itemCount: _milestones.length,
        itemBuilder: (context, index) {
          final milestone = _milestones[index];
          final timeSinceLastSmoke = DateTime.now().difference(lastSmoke!);
          final progress = _calculateProgress(timeSinceLastSmoke, milestone["duration"]);

          return ProgressTile(
            title: milestone["title"],
            progress: progress,
          );
        },
      ),
    );
  }
}
