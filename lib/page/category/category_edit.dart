import 'package:budget/model/category/category.dart';
import 'package:budget/page/input/input_page.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class categoryEditPage extends ConsumerWidget {
  categoryEditPage({super.key, this.id, this.category, this.icon, this.color}) {
    categoryTextEditingController.text = category!;
  }

  late final selectedColorProvider = StateProvider.autoDispose((ref) => color);
  late final selectedIconProvider = StateProvider.autoDispose((ref) => icon);
  late final categoryProvider = StateProvider.autoDispose((ref) => category);

  final List<Color> colorList = [
    Colors.black,
    Colors.green,
    Colors.greenAccent,
    Colors.red,
    Colors.redAccent,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.pinkAccent,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Colors.blue,
    Colors.blueAccent,
    Colors.indigo,
    Colors.lime,
    Colors.cyan,
  ];

  final List<IconData> iconList = [
    Icons.restaurant,
    Icons.brunch_dining,
    Icons.fastfood,
    Icons.monetization_on,
    Icons.shopping_cart,
    Icons.sports_basketball,
    Icons.sports_esports,
    Icons.local_cafe,
    Icons.music_note,
    Icons.tram,
    Icons.pets,
    Icons.airplanemode_active,
    Icons.laptop,
    Icons.call,
    Icons.phone_iphone,
    Icons.store,
    Icons.payment,
    Icons.redeem,
    Icons.keyboard_alt,
    Icons.ac_unit,
    Icons.import_contacts,
    Icons.edit,
    Icons.tv,
    Icons.single_bed,
    Icons.cloud,
    Icons.school,
    Icons.local_taxi,
    Icons.set_meal,
    Icons.local_hospital,
    Icons.water_drop,
    Icons.camera_alt,
    Icons.fitness_center,
    Icons.directions_run,
    Icons.currency_bitcoin,
    Icons.tungsten,
    Icons.local_gas_station,
    Icons.home,
    Icons.coffee,
    Icons.savings,
    Icons.pedal_bike,
    Icons.favorite,
    Icons.content_cut_outlined,
    Icons.local_fire_department
  ];
  int? id;
  String? category;
  Color? color;
  IconData? icon;
  TextEditingController categoryTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cupertinoSlidingValue = ref.watch(cupertinoSlidingValueProvider);
    color = ref.watch(selectedColorProvider);
    icon = ref.watch(selectedIconProvider);
    category = ref.watch(categoryProvider);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("編集"),
        actions: [
          _saveCategoryButtom(
              cupertinoSlidingValue, category!, icon!, color!, ref, context),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1400.h,
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _categoryTextField(cupertinoSlidingValue, ref),
                _selectedIconWithColor(icon!, color!),
                SizedBox(height: 8.0.h),
                _selectColorWidget(ref),
                SizedBox(height: 20.0.h),
                _selectIconsWidget(ref)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryTextField(int cupertinoSliderValue, WidgetRef ref) {
    final categoryController = ref.read(categoryProvider.notifier);
    return Container(
      width: 400.w,
      height: 120.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: TextField(
              style: TextStyle(fontSize: 20.sp),
              cursorHeight: 20.sp,
              controller: categoryTextEditingController,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20.sp),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "カテゴリー",
                hintStyle: TextStyle(fontSize: 20.sp),
              ),
              onChanged: (category) {
                categoryController.state = category;
              },
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2.h,
            height: 1.h,
            indent: 20.h,
            endIndent: 20.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: _cupertinoSlidingWidget(cupertinoSliderValue, ref),
          )
        ],
      ),
    );
  }

  Widget _selectedIconWithColor(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200.w,
        height: 130.h,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            icon,
            size: 80.sp,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _cupertinoSlidingWidget(int cupertinoSlidingValue, WidgetRef ref) {
    final cupertinoSlidingValueController =
        ref.read(cupertinoSlidingValueProvider.notifier);
    return SizedBox(
      width: 300.w,
      height: 40.h,
      child: CupertinoSlidingSegmentedControl(
        children: {
          0: Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              "支出",
              style: TextStyle(
                color: cupertinoSlidingValue == 0 ? Colors.green : Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                fontFamily: "SFProRounded",
              ),
              textAlign: TextAlign.center,
            ),
          ),
          1: Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: Text(
              "収入",
              style: TextStyle(
                color: cupertinoSlidingValue == 1 ? Colors.green : Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                fontFamily: "SFProRounded",
              ),
              textAlign: TextAlign.center,
            ),
          ),
        },
        groupValue: cupertinoSlidingValue,
        onValueChanged: (index) {
          cupertinoSlidingValueController.state = index!;
        },
        thumbColor: Colors.white,
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, WidgetRef ref) {
    final selectedIconController = ref.read(selectedIconProvider.notifier);
    return InkWell(
      onTap: () {
        selectedIconController.state = iconData;
      },
      child: Icon(iconData,
          size: 40.0.sp,
          color: selectedIconController.state == iconData
              ? Colors.green
              : Colors.black),
    );
  }

  Widget _buildColorButton(Color color, WidgetRef ref) {
    final selectedColorController = ref.read(selectedColorProvider.notifier);
    return InkWell(
      onTap: () {
        selectedColorController.state = color;
      },
      child: Container(
        width: 40.0.w,
        height: 40.0.h,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selectedColorController.state == color
              ? Border.all(color: Colors.white, width: 2.0.w)
              : null,
        ),
      ),
    );
  }

  Widget _selectColorWidget(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Container(
              width: 300.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30.r)),
              child: Center(
                child: Text(
                  "カラー",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: colorList
                        .map((color) => _buildColorButton(color, ref))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectIconsWidget(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300.w,
              height: 30.h,
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(30.r)),
              child: Center(
                child: Text(
                  "アイコン",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: iconList
                          .map((icon) => _buildIconButton(icon, ref))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _saveCategoryButtom(int cupertinoSliderValue, String category,
      IconData icon, Color color, WidgetRef ref, BuildContext context) {
    return category != ""
        ? TextButton(
            onPressed: () {
              addDialog(cupertinoSliderValue, context, ref);
            },
            child: Text(
              "保存",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ))
        : TextButton(
            onPressed: () {},
            child: Text(
              "保存",
              style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold),
            ),
          );
  }

  //追加ダイアログ
  Future addDialog(
      int cupertinoSliderValue, BuildContext context, WidgetRef ref) async {
    final categoryExpenseModel =
        ref.read(categoryExpenseModelProvider.notifier);
    final categoryIncomeModel = ref.watch(categoryIncomeModelProvider.notifier);
    final categoryData = Category(
        id: id,
        category: category!,
        color: color!.value,
        icon: icon!.codePoint);

    try {
      cupertinoSliderValue == 0
          ? await categoryExpenseModel.updateCategory(categoryData)
          : await categoryIncomeModel.updateCategory(categoryData);
      await dialogResult(context);
    } on Exception catch (e) {
      await dialogError(e.toString(), context);
    } catch (e) {
      await dialogError(e.toString(), context);
    }
  }

  //成功した時のダイアログー
  Future dialogResult(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('保存しました。'),
          content: const Text(''),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  //エラーダイアログ
  Future dialogError(String error, BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.red,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("エラーが発生しました"),
              )
            ],
          ),
          content: Column(
            children: [
              Text(error),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
