import 'package:flutter/material.dart';
import 'package:fuma_free/pages/widgets/appbar.dart';
import 'package:fuma_free/pages/widgets/customButton.dart';
import 'package:fuma_free/assets/global/colours.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _selectedColor = Colors.blue;
  String _selectedCurrency = 'USD';

  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  final List<String> _currencyOptions = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'AUD',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Settings"),
        foregroundColor: AppColors.textSecondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chosen Theme Color:',
              style: TextStyle(fontSize: 18),
            ),
            Wrap(
              spacing: 10,
              children: _colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            Divider(
              height: 30,
              color: Colors.blue,
              thickness: 3,
            ),
            const Text(
              'Selected currency:',
              style: TextStyle(fontSize: 18),
            ),
            DropdownButton<String>(
              value: _selectedCurrency,
              items: _currencyOptions.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (String? newCurrency) {
                if (newCurrency != null) {
                  setState(() {
                    _selectedCurrency = newCurrency;
                  });
                }
              },
            ),
            Divider(
              height: 30,
              color: AppColors.primary,
              thickness: 3,
            ),
            SizedBox(height: 20,),
            CustomButton(text: 'Save Settings', onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Settings saved!"),
                  duration: Duration(seconds: 2),
                ),
              );
            },),
          ],
        ),
      ),
    );
  }
}
