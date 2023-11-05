
import 'package:budget/provider/ad_banner_provider.dart';
import 'package:budget/utils/util.dart';
import 'package:budget/widgets/dateBar_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final chartDateProvider =
    StateNotifierProvider.autoDispose<ChartDateNotifier,DateTime>(
        (ref) => ChartDateNotifier());

class ChartDateNotifier extends StateNotifier<DateTime> {
  ChartDateNotifier() : super(DateTime.now());
    void incrementChartDate() {
      initializeDateFormatting("ja");
      final nextDay =  DateTime(state.year,state.month + 1);
      state = nextDay;
    }

    void decrementDate() {
      initializeDateFormatting("ja");
      final previousDay  =  DateTime(state.year,state.month - 1);
      state = previousDay;
  }
}