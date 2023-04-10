import 'package:budget/datebases/category_expense_database.dart';
import 'package:budget/model/category/category.dart';
import 'package:budget/states/category_expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositorys/category_expense_repository.dart';

final categoryExpenseModelProvider =
    StateNotifierProvider<CategoryExpenseModel, CategoryExpenseState>(
  (ref) => CategoryExpenseModel(
    CategoryExpenseRepository(CategoryExpenseDatabase()),
  ),
);

class CategoryExpenseModel extends StateNotifier<CategoryExpenseState> {
  CategoryExpenseModel(this._categoryExpenseRepository)
      : super(const CategoryExpenseState()) {
    getCategorys();
  }
  final CategoryExpenseRepository _categoryExpenseRepository;

  Future<void> addCategory(Category category) async {
    final categoryData =
        await _categoryExpenseRepository.addCategorys(category);
    state = state.copyWith(categorys: [
      ...state.categorys,
      categoryData,
    ]);
  }

  Future<void> getCategorys() async {
    final categorys = await _categoryExpenseRepository.getCategorys();
    state = state.copyWith(
      categorys: categorys,
    );
  }

  Future<void> updateCategory(Category category) async {
    await _categoryExpenseRepository.updateCategory(category);
    final categorys = await _categoryExpenseRepository.getCategorys();
    state = state.copyWith(
      categorys: categorys,
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    await _categoryExpenseRepository.deleteCategory(categoryId);
    final categorys =
        state.categorys.where((category) => category.id != categoryId).toList();
    state = state.copyWith(
      categorys: categorys,
    );
  }
}
