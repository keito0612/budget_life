import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedColorProvider = StateProvider.autoDispose((ref) => Colors.black);
final selectedIconProvider =
    StateProvider.autoDispose((ref) => Icons.restaurant);
final categoryProvider = StateProvider.autoDispose((ref) => "");

class categoryAddPage extends ConsumerWidget {
  categoryAddPage({super.key});

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
    Icons.local_gas_station
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(selectedColorProvider);
    final selectedIcon = ref.watch(selectedIconProvider);
    final category = ref.watch(categoryProvider);
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("カテゴリー"),
        actions: [_saveCategoryButtom(category, selectedIcon, selectedColor)],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _categoryTextField(ref),
                _selectedIconWithColor(selectedIcon, selectedColor),
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

  Widget _categoryTextField(WidgetRef ref) {
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
        ],
      ),
    );
  }

  Widget _selectedIconWithColor(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 200,
        height: 100,
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
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Wrap(
                spacing: 20.0,
                runSpacing: 20.0,
                children: colorList
                    .map((color) => _buildColorButton(color, ref))
                    .toList(),
              ),
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
      height: 430,
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
    );
  }

  Widget _saveCategoryButtom(String category, IconData icon, Color color) {
    return category != ""
        ? TextButton(
            onPressed: () {},
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
}
