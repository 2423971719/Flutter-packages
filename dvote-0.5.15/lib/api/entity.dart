import "dart:async";
import 'dart:typed_data';
import 'package:dvote/util/content-uri.dart';
import 'package:convert/convert.dart';
import 'package:dvote/util/parsers.dart';

import '../blockchain/index.dart';
import '../models/dart/entity.pb.dart';
import './file.dart';

Future<EntityMetadata> fetchEntity(
    EntityReference entityRef, String dvoteGatewayUri, String web3GatewayUri,
    {String gatewayPublicKey}) async {
  // Fetch the Content URI from the blockchain
  final hexEntityId = hex.decode(entityRef.entityId.substring(2));
  final List<dynamic> result = await callEntityResolverMethod(
      web3GatewayUri,
      "text",
      [Uint8List.fromList(hexEntityId), "vnd.vocdoni.meta"]);

  if (result == null || result.length == 0 || result.first == null)
    throw "The metadata of the entity can't be found";
  else if (!(result[0] is String))
    throw "The response from the blockchain is invalid";

  // Fetch the JSON from the network
  final contentUri = ContentURI(result[0]);
  final meta = await fetchFileString(contentUri, dvoteGatewayUri,
      gatewayPublicKey: gatewayPublicKey);

  try {
    final res = parseEntityMetadata(meta);
    return res;
  } catch (err) {
    throw "The JSON metadata is not valid";
  }
}
