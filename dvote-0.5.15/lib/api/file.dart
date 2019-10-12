import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import "../net/gateway.dart";
import "../net/ipfs.dart";
import "../util/content-uri.dart";

/// Fetch the given content URI using a Vocdoni Gateway
/// and return it as a string
Future<String> fetchFileString(ContentURI cUri, String gatewayUri,
    {String gatewayPublicKey}) {
  return fetchFileBytes(cUri, gatewayUri,
          gatewayPublicKey: gatewayPublicKey ?? null)
      .then((Uint8List data) => utf8.decode(data.toList()));
}

/// Fetch the given content URI using a Vocdoni Gateway
/// and return it as a byte array
Future<Uint8List> fetchFileBytes(ContentURI cUri, String gatewayUri,
    {String gatewayPublicKey}) async {
  if (cUri == null)
    throw "Invalid Content URI";
  else if (gatewayUri == null || gatewayUri == "") throw "Invalid gatewayUri";

  // Attempt 1: fetch all from a gateway
  DVoteGateway gw =
      DVoteGateway(gatewayUri, publicKey: gatewayPublicKey ?? null);
  Map<String, dynamic> reqParams = {
    "method": "fetchFile",
    "uri": cUri.toString()
  };

  try {
    Map<String, dynamic> response = await gw.request(reqParams);
    if (!(response is Map) || !(response["content"] is String)) {
      throw "Invalid response received from the gateway";
    }
    gw.disconnect();
    return base64.decode(response["content"]);
  } catch (err) {
    gw.disconnect();
    if (err != "The request timed out") throw err;
    // otherwise, continue below
  }

  // Attempt 2: fetch fallback from IPFS public gateways
  if (cUri.ipfsHash != null) {
    try {
      var response = await fetchIpfsHash(cUri.ipfsHash);
      if (response != null) return response;
    } catch (err) {
      // continue
    }
  }

  // Attempt 3: fetch from fallback https endpoints
  for (String uri in cUri.httpsItems) {
    try {
      var response = await http.get(uri);
      if (response != null && response.statusCode < 300)
        return response.bodyBytes;
    } catch (err) {
      // keep trying
      continue;
    }
  }

  // Attempt 4: fetch from fallback http endpoints
  for (String uri in cUri.httpItems) {
    try {
      var response = await http.get(uri);
      if (response != null && response.statusCode < 300)
        return response.bodyBytes;
    } catch (err) {
      // keep trying
      continue;
    }
  }

  throw "Unable to connect to the network";
}
