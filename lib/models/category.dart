import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class BudgetLimit extends HiveObject {
  @HiveField(0) String category;
  @HiveField(1) double limit;

  BudgetLimit({required this.category, required this.limit});
}