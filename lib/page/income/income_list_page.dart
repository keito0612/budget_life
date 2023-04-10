import 'package:budget/model/category/category.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/page/expense/expense_list_page.dart';
import 'package:budget/page/income/income_edit_page.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:budget/widgets/serch_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final serchIncomeTextProvider = StateProvider.autoDispose((ref) {
  return "";
});

final incomeListProvider = StateProvider.autoDispose<List<Income>>((ref) {
  final model = ref.watch(incomeViewModelProvider);
  final sortType = ref.watch(sortTypeProvider);

  List<Income> mutableExpenses = List.from(model.incomes);
  switch (sortType) {
    case SortType.newType:
      return List<Income>.unmodifiable(
          mutableExpenses..sort((a, b) => b.id!.compareTo(a.id!)));
    case SortType.oldType:
      return List<Income>.unmodifiable(
          mutableExpenses..sort((a, b) => b.id!.compareTo(a.id!)));
  }
});

final orderIncomeProvoder = StateProvider.autoDispose((ref) {
  final sortType = ref.watch(sortTypeProvider);
  switch (sortType) {
    case SortType.newType:
      return GroupedListOrder.ASC;
    case SortType.oldType:
      return GroupedListOrder.DESC;
  }
});

final serchIncomeListProvider = StateProvider.autoDispose((ref) {
  final incomeList = ref.watch(incomeListProvider);
  final serchText = ref.watch(serchIncomeTextProvider);
  return incomeList
      .where((income) =>
          income.category!.toLowerCase().contains(serchText.toLowerCase()) ||
          income.memo.toLowerCase().contains(serchText.toLowerCase()))
      .toList();
});

class IncomeListPage extends ConsumerWidget {
  const IncomeListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomes = ref.watch(incomeListProvider);
    final order = ref.watch(orderIncomeProvoder);
    final serchText = ref.watch(serchIncomeTextProvider);
    final serchController = ref.read(serchIncomeTextProvider.notifier);
    final serchIncomeList = ref.watch(serchIncomeListProvider);
    return Column(
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
        Container(
          child: GroupedListView<Income, DateTime>(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: ScrollController(),
              elements: serchText != "" ? serchIncomeList : incomes,
              order: order,
              groupBy: (Income income) {
                final date = Util.convartDate(income.date);
                return date;
              },
              groupComparator: (DateTime value1, DateTime value2) =>
                  value2.compareTo(value1),
              itemComparator: (Income item, Income item2) =>
                  item.date.compareTo(item2.date),
              floatingHeader: true,
              groupSeparatorBuilder: (dateTime) {
                final date =
                    "${dateTime.year}年 ${dateTime.month}月${dateTime.day}日";
                return _getGroupIncomeSeparator(
                  date,
                );
              },
              itemBuilder: (context, expense) {
                return _getExpenseItem(context, expense, ref);
              }),
        ),
      ],
    );
  }

  Widget _getGroupIncomeSeparator(String date) {
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getExpenseItem(BuildContext context, Income income, ref) {
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
                              category: Category(
                                  category: income.category!,
                                  icon: income.icon,
                                  color: income.color),
                              memo: income.memo,
                              categoryIndex: income.categoryIndex,
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      IconData(income.icon!, fontFamily: 'MaterialIcons'),
                      color: Color(income.color!),
                    ),
                    const SizedBox(width: 5),
                    Text(income.category!),
                  ],
                ),
                Text(
                  "金額: ${income.amount}円",
                ),
                Text("メモ: ${income.memo}"),
              ],
            ),
          ),
        ),
      ),
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

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    final sortTypeController = ref.read(sortTypeProvider.notifier);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortType.newType;
              Navigator.pop(context);
            },
            child: const Text('日付が新しい順'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortType.oldType;
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

class DateAndAmount {
  final DateTime date;
  final String amount;

  DateAndAmount({required this.date, required this.amount});
}
