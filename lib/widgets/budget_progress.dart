import 'package:flutter/material.dart';
import '../utils/constants.dart';

class BudgetProgressBar extends StatelessWidget {
  final String category;
  final double spent;
  final double limit;

  const BudgetProgressBar({super.key, required this.category, required this.spent, required this.limit});

  @override
  Widget build(BuildContext context) {
    final pct = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final color = pct > 0.9 ? AppColors.danger : pct > 0.7 ? AppColors.warning : AppColors.success;
    final icon = AppCategories.iconFor(category);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0,2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 18, color: AppCategories.colorFor(category)),
          const SizedBox(width: 8),
          Text(category, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.text)),
          const Spacer(),
          Text('\$${spent.toStringAsFixed(0)} / \$${limit.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct, minHeight: 8,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        if (pct > 0.9) ...[
          const SizedBox(height: 6),
          Text('⚠ Budget almost reached', style: TextStyle(fontSize: 11, color: color)),
        ],
      ]),
    );
  }
}