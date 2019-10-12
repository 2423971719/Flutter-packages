import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web3dart/web3dart.dart';
import '../gomobile/ecdsa-signature.dart';

var random = Random.secure();

// ----------------------------------------------------------------------------
// Exported classes
// ----------------------------------------------------------------------------

/// Client class to send WS requests to a DVote Gateway
class DVoteGateway {
  /// The WebSocket "open" channel
  IOWebSocketChannel _channel;
  List<DVoteGatewayRequest> _requests = [];
  String publicKey;

  // /// List of callbacks to invoke when an unrelated message is received.
  // ObserverList<Function> _listeners = new ObserverList<Function>();

  DVoteGateway(String uri, {String publicKey}) {
    this.publicKey = publicKey;
    connect(uri);
  }

  /// Initialization the WebSockets connection with the server
  connect(String uri) {
    if (uri == null || uri == "") throw "Invalid Gateway URI";

    disconnect();
    _channel = new IOWebSocketChannel.connect(uri);
    _channel.stream.listen(_gotMessage);
  }

  /// Disconnects the WebSocket communication
  disconnect() {
    if (_channel != null) {
      if (_channel.sink != null) {
        _channel.sink.close();
      }
    }
  }

  /// Perform a raw request to the Vocdoni Gateway and wait for a response to
  /// arrive within a given timeout
  Future<Map<String, dynamic>> request(Map<String, dynamic> body,
      {int timeout = 40, String privateKey}) async {
    if (_channel == null || _channel.sink == null)
      throw "You are not connected to a gateway";

    final id = makeRandomId();

    Completer<Map<String, dynamic>> comp = Completer<Map<String, dynamic>>();
    DVoteGatewayRequest req = DVoteGatewayRequest(id, comp);
    _requests.add(req);

    Future.delayed(Duration(seconds: timeout)).then((_) {
      if (comp.isCompleted) return;
      comp.completeError("The request timed out");
    });

    Map<String, dynamic> requestBody = Map.from(body);
    if (!(requestBody["timestamp"] is int)) {
      requestBody["timestamp"] =
          (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    }

    Map<String, dynamic> content;

    // Sign if needed
    if (privateKey == null || privateKey == "") {
      content = {"id": id, "request": requestBody, "signature": ""};
    } else {
      final String signature = await _signMessageBody(requestBody, privateKey);
      content = {"id": id, "request": requestBody, "signature": signature};
    }

    _channel.sink.add(jsonEncode(content));

    return comp.future;
  }

  /// Try to match the incoming message to a previous request
  _gotMessage(message) async {
    Uint8List data = Uint8List.fromList(message);
    var incomingMessage;

    try {
      incomingMessage = jsonDecode(String.fromCharCodes(data));
    } catch (err) {
      return print("ERR: Received a non-JSON message");
    }

    if (incomingMessage == null) {
      return print("ERR: Received an empty message");
    } else if (!(incomingMessage is Map)) {
      return print("ERR: Received an invalid message");
    } else if (incomingMessage["id"] == null) {
      return _handleUnrelatedMessage(incomingMessage);
    }

    final req = _requests.firstWhere((req) => req.id == incomingMessage["id"]);
    if (req == null) {
      // NO ORIGINARY REQUEST
      return print("ERR: Received a message for a non-existing request: " +
          incomingMessage["id"]);
    } else if (req.completer.isCompleted) {
      // ALREADY HANDLED
      return print("Got a response for an already completed request");
    }

    _requests.remove(req);

    final from =
        (new DateTime.now().millisecondsSinceEpoch / 1000).floor() - 10;
    final until =
        (new DateTime.now().millisecondsSinceEpoch / 1000).floor() + 10;

    if (incomingMessage["error"] != null) {
      final error = jsonDecode(incomingMessage["error"]);

      // ERROR RESPONSE
      if (!(error is Map)) {
        return req.completer
            .completeError("Received a non-object 'error' response");
      } else if (incomingMessage["id"] != error["request"]) {
        return req.completer.completeError(
            "The signed request ID does not match the expected one");
      }

      if (!(error["timestamp"] is int) ||
          error["timestamp"] < from ||
          error["timestamp"] > until) {
        return req.completer.completeError("The response timestamp is invalid");
      } else if (!(await _isValidResponseSignature(
          incomingMessage["signature"], error))) {
        return req.completer
            .completeError("The response signature is not valid");
      } else if (!error["message"] is String) {
        return req.completer.completeError("Received an empty error message");
      }
      return req.completer.completeError(error["message"]);
    }

    if (incomingMessage["response"] == null) {
      return req.completer.completeError("Received an empty response");
    }
    final response = incomingMessage["response"];

    if (!(response is Map)) {
      return req.completer.completeError("Received an invalid response");
    }

    // CHECK RESPONSE
    if (incomingMessage["id"] != response["request"]) {
      return req.completer.completeError(
          "The signed request ID does not match the expected one");
    }
    if (!(response["timestamp"] is int) ||
        response["timestamp"] < from ||
        response["timestamp"] > until) {
      return req.completer.completeError("The response timestamp is invalid");
    } else if (!(await _isValidResponseSignature(
        incomingMessage["signature"], response))) {
      return req.completer.completeError("The response signature is not valid");
    }

    // DONE
    req.completer.complete(response);
  }

  // /// Adds a callback to be invoked in case of incoming notification
  // addListener(Function callback) {
  //   _listeners.add(callback);
  // }

  // removeListener(Function callback) {
  //   _listeners.remove(callback);
  // }

  _handleUnrelatedMessage(Map incomingMessage) {
    print("GOT AN UNRELATED MESSAGE: " + incomingMessage.toString());
    // _listeners.forEach((Function callback) {
    //   callback(message);
    // });
  }

  /// Sign the given body using privateKey. Returns an hex-encoded string with the signature.
  Future<String> _signMessageBody(
      Map<String, dynamic> body, String privateKey) {
    // Ensure alphabetically ordered key names
    final sortedBody = sortMapFields(body);
    final strBody = jsonEncode(sortedBody);

    return signString(strBody, privateKey);
  }

  /// Check whether the given signature matches the given body and publicKey.
  /// Returns true if no publicKey is given
  Future<bool> _isValidResponseSignature(
      String signature, Map<String, dynamic> body) {
    if (signature == null || body == null)
      throw "Invalid parameters";
    else if (publicKey == null || publicKey == "") return Future.value(true);

    // Ensure alphabetically ordered key names
    final sortedBody = sortMapFields(body);
    final strBody = jsonEncode(sortedBody);

    return verifySignature(signature, strBody, publicKey);
  }
}

/// Client class to wrap calls to Ethereum Smart Contracts using a (Vocdoni) Gateway
class Web3Gateway {
  String rpcUri;
  String wsUri;
  Web3Client client;

