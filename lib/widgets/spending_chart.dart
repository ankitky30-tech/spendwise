import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SpendingBarChart extends StatelessWidget {
  final Map<int, double> dailyTotals;
  final int daysInMonth;

  const SpendingBarChart({super.key, required this.dailyTotals, required this.daysInMonth});

  @override
  Widget build(BuildContext context) {
    final maxY = dailyTotals.values.isEmpty ? 100.0 : dailyTotals.values.reduce((a, b) => a > b ? a : b) * 1.3;
    return BarChart(BarChartData(
      maxY: maxY,
      gridData: FlGridData(show: true, drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.divider, strokeWidth: 1)),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true, reservedSize: 22,
          getTitlesWidget: (val, _) {
            final day = val.toInt();
            if (day % 5 != 0) return const SizedBox.shrink();
            return Text('$day', style: const TextStyle(fontSize: 10, color: AppColors.textLight));
          },
        )),
      ),
      barGroups: List.generate(daysInMonth, (i) {
        final day = i + 1;
        final amount = dailyTotals[day] ?? 0.0;
        return BarChartGroupData(x: day, barRods: [
          BarChartRodData(
            toY: amount,
            width: 6,
            borderRadius: BorderRadius.circular(4),
            color: amount > 0 ? AppColors.primary : AppColors.divider,
          ),
        ]);
      }),
    ));
  }
}

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryTotals;

  const CategoryPieChart({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {
    if (categoryTotals.isEmpty) {
      return const Center(child: Text('No data', style: TextStyle(color: AppColors.textLight)));
    }
    final entries = categoryTotals.entries.toList();
    return PieChart(PieChartData(
      sectionsSpace: 2,
      centerSpaceRadius: 40,
      sections: entries.map((e) {
        final color = AppCategories.colorFor(e.key);
        return PieChartSectionData(
          value: e.value,
          color: color,
          radius: 60,
          title: e.key,
          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
        );
      }).toList(),
    ));
  }
}