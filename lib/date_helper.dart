import 'package:intl/intl.dart';

class DateHelper {
  static DateTime timestampToDate(int timestamp) =>
      new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
}
