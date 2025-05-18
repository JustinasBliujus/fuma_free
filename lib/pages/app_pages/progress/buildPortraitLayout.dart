import 'package:flutter/material.dart';
import 'package:fuma_free/pages/app_pages/progress/timer_widget.dart';
import 'package:fuma_free/pages/widgets/widgets.dart';
import 'package:fuma_free/assets/progress_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'dart:convert';
import 'package:fuma_free/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fuma_free/assets/calculations.dart';

class PortraitLayout extends StatefulWidget {
  const PortraitLayout({super.key});

  @override
  State<PortraitLayout> createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {
  Map<dynamic, dynamic> data = {};
  double cigsAvoided = 0;
  double moneySaved = 0;
  Duration lifeExpectancyImproved = Duration();
  DateTime leftTillRecord = DateTime(0);
  DateTime? startDate;
  DateTime? lastSmoke;
  double totalCigsSmoked = 0;
  double totalMoneySpent = 0;
  Duration totalLifetimeLost = Duration();
  late int millisecondsPassed;
  int recordInMilliseconds = 0;
  bool _dataLoaded = false;
  DateTime? initiationDate;
  int relapseTimes = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  Future<void> updateLastSmoke() async {
    DataSnapshot? snapshot = await DatabaseService().read(path: 'userData');
    if (snapshot?.value != null) {
      data = jsonDecode(snapshot?.value as String);
      if (data['lastSmoke'] != null) {
        lastSmoke = DateTime.tryParse(data['lastSmoke']);
      }
      if (data['recordInMilliseconds'] != null) {
        recordInMilliseconds = data['recordInMilliseconds'];
      }
      if (data['initiationDate'] != null) {
        initiationDate = DateTime.tryParse(data['initiationDate']);
      }
      if (lastSmoke != null) {
        Duration durationSinceLastSmoke = DateTime.now().difference(lastSmoke!);
        recordInMilliseconds = data['recordInMilliseconds'];
        if (Duration(milliseconds: recordInMilliseconds) < durationSinceLastSmoke) {
          data['recordInMilliseconds'] = durationSinceLastSmoke.inMilliseconds;
        }
      }
      int temp = int.parse(data['relapseTimes'].toString());
      temp++;
      data['relapseTimes'] = temp++;
      data['lastSmoke'] = DateTime.now().toIso8601String();
      final jsonString = jsonEncode(data);
      await DatabaseService().create(path: 'userData', data:jsonString,
      );
      setState(() {
        millisecondsPassed = 0;
        _loadData();
      });
    }
  }

  void _loadData() async {
    DataSnapshot? snapshot = await DatabaseService().read(path: 'userData');
    if (snapshot?.value != null) {
      data = jsonDecode(snapshot?.value as String);
      setState(() {
        if (data['startDate'] != null) {
          startDate = DateTime.tryParse(data['startDate']);
        }
        if (data['lastSmoke'] != null) {
          lastSmoke = DateTime.tryParse(data['lastSmoke']);
          Duration durationSinceLastSmoke = DateTime.now().difference(lastSmoke!);
          recordInMilliseconds = data['recordInMilliseconds'];
          if (Duration(milliseconds: recordInMilliseconds) < durationSinceLastSmoke) {
            data['recordInMilliseconds'] = durationSinceLastSmoke.inMilliseconds;
          }
        }
        if (data['recordInMilliseconds'] != null) {
          recordInMilliseconds = data['recordInMilliseconds'];
        }
        if (data['initiationDate'] != null) {
          initiationDate = DateTime.tryParse(data['initiationDate']);
        }
        totalCigsSmoked = calculateCigarettesSmokedSince(startDate!,data['cigsPerDay'],initiationDate!,data['relapseTimes']);
        totalMoneySpent = calculateTotalMoneySpent(startDate!,data['cigsPerDay'],data['costPerPack'],data['cigsPerPack'],initiationDate!,data['relapseTimes']);
        totalLifetimeLost = calculateTotalLifetimeLost(startDate!,data['cigsPerDay'],data['costPerPack'],data['cigsPerPack'],initiationDate!,data['relapseTimes']);
        cigsAvoided = calculateCurrentCigarettesAvoided(lastSmoke!,data['cigsPerDay'],initiationDate!,data['relapseTimes']);
        moneySaved = calculateCurrentMoneySaved(lastSmoke!,data['cigsPerDay'],data['costPerPack'],data['cigsPerPack'],initiationDate!,data['relapseTimes']);
        lifeExpectancyImproved = calculateCurrentLifetimeSaved(lastSmoke!,data['cigsPerDay'],data['costPerPack'],data['cigsPerPack'],initiationDate!,data['relapseTimes']);
        millisecondsPassed = getMillisecondsSinceLastSmoke(lastSmoke!);
        _dataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: Center(
            child: _dataLoaded
                ? TimerWidget(
              key: ValueKey(millisecondsPassed),
              fontSize: 40,
              millisecondsPassed: millisecondsPassed,
            )
                : const CircularProgressIndicator(),
          ),
        ),
        Divider(
          height: 30,
          color: AppColors.primary,
          indent: 30,
          endIndent: 30,
          thickness: 3,
        ),
        Row(
          children: [
            Flexible(
              child: IconTextWidget(
                icon: ProgressIcons.quarterIcon_1,
                line1: cigsAvoided.toStringAsFixed(0),
                line2: ProgressStrings.quarter_1,
              ),
            ),
            Flexible(
              child: IconTextWidget(
                icon: ProgressIcons.quarterIcon_2,
                line1: moneySaved.toStringAsFixed(2),
                line2: ProgressStrings.quarter_2,
              ),
            ),
          ],
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: IconButton(
              focusColor: AppColors.textPrimary,
              onPressed: () => {
                updateLastSmoke()
              },
              icon: const Icon(
                ProgressIcons.resetIcon,
                size: 35,
              ),
            ),
          ),
        ),
        Row(
          children: [
            Flexible(
              child: IconTextWidget(
                icon: ProgressIcons.quarterIcon_3,
                line1: "Time Saved: ${lifeExpectancyImproved.inDays.toString()}d"
                    " ${(lifeExpectancyImproved.inHours % 24).toString()}h"
                    " ${(lifeExpectancyImproved.inMinutes % 60).toString()}m",
                line2: ProgressStrings.quarter_3,
              ),
            ),
            Flexible(
              child: IconTextWidget(
                icon: ProgressIcons.quarterIcon_4,
                line1: "Record: ${(Duration(milliseconds: recordInMilliseconds).inDays)}d"
                    " ${(Duration(milliseconds: recordInMilliseconds).inHours % 24)}h"
                    " ${(Duration(milliseconds: recordInMilliseconds).inMinutes % 60)}m",
                line2: ProgressStrings.quarter_4,
              ),
            ),
          ],
        ),
        Divider(
          height: 30,
          color: AppColors.primary,
          indent: 30,
          endIndent: 30,
          thickness: 3,
        ),
        Text(ProgressStrings.explanation_1),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                IconTextTile(
                  icon: ProgressIcons.statisticIcon_1,
                  line1: totalCigsSmoked.toStringAsFixed(0),
                  line2: ProgressStrings.statistic_1,
                ),
                IconTextTile(
                  icon: ProgressIcons.statisticIcon_2,
                  line1: totalMoneySpent.toStringAsFixed(2),
                  line2: ProgressStrings.statistic_2,
                ),
                IconTextTile(
                  icon: ProgressIcons.statisticIcon_3,
                  line1: "Time lost: ${totalLifetimeLost.inDays.toString()}d"
                      " ${(totalLifetimeLost.inHours % 24).toString()}h"
                      " ${(totalLifetimeLost.inMinutes % 60).toString()}m",
                  line2: ProgressStrings.statistic_3,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
