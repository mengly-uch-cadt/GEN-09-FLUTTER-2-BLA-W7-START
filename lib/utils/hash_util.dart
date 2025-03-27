import 'dart:math';

class HashUtil {
  static String generateGlobalId() {
    final random = Random();

    // Generate three random uppercase letters.
    final letters = String.fromCharCodes(
      List.generate(3, (_) => 65 + random.nextInt(26)),
    );

    // Generate 12 digits based on the current milliseconds.
    final milliseconds = DateTime.now().millisecondsSinceEpoch;
    final modValue = 1000000000000; // 10^12
    final digits = (milliseconds % modValue).toString().padLeft(12, '0');

    // Combine letters, a '+' sign, and the digits.
    return '$letters+$digits';
  }
}