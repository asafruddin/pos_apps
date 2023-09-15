import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyFormater extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    throw UnimplementedError();
  }
}

extension NumX on num {
  /// when [withSymbol] is false remove "Rp" in front of number
  String toCurrencyFormatted({
    bool withSymbol = true,
    int decimalDigits = 0,
  }) {
    num number = this;
    if (decimalDigits == 0) {
      number = roundToDouble();
    }
    return NumberFormat.currency(
      locale: 'id',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: decimalDigits,
    ).format(number);
  }
}

extension StringX on String {
  String removeFormatCurrency() {
    return toLowerCase().replaceAll(RegExp(r'[rp. ]'), '');
  }
}
