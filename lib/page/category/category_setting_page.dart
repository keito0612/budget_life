import 'package:budget/model/category/category.dart';
import 'package:budget/page/category/category_add_page.dart';
import 'package:budget/page/category/category_edit.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategorySettingPage extends ConsumerWidget {
  const CategorySettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryExpenseModel = ref.watch(categoryExpenseModelProvider);
    final categoryExpenseModelController =
        ref.read(categoryExpenseModelProvider.notifier);
    final categoryIncomeModel = ref.watch(categoryIncomeModelProvider);
    final categoryIncomeModelController =
        ref.read(categoryIncomeModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context),
          ),
          SliverToBoxAdapter(
            child: _buildContent(
              context,
              categoryExpenseModel.categorys,
              categoryExpenseModelController,
              categoryIncomeModel.categoryIncomes,
              categoryIncomeModelController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.category, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Text(
            'カテゴリー',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Category> expenseCategories,
    CategoryExpenseModel expenseModel,
    List<Category> incomeCategories,
    CategoryIncomeModel incomeModel,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8.h),
          // 新規カテゴリーボタン
          _buildAddButton(context),
          SizedBox(height: 24.h),
          // 支出カテゴリー
          _buildSectionTitle('支出カテゴリー', Icons.arrow_downward, const Color(0xFFFF5252)),
          SizedBox(height: 12.h),
          _buildCategoryList(expenseCategories, expenseModel),
          SizedBox(height: 24.h),
          // 収入カテゴリー
          _buildSectionTitle('収入カテゴリー', Icons.arrow_upward, const Color(0xFF00C853)),
          SizedBox(height: 12.h),
          _buildIncomeCategoryList(incomeCategories, incomeModel),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00C853),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => CategoryAddPage(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              '新規カテゴリー',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 18.sp),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(List<Category> list, CategoryExpenseModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(left: 64.w),
            child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),
          itemBuilder: (context, index) {
            final category = list[index];
            return _buildCategoryItem(context, category, model);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, Category category, CategoryExpenseModel model) {
    return Slidable(
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
                  builder: (context) => categoryEditPage(
                    id: category.id,
                    category: category.category,
                    icon: IconData(category.icon!, fontFamily: 'MaterialIcons'),
                    color: Color(category.color!),
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
              await model.deleteCategory(category.id!);
            },
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(category.color!).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                IconData(category.icon!, fontFamily: 'MaterialIcons'),
                size: 22.sp,
                color: Color(category.color!),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                category.category,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: const Color(0xFFA0AEC0),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeCategoryList(List<Category> list, CategoryIncomeModel model) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: list.length,
          separatorBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(left: 64.w),
            child: const Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),
          itemBuilder: (context, index) {
            final category = list[index];
            return _buildIncomeCategoryItem(context, category, model);
          },
        ),
      ),
    );
  }

  Widget _buildIncomeCategoryItem(BuildContext context, Category category, CategoryIncomeModel model) {
    return Slidable(
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
                  builder: (context) => categoryEditPage(
                    id: category.id,
                    category: category.category,
                    icon: IconData(category.icon!, fontFamily: 'MaterialIcons'),
                    color: Color(category.color!),
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
              await model.deleteCategory(category.id!);
            },
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Color(category.color!).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                IconData(category.icon!, fontFamily: 'MaterialIcons'),
                size: 22.sp,
                color: Color(category.color!),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                category.category,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ),
            Icon(
              Icons.chevron_left,
              color: const Color(0xFFA0AEC0),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
