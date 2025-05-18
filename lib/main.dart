import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fuma_free/firebase_options.dart';
import 'package:fuma_free/pages/app_pages/progress/progress.dart';
import 'package:fuma_free/pages/app_pages/money_goals/money_goals.dart';
import 'package:fuma_free/pages/app_pages/diary/diary.dart';
import 'package:fuma_free/pages/app_pages/achievements/achievements.dart';
import 'package:fuma_free/pages/growing_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fuma_free/pages/widgets/appbar.dart';
import 'package:fuma_free/assets/navigation_bar_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'package:fuma_free/assets/achievements_constants.dart';
import 'package:fuma_free/assets/diary_constants.dart';
import 'package:fuma_free/assets/money_goals_constants.dart';
import 'package:fuma_free/assets/progress_constants.dart';
import 'package:fuma_free/assets/button_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 2;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();

  final screens = [
    Diary(),
    MoneyGoals(),
    Progress(),
    Achievements(),
    GrowingButton(),
  ];
  final List<String> pageTitles = [
    DiaryStrings.title,
    MoneyGoalsStrings.title,
    ProgressStrings.title,
    AchievementStrings.title,
    ButtonStrings.title,
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(title: pageTitles[index],),
        body: screens[index],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: IconThemeData(color: AppColors.textSecondary),
          ),
          child: CurvedNavigationBar(
            key: navigationKey,
            animationDuration: Duration(milliseconds: 350),
            backgroundColor: Colors.transparent,
            color: AppColors.primary,
            index: index,
            height: 60,
            onTap: (index) => {
              setState(() {
                this.index = index;
              })
            },
            items: <Widget>[
              Icon(NavigationBarIcons.diaryPageIcon, size: 30,),
              Icon(NavigationBarIcons.moneyGoalsPageIcon, size: 30,),
              Icon(NavigationBarIcons.progressPageIcon, size: 30,),
              Icon(NavigationBarIcons.achievementsPageIcon, size: 30,),
              Icon(NavigationBarIcons.buttonPageIcon, size: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
