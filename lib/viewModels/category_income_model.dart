import 'package:budget/datebases/category_expense_database.dart';
import 'package:budget/datebases/category_income_database.dart';
import 'package:budget/model/category.dart';
import 'package:budget/repositorys/category_income_repository.dart';
import 'package:budget/states/category_income_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryIncomeModelProvider =
    StateNotifierProvider<CategoryIncomeModel, CategoryIncomeState>(
  (ref) => CategoryIncomeModel(
    CategoryIncomeRepository(CategoryIncomeDatabase()),
  ),
);

class CategoryIncomeModel extends StateNotifier<CategoryIncomeState> {
  CategoryIncomeModel(this._categoryIncomeRepository)
      : super(const CategoryIncomeState()) {
    getCategorys();
  }

  final CategoryIncomeRepository _categoryIncomeRepository;

  Future<void> addCategory(Category category) async {
    final categoryData = await _categoryIncomeRepository.addCategorys(category);
    state = state
        .copyWith(categoryIncomes: [categoryData, ...state.categoryIncomes]);
  }

  Future<void> getCategorys() async {
    final categorys = await _categoryIncomeRepository.getCategorys();
    state = state.copyWith(
      categoryIncomes: categorys,
    );
  }

  Future<void> updateCategory(Category category) async {
    await _categoryIncomeRepository.updateCategory(category);
    final categorys = await _categoryIncomeRepository.getCategorys();
    state = state.copyWith(
      categoryIncomes: categorys,
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    await _categoryIncomeRepository.deleteCategory(categoryId);
    final categorys = state.categoryIncomes
        .where((category) => category.id != categoryId)
        .toList();
    state = state.copyWith(
      categoryIncomes: categorys,
    );
  }
}
