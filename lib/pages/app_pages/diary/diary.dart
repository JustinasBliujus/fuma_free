import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fuma_free/pages/app_pages/diary/diaryEntryTile.dart';
import 'package:fuma_free/pages/app_pages/diary/smoking_graph.dart';
import 'package:fuma_free/assets/diary_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';

class Diary extends StatefulWidget {
  const Diary({super.key});

  @override
  State<Diary> createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  List<String> activityOptions = [
    "Working", "At a Bar", "After a Meal", "With Friends", "Stressed", "Chilling"
  ];

  // Now each entry is a map that includes a Firebase key
  List<Map<String, dynamic>> diaryEntries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final ref = FirebaseDatabase.instance.ref('userDiary');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        diaryEntries = data.entries.map((entry) {
          final val = entry.value as Map<dynamic, dynamic>;
          return {
            'key': entry.key,
            'date': val['date'],
            'smoked': val['smoked'],
            'activity': val['activity'],
            'notes': val['notes'],
          };
        }).toList();
        // Optional: Sort by newest
        diaryEntries.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));
      });
    }
  }

  Future<void> _addEntry(Map<String, dynamic> entryData) async {
    try {
      final ref = FirebaseDatabase.instance.ref().child('userDiary').push();
      final dateStr = DateFormat('yyyy-MM-dd – HH:mm').format(DateTime.now());

      final entry = {
        'date': dateStr,
        'smoked': entryData['smoked'],
        'activity': entryData['activity'],
        'notes': entryData['notes'],
      };

      await ref.set(entry);

      setState(() {
        diaryEntries.insert(0, {
          'key': ref.key,
          ...entry,
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving diary entry: $e")),
      );
    }
  }

  Future<void> _deleteEntry(String key, int index) async {
    try {
      await FirebaseDatabase.instance.ref('userDiary/$key').remove();
      setState(() {
        diaryEntries.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entry deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting entry: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: AppColors.textSecondary,
        backgroundColor: AppColors.primary,
        onPressed: () => _displayInputDialog(context),
        child: Icon(DiaryIcons.addButtonIcon),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SmokingGraph(entries: diaryEntries),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 5,
            child: diaryEntries.isEmpty
                ? Center(child: Text(DiaryStrings.noEntriesText))
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: diaryEntries.length,
              itemBuilder: (context, index) {
                final entry = diaryEntries[index];
                return Dismissible(
                  key: Key(entry['key']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteEntry(entry['key'], index),
                  child: DiaryEntryTile(entry: entry),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _displayInputDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();
    List<bool> isSelected = [true, false];
    String selectedActivity = "";

    final result = await showDialog<Map<String, dynamic>>(
      barrierColor: AppColors.primary.withOpacity(0.2),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(DiaryStrings.headline),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ToggleButtons(
                      isSelected: isSelected,
                      selectedColor: AppColors.textSecondary,
                      fillColor: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      borderWidth: 2,
                      onPressed: (index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        });
                      },
                      children: [
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(DiaryStrings.buttonOption_1)),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(DiaryStrings.buttonOption_2)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(DiaryStrings.question_1),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: activityOptions.map((activity) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              selectedColor: AppColors.primary,
                              checkmarkColor: AppColors.textSecondary,
                              label: Text(
                                activity,
                                style: TextStyle(
                                  color: selectedActivity == activity
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                              ),
                              selected: selectedActivity == activity,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) selectedActivity = activity;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: textFieldController,
                      decoration: InputDecoration(
                        labelText: DiaryStrings.placeholder,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    WidgetStateProperty.all<Color>(AppColors.primary),
                    foregroundColor:
                    WidgetStateProperty.all<Color>(AppColors.textSecondary),
                  ),
                  child: Text(DiaryStrings.okButton),
                  onPressed: () {
                    String newActivity = textFieldController.text.trim();
                    if (newActivity.isNotEmpty &&
                        !activityOptions.contains(newActivity)) {
                      setState(() {
                        activityOptions.add(newActivity);
                        selectedActivity = newActivity;
                      });
                    }

                    Navigator.pop(context, {
                      "smoked": isSelected[0] ? "Smoked" : "Controlled",
                      "activity": selectedActivity,
                      "notes": newActivity.isNotEmpty ? newActivity : null,
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null && result["activity"] != null && result["activity"].isNotEmpty) {
      await _addEntry(result);
    }
  }
}
