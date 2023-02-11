import 'package:budget/model/expense.dart';
import 'package:budget/widgets/bottom_sheet_dar.dart';
import 'package:budget/widgets/dateBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final amountProvider = StateProvider.autoDispose((ref) => "");
final memoProvider = StateProvider.autoDispose((ref) => "");

class ExpensePage extends ConsumerWidget {
  ExpensePage({super.key});

  List<String> categoryList = ["交際費", "衣服"];
  String amount = "";
  String memo = "";
  String category = "";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(children: <Widget>[
        dateBarWidget(),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              width: 380,
              height: 450,
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(50)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Column(children: [
                amountTextField(ref, "支出"),
                categoryBar(context, ref, "カテゴリー"),
                memoTextField("メモ")
              ])),
        )
      ]),
    );
  }

  Widget itemLabel(String itemName) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Container(
        width: double.infinity,
        child: Text(itemName,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
    );
  }

  Widget amountTextField(WidgetRef ref, String itemName) {
    amount = ref.watch(amountProvider);
    final amountController = ref.read(amountProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
            height: 60,
            width: 320,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(flex: 1, child: Icon(Icons.currency_yen)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    onChanged: (amountText) {
                      amountController.state = amountText;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "支出",
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

  Widget categoryBar(BuildContext context, WidgetRef ref, String itemName) {
    final categoryIndex = ref.watch(categoryIndexProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
              height: 60,
              width: 320,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 4.0,
                    spreadRadius: 4.0,
                  ),
                ],
              ),
              child: Row(children: <Widget>[
                const SizedBox(width: 15),
                const Icon(Icons.category),
                const SizedBox(width: 20),
                Expanded(
                  flex: 8,
                  child: Text(categoryList[categoryIndex],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                Expanded(
                  flex: 3,
                  child: IconButton(
                      onPressed: () {
                        bottomSheetBar.showModalPicker(
                            categoryList, context, ref);
                      },
                      icon: Icon(Icons.arrow_downward)),
                )
              ])),
        ],
      ),
    );
  }

  Widget memoTextField(String itemName) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          itemLabel(itemName),
          Container(
            height: 60,
            width: 320,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  spreadRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Expanded(flex: 1, child: Icon(Icons.edit)),
                Expanded(
                  flex: 5,
                  child: TextField(
                    style: TextStyle(fontSize: 20),
                    onChanged: (memoText) {
                      memo = memoText;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "メモ",
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
}
