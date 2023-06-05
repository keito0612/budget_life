import 'package:budget/datebases/datebase_helper.dart';
import 'package:budget/model/category/category.dart';
import 'package:budget/model/expense/expense.dart';
import 'package:budget/model/fixed_expense/fixed_expense.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/model/recurring_income/recurring_income.dart';
import 'package:budget/provider/firebase_provider.dart';
import 'package:budget/provider/shared_preferences_provider.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/viewModels/fixed_expense_model.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:budget/viewModels/recurringI_income_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountRepository {
  Future getDate(WidgetRef ref) async {
    await _getExpenses(ref);
    await _getIncomes(ref);
    await _getFixedExpenses(ref);
    await _getRecurringIncomes(ref);
    await _getCategoryExpenses(ref);
    await _getCategoryIncomes(ref);
  }

  Future _getExpenses(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    final expenseViewModel = ref.read(expenseViewModelProvider.notifier);
    final snapshot =
        await instance.ref("users").child(userId).child("expenses").get();
    final List<Expense> expenses = [];
    await DateBaseHelper.rawDelete(tableName: 'expense');
    await expenseViewModel.getExpenses();
    if (snapshot.exists) {
      final value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (final value in value.values) {
        final expense =
            Map<String, dynamic>.from(value! as Map<Object?, Object?>);
        expenses.add(Expense.fromJson(expense));
      }

      await Future.forEach(expenses, (expense) async {
        await expenseViewModel.addExpense(expense);
      });
    }
  }

  static Future dateAllDelete(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    await instance.ref("users").child(userId).remove();
  }

  Future _getIncomes(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    final incomeViewModel = ref.read(incomeViewModelProvider.notifier);

    final snapshot =
        await instance.ref("users").child(userId).child("incomes").get();
    final List<Income> incomes = [];

    if (snapshot.exists) {
      await DateBaseHelper.rawDelete(tableName: 'income');
      await incomeViewModel.getIncomes();
      final value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (final value in value.values) {
        final income =
            Map<String, dynamic>.from(value! as Map<Object?, Object?>);
        incomes.add(Income.fromJson(income));
      }

      await Future.forEach(incomes, (income) async {
        await incomeViewModel.addIncomes(income);
      });
    }
  }

  Future _getFixedExpenses(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    final fixedExpenseViewModel =
        ref.read(fixedExpenseViewModelProvider.notifier);

    final snapshot =
        await instance.ref("users").child(userId).child("fixedExpenses").get();
    final List<FixedExpense> fixedExpenses = [];

    if (snapshot.exists) {
      await DateBaseHelper.rawDelete(tableName: 'fixed_expense');
      await fixedExpenseViewModel.getExpenses();
      final value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (final value in value.values) {
        final fixedExpense =
            Map<String, dynamic>.from(value! as Map<Object?, Object?>);
        fixedExpenses.add(FixedExpense.fromJson(fixedExpense));
      }

      await Future.forEach(fixedExpenses, (fixedExpense) async {
        await fixedExpenseViewModel.addExpense(fixedExpense);
      });
    }
  }

  Future _getRecurringIncomes(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    final recurringIncomeModel =
        ref.read(recurringIncomeViewModelProvider.notifier);
    final List<RecurringIncome> recurringIncomes = [];

    final snapshot = await instance
        .ref("users")
        .child(userId)
        .child("recurringIncomes")
        .get();

    if (snapshot.exists) {
      await DateBaseHelper.rawDelete(tableName: 'recurring_income');
      await recurringIncomeModel.getRecurringIncomes();
      final value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (final value in value.values) {
        final recurringIncome =
            Map<String, dynamic>.from(value! as Map<Object?, Object?>);
        recurringIncomes.add(RecurringIncome.fromJson(recurringIncome));
      }
      await Future.forEach(recurringIncomes, (recurringIncome) async {
        await recurringIncomeModel.addRecurringIncome(recurringIncome);
      });
    }
  }

  Future _getCategoryExpenses(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    final categoryExpenseViewModel =
        ref.read(categoryExpenseModelProvider.notifier);

    final snapshot = await instance
        .ref("users")
        .child(userId)
        .child("categoryExpenses")
        .get();
    final List<Category> categoryExpenses = [];

    if (snapshot.exists) {
      await DateBaseHelper.rawDelete(tableName: 'category_expense');
      await categoryExpenseViewModel.getCategorys();
      final value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (final value in value.values) {
        final categoryExpense =
            Map<String, dynamic>.from(value! as Map<Object?, Object?>);
        categoryExpenses.add(Category.fromJson(categoryExpense));
      }

      await Future.forEach(categoryExpenses, (categoryExpense) async {
        await categoryExpenseViewModel.addCategory(categoryExpense);
      });
    }
  }

  Future _getCategoryIncomes(WidgetRef ref) async {
    final instance = ref.watch(firebaseProvider);
    final userId = ref.watch(userProvider);
    final categoryIncomeViewModel =
        ref.read(categoryIncomeModelProvider.notifier);

    final snapshot = await instance
        .ref("users")
        .child(userId)
        .child("categoryIncomes")
        .get();
    final List<Category> categoryIncomes = [];

    if (snapshot.exists) {
      await DateBaseHelper.rawDelete(tableName: 'category_income');
      await categoryIncomeViewModel.getCategorys();
      final value =
          Map<String, dynamic>.from(snapshot.value! as Map<Object?, Object?>);
      for (final value in value.values) {
        final categoryIncome =
            Map<String, dynamic>.from(value! as Map<Object?, Object?>);
        categoryIncomes.add(Category.fromJson(categoryIncome));
      }

      await Future.forEach(categoryIncomes, (categoryIncome) async {
        await categoryIncomeViewModel.addCategory(categoryIncome);
      });
    }
  }

  Future dateSync(WidgetRef ref) async {
    final prefs = ref.watch(sharedPreferencesProvider);
    final expenses = ref.watch(expenseViewModelProvider).expenses;
    final incomes = ref.watch(incomeViewModelProvider).incomes;
    final userId = ref.watch(userProvider);
    final instance = ref.watch(firebaseProvider);
    final categoryExpenses = ref.watch(categoryExpenseModelProvider).categorys;
    final categoryIncomes =
        ref.watch(categoryIncomeModelProvider).categoryIncomes;
    final fixedExpenses =
        ref.watch(fixedExpenseViewModelProvider).fixedExpenses;
    final recurringIncomes =
        ref.watch(recurringIncomeViewModelProvider).recurringIncomes;
    final balanse = prefs.getInt("balanse");
    final saving = prefs.getInt("saving");
    if (fixedExpenses != []) {
      for (final fixedExpense in fixedExpenses) {
        await instance
            .ref("users")
            .child(userId)
            .child("fixedExpenses")
            .child("itme${fixedExpense.id.toString()}")
            .update(fixedExpense.toJson());
      }
    }
    if (recurringIncomes != []) {
      for (final recurringIncome in recurringIncomes) {
        await instance
            .ref("users")
            .child(userId)
            .child("recurringIncomes")
            .child("itme${recurringIncome.id.toString()}")
            .update(recurringIncome.toJson());
      }
    }
    if (expenses != []) {
      for (final expense in expenses) {
        await instance
            .ref("users")
            .child(userId)
            .child("expenses")
            .child("itme${expense.id.toString()}")
            .update(expense.toJson());
      }
    }

    if (incomes != []) {
      for (final income in incomes) {
        await instance
            .ref("users")
            .child(userId)
            .child("incomes")
            .child("itme${income.id.toString()}")
            .update(income.toJson());
      }
    }
    if (categoryExpenses != []) {
      for (final categoryExpense in categoryExpenses) {
        await instance
            .ref("users")
            .child(userId)
            .child("categoryExpenses")
            .child("itme${categoryExpense.id.toString()}")
            .update(categoryExpense.toJson());
      }
    }
    if (categoryIncomes != []) {
      for (final categoryIncome in categoryIncomes) {
        await instance
            .ref("users")
            .child(userId)
            .child("categoryIncomes")
            .child("itme${categoryIncome.id.toString()}")
            .update(categoryIncome.toJson());
      }
    }

    if (balanse != null) {
      await instance
          .ref("users")
          .child(userId)
          .child("balanse")
          .update({'balanse': balanse});
    }
    if (saving != null) {
      await instance
          .ref("users")
          .child(userId)
          .child("saving")
          .update({'saving': saving});
    }
  }
}
