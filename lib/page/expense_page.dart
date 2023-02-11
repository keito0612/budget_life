import 'package:budget/model/expense.dart';
import 'package:budget/widgets/bottom_sheet_dar.dart';
import 'package:budget/widgets/dateBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final amountProvider = StateProvider.autoDispose((ref) => "");
final memoProvider = StateProvider.autoDispose((ref) => "");

class ExpensePage extends ConsumerWidget {
  ExpensePage({super.key});

  List<String> categoryList = ["交際費", "衣服"];
  String category = "";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Column(children: <Widget>[
        dateBarWidget(),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              width: 380,
              height: 300,
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
              child: Column(
                  children: [amountTextField(ref), categoryBar(context, ref)])),
        )
      ]),
    );
  }

  Widget amountTextField(WidgetRef ref) {
    final amount = ref.watch(amountProvider);
    final amountController = ref.read(amountProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Container(
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
                onChanged: (amount) {
                  amountController.state = amount;
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
    );
  }

  Widget categoryBar(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Container(
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
            Expanded(flex: 2, child: Text(category)),
            Expanded(
                child: IconButton(
                    onPressed: () {
                      bottomSheetBar.showModalPicker(
                          categoryList, context, ref);
                    },
                    icon: Icon(Icons.arrow_downward)))
          ])),
    );
  }
}
