import 'package:flutter/material.dart';
import 'package:fuma_free/assets/money_goals_constants.dart';
import 'package:fuma_free/assets/global/colours.dart';

class PlanCard extends StatefulWidget {
  final String title;
  final String textLine;
  final double progressValue;
  final VoidCallback? onDelete;

  const PlanCard({
    super.key,
    required this.title,
    required this.textLine,
    required this.progressValue,
    this.onDelete,
  });

  @override
  State<PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<PlanCard> {
  bool isPurchased = false;

  void _handlePurchase() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(MoneyGoalsStrings.buyHeadline),
          content: Text(MoneyGoalsStrings.confirmation),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary),
                foregroundColor: WidgetStateProperty.all<Color>(AppColors.textSecondary),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(MoneyGoalsStrings.buyButton),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        isPurchased = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Delete' && widget.onDelete != null) {
                      widget.onDelete!();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'Delete', child: Text(MoneyGoalsStrings.optionOne)),
                  ],
                  icon: Icon(Icons.more_vert, size: 30.0),
                ),
              ],
            ),

            SizedBox(height: 15.0),
            Text(
              widget.textLine,
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: widget.progressValue,
              minHeight: 8.0,
              color: isPurchased ? AppColors.achieved : AppColors.primary,
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 2, color: AppColors.primary),
              ),
              child: IconButton(
                onPressed: () {
                  if (widget.progressValue == 1.0) {
                    _handlePurchase();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(MoneyGoalsStrings.notEnoughMoney),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: Icon(MoneyGoalsIcons.buyButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
