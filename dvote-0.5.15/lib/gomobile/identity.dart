import 'dart:async';
// import './channel.dart';

/// Create an identity database on the given path
Future<void> init(String storagePath) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;

  // final String result =
  //     await gomobileChannel.invokeMethod<String>('signString', [payload, privateKey]);
  // return result;
}

/// Add an identity to the internal database
/// Returns the identity Id and the public key
Future<Map> createIdentity(String relayUrl, String unlockPassphrase,
    {List<String> extraClaims}) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;
}

/// Builds a claim with the given parameters, adds it to the Merkle Tree,
/// commits it to the blockchain using the relay (if needed) and returns
/// the trust anchor of the claim
Future<String> addClaim(String identityId, String claimType, int version,
    Map claimData, String unlockPassphrase) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;
}

/// Generates a Zero Knowledge proof on the given identity using the given file paths
/// and the given public/private inputs mapped as specified by inputsMapping.
/// Returns a string with the zkProof
Future<String> makeZkProof(
    String identityId,
    String provingKeyPath,
    String wasmWitnessGeneratorPath,
    String wasmProverPath,
    Map inputs,
    Map inputsMapping,
    String unlockPassphrase) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;
}

/// Verifies whether the given zkProof conforms to the given verifyingKey using the
/// public inputs as indicated by the inputsMapping
Future<bool> verifyZkProof(String verifyingKeyPath, Map publicInputs,
    Map inputsMapping, String zkProof) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;
}

/// Import the given data as an identity + key pairs on the internal database, decrypt it using importPassword
/// and protect the operational private key using unlockPassphrase
Future<String> importIdentity(
    String identityBlob, String importPassword, String unlockPassphrase) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;
}

/// Export the given identity's data + related key pairs
/// and encrypt it using exportPassword
Future<String> exportIdentity(
    String identityId, String unlockPassphrase, String exportPassword) {
  final c = Completer();
  c.completeError("Unimplemented");
  return c.future;
}
