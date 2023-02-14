import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Util {
  static String toDate(DateTime dateTime) {
    initializeDateFormatting('jp');
    final time = DateFormat('yyyy/MM/dd(E) HH:mm', "ja").format(dateTime);
    return time;
  }
}
