import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/budget_progress.dart';
import '../utils/constants.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  void _showSetBudget(BuildContext context, String category, double current) {
    final ctrl = TextEditingController(text: current > 0 ? current.toStringAsFixed(0) : '');
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Set budget for $category', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 16),
          TextField(
            controller: ctrl, autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixText: '\$ ', hintText: '0.00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                final val = double.tryParse(ctrl.text);
                if (val != null && val > 0) {
                  context.read<ExpenseProvider>().setBudget(category, val);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Budget', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExpenseProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0,
        title: const Text('Budgets', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const Text('Tap a category to set your monthly budget limit.', style: TextStyle(color: AppColors.textLight, fontSize: 13)),
        const SizedBox(height: 16),
        ...AppCategories.all.map((cat) {
          final name = cat['name'] as String;
          final limit = p.budgetFor(name);
          final spent = p.categoryTotals[name] ?? 0.0;
          return GestureDetector(
            onTap: () => _showSetBudget(context, name, limit),
            child: limit > 0
              ? BudgetProgressBar(category: name, spent: spent, limit: limit)
              : Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                  child: Row(children: [
                    Icon(cat['icon'] as IconData, size: 18, color: cat['color'] as Color),
                    const SizedBox(width: 12),
                    Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Text('Tap to set limit', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                    const Icon(Icons.chevron_right, color: AppColors.textLight, size: 18),
                  ]),
                ),
          );
        }),
      ]),
    );
  }
}