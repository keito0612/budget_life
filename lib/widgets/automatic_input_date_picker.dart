import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AutomaticInputDatePicker {
  static void showModalPicker(
      BuildContext context, Function(String) selectedItem) {
    final List<String> items = [
      '月の始まり',
      '月の終わり',
      '毎月1日',
      '毎月2日',
      '毎月3日',
      '毎月4日',
      '毎月5日',
      '毎月6日',
      '毎月7日',
      '毎月8日',
      '毎月9日',
      '毎月10日',
      '毎月11日',
      '毎月12日',
      '毎月13日',
      '毎月14日',
      '毎月15日',
      '毎月16日',
      '毎月17日',
      '毎月18日',
      '毎月19日',
      '毎月20日',
      '毎月21日',
      '毎月22日',
      '毎月23日',
      '毎月24日',
      '毎月25日',
      '毎月26日',
      '毎月27日',
      '毎月29日',
      '毎月30日',
    ];
    showModalBottomSheet<void>(
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "戻る",
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    onSelectedItemChanged: (index) {
                      selectedItem(items[index]);
                    },
                    itemExtent: 40,
                    children: items.map((item) => Text(item)).toList(),
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
