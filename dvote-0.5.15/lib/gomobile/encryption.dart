import 'dart:async';
import './channel.dart';

/// Encrypt the given payload using passphrase and return it as a string
Future<String> encryptString(String payload, String passphrase) async {
  if (payload == null)
    throw "The payload is empty";
  else if (passphrase == null) throw "The passphrase is empty";

  final String result = await gomobileChannel
      .invokeMethod<String>('encryptString', [payload, passphrase]);
  return result;
}

/// Decrypt the given payload using passphrase and return the original text
Future<String> decryptString(String encryptedPayload, String passphrase) async {
  if (encryptedPayload == null)
    throw "The encryptedPayload is empty";
  else if (passphrase == null) throw "The passphrase is empty";

  final String result = await gomobileChannel
      .invokeMethod<String>('decryptString', [encryptedPayload, passphrase]);
  return result;
}
