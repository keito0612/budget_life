import 'package:budget/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final dateProvider = StateProvider.autoDispose((ref) {
  DateTime toDay = DateTime.now();
  initializeDateFormatting("ja");
  final formattedDate = DateFormat.yMMMMEEEEd('ja').format(toDay);
  return formattedDate;
});

class dateBarWidget extends ConsumerWidget {
  dateBarWidget({
    super.key,
  });

  DateTime _toDay = DateTime.now();
  //翌日
  void _incrementDate(WidgetRef ref) {
    initializeDateFormatting("ja");
    _toDay = _toDay.add(const Duration(days: 1));
    final nextDay = _toDay;
    final formattedDate = DateFormat.yMMMMEEEEd('ja').format(nextDay);
    ref.read(dateProvider.notifier).state = formattedDate;
  }

  //前日
  void _decrementDate(WidgetRef ref) {
    initializeDateFormatting("ja");
    _toDay = _toDay.add(const Duration(days: 1) * -1);
    final previousDay = _toDay;
    final formattedDate = DateFormat.yMMMMEEEEd('ja').format(previousDay);
    ref.read(dateProvider.notifier).state = formattedDate;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(dateProvider);
    final dateController = ref.read(dateProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 12, right: 12, left: 12),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.green,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(2.0, 2.0),
              blurRadius: 4.0,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Container(
                child: const Text(
                  "日付",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            TextButton(
                child: Text(date,
                    style: const TextStyle(fontSize: 25, color: Colors.white)),
                onPressed: () async {
                  await showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        '閉じる',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.green),
                                      )),
                                ),
                                Expanded(
                                  child: CupertinoDatePicker(
                                    backgroundColor: Colors.white,
                                    initialDateTime: _toDay,
                                    mode: CupertinoDatePickerMode.date,
                                    minimumDate: _toDay,
                                    maximumDate: DateTime.utc(2100, 12, 30),
                                    onDateTimeChanged: (value) {
                                      dateController.state = Util.toDate(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ));
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 220),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        _decrementDate(ref);
                      },
                      child: const Text("昨日",
                          style: TextStyle(fontSize: 15, color: Colors.white))),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      _incrementDate(ref);
                    },
                    child: const Text("翌日",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
