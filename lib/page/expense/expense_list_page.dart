import 'package:budget/model/expense/expense.dart';
import 'package:budget/page/expense/expense_edit_page.dart';
import 'package:budget/states/expense_state.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ExpenseState model = ref.watch(expenseViewModelProvider);

    return Container(
      child: GroupedListView<Expense, DateTime>(
          controller: ScrollController(),
          elements: model.expenses,
          order: GroupedListOrder.ASC,
          groupBy: (Expense expense) {
            final time = Util.convartDate(expense.date);
            return time;
          },
          groupComparator: (DateTime value1, DateTime value2) =>
              value2.compareTo(value1),
          itemComparator: (Expense expense1, Expense expense2) {
            return expense1.date.compareTo(expense2.date);
          },
          floatingHeader: true,
          groupSeparatorBuilder: _getGroupExpenseSeparator,
          itemBuilder: (context, expense) {
            return _getExpenseItem(context, expense, ref);
          }),
    );
  }

  Widget _getGroupExpenseSeparator(DateTime date) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${date.month}月${date.day}日",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getExpenseItem(BuildContext context, Expense expense, WidgetRef ref) {
    final model = ref.read(expenseViewModelProvider.notifier);
    final categoryExpenseModel = ref.watch(categoryExpenseModelProvider);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SizedBox(
        child: Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                // An action can be bigger than the others.
                backgroundColor: Colors.black38,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: '編集',
                onPressed: (context) async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExpenseEditPage(
                              id: expense.id,
                              amount: expense.amount,
                              category:
                                  categoryExpenseModel.categorys[expense.id!],
                              memo: expense.memo,
                            )),
                  );
                },
              ),
              SlidableAction(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.error_sharp,
                  label: '消去',
                  onPressed: (context) async {
                    await model.deleteExpense(expense.id!);
                  }),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            leading: Icon(
              IconData(expense.icon!, fontFamily: 'MaterialIcons'),
              color: Color(expense.color!),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(expense.category!),
                Text("金額: ${expense.amount}円"),
                Text("メモ: ${expense.memo}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
