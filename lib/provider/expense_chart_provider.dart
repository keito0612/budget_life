import 'package:budget/model/expense_chart/expense_chart.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/states/expense_chart_state.dart';
import 'package:budget/utils/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../states/expense_state.dart';
import '../viewModels/expense_model.dart';

final expenseChartProvider = StateNotifierProvider.autoDispose<
    ExpenseChartProviderNotifier, ExpenseChartState>((ref) {
  ref.listenSelf((previous, next) {
    print('$next => $previous');
  });
  return ExpenseChartProviderNotifier(ref);
});

class ExpenseChartProviderNotifier extends StateNotifier<ExpenseChartState> {
  ExpenseChartProviderNotifier(this._ref)
      : super(const ExpenseChartState(expense: {}, colorList: {})) {
    getExpenseChartData();
  }

  late final Ref _ref;
  ExpenseState get _expenseState => _ref.watch(expenseViewModelProvider);
  final today = DateTime.now();

  //月の合計支出金額
  final Map<String, Map<String, double>> monthExpenseTotal = {};
  final colorList = <String, List<int>>{};
  final iconList =  <String, List<int>>{};
  final totalAmount = <String, int>{};

  Future getExpenseChartData() async {
    final expenseState = _expenseState;
    if (expenseState.expenses.isNotEmpty) {
      //支出リストから日付ごとの支出合計金額を取り出す。
      for (var expense in expenseState.expenses) {
        final date = Util.convartDate(expense.date);
        final String month = "${date.year}年${date.month}月";
        final String category = expense.category!;
        if (monthExpenseTotal.containsKey(month)) {
          if (monthExpenseTotal[month]!.containsKey(category)) {
            monthExpenseTotal[month]![category] =
                monthExpenseTotal[month]![category]! +
                    double.parse(expense.amount);
            totalAmount[month] = totalAmount[month]! + int.parse(expense.amount);
          } else {
            monthExpenseTotal[month]![category] = double.parse(expense.amount);
            colorList[month]!.add(expense.color!);
            iconList[month]!.add(expense.icon!);
            totalAmount[month] = totalAmount[month]! + int.parse(expense.amount);
          }
        } else {
          monthExpenseTotal[month] = {category: double.parse(expense.amount)};
          colorList[month] = [expense.color!];
          iconList[month] = [expense.icon!];
          totalAmount[month] = int.parse(expense.amount);
        }
      }
    }
    state = state.copyWith(expense: monthExpenseTotal, colorList: colorList,iconList: iconList, totalAmount: totalAmount);
  }
}
