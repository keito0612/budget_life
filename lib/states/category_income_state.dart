import 'package:budget/model/category/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'category_income_state.freezed.dart';

@freezed
abstract class CategoryIncomeState with _$CategoryIncomeState {
  const factory CategoryIncomeState(
      {@Default([]) List<Category> categoryIncomes}) = _CategoryIncomeState;
}
