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

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: _buildSearchBar(serchController),
        ),
        _buildSortButton(context, ref),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: GroupedListView<Expense, DateTime>(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
              return _buildGroupSeparator(date);
            },
            itemBuilder: (context, expense) {
              return _buildExpenseItem(context, expense, ref);
            },
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSearchBar(StateController<String> serchController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SerchBar(
        hintText: "カテゴリー、メモを検索",
        onChanged: (text) {
          serchController.state = text;
        },
      ),
    );
  }

  Widget _buildSortButton(BuildContext context, WidgetRef ref) {
    final selectedSortTypeText = ref.watch(selectedSortTypeTextProvider);
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h, bottom: 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showActionSheet(context, ref),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sort,
                    color: const Color(0xFF00C853),
                    size: 18.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    selectedSortTypeText,
                    style: TextStyle(
                      color: const Color(0xFF2D3748),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: const Color(0xFF718096),
                    size: 18.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupSeparator(String date) {
    return Container(
      margin: EdgeInsets.only(top: 4.h, bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5252), Color(0xFFFF8A80)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF5252).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, color: Colors.white, size: 16.sp),
          SizedBox(width: 8.w),
          Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
      BuildContext context, Expense expense, WidgetRef ref) {
    final model = ref.read(expenseViewModelProvider.notifier);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.4,
            children: [
              SlidableAction(
                backgroundColor: const Color(0xFF718096),
                foregroundColor: Colors.white,
                icon: Icons.edit_outlined,
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
                          color: expense.color,
                        ),
                        memo: expense.memo,
                        categoryIndex: expense.categoryIndex,
                        walletId: expense.walletId,
                      ),
                    ),
                  );
                },
              ),
              SlidableAction(
                backgroundColor: const Color(0xFFFF5252),
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                label: '削除',
                onPressed: (context) async {
                  await model.deleteExpense(expense.id!);
                },
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Color(expense.color!).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    IconData(expense.icon!, fontFamily: 'MaterialIcons'),
                    color: Color(expense.color!),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expense.category!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      if (expense.memo.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            expense.memo,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF718096),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '-${_formatNumber(int.tryParse(expense.amount) ?? 0)}円',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF5252),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: expense.walletId == 1
                            ? const Color(0xFF5C6BC0).withValues(alpha: 0.1)
                            : const Color(0xFF00C853).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            expense.walletId == 1
                                ? Icons.account_balance_wallet
                                : Icons.account_balance,
                            size: 12.sp,
                            color: expense.walletId == 1
                                ? const Color(0xFF5C6BC0)
                                : const Color(0xFF00C853),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            expense.walletId == 1 ? '財布' : '口座',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: expense.walletId == 1
                                  ? const Color(0xFF5C6BC0)
                                  : const Color(0xFF00C853),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _showActionSheet(BuildContext context, WidgetRef ref) {
    final sortTypeController = ref.read(sortTypeProvider.notifier);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          '並び替え',
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF718096)),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortType.newType;
              Navigator.pop(context);
            },
            child: const Text('日付が新しい順',
                style: TextStyle(color: Color(0xFF00C853))),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortType.oldType;
              Navigator.pop(context);
            },
            child: const Text('日付が古い順',
                style: TextStyle(color: Color(0xFF00C853))),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
      ),
    );
  }
}
