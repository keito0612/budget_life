import 'package:budget/model/category/category.dart';
import 'package:budget/page/input_page.dart';
import 'package:budget/viewModels/category_expense_model.dart';
import 'package:budget/viewModels/category_income_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          height: 1400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _categoryTextField(cupertinoSlidingValue, ref),
                _selectedIconWithColor(icon!, color!),
                const SizedBox(height: 8.0),
                _selectColorWidget(ref),
                const SizedBox(height: 20.0),
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
      width: 400,
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: categoryTextEditingController,
              decoration: const InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "カテゴリー"),
              onChanged: (category) {
                categoryController.state = category;
              },
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 2,
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
        width: 200,
        height: 130,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Icon(
            icon,
            size: 80,
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
      width: 300,
      child: CupertinoSlidingSegmentedControl(
        children: {
          0: Text(
            "支出",
            style: TextStyle(
              color: cupertinoSlidingValue == 0 ? Colors.green : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: "SFProRounded",
            ),
            textAlign: TextAlign.center,
          ),
          1: Text(
            "収入",
            style: TextStyle(
              color: cupertinoSlidingValue == 1 ? Colors.green : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              fontFamily: "SFProRounded",
            ),
            textAlign: TextAlign.center,
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
          size: 40.0,
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
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18.0),
          border: selectedColorController.state == color
              ? Border.all(color: Colors.white, width: 2.0)
              : null,
        ),
      ),
    );
  }

  Widget _selectColorWidget(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: Text(
                  "カラー",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
      height: 550,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 300,
              height: 30,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: Text(
                  "アイコン",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
            child: const Text(
              "保存",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ))
        : TextButton(
            onPressed: () {},
            child: Text(
              "保存",
              style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 20,
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
