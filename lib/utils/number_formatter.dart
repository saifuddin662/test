class NumberFormatter {

  static double stringToDouble(String amount) {
    double parsedNumber = double.tryParse(amount)!;
    return parsedNumber;
  }

  static double parseOnlyDouble(String amount) {
    double parsedNumber = double.tryParse(amount.replaceAll(RegExp('[^0-9\.]'), '')) ?? 0.0;
    return parsedNumber;
  }

}