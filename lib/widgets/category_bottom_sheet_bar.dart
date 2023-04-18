import 'package:budget/model/category/category.dart';
import 'package:budget/page/category/category_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryExpenseIndexProvide = StateProvider.autoDispose((ref) {
  return 0;
});
final categoryIncomeIndexProvider = StateProvider.autoDispose((ref) => 0);

class categoryBottomSheetBarButtom extends ConsumerWidget {
  categoryBottomSheetBarButtom(
      {required this.categorys,
      required this.onSelectedItemChanged,
      super.key});
  int? pageIndex;
  List<Category>? categorys;

  final void Function(int index) onSelectedItemChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 3,
      child: IconButton(
          onPressed: () {
            showBottomModelSheet(
                context, categorys!, ref, onSelectedItemChanged);
          },
          icon: const Icon(Icons.arrow_downward)),
    );
  }

  showBottomModelSheet(BuildContext context, List<Category> categorys,
      WidgetRef ref, Function(int index) onSelectedItemChanged) async {
    return await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Column(
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            "閉じる",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 245),
                        TextButton(
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CategorySettingPage()),
                            );
                          },
                          child: const Text(
                            "編集",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    children: categorys
                        .map((category) => SizedBox(
                              height: 60,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Icon(
                                          IconData(category.icon!,
                                              fontFamily: 'MaterialIcons'),
                                          color: Color(category.color!)),
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Text(category.category),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                    onSelectedItemChanged: onSelectedItemChanged,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
