import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:dvote/dvote.dart';

final vocGateway = "wss://gwdev1.vocdoni.net/dvote"; // update the value
final web3Gateway = "https://gwdev1.vocdoni.net/web3"; // update the value
final gatewayPublicKey =
    "02325f284f50fa52d53579c7873a480b351cc20f7780fa556929f5017283ad2449";

final entityId =
    "0x180dd5765d9f7ecef810b565a2e5bd14a3ccd536c442b3de74867df552855e85";
final privKeyToSign =
    "fad9c8855b740a0b7ed4c221dbad0f33a83a49cad6b3fe8d5817ac83d38b6a19";
final publicKey =
    "0x049a7df67f79246283fdc93af76d4f8cdd62c4886e8cd870944e817dd0b97934fdd7719d0810951e03418205868a5c1b40b192451367f28e0088dd75e15de40c05";
final messageToSign = "hello";
final messageToEncrypt = 'This is the super secret text message';
final passphrase = "One key to rule them all";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _mnemonic = '(mnemonic)';
  String _privKey = '(priv key)';
  String _pubKey = '(pub key)';
  String _address = '(addr)';
  String _signature = "-";
  bool _validSignature = false;
  String _cipherText = "-";
  String _decryptedMessage = "-";
  EntityMetadata _entityMeta;

  String _error;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String mnemonic, privKey, pubKey, addr;
    String signature;
    bool valid;
    String cipherText, decryptedText;
    EntityMetadata entityMeta;
    String error;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mnemonic = await generateMnemonic(size: 192);
      privKey = await mnemonicToPrivateKey(mnemonic);
      pubKey = await mnemonicToPublicKey(mnemonic);
      addr = await mnemonicToAddress(mnemonic);

      signature = await signString(messageToSign, privKeyToSign);
      valid = await verifySignature(signature, messageToSign, publicKey);

      cipherText = await encryptString(messageToEncrypt, passphrase);
      decryptedText = await decryptString(cipherText, passphrase);
    } on PlatformException catch (err) {
      error = err.message;
    } catch (err) {
      error = err;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    if (error != null) {
      setState(() {
        _error = error;
      });
      return;
    }

    setState(() {
      _mnemonic = mnemonic;
      _privKey = privKey;
      _pubKey = pubKey;
      _address = addr;

      _signature = signature;
      _validSignature = valid ?? false;

      _cipherText = cipherText;
      _decryptedMessage = decryptedText;
    });

    try {
      EntityReference entity = EntityReference();
      entity.entityId = entityId;
      entity.entryPoints.addAll(["https://rpc.slock.it/goerli"]);

      entityMeta = await fetchEntity(entity, vocGateway, web3Gateway,
          gatewayPublicKey: gatewayPublicKey);
    } on SocketException {
      error = "Connecting to the Gateway failed";
    } catch (err) {
      if (err is String) {
        error = err;
        print(err);
      } else {
        error = "Unable to retrieve the entity metadata";
      }
    }

    setState(() {
      _entityMeta = entityMeta;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('DVote plugin example'),
          ),
          body: Container(
            child: Text("Error: " + _error),
          ),
        ),
      );
    }

    final signingData =
        "Signing '$messageToSign' with $privKeyToSign:\n\n$_signature\n\nThe signature is ${_validSignature ? "valid" : "not valid"}";
    final encryptionData = '''Original message: \n > $messageToEncrypt\n
Encryption key: \n > $passphrase\n
Encrypted message: \n > $_cipherText\n
Decrypted message: \n > $_decryptedMessage''';

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DVote plugin example'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text("HD WALLET:"),
                  SizedBox(height: 30),
                  Text('Mnemonic: \n$_mnemonic'),
                  SizedBox(height: 15),
                  Text('Private key: \n$_privKey'),
                  SizedBox(height: 15),
                  Text('Public key: \n$_pubKey'),
                  SizedBox(height: 15),
                  Text('Address: \n$_address'),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text("SIGNING:"),
                  SizedBox(height: 30),
                  Text(signingData),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Text("ENCRYPTION:"),
                  SizedBox(height: 30),
                  Text(encryptionData),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16),
              child: _entityMeta == null
                  ? null
                  : Column(
                      children: <Widget>[
                        Text("ENTITY META:"),
                        SizedBox(height: 30),
                        Text(jsonEncode(_entityMeta.writeToJson())),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
