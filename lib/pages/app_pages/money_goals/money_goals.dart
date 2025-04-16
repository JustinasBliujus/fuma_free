import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuma_free/pages/app_pages/money_goals/goal.dart';
import 'package:fuma_free/pages/app_pages/money_goals/planCard.dart';
import 'package:fuma_free/assets/money_goals_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';

class MoneyGoals extends StatefulWidget {
  const MoneyGoals({super.key});

  @override
  State<MoneyGoals> createState() => _MoneyGoalsState();
}

class _MoneyGoalsState extends State<MoneyGoals> {
  final List<Goal> _goals = [
    Goal(title: "Goal 1", textLine: "textlineone", progressValue: 1),
    Goal(title: "Goal 2", textLine: "textlinetwo", progressValue: 0.6),
    Goal(title: "Goal 3", textLine: "textlinethree", progressValue: 0.3),
    Goal(title: "Goal 4", textLine: "textlinefour", progressValue: 0.7),
  ];

  void _showAddGoalDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      barrierColor: AppColors.primary.withOpacity(0.2),
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(MoneyGoalsStrings.popupTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: MoneyGoalsStrings.placeholder_1),
              ),
              TextField(
                controller: descController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(labelText: MoneyGoalsStrings.placeholder_2),
              )
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary),
                foregroundColor: WidgetStateProperty.all<Color>(AppColors.textSecondary),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                final desc = descController.text.trim();
                if (title.isNotEmpty && desc.isNotEmpty) {
                  setState(() {
                    _goals.add(Goal(
                      title: title,
                      textLine: desc,
                      progressValue: 0,
                    ));
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text(MoneyGoalsStrings.addButton),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.textSecondary,
        backgroundColor: AppColors.primary,
        onPressed: _showAddGoalDialog,
        child: const Icon(MoneyGoalsIcons.addButtonIcon),
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            MoneyGoalsStrings.headline,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(
            height: 30,
            color: AppColors.primary,
            indent: 35,
            endIndent: 35,
            thickness: 3,
          ),
          Expanded(
            child: isPortrait
                ? ListView(
              children: _goals.asMap().entries.map((entry) {
                final index = entry.key;
                final goal = entry.value;
                return PlanCard(
                  title: goal.title,
                  textLine: goal.textLine,
                  progressValue: goal.progressValue,
                  onDelete: () {
                    setState(() {
                      _goals.removeAt(index);
                    });
                  },
                );
              }).toList(),
            )
                : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 2,
              children: _goals.asMap().entries.map((entry) {
                final index = entry.key;
                final goal = entry.value;
                return PlanCard(
                  title: goal.title,
                  textLine: goal.textLine,
                  progressValue: goal.progressValue,
                  onDelete: () {
                    setState(() {
                      _goals.removeAt(index);
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
