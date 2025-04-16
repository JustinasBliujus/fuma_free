import 'package:flutter/material.dart';
import 'package:fuma_free/pages/app_pages/progress/buildPortraitLayout.dart';
import 'package:fuma_free/pages/app_pages/progress/buildLandscapeLayout.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: isPortrait ? const PortraitLayout() : const LandscapeLayout(),
    );
  }
}
