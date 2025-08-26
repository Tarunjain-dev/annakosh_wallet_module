import "package:get/get.dart";
import "package:money_formatter/money_formatter.dart";

class WalletController extends GetxController {
  var coins = 0.obs;

  /// -- Increment coins
  void plus250() => coins.value = coins.value + 250;

  /// -- Decrement coins
  void minus250() => coins.value = coins.value - 250;

  /// -- Reset coins
  void reset() => coins.value = 0;

  /// -- Reset coins
  void twoX() => coins.value = coins.value * 2;

  /// -- getCoins
  String getCoins() {
    double coin = coins.value.toDouble();
    return _formatIndianCurrency(coin);
  }

  /// -- Rupee Formatter (Western style, used for decimals/symbol if needed)
  MoneyFormatter rupeeFormatter(double amount) {
    return MoneyFormatter(
      amount: amount,
      settings: MoneyFormatterSettings(
        symbol: '₹',
        thousandSeparator: ',',
        decimalSeparator: '.',
        fractionDigits: 2,
        compactFormatType: CompactFormatType.short,
      ),
    );
  }

  /// -- Custom Indian Comma Placement
  String _formatIndianCurrency(double amount) {
    String value = amount.toStringAsFixed(0);

    String result = "";
    int counter = 0;

    for (int i = value.length - 1; i >= 0; i--) {
      result = value[i] + result;
      counter++;

      if (i > 0) {
        if (counter == 3) {
          result = "," + result;
        } else if (counter > 3 && (counter - 3) % 2 == 0) {
          result = "," + result;
        }
      }
    }

    return "₹$result";
  }

}