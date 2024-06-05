import 'dart:core';

List<List<String>> generateKeySquare(String key) {
  key = key.replaceAll('j', 'i').toUpperCase();
  String alphabet = "ABCDEFGHIKLMNOPQRSTUVWXYZ";
  String keyString = '';

  for (int i = 0; i < key.length; i++) {
    if (!keyString.contains(key[i])) {
      keyString += key[i];
    }
  }

  for (int i = 0; i < alphabet.length; i++) {
    if (!keyString.contains(alphabet[i])) {
      keyString += alphabet[i];
    }
  }

  List<List<String>> keySquare = List.generate(5, (i) => List.filled(5, ''));
  int k = 0;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      keySquare[i][j] = keyString[k];
      k++;
    }
  }

  return keySquare;
}

String preprocessText(String text) {
  text = text.replaceAll('j', 'i').toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
  StringBuffer cleanedText = StringBuffer();

  for (int i = 0; i < text.length; i++) {
    if (i < text.length - 1 && text[i] == text[i + 1]) {
      cleanedText.write(text[i]);
      cleanedText.write('X');
    } else {
      cleanedText.write(text[i]);
    }
  }

  if (cleanedText.length % 2 != 0) {
    cleanedText.write('X');
  }

  return cleanedText.toString();
}

List<int>? findPosition(String char, List<List<String>> keySquare) {
  if (char == 'J') {
    char = 'I';
  }
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (keySquare[i][j] == char) {
        return [i, j];
      }
    }
  }
  return null; // Should never reach here if the key square is correctly generated
}


String encryptPair(String pair, List<List<String>> keySquare) {
  List<int>? pos1 = findPosition(pair[0], keySquare);
  List<int>? pos2 = findPosition(pair[1], keySquare);

  if (pos1 != null && pos2 != null) {
    if (pos1[0] == pos2[0]) {
      return keySquare[pos1[0]][(pos1[1] + 1) % 5] + keySquare[pos2[0]][(pos2[1] + 1) % 5];
    } else if (pos1[1] == pos2[1]) {
      return keySquare[(pos1[0] + 1) % 5][pos1[1]] + keySquare[(pos2[0] + 1) % 5][pos2[1]];
    } else {
      return keySquare[pos1[0]][pos2[1]] + keySquare[pos2[0]][pos1[1]];
    }
  } else {
    throw ArgumentError('Invalid pair: $pair');
  }
}


String decryptPair(String pair, List<List<String>> keySquare) {
  if (pair.length != 2) {
    throw ArgumentError('Invalid pair: $pair');
  }

  List<int>? pos1 = findPosition(pair[0], keySquare);
  List<int>? pos2 = findPosition(pair[1], keySquare);

  if (pos1 != null && pos2 != null) {
    if (pos1[0] == pos2[0]) {
      return keySquare[pos1[0]][(pos1[1] - 1 + 5) % 5] + keySquare[pos2[0]][(pos2[1] - 1 + 5) % 5];
    } else if (pos1[1] == pos2[1]) {
      return keySquare[(pos1[0] - 1 + 5) % 5][pos1[1]] + keySquare[(pos2[0] - 1 + 5) % 5][pos2[1]];
    } else {
      return keySquare[pos1[0]][pos2[1]] + keySquare[pos2[0]][pos1[1]];
    }
  } else {
    throw ArgumentError('Invalid pair: $pair');
  }
}

class PlayfairEncryption {
  static String encrypt(String plaintext, String key) {
    List<List<String>> keySquare = generateKeySquare(key);
    String cleanedText = preprocessText(plaintext);

    StringBuffer encryptedText = StringBuffer();
    for (int i = 0; i < cleanedText.length; i += 2) {
      String pair = cleanedText.substring(i, i + 2);
      encryptedText.write(encryptPair(pair, keySquare));
    }

    return encryptedText.toString();
  }
}


class PlayfairDecryption {
  static String decrypt(String ciphertext, String key) {
    List<List<String>> keySquare = generateKeySquare(key);

    StringBuffer decryptedText = StringBuffer();
    for (int i = 0; i < ciphertext.length; i += 2) {
      String pair = ciphertext.substring(i, i + 2);
      decryptedText.write(decryptPair(pair, keySquare));
    }

    return decryptedText.toString();
  }
}
