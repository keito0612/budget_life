import 'package:budget/states/income_state.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/income_chart_state.dart';

final incomeChartProvider = StateNotifierProvider.autoDispose<
    IncomeChartProviderNotifier, IncomeChartState>((ref) {
  ref.listenSelf((previous, next) {
    print('$next => $previous');
  });
  return IncomeChartProviderNotifier(ref);
});

class IncomeChartProviderNotifier extends StateNotifier<IncomeChartState> {
  IncomeChartProviderNotifier(this._ref)
      : super(const IncomeChartState(income: {}, colorList: {})) {
    getIncomeChartData();
  }

  late final Ref _ref;
  IncomeState get _incomeState => _ref.watch(incomeViewModelProvider);
  final today = DateTime.now();

  //月の合計支出金額
  final Map<String, Map<String, double>> monthIncomeTotal = {};
  final colorList = <String, List<int>>{};
  final iconList =  <String, List<int>>{};
  final totalAmount = <String, int>{};

  Future getIncomeChartData() async {
    final incomeState = _incomeState;
    if (incomeState.incomes.isNotEmpty) {
      //支出リストから日付ごとの支出合計金額を取り出す。
      for (var expense in incomeState.incomes) {
        final date = Util.convartDate(expense.date);
        final String month = "${date.year}年${date.month}月";
        final String category = expense.category!;
        if (monthIncomeTotal.containsKey(month)) {
          if (monthIncomeTotal[month]!.containsKey(category)) {
            monthIncomeTotal[month]![category] =
                monthIncomeTotal[month]![category]! +
                    double.parse(expense.amount);
            totalAmount[month] = totalAmount[month]! + int.parse(expense.amount);
          } else {
            monthIncomeTotal[month]![category] = double.parse(expense.amount);
            colorList[month]!.add(expense.color!);
            iconList[month]!.add(expense.icon!);
            totalAmount[month] = totalAmount[month]! + int.parse(expense.amount);
          }
        } else {
          monthIncomeTotal[month] = {category: double.parse(expense.amount)};
          colorList[month] = [expense.color!];
          iconList[month] = [expense.icon!];
          totalAmount[month] = int.parse(expense.amount);
        }
      }
    }
    state = state.copyWith(income: monthIncomeTotal, colorList: colorList,iconList: iconList, totalAmount: totalAmount);
  }
}
