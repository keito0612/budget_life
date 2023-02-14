import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final dateProvider = StateProvider((ref) {
  DateTime toDay = DateTime.now();
  initializeDateFormatting("ja");
  final formattedDate = DateFormat.yMMMMEEEEd('ja').format(toDay);
  return formattedDate;
});

class dateBarWidget extends ConsumerWidget {
  dateBarWidget({super.key});
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
              padding: const EdgeInsets.only(bottom: 5),
              child: Container(
                child: const Text(
                  "日付",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Text(date,
                style: const TextStyle(fontSize: 25, color: Colors.white)),
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
                        side: BorderSide(color: Colors.white, width: 3),
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
                      side: BorderSide(color: Colors.white, width: 3),
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
