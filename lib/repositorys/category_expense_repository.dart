import 'package:budget/datebases/category_expense_database.dart';
import 'package:budget/model/category/category.dart';

class CategoryExpenseRepository {
  final CategoryExpenseDatabase _categoryExpenseDatabase;

  CategoryExpenseRepository(this._categoryExpenseDatabase);

  Future<List<Category>> getCategorys() async {
    return _categoryExpenseDatabase.getCategorys();
  }

  Future<Category> addCategorys(Category category) async {
    return _categoryExpenseDatabase.insert(category);
  }

  Future<void> updateCategory(Category category) async {
    return _categoryExpenseDatabase.update(category);
  }

  Future<void> deleteCategory(int id) async {
    return _categoryExpenseDatabase.delete(id);
  }
}
