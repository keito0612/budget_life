import 'package:budget/model/category/category.dart';
import 'package:budget/page/category/category_setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final categoryExpenseIndexProvider = StateProvider.autoDispose((ref) {
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
          onPressed: () async {
            await showBottomModelSheet(
                context, categorys!, ref, onSelectedItemChanged);
          },
          icon: Icon(Icons.arrow_downward, size: 28.sp)),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 240.w),
                          child: Text(
                            "閉じる",
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.green),
                          ),
                        ),
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
                          child: Text(
                            "編集",
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.green),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 170.h,
                  child: CupertinoPicker(
                    itemExtent: 40.sp,
                    children: categorys
                        .map((category) => SizedBox(
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                    ),
                                    Icon(
                                      IconData(category.icon!,
                                          fontFamily: 'MaterialIcons'),
                                      color: Color(category.color!),
                                      size: 30.sp,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          15,
                                    ),
                                    Text(
                                      category.category,
                                      style: TextStyle(fontSize: 25.sp),
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
