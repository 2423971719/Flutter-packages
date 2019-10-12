import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

final String ipfsGatewayListUri =
    "https://ipfs.github.io/public-gateway-checker/gateways.json";

Future<Uint8List> fetchIpfsHash(String hash) async {
  final gwResponse = await http.get(ipfsGatewayListUri);
  List gwList = jsonDecode(gwResponse.body);
  if (!(gwList is List)) throw "Invalid gateway list response";

  for (var gw in gwList) {
    try {
      var res = await http.get(gw.replaceFirst(RegExp(":hash\$"), hash));
      if (res != null && res.statusCode < 300) return res.bodyBytes;
    } catch (err) {
      continue;
    }
  }
  throw "Unable to connect to the IPFS gateways";
}
