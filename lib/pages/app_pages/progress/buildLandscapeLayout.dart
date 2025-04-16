import 'package:flutter/material.dart';
import 'package:fuma_free/pages/app_pages/progress/timer_widget.dart';
import 'package:fuma_free/pages/widgets/widgets.dart';
import 'package:fuma_free/assets/progress_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';

class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
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

                        },
                        icon: const Icon(
                          ProgressIcons.resetIcon,
                          size: 35,
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    const TimerWidget(fontSize: 40,),
                  ],
                ),
              ),
              Divider(
                height: 3,
                color: AppColors.primary,
                indent: 30,
                endIndent: 30,
                thickness: 3,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      IconTextTile(
                        icon: ProgressIcons.quarterIcon_1,
                        line1: "250",
                        line2: ProgressStrings.quarter_1,
                      ),
                      IconTextTile(
                        icon: ProgressIcons.quarterIcon_2,
                        line1: "3520",
                        line2: ProgressStrings.quarter_2,
                      ),
                      IconTextTile(
                        icon: ProgressIcons.quarterIcon_3,
                        line1: "5 min",
                        line2: ProgressStrings.quarter_3,
                      ),
                      IconTextTile(
                        icon: ProgressIcons.quarterIcon_4,
                        line1: "5 days",
                        line2: ProgressStrings.quarter_4,
                      ),
                    ],
                  ),
                ),
              ),
                ],
              ),
        ),
        VerticalDivider(
          width: 30,
          color: AppColors.primary,
          indent: 30,
          endIndent: 30,
          thickness: 3,
        ),
        Expanded(
          child: Column(
            children: [
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
          ),
        ),
      ],
    );
  }
}
