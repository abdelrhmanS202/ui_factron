/// Utility methods for formatting currency (EGP), numbers, percentages, and dates in Arabic/Egyptian style.
class AppFormatters {
  /// Formats currency with commas and EGP suffix in Arabic (ج.م)
  static String formatCurrency(double amount) {
    final String formatted = formatNumber(amount);
    return '$formatted ج.م';
  }

  /// Formats double/int with commas
  static String formatNumber(num number) {
    final parts = number.toStringAsFixed(number is int || number % 1 == 0 ? 0 : 2).split('.');
    final regex = RegExp(r'\B(?=(\d{3})+(?!\d))');
    parts[0] = parts[0].replaceAll(regex, ',');
    return parts.join('.');
  }

  /// Formats percentage
  static String formatPercent(double percent) {
    return '${percent.toStringAsFixed(1)}%';
  }

  /// Formats DateTime to YYYY-MM-DD
  static String formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Formats DateTime with time
  static String formatDateTime(DateTime date) {
    final dateStr = formatDate(date);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$dateStr $hour:$minute';
  }
}
