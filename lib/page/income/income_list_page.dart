import 'package:budget/model/income/income.dart';
import 'package:budget/page/income/income_edit_page.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomeListPage extends ConsumerWidget {
  const IncomeListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(incomeViewModelProvider);
    return Container(
      child: GroupedListView<Income, DateAndAmount>(
          controller: ScrollController(),
          elements: model.incomes,
          order: GroupedListOrder.ASC,
          groupBy: (Income income) {
            final date = Util.convartDate(income.date);
            return DateAndAmount(date: date, amount: income.amount);
          },
          groupComparator: (group1, group2) =>
              group2.date.compareTo(group1.date),
          itemComparator: (Income item, Income item2) =>
              item.date.compareTo(item2.date),
          floatingHeader: true,
          groupSeparatorBuilder: (group) => _getGroupExpenseSeparator(group),
          itemBuilder: (context, expense) {
            return _getExpenseItem(context, expense, ref);
          }),
    );
  }

  Widget _getGroupExpenseSeparator(DateAndAmount group) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 300,
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
              "${group.date.month}月${group.date.day}日",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getExpenseItem(BuildContext context, Income income, WidgetRef ref) {
    final model = ref.read(incomeViewModelProvider.notifier);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: SizedBox(
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
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
                        builder: (context) => IncomeEditPage(
                              id: income.id,
                              amount: income.amount,
                              category: income.category,
                              memo: income.memo,
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
                    await model.deleteIncome(income.id!);
                  }),
            ],
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(income.category),
                Text("金額: ${income.amount}円"),
                Text("メモ: ${income.memo}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateAndAmount {
  final DateTime date;
  final String amount;

  DateAndAmount({required this.date, required this.amount});
}
