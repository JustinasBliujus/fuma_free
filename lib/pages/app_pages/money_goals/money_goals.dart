import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuma_free/pages/app_pages/money_goals/goal.dart';
import 'package:fuma_free/pages/app_pages/money_goals/planCard.dart';
import 'package:fuma_free/assets/money_goals_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fuma_free/assets/calculations.dart';
import 'package:fuma_free/database_service.dart';

class MoneyGoals extends StatefulWidget {
  const MoneyGoals({super.key});

  @override
  State<MoneyGoals> createState() => _MoneyGoalsState();
}

class _MoneyGoalsState extends State<MoneyGoals> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final List<Map<String, dynamic>> _goals = [];
  Map<dynamic, dynamic> userData = {};
  double moneySaved = 0;
  DateTime? lastSmoke;
  DateTime? initiationDate;
  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  void _loadGoals() async {
    final ref = FirebaseDatabase.instance.ref('userGoals');
    final snapshot = await ref.get();
    DataSnapshot? snapshott = await DatabaseService().read(path: 'userData');

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      userData = jsonDecode(snapshott?.value as String);
      setState(() {
        lastSmoke = DateTime.tryParse(userData['lastSmoke']);
        if (userData['initiationDate'] != null) {
          initiationDate = DateTime.tryParse(userData['initiationDate']);
        }
        moneySaved = calculateCurrentMoneySaved(
          lastSmoke!,
          userData['cigsPerDay'],
          userData['costPerPack'],
          userData['cigsPerPack'],
          initiationDate!,
          userData['relapseTimes'],
        );
        _goals.clear();
        data.forEach((key, value) {
          _goals.add({
            'key': key,
            'goal': Goal(
              title: value['title'] ?? '',
              textLine: value['amount'] ?? '',
            ),
          });
        });
      });
    }
  }

  void _showAddGoalDialog() {
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
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(labelText: MoneyGoalsStrings.placeholder_2),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary),
                foregroundColor: WidgetStateProperty.all<Color>(AppColors.textSecondary),
              ),
              onPressed: () async {
                final title = titleController.text.trim();
                final amount = amountController.text.trim();

                if (title.isNotEmpty && amount.isNotEmpty) {
                  try {
                    final goalRef = FirebaseDatabase.instance.ref().child('userGoals').push();
                    await goalRef.set({
                      'title': title,
                      'amount': amount,
                    });

                    setState(() {
                      _goals.add({
                        'key': goalRef.key,
                        'goal': Goal(title: title, textLine: amount),
                      });
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Goal saved to Firebase!")),
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error saving goal: $e")),
                    );
                  }
                }
              },
              child: const Text(MoneyGoalsStrings.addButton),
            ),
          ],
        );
      },
    );
  }

  void _deleteGoal(String key, int index) async {
    try {
      await FirebaseDatabase.instance.ref('userGoals/$key').remove();

      setState(() {
        _goals.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Goal deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: $e")),
      );
    }
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
          Text(
            "${MoneyGoalsStrings.headline} ${moneySaved.toStringAsFixed(2)} money",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                final goalMap = entry.value;
                final key = goalMap['key'];
                final goal = goalMap['goal'] as Goal;

                final goalAmount = double.tryParse(goal.textLine);
                final progressValue = (goalAmount != null && goalAmount > 0)
                    ? (moneySaved / goalAmount).clamp(0.0, 1.0)
                    : 0.0;

                return PlanCard(
                  title: goal.title,
                  textLine: "${goal.textLine} money",
                  progressValue: progressValue,
                  onDelete: () => _deleteGoal(key, index),
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
                final goalMap = entry.value;
                final key = goalMap['key'];
                final goal = goalMap['goal'] as Goal;

                final goalAmount = double.tryParse(goal.textLine);
                final progressValue = (goalAmount != null && goalAmount > 0)
                    ? (moneySaved / goalAmount).clamp(0.0, 1.0)
                    : 0.0;

                return PlanCard(
                  title: goal.title,
                  textLine: "${goal.textLine} money",
                  progressValue: progressValue,
                  onDelete: () => _deleteGoal(key, index),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
