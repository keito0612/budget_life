import 'package:budget/datebases/category_income_database.dart';
import 'package:budget/model/category.dart';

class CategoryIncomeRepository {
  final CategoryIncomeDatabase _categoryIncomeDatabase;

  CategoryIncomeRepository(this._categoryIncomeDatabase);

  Future<List<Category>> getCategorys() async {
    return _categoryIncomeDatabase.getCategorys();
  }

  Future<Category> addCategorys(Category category) async {
    return _categoryIncomeDatabase.insert(category);
  }

  Future<void> updateCategory(Category category) async {
    return _categoryIncomeDatabase.update(category);
  }

  Future<void> deleteCategory(int id) async {
    return _categoryIncomeDatabase.delete(id);
  }
}
