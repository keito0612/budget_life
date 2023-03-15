import 'package:budget/model/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_expense_state.freezed.dart';

@freezed
abstract class CategoryExpenseState with _$CategoryExpenseState {
  const factory CategoryExpenseState({@Default([]) List<Category> categorys}) =
      _CategoryExpenseState;
}
