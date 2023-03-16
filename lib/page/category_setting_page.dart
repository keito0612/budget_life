import 'package:budget/model/category.dart';
import 'package:budget/page/category_add_page.dart';
import 'package:budget/page/category_edit.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class categorySettingPage extends ConsumerWidget {
  const categorySettingPage({super.key});

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
        title: const Text("カテゴリー"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 8, top: 30, bottom: 8),
          child: Column(
            children: [
              Container(
                height: 40,
                width: 320,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "新規カテゴリー",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => categoryAddPage()));
                  },
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: const EdgeInsets.only(right: 300),
                child: Text(
                  "支出",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              _categoryExpenseListWidget(categoryExoenseModel.categorys,
                  categoryExpenseModelController),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(right: 300),
                child: Text(
                  "収入",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
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
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 350,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
        ),
        child: ListView(
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
                    child: Container(
                      child: ListTile(
                          leading: Icon(
                            IconData(category.icon!,
                                fontFamily: 'MaterialIcons'),
                            color: Color(category.color!),
                          ),
                          title: Text(category.category),
                          trailing: const Icon(Icons.arrow_left_sharp)),
                    )))
                .toList()),
      ),
    );
  }

  Widget _categoryIncomeListWidget(
      List<Category> list, CategoryIncomeModel model) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 350,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          child: ListView(
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
                              onPressed: (context) async {},
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
                              color: Color(category.color!),
                            ),
                            title: Text(category.category),
                            trailing: const Icon(Icons.arrow_left_sharp)),
                      ))
                  .toList()),
        ));
  }
}
