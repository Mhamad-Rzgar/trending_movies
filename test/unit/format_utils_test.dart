import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:trending_movies/utils/format_utils.dart';

void main() {
  group('formatCurrency', () {
    /// Tests that an integer amount is correctly formatted as currency.
    test('formats integer amount as currency', () {
      const amount = 1000;
      final formatted = formatCurrency(amount);
      final expected =
          NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
      expect(formatted, expected);
    });

    /// Tests that a null amount returns "N/A".
    test('returns "N/A" for null amount', () {
      final formatted = formatCurrency(null);
      expect(formatted, 'N/A');
    });

    /// Tests that zero is correctly formatted as currency.
    test('formats zero amount as currency', () {
      const amount = 0;
      final formatted = formatCurrency(amount);
      final expected =
          NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
      expect(formatted, expected);
    });

    /// Tests that a negative amount is correctly formatted as currency.
    test('formats negative amount as currency', () {
      const amount = -500;
      final formatted = formatCurrency(amount);
      final expected =
          NumberFormat.simpleCurrency(decimalDigits: 0).format(amount);
      expect(formatted, expected);
    });
  });
}
