import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Util {
  static String toDate(DateTime dateTime) {
    initializeDateFormatting('jp');
    final time = DateFormat.yMMMMEEEEd('ja').format(dateTime);
    return time;
  }

  static String toTime(DateTime dateTime) {
    initializeDateFormatting('jp');
    final time = DateFormat.Hm('ja').format(dateTime);
    return time;
  }

  static DateTime convartDate(String date) {
    initializeDateFormatting('jp');
    final time = DateFormat.yMMMMEEEEd('ja').parse(date);
    return time;
  }

  static DateTime convartDateToTime(String date) {
    initializeDateFormatting('jp');
    final time = DateFormat.Hm('ja').parse(date);
    return time;
  }
  static String toDate2(DateTime dateTime){
    initializeDateFormatting('jp');
    final toDate = DateFormat.yMMMMEEEEd('ja').format(dateTime);
    final date = DateFormat.yMMMMEEEEd('ja').parse(toDate);
    return "${date.year}年${date.month}月";
  }
}
