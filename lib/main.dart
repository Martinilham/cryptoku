import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:kriptografiku/chiper/cbc.dart';
import 'dart:math';
import 'chiper/playfairchiper.dart';
import 'chiper/scytalechiper.dart';

void main() {
  runApp(CipherApp());
}

String generateRandomIV(int length) {
  final random = Random.secure();
  var values = List<int>.generate(length, (i) => random.nextInt(256));
  return String.fromCharCodes(values);
}

class CipherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kriptografiku',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CipherHomePage(),
    );
  }
}

class CipherHomePage extends StatefulWidget {
  @override
  _CipherHomePageState createState() => _CipherHomePageState();
}

class _CipherHomePageState extends State<CipherHomePage> {
  final key = Uint8List.fromList(List.generate(16, (index) => index * 5));
  TextEditingController plaintextController = TextEditingController();
  TextEditingController keywordController = TextEditingController();
  String ciphertext = '';
  String layer1 = "";
  String layer2 = "";
  String decryptedtext = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cryptoku',
          style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          )),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: plaintextController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Plaintext',
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          String plaintext =
                              plaintextController.text.toUpperCase();
                          String playfairResult =
                              PlayfairEncryption.encrypt(plaintext, "poltek");
                          String scytaleResult =
                              ScytaleCipher.encrypt(playfairResult, 3);
                          final encrypted = AES_CBC_Encryption.encrypt(
                              scytaleResult,
                              key,
                              Uint8List.fromList(
                                  List.generate(16, (index) => index * 10)));
                          ciphertext = base64Encode(encrypted);
                          layer1 = playfairResult;
                          layer2 = scytaleResult;
                        });
                      },
                      
                      child: Text('Encrypt',
                        style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                      style:  ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          final decrypted = AES_CBC_Decryption.decrypt(
                              ciphertext,
                              key,
                              Uint8List.fromList(
                                  List.generate(16, (index) => index * 10)));
                          String scytaleResult =
                              ScytaleCipher.decrypt(decrypted, 3);
                          String playfairResult = PlayfairDecryption.decrypt(
                              scytaleResult, "poltek");
                          decryptedtext = playfairResult;
                        });
                      },
                      child: Text('Decrypt',
                        style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                      style:  ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Layer 1: $layer1',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Layer 2: $layer2',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Layer 3: $ciphertext',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'ciphertext: $ciphertext',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'decrypted: $decryptedtext',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            )));
  }
}
