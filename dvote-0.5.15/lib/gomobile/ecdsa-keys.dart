import 'dart:async';
import './channel.dart';

final defaultHdPath = "m/44'/60'/0'/0/0";

/// Generate a random private key and encode it with a human readable BIP39 mnemonic.
/// Entropy is the bit count (128, ..., 256)
Future<String> generateMnemonic({int size = 192}) async {
  final String mnemonic =
      await gomobileChannel.invokeMethod<String>('generateMnemonic', size);
  return mnemonic;
}

/// Return the private key that corresponds to the given mnemonic and (optional) HD derivation path
Future<String> mnemonicToPrivateKey(String mnemonic, {String hdPath}) async {
  if (hdPath == null || hdPath == "") hdPath = defaultHdPath;
  final String privKey = await gomobileChannel
      .invokeMethod<String>('mnemonicToPrivateKey', [mnemonic, hdPath]);
  return privKey;
}

/// Return the public key that corresponds to the given mnemonic and (optional) HD derivation path
Future<String> mnemonicToPublicKey(String mnemonic, {String hdPath}) async {
  if (hdPath == null || hdPath == "") hdPath = defaultHdPath;
  final String pubKey = await gomobileChannel
      .invokeMethod<String>('mnemonicToPublicKey', [mnemonic, hdPath]);
  return pubKey;
}

/// Return the Ethereum address that corresponds to the given mnemonic and (optional) HD derivation path
Future<String> mnemonicToAddress(String mnemonic, {String hdPath}) async {
  if (hdPath == null || hdPath == "") hdPath = defaultHdPath;
  final String addr = await gomobileChannel
      .invokeMethod<String>('mnemonicToAddress', [mnemonic, hdPath]);
  return addr;
}
