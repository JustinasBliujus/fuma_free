import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fuma_free/assets/global/colours.dart';

class SmokingGraph extends StatelessWidget {
  final List<Map<String, dynamic>> entries;

  const SmokingGraph({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    List<String> tooltips = [];
    List<Color> dotColors = [];

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      spots.add(FlSpot(i.toDouble(), 0));
      dotColors.add(entry["smoked"] == "Smoked" ? AppColors.failed : AppColors.achieved);

      tooltips.add(
        "${entry["date"].toString().split(' ')[0]}\n${entry["activity"]}"
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  return LineTooltipItem(
                    tooltips[index],
                    const TextStyle(color: Colors.white, fontSize: 14),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              color: AppColors.primary,
              spots: spots,
              barWidth: 4,
              isCurved: false,
              dotData: FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: dotColors[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
