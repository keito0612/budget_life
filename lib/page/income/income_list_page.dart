import 'package:budget/model/category/category.dart';
import 'package:budget/model/income/income.dart';
import 'package:budget/page/expense/expense_list_page.dart';
import 'package:budget/page/income/income_edit_page.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/income_model.dart';
import 'package:budget/widgets/serch_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: _buildSearchBar(serchController),
        ),
        _buildSortButton(context, ref),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              final date = "${dateTime.year}年 ${dateTime.month}月${dateTime.day}日";
              return _buildGroupSeparator(date);
            },
            itemBuilder: (context, income) {
              return _buildIncomeItem(context, income, ref);
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
          colors: [Color(0xFF00C853), Color(0xFF00E676)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.3),
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

  Widget _buildIncomeItem(BuildContext context, Income income, WidgetRef ref) {
    final model = ref.read(incomeViewModelProvider.notifier);

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
                      builder: (context) => IncomeEditPage(
                        id: income.id,
                        amount: income.amount,
                        category: Category(
                          category: income.category!,
                          icon: income.icon,
                          color: income.color,
                        ),
                        memo: income.memo,
                        categoryIndex: income.categoryIndex,
                        savingsAmount: income.savingsAmount,
                        walletCashAmount: income.walletCashAmount,
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
                  await model.deleteIncome(income.id!);
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
                    color: Color(income.color!).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    IconData(income.icon!, fontFamily: 'MaterialIcons'),
                    color: Color(income.color!),
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        income.category!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                      ),
                      if (income.memo.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            income.memo,
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
                      '+${_formatNumber(int.tryParse(income.amount) ?? 0)}円',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF00C853),
                      ),
                    ),
                    if (income.savingsAmount.isNotEmpty && income.savingsAmount != "0")
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.savings,
                                size: 12.sp,
                                color: const Color(0xFFFFB300),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '貯金 ${_formatNumber(int.tryParse(income.savingsAmount) ?? 0)}円',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFFFB300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (income.walletCashAmount.isNotEmpty && income.walletCashAmount != "0")
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5C6BC0).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 12.sp,
                                color: const Color(0xFF5C6BC0),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '財布 ${_formatNumber(int.tryParse(income.walletCashAmount) ?? 0)}円',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF5C6BC0),
                                ),
                              ),
                            ],
                          ),
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
            child: const Text('日付が新しい順', style: TextStyle(color: Color(0xFF00C853))),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              sortTypeController.state = SortType.oldType;
              Navigator.pop(context);
            },
            child: const Text('日付が古い順', style: TextStyle(color: Color(0xFF00C853))),
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
