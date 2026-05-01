import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static String format(DateTime dateTime, {String pattern = 'yMMMd'}) {
    return DateFormat(pattern).format(dateTime);
  }
}