  Web3Gateway(String gatewayUri) {
    connect(gatewayUri);
  }

  /// Initialization the WebSockets connection with the Gateway
  connect(String gatewayUri) {
    if (gatewayUri == null || gatewayUri == "")
      throw "Invalid Gateway URI";
    else if (gatewayUri.startsWith("http")) {
      this.rpcUri = gatewayUri;
      this.wsUri = gatewayUri.replaceFirst(RegExp("^http"), "ws");
    } else if (gatewayUri.startsWith("ws")) {
      this.rpcUri = gatewayUri.replaceFirst(RegExp("^ws"), "http");
      this.wsUri = gatewayUri;
    }

    disconnect();
    client = Web3Client(rpcUri, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(wsUri).cast<String>();
    });
  }

  /// Disconnects the WebSocket communication
  disconnect() {
    if (client != null) {
      client.dispose();
      client = null;
    }
  }

  /// Perform a call request to Ethereum
  Future<List<dynamic>> callMethod(String contractAbi, String contractAddress,
      String method, List<dynamic> params) {
    if (client == null) throw "You are not connected to Ethereum";

    final ethAddress = EthereumAddress.fromHex(contractAddress);
    final contract = DeployedContract(
        ContractAbi.fromJson(contractAbi, 'Vocdoni'), ethAddress);

    final methodFunc = contract.function(method);
    return client.call(
        contract: contract, function: methodFunc, params: params ?? []);
  }

  /// Send a transaction to the blockchain
  Future<String> sendTransaction(String contractAbi, String contractAddress,
      String method, List<dynamic> params, Credentials credentials) {
    if (client == null)
      throw "You are not connected to Ethereum";
    else if (credentials == null)
      throw "Credentials are required to send a transaction";

    final ethAddress = EthereumAddress.fromHex(contractAddress);
    final contract = DeployedContract(
        ContractAbi.fromJson(contractAbi, 'Vocdoni'), ethAddress);

    final methodFunc = contract.function(method);

    return client.sendTransaction(
        credentials,
        Transaction.callContract(
            contract: contract,
            function: methodFunc,
            parameters: params ?? []));
  }
}

// ----------------------------------------------------------------------------
// Internal classes
// ----------------------------------------------------------------------------

class DVoteGatewayRequest {
  String id;
  Completer completer;

  DVoteGatewayRequest(this.id, this.completer);
}

// ----------------------------------------------------------------------------
// Helper functions
// ----------------------------------------------------------------------------

/// Signatures need to be computed over objects that can be 100% reproduceable.
/// Since the ordering is not guaranteed, this function returns a recursively
/// ordered map
Map<String, dynamic> sortMapFields(Map<String, dynamic> data) {
  List<String> keys = [];
  Map<String, dynamic> result = Map<String, dynamic>();

  data.forEach((k, v) {
    keys.add(k);
  });
  keys.sort((String a, String b) => a.compareTo(b));
  keys.forEach((k) {
    if (data[k] is Map) {
      result[k] = sortMapFields(data[k]);
    } else {
      result[k] = data[k];
    }
  });
  return result;
}

String makeRandomId() {
  final values = List<int>.generate(16, (i) => random.nextInt(256));
  return base64.encode(values);
}
