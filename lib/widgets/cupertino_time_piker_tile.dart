import 'package:budget/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CupertinoTimePikerTile extends ConsumerWidget {
  CupertinoTimePikerTile(
      {required this.title,
      required this.time,
      required this.onDateTimeChanged});

  final String title;
  final String time;
  final void Function(DateTime) onDateTimeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Ink(
      child: ListTile(
        onTap: () {
          _showCupertinoDatePicker(context);
        },
        tileColor: Colors.white,
        title: Row(
          children: [
            Text(title),
            const SizedBox(width: 190),
            Text(time, style: const TextStyle(fontSize: 20))
          ],
        ),
      ),
    );
  }

  void _showCupertinoDatePicker(BuildContext context) {
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
                    child: const Text(
                      "閉じる",
                      style: TextStyle(fontSize: 20),
                    )),
                SizedBox(
                    height: 200,
                    child: CupertinoDatePicker(
                        initialDateTime: Util.convartDateToTime(time),
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.time,
                        onDateTimeChanged: onDateTimeChanged)),
              ],
            ),
          ),
        );
      },
    );
  }
}
