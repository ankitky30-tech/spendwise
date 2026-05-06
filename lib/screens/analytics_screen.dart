import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/spending_chart.dart';
import '../utils/constants.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    final daysInMonth = DateUtils.getDaysInMonth(p.selectedMonth.year, p.selectedMonth.month);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0,
        title: const Text('Analytics', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _card('Daily Spending', SizedBox(height: 200, child: SpendingBarChart(dailyTotals: p.dailyTotals, daysInMonth: daysInMonth))),
        const SizedBox(height: 16),
        _card('By Category', SizedBox(height: 220, child: CategoryPieChart(categoryTotals: p.categoryTotals))),
        const SizedBox(height: 16),
        _card('Breakdown', Column(children: p.categoryTotals.entries.map((e) {
          final pct = p.totalThisMonth > 0 ? e.value / p.totalThisMonth : 0.0;
          return Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [
            Icon(AppCategories.iconFor(e.key), size: 16, color: AppCategories.colorFor(e.key)),
            const SizedBox(width: 10),
            Expanded(child: Text(e.key, style: const TextStyle(fontSize: 14, color: AppColors.text))),
            Text('\$${e.value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(width: 8),
            Text('${(pct*100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
          ]));
        }).toList())),
      ]),
    );
  }

  Widget _card(String title, Widget child) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0,3))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.text)),
      const SizedBox(height: 16),
      child,
    ]),
  );
}