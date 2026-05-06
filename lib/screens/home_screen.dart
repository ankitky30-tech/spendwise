import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_card.dart';
import '../widgets/category_chip.dart';
import '../utils/constants.dart';
import '../utils/csv_export.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';
import 'budget_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    final fmt = NumberFormat.currency(symbol: '\$');
    final monthLabel = DateFormat('MMMM yyyy').format(p.selectedMonth);
    final categories = ['All', ...AppCategories.all.map((c) => c['name'] as String)];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        // Header
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('SpendWise', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.text))),
              IconButton(icon: const Icon(Icons.bar_chart_rounded, color: AppColors.primary),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()))),
              IconButton(icon: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetScreen()))),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textLight),
                onSelected: (val) async {
                  if (val == 'csv') {
                    final path = await ExportUtils.exportCSV(p.filteredExpenses);
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV saved: $path')));
                  } else if (val == 'pdf') {
                    await ExportUtils.exportPDF(p.filteredExpenses, p.totalThisMonth);
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'csv', child: Row(children: [Icon(Icons.table_chart_outlined, size: 18), SizedBox(width: 10), Text('Export CSV')])),
                  const PopupMenuItem(value: 'pdf', child: Row(children: [Icon(Icons.picture_as_pdf_outlined, size: 18), SizedBox(width: 10), Text('Export PDF')])),
                ],
              ),
            ]),
            const SizedBox(height: 16),
            // Summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9C94FF)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0,8))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(monthLabel, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      final prev = DateTime(p.selectedMonth.year, p.selectedMonth.month - 1);
                      p.setMonth(prev);
                    },
                    child: const Icon(Icons.chevron_left, color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      final next = DateTime(p.selectedMonth.year, p.selectedMonth.month + 1);
                      if (next.isBefore(DateTime.now().add(const Duration(days: 1)))) p.setMonth(next);
                    },
                    child: const Icon(Icons.chevron_right, color: Colors.white70),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(fmt.format(p.totalThisMonth),
                  style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                const Text('Total spent this month', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ),
          ]),
        ),

        // Category filter
        Container(
          color: AppColors.surface,
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (_, i) => CategoryChip(
              label: categories[i],
              selected: p.selectedCategory == categories[i],
              onTap: () => p.setCategory(categories[i]),
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.divider),

        // Expense list
        Expanded(child: p.filteredExpenses.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.receipt_long_outlined, size: 56, color: AppColors.textLight.withOpacity(0.4)),
              const SizedBox(height: 12),
              const Text('No expenses yet', style: TextStyle(color: AppColors.textLight, fontSize: 15)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: p.filteredExpenses.length,
              itemBuilder: (_, i) {
                final e = p.filteredExpenses[i];
                return ExpenseCard(expense: e, onDelete: () => p.deleteExpense(e.id));
              },
            ),
        ),
      ])),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}