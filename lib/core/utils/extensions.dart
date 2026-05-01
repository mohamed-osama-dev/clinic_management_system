extension StringX on String {
  bool get isBlank => trim().isEmpty;
}

extension DateTimeX on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
}
