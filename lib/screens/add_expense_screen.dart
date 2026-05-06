import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expense_provider.dart';
import '../utils/constants.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});
  @override State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _category = 'Food';
  DateTime _date = DateTime.now();

  void _submit() {
    if (_titleCtrl.text.isEmpty || _amountCtrl.text.isEmpty) return;
    final amount = double.tryParse(_amountCtrl.text);
    if (amount == null || amount <= 0) return;
    context.read<ExpenseProvider>().addExpense(
      title: _titleCtrl.text.trim(),
      amount: amount,
      category: _category,
      date: _date,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Add Expense', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.close, color: AppColors.text), onPressed: () => Navigator.pop(context)),
        actions: [TextButton(onPressed: _submit, child: const Text('Save', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16)))],
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _field('Title', _titleCtrl, hint: 'e.g. Lunch at cafe'),
        const SizedBox(height: 16),
        _field('Amount', _amountCtrl, hint: '0.00', numeric: true),
        const SizedBox(height: 20),
        const Text('Category', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.text)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: AppCategories.all.map((cat) {
          final name = cat['name'] as String;
          final selected = _category == name;
          return GestureDetector(
            onTap: () => setState(() => _category = name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? (cat['color'] as Color).withOpacity(0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: selected ? (cat['color'] as Color) : AppColors.divider, width: selected ? 1.5 : 1),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(cat['icon'] as IconData, size: 16, color: selected ? cat['color'] as Color : AppColors.textLight),
                const SizedBox(width: 6),
                Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? cat['color'] as Color : AppColors.textLight)),
              ]),
            ),
          );
        }).toList()),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime(2020), lastDate: DateTime.now());
            if (picked != null) setState(() => _date = picked);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider)),
            child: Row(children: [
              const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(DateFormat('MMMM d, yyyy').format(_date), style: const TextStyle(fontWeight: FontWeight.w500)),
              const Spacer(),
              const Icon(Icons.chevron_right, color: AppColors.textLight),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        _field('Note (optional)', _noteCtrl, hint: 'Any extra details...'),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: const Text('Add Expense', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {String? hint, bool numeric = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.text)),
      const SizedBox(height: 8),
      TextField(
        controller: ctrl,
        keyboardType: numeric ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textLight),
          filled: true, fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.divider)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.divider)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    ]);
  }
}