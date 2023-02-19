import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Util {
  static String toDate(DateTime dateTime) {
    initializeDateFormatting('jp');
    final time = DateFormat.yMMMMEEEEd('ja').format(dateTime);
    return time;
  }

  static DateTime convartDate(String date) {
    initializeDateFormatting('jp');
    final time = DateFormat.yMMMMEEEEd('ja').parse(date);
    return time;
  }
}
