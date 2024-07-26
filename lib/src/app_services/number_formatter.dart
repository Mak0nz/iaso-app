class NumberFormatter {
  static String formatDouble(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    } else {
      return value.toString();
    }
  }
}