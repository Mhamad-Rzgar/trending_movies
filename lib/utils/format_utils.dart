import 'package:intl/intl.dart';

/// Formats an integer amount as currency.
///
/// [amount] is the amount to be formatted.
/// Returns a formatted currency string or 'N/A' if the amount is null.
String formatCurrency(int? amount) {
  final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
  return amount != null ? formatter.format(amount) : 'N/A';
}
