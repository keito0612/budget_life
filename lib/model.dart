class model {
  List<String> dateList = [
    "2022-01-01",
    "2022-01-02",
    "2022-01-03",
    "2022-01-04",
    "2022-01-05",
    "2022-01-06",
    "2022-01-07"
  ];
  Map<int, List<DateTime>> classifiedDate = {};
  void getSpendingDate() {
    if (dateList != null) {
      dateList.forEach((date) {
        DateTime dateTime = DateTime.parse(date);
        int weekDay = dateTime.weekday;
        if (classifiedDate.containsKey(weekDay)) {
          //配列の中に同じ曜日があったら、その曜日にデータを追加する
          classifiedDate[weekDay]!.add(dateTime);
        } else {
          //配列の中に同じ曜日がなかったら、新たに別の曜日にデータを入れる。
          classifiedDate[weekDay] = [dateTime];
        }
      });
    }
  }
}
