class ScytaleCipher {
  static String encrypt(String text, int numRails) {
    text = text.replaceAll(' ', '');
    final length = text.length;
    final encryptedText = List<String>.filled(numRails, '');
    for (var i = 0; i < length; i++) {
      encryptedText[i % numRails] += text[i];
    }
    return encryptedText.join('');
  }

  static String decrypt(String text, int numRails) {
  final length = text.length;
  final numCols = (length / numRails).ceil();
  final decryptedText = List<String>.filled(numCols, '');
  for (var i = 0; i < length; i++) {
    decryptedText[i % numCols] += text[i];
  }

  
  for (var i = 0; i < decryptedText.length; i++) {
    decryptedText[i] = decryptedText[i].replaceAll(' ', '');
  }

  return decryptedText.join('');
}

}
