import 'package:budget/main.dart';
import 'package:budget/model/balance_with_saving/balance_with_saving.dart';
import 'package:budget/page/balance_saving/balance_savingings_settings_page.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:budget/widgets/hp_gauge3_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageCotroller = ref.read(selectedPageProvider.notifier);
    final model = ref.watch(balanceWithSavingModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            "ホーム",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.settings,
                size: 25.sp,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BalanceSavingSettingsPage()));
              },
            ),
          ],
          backgroundColor: Colors.green),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: Container(
                height: 630.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(700.r),
                  ),
                )),
          ),
          Column(
            children: [
              dateBarWidget(
                model.date,
              ),
              balanseWithSaving(ref, model),
              //メニューボタン
            ],
          ),
        ],
      ),
    );
  }

  Widget dateBarWidget(String date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50.h,
        child: Center(
          child: Text(
            date,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.sp,
                color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget balanseWithSaving(WidgetRef ref, BalanceWithSaving model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: itemLabel('残高ゲージ'),
        ),
        //残高ゲージ
        Padding(
          padding: EdgeInsets.only(top: 5.0.h),
          child: HpGauge3Color(
              title: "残高",
              currentAmount: model.remainingBalance,
              maxAmount: model.balance),
        ),
        Padding(
          padding: EdgeInsets.only(right: 0.w, top: 30.h),
          child: itemLabel('貯金ゲージ'),
        ),
        //貯金ゲージ
        Padding(
          padding: EdgeInsets.only(top: 5.0.h),
          child: HpGauge3Color(
              title: "貯金",
              currentAmount: model.remainingSaving,
              maxAmount: model.saving),
        ),
      ],
    );
  }

  Widget itemLabel(String item) {
    return Text(item,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.sp,
            color: Colors.lightGreen));
  }
}
