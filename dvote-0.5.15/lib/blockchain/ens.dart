import 'dart:typed_data';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:web3dart/crypto.dart';
// import 'package:web_socket_channel/io.dart';

// Adapted from https://github.com/ethers-io/ethers.js/blob/b0bd9ee162f27fb2bc51ab6a0c0694c3b48dc95f/src.ts/providers/base-provider.ts

// CONSTANTS

final homestead = {
  "chainId": 1,
  "ensAddress": "0x314159265dd8dbb310642f98f50c066173c1259b"
};
final ropsten = {
  "chainId": 3,
  "ensAddress": "0x112234455c3a32fd11230c42e7bccd4a84e02010"
};
final rinkeby = {
  "chainId": 4,
  "ensAddress": "0xe7410170f87102DF0055eB195163A03B7F2Bff4A"
};
final goerli = {
  "chainId": 5,
  "ensAddress": "0x112234455c3a32fd11230c42e7bccd4a84e02010"
};

final RegExp domainRegExp = new RegExp(r"^[a-zA-Z0-9-\.]+$");
final RegExp addressRegExp = new RegExp(r"^0x[0-9A-Fa-f]{40}$");

// FUNCTIONS

Future<String> resolveName(String domain, String gatewayUri) async {
  if (!domainRegExp.hasMatch(domain)) return null;

  final nodeHash = hashDomainName(domain);

  // Get the resolver from the registry
  final resolverAddress = await getResolver(domain, gatewayUri);
  if (resolverAddress == null) return null;

  // keccak256('addr(bytes32)')
  final hexDataStr = '0x3b3b57de' + nodeHash.substring(2);
  final data = hexToBytes(hexDataStr);

  final value = await _callContract(gatewayUri, resolverAddress, data);

  if (value.length != 66) return null;
  final result = _extractAddress(value);

  if (result == "0x0000000000000000000000000000000000000000") return null;
  return result;
}

Future<String> getResolver(String domain, String gatewayUri) async {
  if (!domainRegExp.hasMatch(domain)) return null;

  final nodeHash = hashDomainName(domain);

  // Detect the network
  String ensAddress;
  JsonRPC client = JsonRPC(gatewayUri, Client());
  final response = await client.call("net_version");
  if (response.result == homestead["chainId"].toString())
    ensAddress = homestead["ensAddress"];
  else if (response.result == ropsten["chainId"].toString())
    ensAddress = ropsten["ensAddress"];
  else if (response.result == rinkeby["chainId"].toString())
    ensAddress = rinkeby["ensAddress"];
  else if (response.result == goerli["chainId"].toString())
    ensAddress = goerli["ensAddress"];
  else
    return null;

  // keccak256('resolver(bytes32)')
  final hexDataStr = '0x0178b8bf' + nodeHash.substring(2);
  final data = hexToBytes(hexDataStr);

  final value = await _callContract(gatewayUri, ensAddress, data);

  if (value.length != 66) return null;
  final resolverAddress = _extractAddress(value);

  if (resolverAddress == "0x0000000000000000000000000000000000000000")
    return null;
  return resolverAddress; // 0xc1EA41786094D1fBE5aded033B5370d51F7a3F96
}

String hashDomainName(String domain) {
  domain = domain.toLowerCase();

  List<int> result = List<int>(32);
  for (int i = 0; i < 32; i++) result[i] = 0;

  final terms = domain.split(".");

  for (String strTerm in terms.reversed) {
    var catenatedBytes = result + keccakUtf8(strTerm);
    var catenatedBytesHashed = keccak256(Uint8List.fromList(catenatedBytes));
    result = catenatedBytesHashed.toList();
  }
  return "0x" + bytesToHex(result);
}

String _extractAddress(String hexHash) {
  hexHash = hexHash.replaceFirst(new RegExp(r'^0x'), '');

  if (hexHash.length != 64) return null;

  var addressDigits = hexHash.substring(24).toLowerCase();
  final chars = addressDigits.split('');
  final hashed = keccakUtf8(addressDigits);

  for (int i = 0; i < 40; i += 2) {
    if ((hashed[i >> 1] >> 4) >= 8) {
      chars[i] = addressDigits[i].toUpperCase();
    }
    if ((hashed[i >> 1] & 0x0f) >= 8) {
      chars[i + 1] = addressDigits[i + 1].toUpperCase();
    }
  }

  return "0x" + chars.join();
}

Future<String> _callContract(String gatewayUri, String to, Uint8List data) {
  if (!(gatewayUri is String)) throw Exception("Invalid Gateway URI");
  if (!(to is String)) throw Exception("Invalid contract address");
  if (!(data is Uint8List)) throw Exception("Invalid data");

  final client = Web3Client(gatewayUri, Client());
  return client.callRaw(contract: EthereumAddress.fromHex(to), data: data);

  // final client = Web3Client(gatewayUri, Client(), socketConnector: () {
  //   return IOWebSocketChannel.connect(wsUri).cast<String>();
  // });
  // client.callRaw(contract: EthereumAddress.fromHex(to), data: data);
}
