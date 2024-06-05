import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class AES_CBC_Encryption {
  static Uint8List encrypt(String plaintext, Uint8List key, Uint8List iv) {
    final plainData = Uint8List.fromList(utf8.encode(plaintext));
    final cipher = CBCBlockCipher(AESFastEngine());
    final params = ParametersWithIV(KeyParameter(key), iv);
    cipher.init(true, params);
    final paddedData = _padData(plainData);
    final encrypted = _processData(cipher, paddedData);
    return encrypted;
  }

  static Uint8List _padData(Uint8List data) {
    final blockSize = 16;
    final paddingLength = blockSize - (data.length % blockSize);
    final paddedData = Uint8List(data.length + paddingLength);
    paddedData.setAll(0, data);
    paddedData.fillRange(data.length, paddedData.length, paddingLength);
    return paddedData;
  }

  static Uint8List _processData(BlockCipher cipher, Uint8List data) {
    final output = Uint8List(data.length);
    for (var offset = 0; offset < data.length; offset += 16) {
      final chunkEnd = offset + 16 < data.length ? offset + 16 : data.length;
      final chunk = data.sublist(offset, chunkEnd);
      final processedChunk = cipher.process(Uint8List.fromList(chunk));
      output.setRange(offset, chunkEnd, processedChunk);
    }
    return output;
  }
}

class AES_CBC_Decryption {
  static String decrypt(String ciphertext, Uint8List key, Uint8List iv) {
    final cipher = CBCBlockCipher(AESFastEngine());
    final params = ParametersWithIV(KeyParameter(key), iv);
    cipher.init(false, params);
    final encryptedData = base64.decode(ciphertext); // Konversi ciphertext menjadi Uint8List
    final decrypted = _unpadData(_processData(cipher, encryptedData));
    return utf8.decode(decrypted);
  }

  static Uint8List _unpadData(Uint8List data) {
    final paddingLength = data.last;
    return Uint8List.fromList(data.sublist(0, data.length - paddingLength));
  }

  static Uint8List _processData(BlockCipher cipher, Uint8List data) {
    final output = Uint8List(data.length);
    for (var offset = 0; offset < data.length; offset += 16) {
      final chunkEnd = offset + 16 < data.length ? offset + 16 : data.length;
      final chunk = data.sublist(offset, chunkEnd);
      final processedChunk = cipher.process(Uint8List.fromList(chunk));
      output.setRange(offset, chunkEnd, processedChunk);
    }
    return output;
  }
}
