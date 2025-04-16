import 'package:flutter/material.dart';
import 'package:fuma_free/pages/app_pages/progress/timer_widget.dart';
import 'package:fuma_free/pages/widgets/widgets.dart';
import 'package:fuma_free/pages/data.dart';
import 'package:fuma_free/assets/progress_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';

class PortraitLayout extends StatefulWidget {
  const PortraitLayout({super.key});

  @override
  State<PortraitLayout> createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {
  late Data userData;

  @override
  void initState() {
    super.initState();

    userData = Data(
      startedSmoking: DateTime(2020, 1, 1),
      costPerPack: 5.0,
      cigsPerDay: 20,
      amountPerPack: 20,
      lastSmoke: DateTime.now().subtract(Duration(days: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: screenHeight * 0.15,
          child: Center(child: const TimerWidget(fontSize: 25,)),
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
                line1: userData.calculateCigsAvoided().toString(),
                line2: ProgressStrings.quarter_1,
              ),
            ),
            Flexible(
              child: IconTextWidget(
                icon: ProgressIcons.quarterIcon_2,
                line1: userData.calculateMoneySaved().toString(),
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
              onPressed: () => {},
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
                line1: userData.getFormattedLifeExpectancyImproved().toString(),
                line2: ProgressStrings.quarter_3,
              ),
            ),
            Flexible(
              child: IconTextWidget(
                icon: ProgressIcons.quarterIcon_4,
                line1: userData.calculateTimeTillRecordWithoutSmokingFormatted().toString(),
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
                  line1: "500",
                  line2: ProgressStrings.statistic_1,
                ),
                IconTextTile(
                  icon: ProgressIcons.statisticIcon_2,
                  line1: "2656 euros",
                  line2: ProgressStrings.statistic_2,
                ),
                IconTextTile(
                  icon: ProgressIcons.statisticIcon_3,
                  line1: "5 days",
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