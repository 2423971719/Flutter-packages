import 'package:dvote/api/file.dart';
import 'package:dvote/api/entity.dart';
import 'package:dvote/util/content-uri.dart';
import 'package:dvote/net/gateway.dart';
import 'package:dvote/models/dart/entity.pb.dart';

void main() async {
  Map<String, dynamic> val = Map<String, dynamic>();
  val["z"] = "hola";
  val["g"] = "hola";
  val["a"] = {"z": 1234, "b": 234, "BB": 33, "\$": "Hello"};
  val["1"] = "hi ho hoe";
  print(sortMapFields(val));

  // 1
  // VocGateway gw = new VocGateway("wss://echo.websocket.org");
  // gw.request(sortMapFields(val));

  // await Future.delayed(Duration(seconds: 2));
  // gw.disconnect();

  // 2
  final res = await fetchFileString(
      ContentURI("ipfs://Qmaisz6NMhDB51cCvNWa1GMS7LU1pAxdF4Ld6Ft9kZEP2a"),
      "ws://gateway:2082/dvote");
  print("DAT: " + res);

  // 3
  EntityReference entity = EntityReference();
  entity.entityId = "0xF904848ea36c46817096E94f932A9901E377C8a5";
  entity.entryPoints.addAll(["https://rpc.slock.it/goerli"]);

  final ent = await fetchEntity(
      entity, "ws://gateway:2082/dvote", "http://gateway:2086/web3");

  print(ent.writeToJson());
}
