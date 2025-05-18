import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fuma_free/database_service.dart';
import 'package:fuma_free/pages/widgets/customButton.dart';
import 'package:fuma_free/assets/global/colours.dart';
import 'package:intl/intl.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<dynamic, dynamic> data = {};

  DateTime? _startDate;
  final TextEditingController _costPerPackController = TextEditingController();
  final TextEditingController _cigsPerDayController = TextEditingController();
  final TextEditingController _cigsPerPackController = TextEditingController(
      text: "20");

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    DataSnapshot? snapshot = await DatabaseService().read(path: 'userData');
    if (snapshot?.value != null) {
      data = jsonDecode(snapshot?.value as String);

      setState(() {
        // Parse startDate
        if (data['startDate'] != null) {
          _startDate = DateTime.tryParse(data['startDate']);
        }
        _costPerPackController.text = data['costPerPack']?.toString() ?? "";
        _cigsPerDayController.text = data['cigsPerDay']?.toString() ?? "";
        _cigsPerPackController.text = data['cigsPerPack']?.toString() ?? "";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final dateText = _startDate == null
        ? "Select date"
        : DateFormat('yMMMd').format(_startDate!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Settings"),
        foregroundColor: AppColors.textSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: const Text("Your smoking information: ",style: TextStyle(fontSize: 24),)),
              SizedBox(height: 40,),
              const Text('When did you start smoking?',
                  style: TextStyle(fontSize: 18)),
              TextButton(
                onPressed: () => _pickStartDate(context),
                child: Text(dateText),
              ),
              const SizedBox(height: 10),

              const Text('Cost per pack:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _costPerPackController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: "e.g., 10.00",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                  'Cigarettes smoked per day:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _cigsPerDayController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "e.g., 5",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                  'Cigarettes per pack:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: _cigsPerPackController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              CustomButton(
                text: 'Save Settings',
                  onPressed: () async {
                    if (_costPerPackController.text.isEmpty ||
                        _cigsPerDayController.text.isEmpty ||
                        _cigsPerPackController.text.isEmpty ||
                        _startDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please fill in all fields")),
                      );
                      return;
                    }

                    try {
                      final settingsMap = {
                        'startDate': _startDate!.toIso8601String(),
                        'initiationDate': DateTime.now().toIso8601String(),
                        'relapseTimes': 0,
                        'costPerPack': double.tryParse(_costPerPackController.text) ?? 0.0,
                        'cigsPerDay': int.tryParse(_cigsPerDayController.text) ?? 0,
                        'cigsPerPack': int.tryParse(_cigsPerPackController.text) ?? 20,
                        'lastSmoke': DateTime.now().toIso8601String(),
                        'recordInMilliseconds': 0,
                      };

                      final jsonString = jsonEncode(settingsMap);

                      await DatabaseService().create(path: 'userData', data:jsonString,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Settings saved to Firebase!")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error saving settings: $e")),
                      );
                    }
                  }

              ),
            ],
          ),
        ),
      ),
    );
  }
}