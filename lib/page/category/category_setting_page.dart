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
    final categoryExoenseModel = ref.watch(categoryExpenseModelProvider);
    final categoryExpenseModelController =
        ref.read(categoryExpenseModelProvider.notifier);
    final categoryIncomeModel = ref.watch(categoryIncomeModelProvider);
    final categoryIncomeModelController =
        ref.read(categoryIncomeModelProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("カテゴリー", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 8.w, top: 30.h, bottom: 8.h),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
                width: 320.w,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white, width: 3.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "新規カテゴリー",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => CategoryAddPage()));
                  },
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(right: 300.w),
                child: Text(
                  "支出",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
              _categoryExpenseListWidget(categoryExoenseModel.categorys,
                  categoryExpenseModelController),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.only(right: 300.w),
                child: Text(
                  "収入",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
              _categoryIncomeListWidget(categoryIncomeModel.categoryIncomes,
                  categoryIncomeModelController)
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryExpenseListWidget(
      List<Category> list, CategoryExpenseModel model) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: 350.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          color: Colors.white,
        ),
        child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: list
                .map((category) => Slidable(
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
                                    builder: (context) => categoryEditPage(
                                          id: category.id,
                                          category: category.category,
                                          icon: IconData(category.icon!,
                                              fontFamily: 'MaterialIcons'),
                                          color: Color(category.color!),
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
                                await model.deleteCategory(category.id!);
                              }),
                        ],
                      ),
                      child: ListTile(
                          leading: Icon(
                            IconData(category.icon!,
                                fontFamily: 'MaterialIcons'),
                            size: 25.sp,
                            color: Color(category.color!),
                          ),
                          title: Text(category.category,
                              style: TextStyle(fontSize: 21.sp)),
                          trailing: Icon(
                            Icons.arrow_left_sharp,
                            size: 30.sp,
                          )),
                    ))
                .toList()),
      ),
    );
  }

  Widget _categoryIncomeListWidget(
      List<Category> list, CategoryIncomeModel model) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 350.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            color: Colors.white,
          ),
          child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: list
                  .map((category) => Slidable(
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
                                      builder: (context) => categoryEditPage(
                                            id: category.id,
                                            category: category.category,
                                            icon: IconData(category.icon!,
                                                fontFamily: 'MaterialIcons'),
                                            color: Color(category.color!),
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
                                  await model.deleteCategory(category.id!);
                                }),
                          ],
                        ),
                        child: ListTile(
                            leading: Icon(
                              IconData(category.icon!,
                                  fontFamily: 'MaterialIcons'),
                              size: 22.sp,
                              color: Color(category.color!),
                            ),
                            title: Text(
                              category.category,
                              style: TextStyle(fontSize: 21.sp),
                            ),
                            trailing:
                                Icon(Icons.arrow_left_sharp, size: 30.sp)),
                      ))
                  .toList()),
        ));
  }
}


