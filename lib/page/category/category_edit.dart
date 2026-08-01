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
      backgroundColor: const Color(0xFFF5F7FA),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: _buildHeader(context, cupertinoSlidingValue, ref)),
            SliverToBoxAdapter(
                child: _buildContent(context, ref, cupertinoSlidingValue)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, int cupertinoSlidingValue, WidgetRef ref) {
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
              child: Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.edit, color: Colors.white, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'カテゴリー編集',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildSaveButton(cupertinoSlidingValue, ref, context),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
      int cupertinoSlidingValue, WidgetRef ref, BuildContext context) {
    final isEnabled = category != "";
    return GestureDetector(
      onTap: isEnabled
          ? () => addDialog(cupertinoSlidingValue, context, ref)
          : null,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: isEnabled ? 1.0 : 0.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          '保存',
          style: TextStyle(
            color: isEnabled
                ? const Color(0xFF00C853)
                : Colors.white.withValues(alpha: 0.5),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, int cupertinoSlidingValue) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildCategoryInputCard(cupertinoSlidingValue, ref),
          SizedBox(height: 16.h),
          _buildPreviewCard(),
          SizedBox(height: 16.h),
          _buildColorCard(ref),
          SizedBox(height: 16.h),
          _buildIconCard(ref),
        ],
      ),
    );
  }

  Widget _buildCategoryInputCard(int cupertinoSlidingValue, WidgetRef ref) {
    final categoryController = ref.read(categoryProvider.notifier);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'カテゴリー名',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A5568),
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              ),
              child: TextField(
                controller: categoryTextEditingController,
                style:
                    TextStyle(fontSize: 16.sp, color: const Color(0xFF2D3748)),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'カテゴリー名を入力',
                  hintStyle: TextStyle(
                      color: const Color(0xFFA0AEC0), fontSize: 16.sp),
                  contentPadding: EdgeInsets.all(16.w),
                ),
                onChanged: (category) {
                  categoryController.state = category;
                },
              ),
            ),
            SizedBox(height: 16.h),
            _buildSegmentControl(cupertinoSlidingValue, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentControl(int cupertinoSlidingValue, WidgetRef ref) {
    final cupertinoSlidingValueController =
        ref.read(cupertinoSlidingValueProvider.notifier);
    return Container(
      width: double.infinity,
      child: CupertinoSlidingSegmentedControl<int>(
        children: {
          0: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              "支出",
              style: TextStyle(
                color: cupertinoSlidingValue == 0
                    ? const Color(0xFF00C853)
                    : const Color(0xFF718096),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          1: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              "収入",
              style: TextStyle(
                color: cupertinoSlidingValue == 1
                    ? const Color(0xFF00C853)
                    : const Color(0xFF718096),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        },
        groupValue: cupertinoSlidingValue,
        onValueChanged: (index) {
          cupertinoSlidingValueController.state = index!;
        },
        thumbColor: Colors.white,
        backgroundColor: const Color(0xFFE8F5E9),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Text(
              'プレビュー',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A5568),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon!,
                size: 64.sp,
                color: color!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.palette,
                    color: const Color(0xFF00C853), size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'カラー',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.w,
              runSpacing: 12.h,
              children:
                  colorList.map((c) => _buildColorButton(c, ref)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorButton(Color buttonColor, WidgetRef ref) {
    final selectedColorController = ref.read(selectedColorProvider.notifier);
    final isSelected = selectedColorController.state == buttonColor;
    return GestureDetector(
      onTap: () {
        selectedColorController.state = buttonColor;
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: const Color(0xFF00C853), width: 3.w)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: buttonColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  Widget _buildIconCard(WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_emotions,
                    color: const Color(0xFF00C853), size: 24.sp),
                SizedBox(width: 8.w),
                Text(
                  'アイコン',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12.w,
              runSpacing: 12.h,
              children: iconList.map((i) => _buildIconButton(i, ref)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData iconData, WidgetRef ref) {
    final selectedIconController = ref.read(selectedIconProvider.notifier);
    final isSelected = selectedIconController.state == iconData;
    return GestureDetector(
      onTap: () {
        selectedIconController.state = iconData;
      },
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected
              ? Border.all(color: const Color(0xFF00C853), width: 2)
              : null,
        ),
        child: Icon(
          iconData,
          size: 28.sp,
          color: isSelected ? const Color(0xFF00C853) : const Color(0xFF718096),
        ),
      ),
    );
  }

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

  Future dialogResult(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle,
                  color: const Color(0xFF00C853), size: 24.sp),
              SizedBox(width: 8.w),
              const Text('完了'),
            ],
          ),
          content: Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: const Text('保存しました。'),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('OK', style: TextStyle(color: Color(0xFF00C853))),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future dialogError(String error, BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24.sp),
              SizedBox(width: 8.w),
              const Text('エラー'),
            ],
          ),
          content:
              Padding(padding: EdgeInsets.only(top: 12.h), child: Text(error)),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(context).pop())
          ],
        );
      },
    );
  }
}
