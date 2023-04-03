import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/model/expense/expense.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/states/expense_state.dart';
import 'package:budget/states/income_state.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

final mocBalanceWithSavingModelProvider =
    StateNotifierProvider<BalanceWithSavingModel, BalanceWithSaving>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BalanceWithSavingModel(ref, prefs);
});
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('BalanceWithSavingModel', () {
    late SharedPreferences mockPrefs;
    late ExpenseState expenseState;
    late IncomeState incomeState;
    late BalanceWithSavingModel model;
    late ProviderContainer container;

    setUp(() async {
      // Set up mocks
      container = ProviderContainer();
      SharedPreferences.setMockInitialValues({});
      mockPrefs = await SharedPreferences.getInstance();
      expenseState = ExpenseState();
      incomeState = const IncomeState();

      when(expenseState.expenses).thenReturn([]);
      when(incomeState.incomes).thenReturn([]);
      // Set up the model
      model = container.read(balanceWithSavingModelProvider.notifier);
    });
    test('sharedPreferencesに貯金金額と月の金額をセットするテスト', () async {
      // 初期データ
      const balanceWithSaving =
          BalanceWithSaving(balance: 50000, saving: 20000);
      // Call the method to be tested
      await model.setBalanseWithSaving(balanceWithSaving);

      // Verify that SharedPreferences was called correctly
      expect(mockPrefs.getInt('balanse'), equals(50000),
          reason: 'SharedPreferencesに残高が正しくセットされていません');
      expect(mockPrefs.getInt('saving'), equals(20000),
          reason: 'SharedPreferencesに貯金金額が正しくセットされていません');
    });

    test('月の収入から支出を引き、もし収入が余れば、その分を残高を足す、余らなければ残高を引くという処理が出来ているかを確認するテスト',
        () async {
      expenseState =
          expenseState.copyWith(expenses: const [Expense(amount: "10000")]);
      incomeState =
          incomeState.copyWith(incomes: const [Income(amount: "30000")]);
      mockPrefs.setInt('balanse', 50000);
      mockPrefs.setInt('saving', 20000);
      await model.getBalanseWithSaving();
      final balance = model.debugState.balance;
      final saving = model.debugState.saving;
      final remainingSaving = model.debugState.remainingSaving;
      final remainingBalance = model.debugState.remainingBalance;

      // Verify that the balance with saving was calculated correctly
      expect(balance, equals(50000), reason: '残高が違います。');
      expect(saving, equals(20000), reason: '貯金額が違います。');
      expect(remainingBalance, equals(55000), reason: '計算された残高が違います。');
      expect(remainingSaving, equals(20000), reason: '計算された貯金が違います。');
    });
  });
}
