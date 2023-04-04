import 'package:budget/model/expense/expense.dart';
import 'package:budget/page/expense/expense_edit_page.dart';
import 'package:budget/model/category/category.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/widgets/serch_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sortTypeProvider = StateProvider((ref) {
  return SortExpenseType.newType;
});
final selectedSortTypeTextProvider = StateProvider((ref) {
  final sortType = ref.watch(sortTypeProvider);
  switch (sortType) {
    case SortExpenseType.newType:
      return "日付が新しい順";
    case SortExpenseType.oldType:
      return "日付が古い順";
  }
});

final serchTextProvider = StateProvider.autoDispose((ref) {
  return "";
});

final orderExpenseProvoder = StateProvider((ref) {
  final sortType = ref.watch(sortTypeProvider);
  switch (sortType) {
    case SortExpenseType.newType:
      return GroupedListOrder.ASC;
    case SortExpenseType.oldType:
      return GroupedListOrder.DESC;
  }
});

final expenseListProvider = StateProvider<List<Expense>>((ref) {
  final model = ref.watch(expenseViewModelProvider);
  final sortType = ref.watch(sortTypeProvider);

  List<Expense> mutableExpenses = List.from(model.expenses);
  switch (sortType) {
    case SortExpenseType.newType:
      return List<Expense>.unmodifiable(
          mutableExpenses..sort((a, b) => b.id!.compareTo(a.id!)));
    case SortExpenseType.oldType:
      return List<Expense>.unmodifiable(
          mutableExpenses..sort((a, b) => b.id!.compareTo(a.id!)));
  }
});

final serchExpenseListProvider = StateProvider.autoDispose((ref) {
  final expenseList = ref.watch(expenseListProvider);
  final serchText = ref.watch(serchTextProvider);
  return expenseList
      .where((expense) =>
          expense.category!.toLowerCase().contains(serchText.toLowerCase()) ||
          expense.memo.toLowerCase().contains(serchText.toLowerCase()))
      .toList();
});

enum SortExpenseType { oldType, newType }

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseListProvider);
    final order = ref.watch(orderExpenseProvoder);
    final serchText = ref.watch(serchTextProvider);
    final serchController = ref.read(serchTextProvider.notifier);
    final serchExpenseList = ref.watch(serchExpenseListProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SerchBar(
                hintText: "カテゴリー,メモを検索",
                onChanged: (text) {
                  serchController.state = text;
                }),
          ),
          _sortButton(context, ref),
          GroupedListView<Expense, DateTime>(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              controller: ScrollController(),
              order: order,
              elements: serchText != "" ? serchExpenseList : expenses,
              groupBy: (Expense expense) {
                final date = Util.convartDate(expense.date);
                return date;
              },
              groupComparator: (DateTime value1, DateTime value2) =>
                  value2.compareTo(value1),
              itemComparator: (Expense expense1, Expense expense2) {
                return expense1.date.compareTo(expense2.date);
              },
              floatingHeader: true,
              groupSeparatorBuilder: (dateTime) {
                final date =
                    "${dateTime.year}年 ${dateTime.month}月${dateTime.day}日";
                final monthTotalAmount = _monthTotalAmount(expenses, date);
                return _getGroupExpenseSeparator(date, monthTotalAmount);
              },
              itemBuilder: (context, expense) {
                return _getExpenseItem(context, expense, ref);
              }),
        ],
      ),
    );
  }

  int _monthTotalAmount(List<Expense> expenses, String date) {
    var monthTotalAmount = <String, int>{};
    for (final expense in expenses) {
      if (monthTotalAmount.containsKey(date)) {
        monthTotalAmount[date] =
            monthTotalAmount[date]! + int.parse(expense.amount);
      } else {
        monthTotalAmount[date] = int.parse(expense.amount);
      }
    }

    return monthTotalAmount[date]!;
  }

  Widget _serchTextField() {
    return CupertinoSearchTextField(
      onChanged: (value) {},
    );
  }

  Widget _sortButton(BuildContext context, WidgetRef ref) {
    final selectedSortTypeText = ref.watch(selectedSortTypeTextProvider);
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 8.0),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              _showActionSheet(context, ref);
            },
            child: Row(
              children: [
                const Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.white,
                ),
                Text(
                  selectedSortTypeText,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGroupExpenseSeparator(String date, int amount) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10),
                Text(
                  "合計金額：$amount",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getExpenseItem(BuildContext context, Expense expense, WidgetRef ref) {
    final model = ref.read(expenseViewModelProvider.notifier);
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
                              category: Category(
                                  category: expense.category!,
                                  icon: expense.icon,
                                  color: expense.color),
                              memo: expense.memo,
                              categoryIndex: expense.categoryIndex,
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      IconData(expense.icon!, fontFamily: 'MaterialIcons'),
                      color: Color(expense.color!),
                    ),
                    const SizedBox(width: 5),
                    Text(expense.category!),
                  ],
                ),
                Text(
                  "金額：${expense.amount}円",
                ),
                Text("メモ: ${expense.memo}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    final sortTypeController = ref.read(sortTypeProvider.notifier);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortExpenseType.newType;
              Navigator.pop(context);
            },
            child: const Text('日付が新しい順'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortExpenseType.oldType;
              Navigator.pop(context);
            },
            child: const Text('日付が古い順'),
          ),
        ],
        cancelButton: TextButton(
            child: const Text(
              "キャンセル",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
