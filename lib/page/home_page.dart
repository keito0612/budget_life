import 'package:budget/main.dart';
import 'package:budget/model.dart';
import 'package:budget/model/balance_with_saving.dart';

import 'package:budget/page/balance_savingings_settings_page.dart';

import 'package:budget/utils/util.dart';
import 'package:budget/viewModels/balance_with_saving_model.dart';
import 'package:budget/widgets/hp_gauge3_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPageCotroller = ref.read(selectedPageProvider.notifier);
    final model = ref.watch(balanceWithSavingModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text("ホーム"),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
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
            padding: const EdgeInsets.only(top: 100),
            child: Container(
                height: 545,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(700),
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
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        selectedPageCotroller.state = 1;
                      },
                      child: const Text(
                        '入力',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(80, 80),
                        shape: const CircleBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          selectedPageCotroller.state = 2;
                        },
                        child: const Text(
                          'リスト',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(80, 80),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          selectedPageCotroller.state = 3;
                        },
                        child: const Text(
                          '設定',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(80, 80),
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
        height: 50,
        child: Center(
          child: Text(
            date,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget balanseWithSaving(WidgetRef ref, BalanceWithSaving model) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 250, top: 30),
          child: itemLabel('残高ゲージ'),
        ),
        //残高ゲージ
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: HpGauge3Color(
              title: "残高",
              currentAmount: model.remainingBalance,
              maxAmount: model.balance),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 250, top: 30),
          child: itemLabel('貯金ゲージ'),
        ),
        //貯金ゲージ
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
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
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.lightGreen));
  }
}
