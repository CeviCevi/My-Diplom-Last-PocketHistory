class DateFormatterService {
  static String getGreatDate(String date) {
    final DateTime data = DateTime.parse(date);

    final day = data.day.toString().padLeft(2, '0');
    final month = data.month.toString().padLeft(2, '0');
    final year = data.year.toString();

    return "$day.$month.$year";
  }
}
