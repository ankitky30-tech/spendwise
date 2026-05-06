import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/category.dart';

class ExpenseProvider extends ChangeNotifier {
  late Box<Expense> _expenseBox;
  late Box<BudgetLimit> _budgetBox;
  String _selectedCategory = 'All';
  DateTime _selectedMonth = DateTime.now();

  String get selectedCategory => _selectedCategory;
  DateTime get selectedMonth => _selectedMonth;

  Future<void> init() async {
    _expenseBox = await Hive.openBox<Expense>('expenses');
    _budgetBox = await Hive.openBox<BudgetLimit>('budgets');
    notifyListeners();
  }

  List<Expense> get allExpenses {
    final list = _expenseBox.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  List<Expense> get filteredExpenses {
    return allExpenses.where((e) {
      final matchCat = _selectedCategory == 'All' || e.category == _selectedCategory;
      final matchMonth = e.date.year == _selectedMonth.year &&
          e.date.month == _selectedMonth.month;
      return matchCat && matchMonth;
    }).toList();
  }

  double get totalThisMonth {
    return filteredExpenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  Map<String, double> get categoryTotals {
    final Map<String, double> totals = {};
    for (var e in filteredExpenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  Map<int, double> get dailyTotals {
    final Map<int, double> totals = {};
    for (var e in filteredExpenses) {
      totals[e.date.day] = (totals[e.date.day] ?? 0) + e.amount;
    }
    return totals;
  }

  List<BudgetLimit> get budgets => _budgetBox.values.toList();

  double budgetFor(String category) {
    try {
      return _budgetBox.values
          .firstWhere((b) => b.category == category)
          .limit;
    } catch (_) { return 0.0; }
  }

  void setCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setMonth(DateTime month) {
    _selectedMonth = month;
    notifyListeners();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String? note,
  }) async {
    final expense = Expense(
      id: const Uuid().v4(),
      title: title,
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
    await _expenseBox.put(expense.id, expense);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
    notifyListeners();
  }

  Future<void> setBudget(String category, double limit) async {
    final existing = _budgetBox.values
        .where((b) => b.category == category)
        .toList();
    if (existing.isNotEmpty) {
      existing.first.limit = limit;
      await existing.first.save();
    } else {
      await _budgetBox.add(BudgetLimit(category: category, limit: limit));
    }
    notifyListeners();
  }
}