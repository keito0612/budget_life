import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryIndexProvider = StateProvider.autoDispose((ref) {
  return 0;
});

class bottomSheetBar {
  static void showModalPicker(
      List<String> listItem, BuildContext context, WidgetRef ref) {
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
                TextButton(
                    style: TextButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "閉じる",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(width: 230),
                        TextButton(
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          onPressed: () {},
                          child: const Text(
                            "閉じる",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 200,
                  child: CupertinoPicker(
                    itemExtent: 40,
                    children:
                        listItem.map((item) => Text(item.toString())).toList(),
                    onSelectedItemChanged: (index) {
                      ref.read(categoryIndexProvider.notifier).state = index;
                    },
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
