import 'dart:math';

class EncryptionHelper {
  /// ✅ Custom String Encryption
  static String encryptString(String input) {
    try {
      int inputLen = input.length;
      int randKey = Random().nextInt(9) + 1; // Generate random key between 1-9

      List<int> inputChr = List<int>.filled(inputLen, 0);

      // Modify characters based on the random key
      for (int i = 0; i < inputLen; i++) {
        inputChr[i] = input.codeUnitAt(i) - randKey;
      }

      // Convert encrypted characters to string
      StringBuffer sb = StringBuffer();
      for (int i in inputChr) {
        sb.write('$i  a');
      }

      // Append encoded key at the end
      sb.write((randKey.toString().codeUnitAt(0)) + 50);

      return sb.toString();
    } catch (e) {
      return "";
    }
  }

  /// ✅ Custom String Decryption
  static String decryptString(String encryptedInput) {
    try {
      List<String> parts = encryptedInput.split('  a');
      if (parts.length < 2) return "";

      // Extract the encoded key from the last part
      int encodedKey = int.parse(parts.last);
      int randKey = encodedKey - 50;

      // Remove the last part (random key)
      parts.removeLast();

      // Convert back to original characters
      StringBuffer sb = StringBuffer();
      for (String part in parts) {
        int originalChar = int.parse(part) + randKey;
        sb.write(String.fromCharCode(originalChar));
      }

      return sb.toString();
    } catch (e) {
      return "";
    }
  }
}
