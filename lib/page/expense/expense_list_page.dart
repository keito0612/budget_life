import 'package:budget/model/category/category.dart';
import 'package:budget/model/expense/expense.dart';
import 'package:budget/page/expense/expense_edit_page.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/expense_model.dart';
import 'package:budget/widgets/serch_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sortTypeProvider = StateProvider.autoDispose((ref) {
  return SortType.newType;
});
final selectedSortTypeTextProvider = StateProvider.autoDispose((ref) {
  final sortType = ref.watch(sortTypeProvider);
  switch (sortType) {
    case SortType.newType:
      return "日付が新しい順";
    case SortType.oldType:
      return "日付が古い順";
  }
});

final serchExpenseTextProvider = StateProvider.autoDispose((ref) {
  return "";
});

final orderExpenseProvoder = StateProvider.autoDispose((ref) {
  final sortType = ref.watch(sortTypeProvider);
  switch (sortType) {
    case SortType.newType:
      return GroupedListOrder.ASC;
    case SortType.oldType:
      return GroupedListOrder.DESC;
  }
});

final expenseListProvider = StateProvider.autoDispose<List<Expense>>((ref) {
  final model = ref.watch(expenseViewModelProvider);
  final sortType = ref.watch(sortTypeProvider);

  List<Expense> mutableExpenses = List.from(model.expenses);
  switch (sortType) {
    case SortType.newType:
      return List<Expense>.unmodifiable(
          mutableExpenses..sort((a, b) => b.id!.compareTo(a.id!)));
    case SortType.oldType:
      return List<Expense>.unmodifiable(
          mutableExpenses..sort((a, b) => b.id!.compareTo(a.id!)));
  }
});

final serchExpenseListProvider = StateProvider.autoDispose((ref) {
  final expenseList = ref.watch(expenseListProvider);
  final serchText = ref.watch(serchExpenseTextProvider);
  return expenseList
      .where((expense) =>
          expense.category!.toLowerCase().contains(serchText.toLowerCase()) ||
          expense.memo.toLowerCase().contains(serchText.toLowerCase()))
      .toList();
});

enum SortType { oldType, newType }

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseListProvider);
    final order = ref.watch(orderExpenseProvoder);
    final serchText = ref.watch(serchExpenseTextProvider);
    final serchController = ref.read(serchExpenseTextProvider.notifier);
    final serchExpenseList = ref.watch(serchExpenseListProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
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

                return _getGroupExpenseSeparator(date);
              },
              itemBuilder: (context, expense) {
                return _getExpenseItem(context, expense, ref);
              }),
        ],
      ),
    );
  }

  Widget _sortButton(BuildContext context, WidgetRef ref) {
    final selectedSortTypeText = ref.watch(selectedSortTypeTextProvider);
    return Padding(
      padding: EdgeInsets.only(left: 5.w, bottom: 8.0.h),
      child: Row(
        children: [
          TextButton(
            onPressed: () {
              _showActionSheet(context, ref);
            },
            child: Row(
              children: [
                Icon(
                  Icons.arrow_downward_rounded,
                  color: Colors.white,
                  size: 25.sp,
                ),
                Text(
                  selectedSortTypeText,
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getGroupExpenseSeparator(String date) {
    return SizedBox(
      height: 50.h,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 350.w,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
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
        borderRadius: BorderRadius.circular(6.0.r),
      ),
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 6.0.h),
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
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.r),
                      bottomRight: Radius.circular(5.r)),
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
                      IconData(
                        expense.icon!,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Color(expense.color!),
                      size: 25.sp,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      expense.category!,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ],
                ),
                Text(
                  "金額：${expense.amount}円",
                  style: TextStyle(fontSize: 20.sp),
                ),
                Text(
                  "メモ：${expense.memo}",
                  style: TextStyle(fontSize: 20.sp),
                ),
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
            child: Text(
              "キャンセル",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
