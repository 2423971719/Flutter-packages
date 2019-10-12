import 'dart:async';
import './channel.dart';

/// Sign the given payload using the private key and return a hex signature
Future<String> signString(String payload, String privateKey) async {
  if (payload == null)
    throw "The payload is empty";
  else if (privateKey == null) throw "The privateKey is empty";

  final String result = await gomobileChannel
      .invokeMethod<String>('signString', [payload, privateKey]);
  return result;
}

/// Check whether the given signature is valid and belongs to the given message and
/// public key
Future<bool> verifySignature(
    String hexSignature, String strPayload, String hexPublicKey) async {
  if (hexSignature == null)
    throw "The hexSignature is empty";
  else if (strPayload == null)
    throw "The payload is empty";
  else if (hexPublicKey == null) throw "The hexPublicKey is empty";

  final bool result = await gomobileChannel.invokeMethod<bool>(
      'verifySignature', [hexSignature, strPayload, hexPublicKey]);
  return result;
}
